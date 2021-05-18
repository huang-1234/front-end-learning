## 进程

```c++
// 进程控制结构体(PCB) --> 用来管理进程
struct tack_struct {
	struct List list; // 双向链表, 用于连接各个进程控制结构体, 在Linux中这样的链表创建方式比较常见
	volatile long state; // 表示进程的状态: 运行态, 停止态, 可中断态等
	unsigned long flags; // 进程标志, 是进程还是线程, 也许这就是Linux中的线程被称为轻量级的进程的原因

	struct mm_struct *mm; // 记录内存页表和程序段信息, 说白了就是管理内存中的程序(data, code, rodata, bss), 应用程序的栈顶地址
	struct thread_struct *thread; // 用于保存进程切换时的数据

	unsigned long addr_limit; // 进程地址空间范围

	long pid; 
	long counter; // 进程占用的时间片
	long signal; // 进程的信号
	long priority; // 进程的优先级
 
};


struct mm_struct {
	// pgd的值是从cr3寄存器中获取的, 就是页表的地址
	pml4t_5 *pgd; // 页表指针

	unsigned long start_code, end_code;
	unsigned long start_data, end_data;
	unsigned long start_rodata, end_rodata;
	unsigned long start_brk, end_brk;
	// 应用程序的栈顶地址
	unsigned long start_stack;
};


// 用于保留现场
struct thread_struct {
	unsigned long rsp0; // 内核层栈基地址

	unsigned long rip; // 内核层代码指针
	unsigned long rsp; // 内核层当前栈指针

	unsigned long fs; // 存储fs段寄存器的值
	unsigned long gs; // gs段寄存器的值

	unsigned long cr2; // cr2控制寄存器的值
	unsigned long trap_nr; // 产成异常的异常号
	unsigned long error_code; // 异常的错误码
};

/*
 * 在Linux内核中, 将task_truct结构体和进程的内核层栈空间融为一体, 低地址存放task_struct结构体, 余下的存放进程的内核层栈空间使用
 *
 */

// 通过该联合体创建出来的是Linux下第一个进程, 注意: 这个进程不是我们提到的init进程, init进程是Linux第二个进程
union task_union {
	struct task_struct task;
	unsigned long stack[STACK_SIZE / sizeof(unsigned long)];
};


#define INIT_TASK(tsk) \
{\
	.state = TASK_UNINTERRUPTIBLE, \
	.flags = PF_KTHREAD,\
	.mm = &init_mm,\
	.thread = &init_thread, \
	.addr_limit = 0xffff800000000000, \
	.pid = 0, \
	.counter = 1, \
	.signal = 0, \
	.priority = 0\
}

// 1, 2, 3都是初始化第一个进程
// 1
union task_union init_task_union __attribute__((__section__(".data.init_task"))) = {INIT_TASK(init_task_union.task)};

// 2
struct task_struct *init_task[NP_CPUS] = {&init_task_union.task, 0};
struct mm_struct init_mm = {0};

// 3
struct thread_struct init_thread = {
	.rsp0 = (unsigned long)(init_task_union.stack + STACK_SIZE / sizeof(unsigned long)),
	.rsp = (unsigned long)(init_task_union.stack + STACK_SIZE / sizeof(unsigned long)),
	.fs = KERNEL_DS,
	.gs = KERNEL_DS,
	.cr2 = 0,
	.trap_nr = 0,
	.error_code = 0
};


struct tss_struct {
	unsigned int reserved0;
	unsigned long rsp0;
	unsigned long rsp1;
	unsigned long rsp2;
	unsigned long reserved1;
	unsigned long ist1;
	unsigned long ist2;
	unsigned long ist3;
	unsigned long ist4;
	unsigned long ist5;
	unsigned long ist6;
	unsigned long ist7;
	unsigned long reserved2;
	unsigned short reserved3;
	unsigned short iomapbaseaddr;
}__attirbute__((packed));

#define INIT_TSS \
{\
	.reserved = 0,
	... \
	.ist1 = 0xffff800000007c00,\
	...\
}

struct tss_struct init_tss[NR_CPUS] = { [0 ... NR_CPUS - 1] = INIT_TSS };
```

> task_struct

```c++
/*
 * 在之前我们恢复异常和中断的现场的时候就发现要对大量的寄存器中的数据压栈保存, 有在task_struct的thread在进程切换的时候保存数据的方式的启发, 我们可以定义一个结构体来保存保留
 * 现场的寄存器的数据, 然后直接将这个结构体中的数据直接拷贝到内核栈中, 而不是一个一个地压入到内核栈中, 这样效率高
 */

/*
 * 这个进程的现场保留的数据就交给了这个pt_regs结构体了, 他和异常以及中断时将大部分寄存器中的数据压栈是一样的
 */

/*
 * 我们知道一个操作系统会管理很多个进程, 我们需要有一个函数来获取当前的task_struct
 */

inline struct task_struct *get_current() {
	struct task_struct *current = NULL;
	__asm__ __volatile__("andq %%rsp, %0":"=r"(current):"0"(~3276UL));
	return current;
}


#define current get_current()

#define GET_CURRENT \
	"movq %rsp,	%rbx \n\t" \
	"andq $ - 32768, %rbx \n\t"



```

- 进程内的切换是在内核空间中的, 如果将这个机制搬运到应用程序中则实现了线程间的切换工作
- 进程间的切换主要涉及到页目录的切换和各个寄存器值的保存和恢复
- 进程间切换需要在一块公共区域内进行, 这个区域就是内核空间(***注意: 作为的在内核空间运行就是指我们当前的堆栈指针指向的是内核的堆栈***)
- 对于操作系统的第一个PCB我们进行特殊的创建, 就是直接手动的创建, 目前来看这个就是我们的current的进程控制结构体了, 接着我们要生成一个新的进程, 这个进程就是我们熟悉的init进程, 这个进程和剩余的其他进程都是通过一个kernel_thread函数创建的, 而在kernel_thread函数中核心的创建子函数就是do_fork函数, 这个函数会拷贝当前的current的内存数据到一个新的区域, 很熟悉吧, 这个就是所谓的子进程从父进程中的一个复制, 下面就是来介绍这个kernel_thread函数
- kernel_thread:
  - 先声明一点, 所谓创建一个新的进程和一个老的进程恢复现场都是一个样的, 所以我们在创建一个新的进程的时候采用伪造恢复现场的方式来创建
  - 因此在kernel_thread函数中, 我们先创建一个用来存储恢复现场的数据结构体, 也就是pt_regs struct结构体, 这个结构体的属性几乎就是所有的寄存器(因为保留现场我们需要将几乎所有的寄存器的值都保存起来), 这个pt_regs结构体在前面有提到过, 这里还有一点需要***注意: 我们在这里还要提到一个kernel_thread_func函数指针(在这个函数中先进行现场恢复, 再调用传入的进程的入口函数地址使用call指令执行该进程代码, 接着返回, 调用call do_exit退出进程程序, 如果不在内核层的话, 则调用的是另外一个ret_from_syscall, 因为do_fork是一个系统调用), 这个函数就是用来在执行我们的进程的function的使用先执行的一段恢复现场的代码, 这里我们又提到了一个function, 其实这个就是一个程序的入口地址而已, 我们所以的进程不就是一个动态的程序吗, 就是让cpu去执行, 那么就需要知道他的入口地址***
  - 初始化完毕pt_regs结构体之后, 使用的do_fork函数去fork父进程创建出子进程
  - do_fork 函数
    \+ 在该函数中我们需要调用分页的alloc_pages函数去一个物理页存放task truct(也就是进程控制结构体)
    \+ 接着讲task所在的物理页的数据清0
    \+ 这个语句 *task = *current就是核心了, 就是所谓的子进程从父进程复制数据出来(这里没有使用先进的CoW技术)
    \+ 将这个task结构体添加到进程控制列表中
    \+ 递增pid, 原来pid只这样出来的 😃
    \+ thread结构体就创建在task之后, thread结构体是用来存储一些进程的状态的, 用于现场保留什么的
    \+ 判断task是在内核态还是在应用层
    \+ 设置task的state为TASK_RUNNING
- 调用了kernel_thread函数之后, 我们只是完成了一个子进程的创建, 现在我们要去运行该进程了
- 使用switch_to函数进行进程切换即可
  - 在switch_to函数中, 会执行current进程的现场保留
  - 修改rip等寄存器的值, 让其指向新的子进程的func函数指针指向的地址, 在上面我们已经知道了func会执行现场恢复, 执行进程函数, 退出进程



__EOF__
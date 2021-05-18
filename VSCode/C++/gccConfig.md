# 最新VScode C/C++ 环境配置的详细教程

**目录**

- [前言](https://www.jb51.net/article/200762.htm#_label0)
- [一、VScode下载及安装](https://www.jb51.net/article/200762.htm#_label1)
- [二、MinGW64安装及环境配置](https://www.jb51.net/article/200762.htm#_label2)
- [三、配置json文件](https://www.jb51.net/article/200762.htm#_label3)
- [四、测试](https://www.jb51.net/article/200762.htm#_label4)
- [五、Code Runner](https://www.jb51.net/article/200762.htm#_label5)
- [总结](https://www.jb51.net/article/200762.htm#_label6)

 

## 前言

一次在VScode上配置C/C++环境的记录。

 

## 一、VScode下载及安装

VScode官网下载链接：https://code.visualstudio.com/Download
1.安装路径自行选择，例如我的安装路径为D:\Program Files\Microsoft VS Code；
2.安装完成进入VScode后按照步骤install中文插件完成汉化（此处我已完成汉化，故插件包显示“卸载”，未安装情况下此处应显示“install”）；

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081322.png)

3.以同样的步骤安装C/C++拓展包（*注：此处可能存在插件在线安装失败的情况，可尝试换个网络环境或重启机器；或者按照提示进行离线手动安装*）。

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081323.png)

 

## 二、MinGW64安装及环境配置

VScode是微软发布的一款轻量级文本编辑器，本质是IDE性质（与txt，notepad++无异），本身不具备编译各种高级语言的能力，故要安装一款编译器配合VScode使用。

1.MinGW介绍

MinGW 的全称是：Minimalist GNU on Windows 。它实际上是将经典的开源 C语言 编译器 GCC 移植到了 Windows 平台下，并且包含了 Win32API ，因此可以将源代码编译为可在 Windows 中运行的可执行程序。而且还可以使用一些 Windows 不具备的Linux平台下的开发工具。一句话来概括：MinGW 就是 GCC 的 Windows 版本 。

以上是 MinGW 的介绍，MinGW-w64 与 MinGW 的区别在于 MinGW 只能编译生成32位可执行程序，而 MinGW-w64 则可以编译生成 64位 或 32位 可执行程序。

1.MinGW64安装

自行搜索MinGW的各种版本的安装包（注：现代Windows机器一般选择64位的x86-64版本）,我的安装包是x86_64-8.1.0-release-win32-sjlj-rt_v6-rev0_2，自行选择解压路径，即安装路径，例如我的安装路径为E:\mingw64（注：此路径非常重要，是VScode能正确连接编译器的桥梁）。

2.配置环境变量

1.在MinGW64的安装路径下依次打开E:\mingw64\bin，找到gcc.exe，右键属性复制路径；

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081324.png)

2.（Win系统下）右键我的电脑，单击属性，然后按照图示顺序依次操作，将mingw64目录下的bin文件添加至系统变量；

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081325.jpg)

3.验证是否配置成功

配置完毕后，快捷键win+r，输入cmd。在窗口依次输入gcc -v、g++ -v、gdb -v,若显示如下图，则表示配置成功；

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081326.jpg)
![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081327.jpg)
![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081428.png)

 

## 三、配置json文件

VScode是基于一个个文件夹并利用json配置文件来实现的，所以我们新建一个文件夹，右键通过VScode打开。
1.打开后在根目录下新建一个c源文件，并编辑测试代码，如下图所示:

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081429.png)

测试代码如下：

```
# include<stdio.h>` `int` `main(``void``)``{`` ``printf``(``"Hello World\n"``);`` ``getchar``(); ``// getchar()函数保证在调试过程中字符一直在终端显示，直到按下任意键`` ``return` `0;``}
```

2.按F5进入调试，选择C++（GDB/LLDB） —> gcc.exe

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081430.png)
![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081431.png)

软件自动在文件夹根目录下生成一个.vscode文件，包含两个json配置文件，如下图所示：

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081432.png)

其中launch.json配置文件代码如下：

```c++
{
 // 使用 IntelliSense 了解相关属性。 
 // 悬停以查看现有属性的描述。
 // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
 "version": "0.2.0",
 "configurations": [
  {
   "name": "gcc.exe - 生成和调试活动文件",
   "type": "cppdbg",
   "request": "launch",
   "program": "${fileDirname}\\${fileBasenameNoExtension}.exe",
   "args": [],
   "stopAtEntry": false,
   "cwd": "${workspaceFolder}",
   "environment": [],
   "externalConsole": true, //控制台输出,false则不显示终端窗口
   "MIMode": "gdb",
   "miDebuggerPath": "F:\\WareDownload\\C++\\mingw64\\bin\\gdb.exe", //修改成你自己的路径
   "setupCommands": [
    {
     "description": "为 gdb 启用整齐打印",
     "text": "-enable-pretty-printing",
     "ignoreFailures": true
    }
   ],
   "preLaunchTask": "gcc.exe build active file"//该处一定要与tasks.json的lable一致
  }
 ]
}
```

tasks.json配置文件代码如下：

```c++
{
  "version": "2.0.0",
  "tasks": [
    {
      "type": "shell",
      "label": "gcc.exe build active file", //一定与preLaunchTask一致
      "command": "F:\\WareDownload\\C++\\mingw64\\bin\\gdb.exe", //改为你自己的路径
      "args": [
        "-g",
        "${file}",
        // "${fileDirname}\\printf.c",
        "-o",
        "${fileDirname}\\${fileBasenameNoExtension}.exe"
      ],
      "options": {
        "cwd": "F:\\WareDownload\\C++\\mingw64\\bin" //改为自己的路径的bin文件夹
      },
      "problemMatcher": [
        "$gcc"
      ],
      "group": "build"
    }
  ]
}
```

注1：要特别注意两个配置文件中的注释部分，尤其是路径部分，要改成自己的安装路径。
注2：两个配置文件中的三处“gcc”和“g++”的区别？（gcc链接c代码，g++链接c++？）。
注3：若要链接多个源文件，则解开tasks.json配置文件中“args”部分代码即可（示例链接printf.c文件），有更简便的方法不需要枚举所有c源文件，自行百度尝试。
注4：配置完成后保存.vscode文件，复制到其他工程的根目录下可省略下一次的重新配置。
注5：每次更改完配置文件后要及时保存，否则不更新配置信息。

 

## 四、测试

1.单文件测试

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081433.png)

2.不解开tasks.json文件中的注释部分进行多文件链接测试

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081434.png)

终端提示信息undefined reference to `printf_fun()'，观察编译过程发现链接器没有编译printf.c文件，只编译了main.c文件（更别说链接了）：
\> Executing task: E:\mingw64\bin\g++.exe -g e:\GCC\printf\main.c -o e:\GCC\printf\main.exe <

3.解开tasks.json文件中的注释部分进行多文件链接测试

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081435.png)

测试通过，且终端信息提示两个文件均被编译，且链接器将两个.o文件进行链接：
\> Executing task: E:\mingw64\bin\g++.exe -g e:\GCC\printf\main.c e:\GCC\printf\printf.c -o e:\GCC\printf\main.exe <

 

## 五、Code Runner

VScode的插件Code Runner安装后，编辑器页面右上方生成一个一键运行按键，如下图：

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081536.png)

测试后，单文件编译能在输出窗口正确输出，但是多文件测试不通过，无法链接多个c文件，如下图：

![在这里插入图片描述](https://img.jbzj.com/file_images/article/202011/2020112710081537.png)

还没搞清楚需要配置哪些文件能正常使用Code Runner，故暂时不建议安装该插件。

 

## 总结

仅以此记录使用VScode配置C/C++环境的尝试（事实上已经进行了了无数次让人吐血的debug）。文中的一些概念均为多次调试后自己的猜测和理解，某些理解不正确的计算机基础知识望请谅解！

到此这篇关于最新VScode C/C++ 环境配置的详细教程的文章就介绍到这了,更多相关VScode配置C/C++ 环境内容请搜索脚本之家以前的文章或继续浏览下面的相关文章希望大家以后多多支持脚本之家！

> theme
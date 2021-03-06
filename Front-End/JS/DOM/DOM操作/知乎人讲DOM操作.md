# 操作DOM

## 为什么说DOM操作慢

### 1.  [Jacky](https://www.zhihu.com/people/lee-63-74-79)有话说：

在学前端的过程中，经常会听说DOM操作慢，要尽量少去操作DOM，本文就浅析一下DOM操作慢的原因

我们知道：

- JS引擎不能操作页面，只能操作JS
- 渲染引擎不能操作JS，只能操作页面

#### 那document.body.appendChild(‘div1’)这句JS是如何改变页面的呢？

我们先来完善一下这句JS语句的代码

```text
let div1 = document.createElement('div1')
div1.innerTEXT = 'h1'
document.body.append(div1)
//...省略n行代码
div.innerTEXT = `I'm Jacky`
```

这段代码的运行过程

- **在 div1 放入页面之前:**
  对 div1 所有的操作都属于JS线程内的操作
- **把 div1 放入页面中：**
  浏览器会发现JS的意图 就会通知渲染线程在页面中渲染 div1 对应的元素
- **把 div1 放入页面之后**
  你对 div1 的操作都[有可能](https://link.zhihu.com/?target=https%3A//kcvo.top/post/%E4%B8%BA%E4%BB%80%E4%B9%88%E8%AF%B4dom%E6%93%8D%E4%BD%9C%E6%85%A2/)触发重新渲染

注： 有可能代表，可能触发也可能不触发

**——————————————————————————————————————**

#### 首先，DOM对象本身也是一个js对象，

**所以严格来说，并不是操作这个对象慢，而是说操作了这个对象后，需要经过跨流程通信和渲染线程触发的重新渲染，导致DOM操作慢。**

**——————————————————————————————————————**

div1.innerTEXT = `I'm Jacky` 操作了什么？

上图的最后一句语句，看似简单，但实际其全部含义是巨大的。可以粗略概述为：

- 解析`I'm Jacky`为HTML文本
- 向浏览器扩展程序寻求许可
- 销毁现有的子节点div1
- 创建子字节
- 根据父子关系重新计算Layout
- 重新Paint绘制

**JS引擎和和渲染引擎的模块化设计，使得它们可以独立优化，运行速度更快，但是这种设计带来的后果就是DOM操作会越来越慢**

------------------------------------------------------------------------------------------------------------------

编辑于 2020-01-19
## 第01讲：Webpack 究竟解决了什么问题？

你好，我是汪磊，今天我要跟你分享的内容是 Webpack 背后的模块化以及它的发展过程。

正如开篇词中所描述的，Webpack 最初的目标就是实现前端项目的模块化，也就是说它所解决的问题是如何在前端项目中更高效地管理和维护项目中的每一个资源。

所以如果你想要搞明白 Webpack ，就必须先对它想要解决的问题或者目标有一个充分的认识，带着问题再去理解它的很多特性，学习思路会更清晰，理解也会更深刻。

在这一课时中，我将带你简单了解前端模块化的发展史，以及这个过程中所出现的一些标准规范。有句话叫作：读史使人明智，希望通过学习本课时的内容，能够为你在 Webpack 的理解上带来新的启示。

模块化的演进过程
随着互联网的深入发展，前端技术标准发生了巨大的变化。早期的前端技术标准根本没有预料到前端行业会有今天这个规模，所以在设计上存在很多缺陷，导致我们现在去实现前端模块化时会遇到诸多问题。虽然说，如今绝大部分问题都已经被一些标准或者工具解决了，但在这个演进过程中依然有很多东西值得我们思考和学习，所以接下来我想先介绍一下前端方向落实模块化的几个代表阶段。

1. Stage 1 - 文件划分方式
最早我们会基于文件划分的方式实现模块化，也就是 Web 最原始的模块系统。具体做法是将每个功能及其相关状态数据各自单独放到不同的 JS 文件中，约定每个文件是一个独立的模块。使用某个模块将这个模块引入到页面中，一个 script 标签对应一个模块，然后直接调用模块中的成员（变量 / 函数）。

复制代码
└─ stage-1
    ├── module-a.js
    ├── module-b.js
    └── index.html
复制代码
// module-a.js 
function foo () {
   console.log('moduleA#foo') 
}
复制代码
// module-b.js 
var data = 'something'
复制代码
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Stage 1</title>
</head>
<body>
  <script src="module-a.js"></script>
  <script src="module-b.js"></script>
  <script>
    // 直接使用全局成员
    foo() // 可能存在命名冲突
    console.log(data)
    data = 'other' // 数据可能会被修改
  </script>
</body>
</html>
缺点：

模块直接在全局工作，大量模块成员污染全局作用域；
没有私有空间，所有模块内的成员都可以在模块外部被访问或者修改；
一旦模块增多，容易产生命名冲突；
无法管理模块与模块之间的依赖关系；
在维护的过程中也很难分辨每个成员所属的模块。
总之，这种原始“模块化”的实现方式完全依靠约定实现，一旦项目规模变大，这种约定就会暴露出种种问题，非常不可靠，所以我们需要尽可能解决这个过程中暴露出来的问题。

2. Stage 2 – 命名空间方式
后来，我们约定每个模块只暴露一个全局对象，所有模块成员都挂载到这个全局对象中，具体做法是在第一阶段的基础上，通过将每个模块“包裹”为一个全局对象的形式实现，这种方式就好像是为模块内的成员添加了“命名空间”，所以我们又称之为命名空间方式。


复制代码
// module-a.js
window.moduleA = {
  method1: function () {
    console.log('moduleA#method1')
  }
}
复制代码
// module-b.js
window.moduleB = {
  data: 'something'
  method1: function () {
    console.log('moduleB#method1')
  }
}
复制代码
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Stage 2</title>
</head>
<body>
  <script src="module-a.js"></script>
  <script src="module-b.js"></script>
  <script>
    moduleA.method1()
    moduleB.method1()
    // 模块成员依然可以被修改
    moduleA.data = 'foo'
  </script>
</body>
</html>
这种命名空间的方式只是解决了命名冲突的问题，但是其它问题依旧存在。

3. Stage 3 – IIFE
使用立即执行函数表达式（IIFE，Immediately-Invoked Function Expression）为模块提供私有空间。具体做法是将每个模块成员都放在一个立即执行函数所形成的私有作用域中，对于需要暴露给外部的成员，通过挂到全局对象上的方式实现。

复制代码
// module-a.js
;(function () {
  var name = 'module-a'

  function method1 () {
    console.log(name + '#method1')
  }

  window.moduleA = {
    method1: method1
  }
})()
复制代码
// module-b.js
;(function () {
  var name = 'module-b'

  function method1 () {
    console.log(name + '#method1')
  }

  window.moduleB = {
    method1: method1
  }
})()
这种方式带来了私有成员的概念，私有成员只能在模块成员内通过闭包的形式访问，这就解决了前面所提到的全局作用域污染和命名冲突的问题。

4. Stage 4 - IIFE 依赖参数
在 IIFE 的基础之上，我们还可以利用 IIFE 参数作为依赖声明使用，这使得每一个模块之间的依赖关系变得更加明显。

复制代码
// module-a.js
;(function ($) { // 通过参数明显表明这个模块的依赖
  var name = 'module-a'

  function method1 () {
    console.log(name + '#method1')
    $('body').animate({ margin: '200px' })
  }

  window.moduleA = {
    method1: method1
  }
})(jQuery)
模块加载的问题
以上 4 个阶段是早期的开发者在没有工具和规范的情况下对模块化的落地方式，这些方式确实解决了很多在前端领域实现模块化的问题，但是仍然存在一些没有解决的问题。

复制代码
<!DOCTYPE html>
<html>
<head>
  <title>Evolution</title>
</head>
<body>
  <script src="https://unpkg.com/jquery"></script>
  <script src="module-a.js"></script>
  <script src="module-b.js"></script>
  <script>
    moduleA.method1()
    moduleB.method1()
  </script>
</body>
</html>
最明显的问题就是：模块的加载。在这几种方式中虽然都解决了模块代码的组织问题，但模块加载的问题却被忽略了，我们都是通过 script 标签的方式直接在页面中引入的这些模块，这意味着模块的加载并不受代码的控制，时间久了维护起来会十分麻烦。试想一下，如果你的代码需要用到某个模块，如果 HTML 中忘记引入这个模块，又或是代码中移除了某个模块的使用，而 HTML 还忘记删除该模块的引用，都会引起很多问题和不必要的麻烦。

更为理想的方式应该是在页面中引入一个 JS 入口文件，其余用到的模块可以通过代码控制，按需加载进来。

模块化规范的出现
除了模块加载的问题以外，目前这几种通过约定实现模块化的方式，不同的开发者在实施的过程中会出现一些细微的差别，因此，为了统一不同开发者、不同项目之间的差异，我们就需要制定一个行业标准去规范模块化的实现方式。

再接合我们刚刚提到的模块加载的问题，我们现在的需求就是两点：

一个统一的模块化标准规范
一个可以自动加载模块的基础库
提到模块化规范，你可能会想到 CommonJS 规范，它是 Node.js 中所遵循的模块规范，该规范约定，一个文件就是一个模块，每个模块都有单独的作用域，通过 module.exports 导出成员，再通过 require 函数载入模块。现如今的前端开发者应该对其有所了解，但是如果我们想要在浏览器端直接使用这个规范，那就会出现一些新的问题。

如果你对 Node.js 的模块加载机制有所了解，那么你应该知道，CommonJS 约定的是以同步的方式加载模块，因为 Node.js 执行机制是在启动时加载模块，执行过程中只是使用模块，所以这种方式不会有问题。但是如果要在浏览器端使用同步的加载模式，就会引起大量的同步模式请求，导致应用运行效率低下。

所以在早期制定前端模块化标准时，并没有直接选择 CommonJS 规范，而是专门为浏览器端重新设计了一个规范，叫做 AMD （ Asynchronous Module Definition） 规范，即异步模块定义规范。同期还推出了一个非常出名的库，叫做 Require.js，它除了实现了 AMD 模块化规范，本身也是一个非常强大的模块加载器。

在 AMD 规范中约定每个模块通过 define() 函数定义，这个函数默认可以接收两个参数，第一个参数是一个数组，用于声明此模块的依赖项；第二个参数是一个函数，参数与前面的依赖项一一对应，每一项分别对应依赖项模块的导出成员，这个函数的作用就是为当前模块提供一个私有空间。如果在当前模块中需要向外部导出成员，可以通过 return 的方式实现。



除此之外，Require.js 还提供了一个 require() 函数用于自动加载模块，用法与 define() 函数类似，区别在于 require() 只能用来载入模块，而  define() 还可以定义模块。当 Require.js 需要加载一个模块时，内部就会自动创建 script 标签去请求并执行相应模块的代码。



目前绝大多数第三方库都支持 AMD 规范，但是它使用起来相对复杂，而且当项目中模块划分过于细致时，就会出现同一个页面对 js 文件的请求次数过多的情况，从而导致效率降低。在当时的环境背景下，AMD 规范为前端模块化提供了一个标准，但这只是一种妥协的实现方式，并不能成为最终的解决方案。

同期出现的规范还有淘宝的 Sea.js，只不过它实现的是另外一个标准，叫作 CMD，这个标准类似于 CommonJS，在使用上基本和 Require.js 相同，可以算上是重复的轮子。但随着前端技术的发展，Sea.js 后来也被 Require.js 兼容了。如果你感兴趣可以课后了解一下 Seajs官网。



模块化的标准规范
尽管上面介绍的这些方式和标准都已经实现了模块化，但是都仍然存在一些让开发者难以接受的问题。

随着技术的发展，JavaScript 的标准逐渐走向完善，可以说，如今的前端模块化已经发展得非常成熟了，而且对前端模块化规范的最佳实践方式也基本实现了统一。

在 Node.js 环境中，我们遵循 CommonJS 规范来组织模块。
在浏览器环境中，我们遵循 ES Modules 规范
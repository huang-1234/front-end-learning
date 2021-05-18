## 认识webpack
webpack的安装
webpack的起步
webpack的配置
loader的使用
webpack中配置Vue
plugin的使用
搭建本地服务器

## 什么是webpack？
这个webpack还真不是一两句话可以说清楚的。
我们先看看官方的解释：
At its core, webpack is a static module bundler for modern JavaScript applications. 
从本质上来讲，webpack是一个现代的JavaScript应用的静态模块打包工具。
但是它是什么呢？用概念解释概念，还是不清晰。
我们从两个点来解释上面这句话：模块 和 打包

## 前端模块化

前端模块化：
在前面学习中，我已经用了大量的篇幅解释了为什么前端需要模块化。
而且我也提到了目前使用前端模块化的一些方案：AMD、CMD、CommonJS、ES6。
在ES6之前，我们要想进行模块化开发，就必须借助于其他的工具，让我们可以进行模块化开发。
并且在通过模块化开发完成了项目后，还需要处理模块间的各种依赖，并且将其进行整合打包。
而webpack其中一个核心就是让我们可能进行模块化开发，并且会帮助我们处理模块间的依赖关系。
而且不仅仅是JavaScript文件，我们的CSS、图片、json文件等等在webpack中都可以被当做模块来使用（在后续我们会看到）。
这就是webpack中模块化的概念。

打包如何理解呢？
理解了webpack可以帮助我们进行模块化，并且处理模块间的各种复杂关系后，打包的概念就非常好理解了。
就是将webpack中的各种资源模块进行打包合并成一个或多个包(Bundle)。
并且在打包的过程中，还可以对资源进行处理，比如压缩图片，将scss转成css，将ES6语法转成ES5语法，将TypeScript转成JavaScript等等操作。
但是打包的操作似乎grunt/gulp也可以帮助我们完成，它们有什么不同呢？

## 和grunt/gulp的对比

grunt/gulp的核心是Task
我们可以配置一系列的task，并且定义task要处理的事务（例如ES6、ts转化，图片压缩，scss转成css）
之后让grunt/gulp来依次执行这些task，而且让整个流程自动化。
所以grunt/gulp也被称为前端自动化任务管理工具。
我们来看一个gulp的task
下面的task就是将src下面的所有js文件转成ES5的语法。
并且最终输出到dist文件夹中。
什么时候用grunt/gulp呢？
如果你的工程模块依赖非常简单，甚至是没有用到模块化的概念。
只需要进行简单的合并、压缩，就使用grunt/gulp即可。
但是如果整个项目使用了模块化管理，而且相互依赖非常强，我们就可以使用更加强大的webpack了。
所以，grunt/gulp和webpack有什么不同呢？
grunt/gulp更加强调的是前端流程的自动化，模块化不是它的核心。
webpack更加强调模块化开发管理，而文件压缩合并、预处理等功能，是他附带的功能。

## webpack安装

安装webpack首先需要安装Node.js，Node.js自带了软件包管理工具npm
查看自己的node版本：

```cmd
node -v
```

全局安装webpack(这里我先指定版本号3.6.0，因为vue cli2依赖该版本)

```js
npm install webpack@3.6.0 --save-dev
```



局部安装webpack（后续才需要）
--save-dev`是开发时依赖，项目打包后不需要继续使用的。


为什么全局安装后，还需要局部安装呢？
在终端直接执行webpack命令，使用的全局安装的webpack
当在package.json中定义了scripts时，其中包含了webpack命令，那么使用的是局部webpack

## 准备工作

我们创建如下文件和文件夹：
文件和文件夹解析：
dist文件夹：用于存放之后打包的文件
src文件夹：用于存放我们写的源文件
main.js：项目的入口文件。具体内容查看下面详情。
mathUtils.js：定义了一些数学工具函数，可以在其他地方引用，并且使用。具体内容查看下面的详情。
index.html：浏览器打开展示的首页html
package.json：通过npm init生成的，npm包管理的文件（暂时没有用上，后面才会用上）
mathUtils.js文件中的代码：
main.js文件中的代码：

## js文件的打包

现在的js文件中使用了模块化的方式进行开发，他们可以直接使用吗？不可以。
因为如果直接在index.html引入这两个js文件，浏览器并不识别其中的模块化代码。
另外，在真实项目中当有许多这样的js文件时，我们一个个引用非常麻烦，并且后期非常不方便对它们进行管理。
我们应该怎么做呢？使用webpack工具，对多个js文件进行打包。
我们知道，webpack就是一个模块化的打包工具，所以它支持我们代码中写模块化，可以对模块化的代码进行处理。（如何处理的，待会儿在原理中，我会讲解）
另外，如果在处理完所有模块之间的关系后，将多个js打包到一个js文件中，引入时就变得非常方便了。
OK，如何打包呢？使用webpack的指令即可

打包后会在dist文件下，生成一个bundle.js文件
文件内容有些复杂，这里暂时先不看，后续再进行分析。
bundle.js文件，是webpack处理了项目直接文件依赖后生成的一个js文件，我们只需要将这个js文件在index.html中引入即可

## 配置webpack

我们考虑一下，如果每次使用webpack的命令都需要写上入口和出口作为参数，就非常麻烦，有没有一种方法可以将这两个参数写到配置中，在运行时，直接读取呢？
当然可以，就是创建一个webpack.config.js文件

目前，我们使用的webpack是全局的webpack，如果我们想使用局部来打包呢？
因为一个项目往往依赖特定的webpack版本，全局的版本可能很这个项目的webpack版本不一致，导出打包出现问题。
所以通常一个项目，都有自己局部的webpack。
第一步，项目中需要安装自己局部的webpack
这里我们让局部安装webpack3.6.0
Vue CLI3中已经升级到webpack4，但是它将配置文件隐藏了起来，所以查看起来不是很方便。

```bash
npm install webpack@3.6.0 --save-dev
```

第二步，通过node_modules/.bin/webpack启动webpack打包

但是，每次执行都敲这么一长串有没有觉得不方便呢？
OK，我们可以在package.json的scripts中定义自己的执行脚本。
package.json中的scripts的脚本在执行时，会按照一定的顺序寻找命令对应的位置。
首先，会寻找本地的node_modules/.bin路径中对应的命令。
如果没有找到，会去全局的环境变量中寻找。
如何执行我们的build指令呢？

在package.json里面加上

```json
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "build": "webpack"
  },
```

然后运行shell命令

```shell
npm run build
```

> <font color=red>为了能让webpack打包除了js以外iade文件，比如css，less，jsx，.png等资源，就需要为webpack加上相应的loader

## 什么是loader？

loader是webpack中一个非常核心的概念。
webpack用来做什么呢？
在我们之前的实例中，我们主要是用webpack来处理我们写的js代码，并且webpack会自动处理js之间相关的依赖。
但是，在开发中我们不仅仅有基本的js代码处理，我们也需要加载css、图片，也包括一些高级的将ES6转成ES5代码，将TypeScript转成ES5代码，将scss、less转成css，将.jsx、.vue文件转成js文件等等。
对于webpack本身的能力来说，对于这些转化是不支持的。
那怎么办呢？给webpack扩展对应的loader就可以啦。
loader使用过程：
步骤一：通过npm安装需要使用的loader
步骤二：在webpack.config.js中的modules关键字下进行配置
大部分loader我们都可以在webpack的官网中找到，并且学习对应的用法。

## css文件处理-添加css-loader

项目开发过程中，我们必然需要添加很多的样式，而样式我们往往写到一个单独的文件中。
在src目录中，创建一个css文件，其中创建一个normal.css文件。
我们也可以重新组织文件的目录结构，将零散的js文件放在一个js文件夹中。
normal.css中的代码非常简单，就是将body设置为red
但是，这个时候normal.css中的样式会生效吗？
当然不会，因为我们压根就没有引用它。
webpack也不可能找到它，因为我们只有一个入口，webpack会从入口开始查找其他依赖的文件。

在入口文件中引用：

这个错误告诉我们：加载normal.css文件必须有对应的loader。

在webpack的官方中，我们可以找到如下关于样式的loader使用方法：
按照官方配置webpack.config.js文件
注意：配置中有一个style-loader，我们并不知道它是什么，所以可以暂时不进行配置。

重新打包项目：
但是，运行index.html，你会发现样式并没有生效。
原因是css-loader只负责加载css文件，但是并不负责将css具体样式嵌入到文档中。
这个时候，我们还需要一个style-loader帮助我们处理。

我们来安装style-loader

注意：style-loader需要放在css-loader的前面。
疑惑：不对吧？按照我们的逻辑，在处理css文件过程中，应该是css-loader先加载css文件，再由style-loader来进行进一步的处理，为什么会将style-loader放在前面呢？
答案：这次因为webpack在读取使用的loader的过程中，是按照从右向左的顺序读取的。
目前，webpack.config.js的配置如下：

如果我们希望在项目中使用less、scss、stylus来写样式，webpack是否可以帮助我们处理呢？
我们这里以less为例，其他也是一样的。
我们还是先创建一个less文件，依然放在css文件夹中

> 继续在官方中查找，我们会找到less-loader相关的使用说明
> 首先，还是需要安装对应的loader
> 注意：我们这里还安装了less，因为webpack会使用less对less文件进行编译

```shell
npm install --save-dev less-loader less
```

其次，修改对应的配置文件
添加一个rules选项，用于处理.less文件

```json
      {
        test: /\.less$/,
        use: [{
          loader: "style-loader", // creates style nodes from JS strings
        }, {
          loader: "css-loader" // translates CSS into CommonJS
        }, {
          loader: "less-loader", // compiles Less to CSS
        }]
      },
```

## 图片文件处理 – 资源准备阶段

首先，我们在项目中加入两张图片：
一张较小的图片test01.jpg(小于8kb)，一张较大的图片test02.jpeg(大于8kb)
待会儿我们会针对这两张图片进行不同的处理
我们先考虑在css样式中引用图片的情况，所以我更改了normal.css中的样式：


如果我们现在直接打包，会出现如下问题

## 图片文件处理 – url-loader

图片处理，我们使用url-loader来处理，依然先安装url-loader

修改webpack.config.js配置文件：






再次打包，运行index.html，就会发现我们的背景图片选出了出来。
而仔细观察，你会发现背景图是通过base64显示出来的
OK，这也是limit属性的作用，当图片小于8kb时，对图片进行base64编码

## 图片文件处理 – file-loader

那么问题来了，如果大于8kb呢？我们将background的图片改成test02.jpg
这次因为大于8kb的图片，会通过file-loader进行处理，但是我们的项目中并没有file-loader




所以，我们需要安装file-loader

```shell
npm install --save-dev file-loader
```

再次打包，就会发现dist文件夹下多了一个图片文件

我们发现webpack自动帮助我们生成一个非常长的名字
这是一个32位hash值，目的是防止名字重复
但是，真实开发中，我们可能对打包的图片名字有一定的要求
比如，将所有的图片放在一个文件夹中，跟上图片原来的名称，同时也要防止重复
配置：

```js
module.exports = {
  entry: './src/main.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: 'dist/'
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        // css-loader只负责将css文件进行加载
        // style-loader负责将样式添加到DOM中
        // 使用多个loader时, 是从右向左
        use: [ 'style-loader', 'css-loader' ]
      },
      {
        test: /\.less$/,
        use: [{
          loader: "style-loader", // creates style nodes from JS strings
        }, {
          loader: "css-loader" // translates CSS into CommonJS
        }, {
          loader: "less-loader", // compiles Less to CSS
        }]
      },
      {
        test: /\.(png|jpg|gif|jpeg)$/,
        use: [
          {
            loader: 'url-loader',
            options: {
              // 当加载的图片, 小于limit时, 会将图片编译成base64字符串形式.
              // 当加载的图片, 大于limit时, 需要使用file-loader模块进行加载.
              limit: 13000,
              // 创建一个img文件夹，然后选择图片的名字.哈希值的八位.extension
              name: 'img/[name].[hash:8].[ext]'
            },
          }
        ]
      },
      {
        test: /\.js$/,
        // exclude: 排除
        // include: 包含
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['es2015']
          }
        }
      }
    ]
  }
}
```
所以，我们可以在options中添加上如下选项：
img：文件要打包到的文件夹
name：获取图片原来的名字，放在该位置
hash:8：为了防止图片名称冲突，依然使用hash，但是我们只保留8位
ext：使用图片原来的扩展名
但是，我们发现图片并没有显示出来，这是因为图片使用的路径不正确
默认情况下，webpack会将生成的路径直接返回给使用者
但是，我们整个程序是打包在dist文件夹下的，所以这里我们需要在路径下再添加一个dist/

## 24. ES6语法处理

如果你仔细阅读webpack打包的js文件，发现写的ES6语法并没有转成ES5，那么就意味着可能一些对ES6还不支持的浏览器没有办法很好的运行我们的代码。
在前面我们说过，如果希望将ES6的语法转成ES5，那么就需要使用babel。
而在webpack中，我们直接使用babel对应的loader就可以了。

```shell
npm install --save-dev babel-loader@7 babel-core babel-parset-es2015
```

配置webpack.config.js文件

```js
      {
        test: /\.js$/,
        // exclude: 排除
        // include: 包含
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['es2015']
          }
        }
      },
```





重新打包，查看bundle.js文件，发现其中的内容变成了ES5的语法
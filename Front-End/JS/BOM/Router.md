## 原生js实现简单路由切换

js实现的简单前端路由https://www.zhihu.com/video/1067148067286851584
二.实现思路
利用<a>标签进行url的切换，然后js代码监测url的变化，从而改变特定区域的显示内容。

注意：<a>标签的href必须以“#”开头，如：<a href="#/....">。因为有“#”，页面则不会向服务器请求资源，则不会刷新页面。这也就是单页面应用程序路由切换的原理。

### 三.页面结构---->HTML
这个页面结构是很常见的一种网站布局方式：采用头部和底部固定，中间左侧为菜单栏，右侧为内容显示区。

```html
<body>

    <header class="header">
        <h1>我是头部</h1>
    </header>
    <!-- 左侧导航栏 -->
    <section class="section_left">
        <ul>
            <li>
                <a href="#/">这是默认菜单</a>
            </li>
            <li>
                <a href="#/html">HTML学习</a>
            </li>
            <li>
                <a href="#/css">CSS学习</a>
            </li>
            <li>
                <a href="#/javascript">Javascript学习</a>
            </li>
        </ul>
    </section>
    <!-- 右侧内容显示区域 -->
    <sidebar class="sidebar_right">
        <h1>我是默认内容</h1>
    </sidebar>
    <!-- 底部 -->
    <footer class="footer">
        <h1>我是底部</h1>
    </footer>
</body>
```
### 四.来点样式---->CSS
页面结构是出来了，但是没有样式就如同行尸走肉一般，我们来为它添加一点样式：

```css
* {
    padding: 0;
    margin: 0;
}
a {
    text-decoration: none;
    color: #ffffff;
}
.header {
    width: 100%;
    height: 100px;
    background-color: rgb(198, 195, 212);
    text-align: center;
    line-height: 100px;
    color: #865a5a;
}
.section_left {
    width: 16%;
    height: 500px;
    float: left;
    background-color: rgb(173, 145, 145);
}
.section_left ul li {
    list-style: none;
    width: 100%;
    height: 50px;
    border-bottom: 1px solid #ffffff;
    text-align: center;
    line-height: 50px;
}
.sidebar_right {
    width: 78%;
    float: right;
    height: 470px;
    background-color: rgb(105, 90, 90);
    margin-right: 3%;
    margin-top: 15px;
    text-align: center;
    line-height: 470px;
    border-radius: 10px;
    color: #e6cdcd;
}
.footer {
    width: 100%;
    height:100px;
    background-color: rgb(190, 195, 216);
    clear: both;
    text-align: center;
    line-height: 100px;
    color: #925959;
}
```

### 五.js路由切换函数封装

---->JavaScript

现在是最重要的js代码了，我们最开始提到实现前端路由的这种方式就是监测浏览器url的变化，其实就是监测“#”后面的变化值。在浏览器中，每个url就是hash值，所以实际上我们监测的是url的hash值变化，所以这种路由方式也被称作hash路由。

这里的js实现代码我们把它分为几大部分：

设置一个自执行函数，保证代码不被污染。
在自执行函数里面添加一个构造函数。
在构造函数的原型对象上添加一些函数。
利用window.object = function() 将函数暴露出去。
大致步骤说了，下面我们就来实现我们的代码，在代码里面我们再来慢慢体会。

先来实现我们的自执行函数：
```js
(function(){
    var Router = function () {
        this.routes = {};//保存路由
        this.curUrl = '';//获取当前的hash值
    }
    Router.prototype.init = function () {
        //hashchange事件，当hash变化时，调用reloadPage方法
        //第一个this指向window，bind里面的this指向调用这个函数的对象，具体使用方法可以百度
        window.addEventListener('hashchange', this.reloadPage.bind(this));
    }

    Router.prototype.reloadPage = function () {
        this.curUrl = location.hash.substring(1) || '/';//获取当前hash的值（去掉#）
        this.routes[this.curUrl]();      //运行当前hsah值对应的函数
    }
     
    Router.prototype.map = function( key, callback ){ //保存路由对应的函数：
        this.routes[key] = callback;  //key表示hash的值（去掉#），callback表示当前hash对应的函数
    } 
    window.oRou = Router;
})()
接下来就是编写对应url应该对应什么内容的js代码了

(function(){
    var Router = function () {
        this.routes = {};//保存路由
        this.curUrl = '';//获取当前的hash值
    }
    Router.prototype.init = function () {
        //hashchange事件，当hash变化时，调用reloadPage方法
        //第一个this指向window，bind里面的this指向调用这个函数的对象，具体使用方法可以百度
        window.addEventListener('hashchange', this.reloadPage.bind(this));
    }

    Router.prototype.reloadPage = function () {
        this.curUrl = location.hash.substring(1) || '/';//获取当前hash的值（去掉#）
        this.routes[this.curUrl]();      //运行当前hsah值对应的函数
    }
     
    Router.prototype.map = function( key, callback ){ //保存路由对应的函数：
        this.routes[key] = callback;  //key表示hash的值（去掉#），callback表示当前hash对应的函数
    } 
    window.oRou = Router;
})()


var oRouter2 = new oRou();
oRouter2.init();
oRouter2.map('/',function () {
    var oSidebar = document.querySelector("sidebar");
    oSidebar.innerHTML = '我是主页';
})

oRouter2.map('/html',function () {
    var oSidebar = document.querySelector("sidebar");
    oSidebar.innerHTML = '我是html页面';
})

oRouter2.map('/css',function () {
    var oSidebar = document.querySelector("sidebar");
    oSidebar.innerHTML = '我是css页面';
})

oRouter2.map('/javascript',function () {
    var oSidebar = document.querySelector("sidebar");
    oSidebar.innerHTML = '我是javascript页面';
})
```
### 六.总结
到这里我们想要的效果已经基本实现了，回顾所有代码，其实很简单。我大概梳理一下实现思路：

实现的效果：左侧侧边栏，右侧显示区域，实现点击左侧侧边栏，只有右边内容区域改变，而不刷新整个页面。
实现的原理：利用a标签改变url的特性，通过监听路由hash值得改变来执行相应的函数。
实现一个自执行函数，函数里面初始化几个方法。
第一初始化一个‘hashchange’事件函数，用来监听路由的变化。

第二设置一个改变页面函数（reloadPage ），不同的url执行不同的函数。

第三设置map函数，给不同的url赋予不同的函数。

到这里就结束了，具体实现代码是笔者参考网上大牛们和自己思考所写下的，欢迎大家指点。

源代码地址：

Hacker233/JavaScript​github.com
[yuanwne](https://blog.csdn.net/weixin_35642839/article/details/113076971)
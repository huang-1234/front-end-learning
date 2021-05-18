

## [前端 MVVM 原理](https://segmentfault.com/a/1190000013464776)

```
author: 陈家宾
email: 617822642@qq.com
date: 2018/3/1
```

## MVVM 背景

都说懒惰使人进步，MVVM 的进化史，正印证了这句话，是一步步让开发人员更懒惰更简单的历史：

> 直接 DOM 操作 -> MVC -> MVP -> MVVM

最开始的前端交互，是很直接的 DOM 操作，最出名的这类库当数 jQuery 了，封装了 DOM API，让一切 DOM 操作都变得简单。

但当页面数据和交互多的时候，散乱的代码将使项目变得难以维护，让人发狂。所以才有了 MV* 模式的发展。

## MV* 模式

> MVC & MVP & MVVM 三者对比伪代码：[点我](https://github.com/henry-CJ/demo/blob/master/MVC-MVP-MVVM-demo.html)

### MVC

- Model：数据模型 & **手动渲染模板**
- View：模板
- Controller：修改数据

### MVP

- Model：数据模型
- View：模板
- Presenter：修改数据 & **手动渲染模板**

MVP 是 MVC 模式的一种改造（这里不说改进，是因为两者其实很相似，没有本质上的变化），将 **手动渲染** 步骤** 从 Model 移到了 Presenter，让 View 和 Model 更独立更存粹了，但从另一个角度来说，也加大了 Presenter 的工作。

### MVVM

- Model：数据模型
- View：带**特殊属性**的 html 模板
- ViewModel：依靠 **Directive**，修改数据 & **自动渲染**

MVVM 模式依靠 **Directive**，实现了 **模板自动渲染**，极大地解放了开发者的双手，此时开发者只需关注 View 和 Model，效率和可维护性方面达到了飞跃式的进步。

下面将着重介绍下神奇的 Directive。

## 数据变更检测方案（Directive）

### （一）手动触发绑定

在页面需要改变时，手动触发检测，改变 model 数据，并扫描元素，对有特殊标记的元素进行修改

```
let data = {
      value: 'hello'
};

let directive = {
    html: function (html) {
        this.innerHTML = html;
    },
    value: function (html) {
        this.setAttribute('value', value);
    }
};

ViewModelSet('value', 'hello world');

function ViewModelSet(key, value) {
    data[key] = value;
    scan(); 
}

function scan() {
    for (let elem of elems) {
        elem.directive = [];
        for (let attr of elem.attributes) {
            if (attr.nodeName.indexOf('v-') >= 0) {
                directive[attr.nodeName.slice(2)].call(elem, data[attr.nodeValue]);
            }
        }
    }
}
```

### （二）脏检测机制

针对手动绑定进行优化，只对**修改到的数据**进行更新元素

```
function scan(elems, val) {
    let list = document.querySelectorAll(`[v-bind=${val}]`); // 只扫描修改到的数据涉及的元素
    for (let elem of elems) {
        for (let attr of elem.attributes) {
            let dataKey = elem.getAttribute('v-bind');
            if (elem.directive[attr.nodeValue] !== data[dataKey]) { // 当元素值有变时，更新元素
                directive[attr.nodeValue].call(elem, data[dataKey]); 
                elem.directive[attr.nodeValue] = data[dataKey]; // 保存元素当前值
            }
        }
    }
}
```

### （三）前端数据对象劫持（Hijacking）

在上面的基础更进一步，使用 Object.defineProperty 对数据进行 get & set 监听，当数据有变时，**自动执行** scan 扫描并更新元素。

原来是在改变数据时，还要手动 scan。现在只需要直接改变数据，会自动 scan，更新元素。

```
defineGetAndSet(data, 'value');

data.value = 'hello world';

function defineGetAndSet(obj, propName) {
    Object.efineProperty(obj, propName, {
        get: function () {
            return this.bVal;
        },
        set: function (newVal) {
            this.bVal = newVal;
            scan();
        },
        enumerable: true,
        configurable: true
    });
}
```

### （四）ECMAScript 6 Proxy

与方法三类似，换了种写法，这里应用了 ES6 里的 Proxy

```
let data = new Proxy({
    get: function (obj, key) {
        return obj[key];
    },
    set: function (obj, key, val) {
        obj[key] = val;
        scan();
        return obj[key];
    }
});
```

以上。

## 参考资料

1. 《现代前端 技术解析》，张成文，2017 年 4 月第 1 版d
2. 《MVC，MVP 和 MVVM 的图示》，阮一峰，2015年2月 1日，[http://www.ruanyifeng.com/blo...](http://www.ruanyifeng.com/blog/2015/02/mvcmvp_mvvm.html)

## [vue框架中什么是MVVM](https://www.cnblogs.com/yanl55555/p/11744193.html)

前端页面中使用MVVM的思想，即MVVM是整个视图层view的概念，属于视图层的概念。

MVVM是Model-View-ViewModel的简写。即模型-视图-视图模型。

**模型**指的是后端传递的数据。

**视图**指的是所看到的页面。

**视图模型是**mvvm模式的核心，它是连接view和model的桥梁。

它有两个数据传递方向：

一是将模型转化成视图，即将后端传递的数据转化成所看到的页面。实现的方式是：数据绑定。

二是将视图转化成模型，即将所看到的页面转化成后端的数据。实现的方式是：DOM 事件监听。

以上两个方向都实现的，我们称之为数据的双向绑定。

总结：在MVVM的框架下视图和模型是不能直接通信的。它们通过ViewModel来通信，ViewModel通常要实现一个observer观察者，当数据发生变化，ViewModel能够监听到数据的这种变化，然后通知到对应的视图做自动更新，而当用户操作视图，ViewModel也能监听到视图的变化，然后通知数据做改动，这实际上就实现了数据的双向绑定。并且MVVM中的View 和 ViewModel可以互相通信。MVVM流程图如下：
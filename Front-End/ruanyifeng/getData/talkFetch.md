# fetch 没有你想象的那么美

前端工程中发送 HTTP 请求从来都不是一件容易的事，前有骇人的 `ActiveXObject`，后有 API 设计十分别扭的 `XMLHttpRequest`，甚至这些原生 API 的用法至今仍是很多大公司前端校招的考点之一。

也正是如此，fetch 的出现在前端圈子里一石激起了千层浪，大家欢呼雀跃弹冠相庆恨不得马上把项目中的 `$.ajax` 全部干掉。然而，在新鲜感过后， fetch 真的有你想象的那么美好吗？

> 如果你还不了解 fetch，可以参考我的同事 @camsong 在 2015 年写的文章 [《传统 Ajax 已死，Fetch 永生》](https://github.com/camsong/blog/issues/2)

在开始「批斗」fetch之前，大家需要明确 fetch 的定位：**fetch 是一个 low-level 的 API，它注定不会像你习惯的 `$.ajax` 或是 `axios` 等库帮你封装各种各样的功能或实现。**也正是因为这个定位，在学习或使用 fetch API 时，你会遇到不少的挫折。

（对于没有耐心看完全文的同学，请先记住本文的主旨不在于批评 fetch，事实上 fetch 的出现绝对是前端领域的进步体现。在了解主旨的前提下，关注**加黑**部分即可。）

## 发请求，比你想象的要复杂

很多人看到 fetch 的第一眼肯定会被它简洁的 API 吸引：

```js
fetch('http://abc.com/tiger.png');
```

原来需要 `new XMLHttpRequest` 等小十行代码才能实现的功能如今一行代码就能搞定，能不让人动心吗！

但是当你真正在项目中使用时，少不了需要向服务端发送数据的过程，那么使用 fetch 发送一个对象到服务端需要几行代码呢？（出于兼容性考虑，大部分的项目在发送 POST 请求时都会使用 `application/x-www-form-urlencoded` 这种 `Content-Type`）

先来看看使用 jQuery 如何实现：

```js
$.post('/api/add', {name: 'test'});
```

然后再看看 fetch 如何处理：

```js
fetch('/api/add', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
  },
  body: Object.keys({name: 'test'}).map((key) => {
    return encodeURIComponent(key) + '=' + encodeURIComponent(params[key]);
  }).join('&')
});
```

等等，`body` 字段那一长串代码在干什么？**因为 fetch 是一个 low-level 的 API，所以你需要自己 encode HTTP 请求的 payload，还要自己指定 HTTP Header 中的 `Content-Type` 字段。**

这样就结束了吗？如果你在自己的项目中这样发送 POST 请求，很可能会得到一个 `401 Unauthorized` 的结果（视你的服务端如何处理无权限的情况而定）。如果你在仔细看一遍文档，会发现**原来 fetch 在发送请求时默认不会带上 Cookie！**

好，我们让 fetch 带上 Cookie：

```js
fetch('/api/add', {
  method: 'POST',
  credentials: 'include',
  ...
});
```

这样，一个最基础的 POST 请求才算能够发出去。

同理，如果你需要 POST 一个 JSON 到服务端，你需要这样做：

```js
fetch('/api/add', {
  method: 'POST',
  credentials: 'include',
  headers: {
    'Content-Type': 'application/json;charset=UTF-8'
  },
  body: JSON.stringify({name: 'test'})
});
```

相比于 `$.ajax` 的封装，是不是复杂的不是一点半点呢？

## 错误处理，比你想象的复杂

按理说，fetch 是基于 `Promise` 的 API，每个 fetch 请求会返回一个 Promise 对象，而 Promise 的异常处理且不论是否方便，起码大家是比较熟悉的了。然而 fetch 的异常处理，还是有不少门道。

假如我们用 fetch 请求一个不存在的资源：

```js
fetch('xx.png')
.then(() => {
  console.log('ok');
})
.catch(() => {
  console.log('error');
});
```

按照我们的惯例 console 应该要打印出 「error」才对，可事实又如何呢？有图有真相：

为什么会打印出 「ok」呢？

**按照 MDN 的[说法](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch#Checking_that_the_fetch_was_successful)，fetch 只有在遇到网络错误的时候才会 reject 这个 promise，比如用户断网或请求地址的域名无法解析等。只要服务器能够返回 HTTP 响应（甚至只是 CORS preflight 的 OPTIONS 响应），promise 一定是 resolved 的状态。**

所以要怎么判断一个 fetch 请求是不是成功呢？你得用 `response.ok` 这个字段：

```js
fetch('xx.png')
.then((response) => {
  if (response.ok) {
    console.log('ok');
  } else {
    console.log('error');
  }
})
.catch(() => {
  console.log('error');
});
```

## Stream API，比你想象的复杂

**当你的服务端返回的数据是 JSON 格式时，你肯定希望 fetch 返回给你的是一个普通 JavaScript 对象，然而你拿到的是一个 `Response` 对象，而真正的请求结果 —— 即 `response.body` —— 则是一个 `ReadableStream`。**

```js
fetch('/api/user.json?id=2')   // 服务端返回 {"name": "test", "age": 1} 字符串
.then((response) => {
  // 这里拿到的 response 并不是一个 {name: 'test', age: 1} 对象
  return response.json();  // 将 response.body 通过 JSON.parse 转换为 JS 对象
})
.then(data => {
  console.log(data); // {name: 'test', age: 1}
});
```

你可能觉得，这些写在规范里的技术细节使用 fetch 的人无需关心，然而在实际使用过程中你会遇到各种各样的问题迫使你不得不了解这些细节。

首先需要承认，fetch 将 `response.body` 设计成 ReadableStream 其实是非常有前瞻性的，这种设计让你在请求大体积文件时变得非常有用。然而，在我们的日常使用中，还是短小的 JSON 片段更加常见。而为了兼容不常见的设计，我们不得不多一次 `response.json()` 的调用。

不仅是调用变得麻烦，如果你的服务端采用了严格的 REST 风格，**对于某些特殊情况并没有返回 JSON 字符串，而是用了 HTTP 状态码（如：`204 No Content`），那么在调用 `response.json()` 时则会抛出异常。**

此外，**`Response` 还限制了响应内容的重复读取和转换**，例如如下代码：

```js
var prevFetch = window.fetch;
window.fetch = function() {
  prevFetch.apply(this, arguments)
  .then(response => {
    return new Promise((resolve, reject) => {
      response.json().then(data => {
        if (data.hasError === true) {
          tracker.log('API Error');
        }
        resolve(response);
      });
    });
  });
}

fetch('/api/user.json?id=1')
.then(response => {
  return response.json();  // 先将结果转换为 JSON 对象
})
.then(data => {
  console.log(data);
});
```

是对 fetch 做了一个简单的 AOP，试图拦截所有的请求结果，并当返回的 JSON 对象中 `hasError` 字段如果为 `true` 的话，打点记录出错的接口。

然而这样的代码会导致如下错误：

> Uncaught TypeError: Already read

调试一番后，你会发现是因为我们在切面中已经调用了 `response.json()`，这个时候重复调用该方法时就会报错。（实际上，再次调用其它任何转换方法，如 `.text()` 也会报错）

因此，想要在 fetch 上实现 AOP 仍需另辟蹊径。

## 其它问题

1. fetch 不支持同步请求

大家都知道同步请求阻塞页面交互，但事实上仍有不少项目在使用同步请求，可能是历史架构等等原因。如果你切换了 fetch 则无法实现这一点。

2. fetch 不支持取消一个请求

使用 XMLHttpRequest 你可以用 `xhr.abort()` 方法取消一个请求（虽然这个方法也不是那么靠谱，同时是否真的「取消」还依赖于服务端的实现），但是使用 fetch 就无能为力了，至少目前是这样的。

3. fetch 无法查看请求的进度

使用 XMLHttpRequest 你可以通过 `xhr.onprogress` 回调来动态更新请求的进度，而这一点目前 fetch 还没有原生支持。

## 小结

还是要再次明确，fetch API 的出现绝对是推动了前端在请求发送功能方面的进步。

然而，也需要意识到，**fetch 是一个相当底层的 API，在实际项目使用中，需要做各种各样的封装和异常处理，而并非开箱即用**，更做不到直接替换 `$.ajax` 或其他请求库。

## 参考资料

1. fetch spec https://fetch.spec.whatwg.org/#body
2. fetch 实现 https://github.com/github/fetch
3. 什么是 Already Read 报错 http://stackoverflow.com/questions/34786358/what-does-this-error-mean-uncaught-typeerror-already-read
4. 使用 fetch 处理 HTTP 请求失败 https://www.tjvantoll.com/2015/09/13/fetch-and-errors/
5. https://jakearchibald.com/2015/thats-so-fetch/

# 传统 Ajax 已死，Fetch 永生

原谅我做一次标题党，Ajax 不会死，传统 Ajax 指的是 XMLHttpRequest（XHR），~~未来~~现在已被 [Fetch](https://fetch.spec.whatwg.org/) 替代。

最近把阿里一个千万级 PV 的数据产品全部由 jQuery 的 `$.ajax` 迁移到 `Fetch`，上线一个多月以来运行非常稳定。结果证明，对于 IE8+ 以上浏览器，在生产环境使用 Fetch 是可行的。

由于 Fetch API 是基于 Promise 设计，有必要先学习一下 Promise，推荐阅读 [MDN Promise 教程](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Promise)。旧浏览器不支持 Promise，需要使用 polyfill [es6-promise](https://github.com/jakearchibald/es6-promise) 。

本文不是 Fetch API 科普贴，其实是讲异步处理和 Promise 的。Fetch API 很简单，看文档很快就学会了。推荐 [MDN Fetch 教程](https://developer.mozilla.org/zh-CN/docs/Web/API/GlobalFetch/fetch) 和 万能的[WHATWG Fetch 规范](https://fetch.spec.whatwg.org/)

## Why Fetch

XMLHttpRequest 是一个设计粗糙的 API，不符合关注分离（Separation of Concerns）的原则，配置和调用方式非常混乱，而且基于事件的异步模型写起来也没有现代的 Promise，generator/yield，async/await 友好。

Fetch 的出现就是为了解决 XHR 的问题，拿例子说明：

使用 XHR 发送一个 json 请求一般是这样：

```js
var xhr = new XMLHttpRequest();
xhr.open('GET', url);
xhr.responseType = 'json';

xhr.onload = function() {
  console.log(xhr.response);
};

xhr.onerror = function() {
  console.log("Oops, error");
};

xhr.send();
```

使用 Fetch 后，顿时看起来好一点

```js
fetch(url).then(function(response) {
  return response.json();
}).then(function(data) {
  console.log(data);
}).catch(function(e) {
  console.log("Oops, error");
});
```

使用 ES6 的 [箭头函数](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Functions/Arrow_functions) 后：

```js
fetch(url).then(response => response.json())
  .then(data => console.log(data))
  .catch(e => console.log("Oops, error", e))
```

现在看起来好很多了，但这种 Promise 的写法还是有 Callback 的影子，而且 promise 使用 catch 方法来进行错误处理的方式有点奇怪。不用急，下面使用 async/await 来做最终优化：

> 注：async/await 是非常新的 API，属于 ES7，目前尚在 Stage 1(提议) 阶段，这是它的[完整规范](https://github.com/lukehoban/ecmascript-asyncawait)。使用 [Babel](https://babeljs.io/) 开启 [runtime](https://babeljs.io/docs/usage/runtime/) 模式后可以把 async/await 无痛编译成 ES5 代码。也可以直接使用 [regenerator](https://github.com/facebook/regenerator) 来编译到 ES5。

```js
try {
  let response = await fetch(url);
  let data = await response.json();
  console.log(data);
} catch(e) {
  console.log("Oops, error", e);
}
// 注：这段代码如果想运行，外面需要包一个 async function
```

duang~~ 的一声，使用 `await` 后，**写异步代码就像写同步代码一样爽**。`await` 后面可以跟 Promise 对象，表示等待 Promise `resolve()` 才会继续向下执行，如果 Promise 被 `reject()` 或抛出异常则会被外面的 `try...catch` 捕获。

Promise，generator/yield，await/async 都是现在和未来 JS 解决异步的标准做法，可以完美搭配使用。这也是使用标准 Promise 一大好处。最近也把项目中使用第三方 Promise 库的代码全部转成标准 Promise，为以后全面使用 async/await 做准备。

另外，Fetch 也很适合做现在流行的同构应用，有人基于 Fetch 的语法，在 Node 端基于 http 库实现了 [node-fetch](https://github.com/bitinn/node-fetch)，又有人封装了用于同构应用的 [isomorphic-fetch](https://github.com/matthew-andrews/isomorphic-fetch)。

> 注：同构(isomorphic/universal)就是使**前后端运行同一套代码**的意思，后端一般是指 NodeJS 环境。

总结一下，Fetch 优点主要有：

1. 语法简洁，更加语义化
2. 基于标准 Promise 实现，支持 async/await
3. 同构方便，使用 [isomorphic-fetch](https://github.com/matthew-andrews/isomorphic-fetch)

## Fetch 启用方法

下面是重点↓↓↓

先看一下 Fetch 原生支持率：

原生支持率并不高，幸运的是，引入下面这些 polyfill 后可以完美支持 IE8+ ：

1. 由于 IE8 是 ES3，需要引入 ES5 的 polyfill: [es5-shim, es5-sham](https://github.com/es-shims/es5-shim)
2. 引入 Promise 的 polyfill: [es6-promise](https://github.com/jakearchibald/es6-promise)
3. 引入 fetch 探测库：[fetch-detector](https://github.com/camsong/fetch-detector)
4. 引入 fetch 的 polyfill: [fetch-ie8](https://github.com/camsong/fetch-ie8)
5. 可选：如果你还使用了 jsonp，引入 [fetch-jsonp](https://github.com/camsong/fetch-jsonp)
6. 可选：开启 Babel 的 runtime 模式，现在就使用 async/await

Fetch polyfill 的基本原理是探测是否存在 `window.fetch` 方法，如果没有则用 XHR 实现。这也是 [github/fetch](https://github.com/github/fetch) 的做法，但是有些浏览器（Chrome 45）原生支持 Fetch，但响应中有[中文时会乱码](https://lists.w3.org/Archives/Public/public-webapps-github/2015Aug/0218.html)，老外又不太关心这种问题，所以我自己才封装了 `fetch-detector` 和 `fetch-ie8` 只在浏览器稳定支持 Fetch 情况下才使用原生 Fetch。这些库现在 **每天有几千万个请求都在使用，绝对靠谱** ！

终于，引用了这一堆 polyfill 后，可以愉快地使用 Fetch 了。但要小心，下面有坑：

## Fetch 常见坑

- Fetch 请求默认是不带 cookie 的，需要设置 `fetch(url, {credentials: 'include'})`
- 服务器返回 400，500 错误码时并不会 reject，只有网络错误这些导致请求不能完成时，fetch 才会被 reject。

竟然没有提到 IE，这实在太不科学了，现在来详细说下 IE

## IE 使用策略

所有版本的 IE 均不支持原生 Fetch，fetch-ie8 会自动使用 XHR 做 polyfill。但在跨域时有个问题需要处理。

IE8, 9 的 XHR 不支持 CORS 跨域，虽然提供 `XDomainRequest`，但这个东西就是玩具，不支持传 Cookie！如果接口需要权限验证，还是乖乖地使用 jsonp 吧，推荐使用 [fetch-jsonp](https://github.com/camsong/fetch-jsonp)。如果有问题直接提 issue，我会第一时间解决。

## Fetch 和标准 Promise 的不足

由于 Fetch 是典型的异步场景，所以大部分遇到的问题不是 Fetch 的，其实是 Promise 的。ES6 的 Promise 是基于 [Promises/A+](https://promisesaplus.com/) 标准，为了保持 **简单简洁** ，只提供极简的几个 API。如果你用过一些牛 X 的异步库，如 jQuery(不要笑) 、Q.js 或者 RSVP.js，可能会感觉 Promise 功能太少了。

### 没有 Deferred

[Deferred](http://api.jquery.com/category/deferred-object/) 可以在创建 Promise 时可以减少一层嵌套，还有就是跨方法使用时很方便。
ECMAScript 11 年就有过 [Deferred 提案](http://wiki.ecmascript.org/doku.php?id=strawman:deferred_functions)，但后来没被接受。其实用 Promise 不到十行代码就能实现 Deferred：[es6-deferred](https://github.com/seangenabe/es6-deferred/blob/master/deferred.js)。现在有了 async/await，generator/yield 后，deferred 就没有使用价值了。

### 没有获取状态方法：isRejected，isResolved

标准 Promise 没有提供获取当前状态 rejected 或者 resolved 的方法。只允许外部传入成功或失败后的回调。我认为这其实是优点，这是一种声明式的接口，更简单。

### 缺少其它一些方法：always，progress，finally

always 可以通过在 then 和 catch 里重复调用方法实现。finally 也类似。progress 这种进度通知的功能还没有用过，暂不知道如何替代。

### 不能中断，没有 abort、terminate、onTimeout 或 cancel 方法

Fetch 和 Promise 一样，一旦发起，不能中断，也不会超时，只能等待被 resolve 或 reject。幸运的是，whatwg 目前正在尝试解决这个问题 [whatwg/fetch#27](https://github.com/whatwg/fetch/issues/27)

## 资料

- [WHATWG Fetch 规范](https://fetch.spec.whatwg.org/)
- [Fetch API 简介](http://bubkoo.com/2015/05/08/introduction-to-fetch/)
- [教你驯服 async](http://pouchdb.com/2015/03/05/taming-the-async-beast-with-es7.html)
- [阮一峰介绍 async](http://www.ruanyifeng.com/blog/2015/05/async.html)
# 跨域的问题

> 写下这篇文章后我想，要不以后就把这种基础的常见知识都归到这个“不要再问我XX的问题”，形成一系列内容，希望大家看完之后再有人问你这些问题，你心里会窃喜：“嘿嘿，是时候展现真正的技术了！”
> 一、[不要再问我this的指向问题了](https://segmentfault.com/a/1190000015438195)

跨域这两个字就像一块狗皮膏药一样黏在每一个前端开发者身上，无论你在工作上或者面试中无可避免会遇到这个问题。为了应付面试，我每次都随便背几个方案，也不知道为什么要这样干，反正面完就可以扔了，我想工作上也不会用到那么多乱七八糟的方案。到了真正工作，开发环境有webpack-dev-server搞定，上线了服务端的大佬们也会配好，配了什么我不管，反正不会跨域就是了。日子也就这么混过去了，终于有一天，我觉得不能再继续这样混下去了，我一定要彻底搞懂这个东西！于是就有了这篇文章。

## 要掌握跨域，首先要知道为什么会有跨域这个问题出现

确实，我们这种搬砖工人就是为了混口饭吃嘛，好好的调个接口告诉我跨域了，这种阻碍我们轻松搬砖的事情真恶心！为什么会跨域？是谁在搞事情？为了找到这个问题的始作俑者，请点击[浏览器的同源策略](https://developer.mozilla.org/zh-CN/docs/Web/Security/Same-origin_policy)。
这么官方的东西真难懂，没关系，至少你知道了，因为浏览器的同源策略导致了跨域，就是浏览器在搞事情。
所以，浏览器为什么要搞事情？就是不想给好日子我们过？对于这样的质问，浏览器甩锅道：“同源策略限制了从同一个源加载的文档或脚本如何与来自另一个源的资源进行交互。这是一个用于隔离潜在恶意文件的重要安全机制。”
这么官方的话术真难懂，没关系，至少你知道了，似乎这是个安全机制。
所以，究竟为什么需要这样的安全机制？这样的安全机制解决了什么问题？别急，让我们继续研究下去。

## 没有同源策略限制的两大危险场景

据我了解，浏览器是从两个方面去做这个同源策略的，一是针对接口的请求，二是针对Dom的查询。试想一下没有这样的限制上述两种动作有什么危险。

### 没有同源策略限制的接口请求

有一个小小的东西叫cookie大家应该知道，一般用来处理登录等场景，目的是让服务端知道谁发出的这次请求。如果你请求了接口进行登录，服务端验证通过后会在响应头加入Set-Cookie字段，然后下次再发请求的时候，浏览器会自动将cookie附加在HTTP请求的头字段Cookie中，服务端就能知道这个用户已经登录过了。知道这个之后，我们来看场景：
1.你准备去清空你的购物车，于是打开了买买买网站www.maimaimai.com，然后登录成功，一看，购物车东西这么少，不行，还得买多点。
2.你在看有什么东西买的过程中，你的好基友发给你一个链接www.nidongde.com，一脸yin笑地跟你说：“你懂的”，你毫不犹豫打开了。
3.你饶有兴致地浏览着www.nidongde.com，谁知这个网站暗地里做了些不可描述的事情！由于没有同源策略的限制，它向www.maimaimai.com发起了请求！聪明的你一定想到上面的话“服务端验证通过后会在响应头加入Set-Cookie字段，然后下次再发请求的时候，浏览器会自动将cookie附加在HTTP请求的头字段Cookie中”，这样一来，这个不法网站就相当于登录了你的账号，可以为所欲为了！如果这不是一个买买买账号，而是你的银行账号，那……
这就是传说中的CSRF攻击[浅谈CSRF攻击方式](http://www.cnblogs.com/hyddd/archive/2009/04/09/1432744.html)。
看了这波CSRF攻击我在想，即使有了同源策略限制，但cookie是明文的，还不是一样能拿下来。于是我看了一些cookie相关的文章[聊一聊 cookie](https://segmentfault.com/a/1190000004556040#articleHeader6)、[Cookie/Session的机制与安全](https://harttle.land/2015/08/10/cookie-session.html)，知道了服务端可以设置httpOnly，使得前端无法操作cookie，如果没有这样的设置，像XSS攻击就可以去获取到cookie[Web安全测试之XSS](https://www.cnblogs.com/TankXiao/archive/2012/03/21/2337194.html)；设置secure，则保证在https的加密通信中传输以防截获。

### 没有同源策略限制的Dom查询

1.有一天你刚睡醒，收到一封邮件，说是你的银行账号有风险，赶紧点进www.yinghang.com改密码。你吓尿了，赶紧点进去，还是熟悉的银行登录界面，你果断输入你的账号密码，登录进去看看钱有没有少了。
2.睡眼朦胧的你没看清楚，平时访问的银行网站是www.yinhang.com，而现在访问的是www.yinghang.com，这个钓鱼网站做了什么呢？

```
// HTML
<iframe name="yinhang" src="www.yinhang.com"></iframe>
// JS
// 由于没有同源策略的限制，钓鱼网站可以直接拿到别的网站的Dom
const iframe = window.frames['yinhang']
const node = iframe.document.getElementById('你输入账号密码的Input')
console.log(`拿到了这个${node}，我还拿不到你刚刚输入的账号密码吗`)
```

由此我们知道，同源策略确实能规避一些危险，不是说有了同源策略就安全，只是说同源策略是一种浏览器最基本的安全机制，毕竟能提高一点攻击的成本。其实没有刺不穿的盾，只是攻击的成本和攻击成功后获得的利益成不成正比。

## 跨域正确的打开方式

经过对同源策略的了解，我们应该要消除对浏览器的误解，同源策略是浏览器做的一件好事，是用来防御来自邪门歪道的攻击，但总不能为了不让坏人进门而把全部人都拒之门外吧。没错，我们这种正人君子只要打开方式正确，就应该可以跨域。
下面将一个个演示正确打开方式，但在此之前，有些准备工作要做。为了本地演示跨域，我们需要：
1.随便跑起一份前端代码（以下前端是随便跑起来的vue），地址是[http://localhost](http://localhost/):9099。
2.随便跑起一份后端代码（以下后端是随便跑起来的node koa2），地址是[http://localhost](http://localhost/):9971。

### 同源策略限制下接口请求的正确打开方式

**1.JSONP**
在HTML标签里，一些标签比如script、img这样的获取资源的标签是没有跨域限制的，利用这一点，我们可以这样干：

后端写个小接口

```
// 处理成功失败返回格式的工具
const {successBody} = require('../utli')
class CrossDomain {
  static async jsonp (ctx) {
    // 前端传过来的参数
    const query = ctx.request.query
    // 设置一个cookies
    ctx.cookies.set('tokenId', '1')
    // query.cb是前后端约定的方法名字，其实就是后端返回一个直接执行的方法给前端，由于前端是用script标签发起的请求，所以返回了这个方法后相当于立马执行，并且把要返回的数据放在方法的参数里。
    ctx.body = `${query.cb}(${JSON.stringify(successBody({msg: query.msg}, 'success'))})`
  }
}
module.exports = CrossDomain
```

简单版前端

```
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
  </head>
  <body>
    <script type='text/javascript'>
      // 后端返回直接执行的方法，相当于执行这个方法，由于后端把返回的数据放在方法的参数里，所以这里能拿到res。
      window.jsonpCb = function (res) {
        console.log(res)
      }
    </script>
    <script src='http://localhost:9871/api/jsonp?msg=helloJsonp&cb=jsonpCb' type='text/javascript'></script>
  </body>
</html>
```

简单封装一下前端这个套路

```
/**
 * JSONP请求工具
 * @param url 请求的地址
 * @param data 请求的参数
 * @returns {Promise<any>}
 */
const request = ({url, data}) => {
  return new Promise((resolve, reject) => {
    // 处理传参成xx=yy&aa=bb的形式
    const handleData = (data) => {
      const keys = Object.keys(data)
      const keysLen = keys.length
      return keys.reduce((pre, cur, index) => {
        const value = data[cur]
        const flag = index !== keysLen - 1 ? '&' : ''
        return `${pre}${cur}=${value}${flag}`
      }, '')
    }
    // 动态创建script标签
    const script = document.createElement('script')
    // 接口返回的数据获取
    window.jsonpCb = (res) => {
      document.body.removeChild(script)
      delete window.jsonpCb
      resolve(res)
    }
    script.src = `${url}?${handleData(data)}&cb=jsonpCb`
    document.body.appendChild(script)
  })
}
// 使用方式
request({
  url: 'http://localhost:9871/api/jsonp',
  data: {
    // 传参
    msg: 'helloJsonp'
  }
}).then(res => {
  console.log(res)
})
```

**2.空iframe加form**
细心的朋友可能发现，JSONP只能发GET请求，因为本质上script加载资源就是GET，那么如果要发POST请求怎么办呢？

后端写个小接口

```
// 处理成功失败返回格式的工具
const {successBody} = require('../utli')
class CrossDomain {
  static async iframePost (ctx) {
    let postData = ctx.request.body
    console.log(postData)
    ctx.body = successBody({postData: postData}, 'success')
  }
}
module.exports = CrossDomain
```

前端

```
const requestPost = ({url, data}) => {
  // 首先创建一个用来发送数据的iframe.
  const iframe = document.createElement('iframe')
  iframe.name = 'iframePost'
  iframe.style.display = 'none'
  document.body.appendChild(iframe)
  const form = document.createElement('form')
  const node = document.createElement('input')
  // 注册iframe的load事件处理程序,如果你需要在响应返回时执行一些操作的话.
  iframe.addEventListener('load', function () {
    console.log('post success')
  })

  form.action = url
  // 在指定的iframe中执行form
  form.target = iframe.name
  form.method = 'post'
  for (let name in data) {
    node.name = name
    node.value = data[name].toString()
    form.appendChild(node.cloneNode())
  }
  // 表单元素需要添加到主文档中.
  form.style.display = 'none'
  document.body.appendChild(form)
  form.submit()

  // 表单提交后,就可以删除这个表单,不影响下次的数据发送.
  document.body.removeChild(form)
}
// 使用方式
requestPost({
  url: 'http://localhost:9871/api/iframePost',
  data: {
    msg: 'helloIframePost'
  }
})
```

**3.CORS**

CORS是一个W3C标准，全称是"跨域资源共享"（Cross-origin resource sharing）[跨域资源共享 CORS 详解](http://www.ruanyifeng.com/blog/2016/04/cors.html)。看名字就知道这是处理跨域问题的标准做法。CORS有两种请求，简单请求和非简单请求。

> 这里引用上面链接阮一峰老师的文章说明一下简单请求和非简单请求。
> 浏览器将CORS请求分成两类：简单请求（simple request）和非简单请求（not-so-simple request）。

只要同时满足以下两大条件，就属于简单请求。
（1) 请求方法是以下三种方法之一：

- HEAD
- GET
- POST

（2）HTTP的头信息不超出以下几种字段：

- Accept
- Accept-Language
- Content-Language
- Last-Event-ID
- Content-Type：只限于三个值application/x-www-form-urlencoded、multipart/form-data、text/plain

1.简单请求
后端

```
// 处理成功失败返回格式的工具
const {successBody} = require('../utli')
class CrossDomain {
  static async cors (ctx) {
    const query = ctx.request.query
    // *时cookie不会在http请求中带上
    ctx.set('Access-Control-Allow-Origin', '*')
    ctx.cookies.set('tokenId', '2')
    ctx.body = successBody({msg: query.msg}, 'success')
  }
}
module.exports = CrossDomain
```

前端什么也不用干，就是正常发请求就可以，如果需要带cookie的话，前后端都要设置一下，下面那个非简单请求例子会看到。

```
fetch(`http://localhost:9871/api/cors?msg=helloCors`).then(res => {
  console.log(res)
})
```

2.非简单请求
非简单请求会发出一次预检测请求，返回码是204，预检测通过才会真正发出请求，这才返回200。这里通过前端发请求的时候增加一个额外的headers来触发非简单请求。
![clipboard.png](Cross-origin.assets/bVbdz9K)

后端

```
// 处理成功失败返回格式的工具
const {successBody} = require('../utli')
class CrossDomain {
  static async cors (ctx) {
    const query = ctx.request.query
    // 如果需要http请求中带上cookie，需要前后端都设置credentials，且后端设置指定的origin
    ctx.set('Access-Control-Allow-Origin', 'http://localhost:9099')
    ctx.set('Access-Control-Allow-Credentials', true)
    // 非简单请求的CORS请求，会在正式通信之前，增加一次HTTP查询请求，称为"预检"请求（preflight）
    // 这种情况下除了设置origin，还需要设置Access-Control-Request-Method以及Access-Control-Request-Headers
    ctx.set('Access-Control-Request-Method', 'PUT,POST,GET,DELETE,OPTIONS')
    ctx.set('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, t')
    ctx.cookies.set('tokenId', '2')

    ctx.body = successBody({msg: query.msg}, 'success')
  }
}
module.exports = CrossDomain
```

一个接口就要写这么多代码，如果想所有接口都统一处理，有什么更优雅的方式呢？见下面的koa2-cors。

```
const path = require('path')
const Koa = require('koa')
const koaStatic = require('koa-static')
const bodyParser = require('koa-bodyparser')
const router = require('./router')
const cors = require('koa2-cors')
const app = new Koa()
const port = 9871
app.use(bodyParser())
// 处理静态资源 这里是前端build好之后的目录
app.use(koaStatic(
  path.resolve(__dirname, '../dist')
))
// 处理cors
app.use(cors({
  origin: function (ctx) {
    return 'http://localhost:9099'
  },
  credentials: true,
  allowMethods: ['GET', 'POST', 'DELETE'],
  allowHeaders: ['t', 'Content-Type']
}))
// 路由
app.use(router.routes()).use(router.allowedMethods())
// 监听端口
app.listen(9871)
console.log(`[demo] start-quick is starting at port ${port}`)
```

前端

```
fetch(`http://localhost:9871/api/cors?msg=helloCors`, {
  // 需要带上cookie
  credentials: 'include',
  // 这里添加额外的headers来触发非简单请求
  headers: {
    't': 'extra headers'
  }
}).then(res => {
  console.log(res)
})
```

**4.代理**
想一下，如果我们请求的时候还是用前端的域名，然后有个东西帮我们把这个请求转发到真正的后端域名上，不就避免跨域了吗？这时候，Nginx出场了。
Nginx配置

```
server{
    # 监听9099端口
    listen 9099;
    # 域名是localhost
    server_name localhost;
    #凡是localhost:9099/api这个样子的，都转发到真正的服务端地址http://localhost:9871 
    location ^~ /api {
        proxy_pass http://localhost:9871;
    }    
}
```

前端就不用干什么事情了，除了写接口，也没后端什么事情了

```
// 请求的时候直接用回前端这边的域名http://localhost:9099，这就不会跨域，然后Nginx监听到凡是localhost:9099/api这个样子的，都转发到真正的服务端地址http://localhost:9871 
fetch('http://localhost:9099/api/iframePost', {
  method: 'POST',
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    msg: 'helloIframePost'
  })
})
```

Nginx转发的方式似乎很方便！但这种使用也是看场景的，如果后端接口是一个公共的API，比如一些公共服务获取天气什么的，前端调用的时候总不能让运维去配置一下Nginx，如果兼容性没问题（IE 10或者以上），CROS才是更通用的做法吧。

### 同源策略限制下Dom查询的正确打开方式

**1.postMessage**
window.postMessage() 是HTML5的一个接口，专注实现不同窗口不同页面的跨域通讯。
为了演示方便，我们将hosts改一下：127.0.0.1 crossDomain.com，现在访问域名crossDomain.com就等于访问127.0.0.1。

这里是[http://localhost](http://localhost/):9099/#/crossDomain，发消息方

```
<template>
  <div>
    <button @click="postMessage">给http://crossDomain.com:9099发消息</button>
    <iframe name="crossDomainIframe" src="http://crossdomain.com:9099"></iframe>
  </div>
</template>

<script>
export default {
  mounted () {
    window.addEventListener('message', (e) => {
      // 这里一定要对来源做校验
      if (e.origin === 'http://crossdomain.com:9099') {
        // 来自http://crossdomain.com:9099的结果回复
        console.log(e.data)
      }
    })
  },
  methods: {
    // 向http://crossdomain.com:9099发消息
    postMessage () {
      const iframe = window.frames['crossDomainIframe']
      iframe.postMessage('我是[http://localhost:9099], 麻烦你查一下你那边有没有id为app的Dom', 'http://crossdomain.com:9099')
    }
  }
}
</script>
```

这里是[http://crossdomain.com](http://crossdomain.com/):9099，接收消息方

```
<template>
  <div>
    我是http://crossdomain.com:9099
  </div>
</template>

<script>
export default {
  mounted () {
    window.addEventListener('message', (e) => {
      // 这里一定要对来源做校验
      if (e.origin === 'http://localhost:9099') {
        // http://localhost:9099发来的信息
        console.log(e.data)
        // e.source可以是回信的对象，其实就是http://localhost:9099窗口对象(window)的引用
        // e.origin可以作为targetOrigin
        e.source.postMessage(`我是[http://crossdomain.com:9099]，我知道了兄弟，这就是你想知道的结果：${document.getElementById('app') ? '有id为app的Dom' : '没有id为app的Dom'}`, e.origin);
      }
    })
  }
}
</script>
```

结果可以看到：

![clipboard.png](Cross-origin.assets/bVbdBwQ)

**2.document.domain**
这种方式只适合主域名相同，但子域名不同的iframe跨域。
比如主域名是[http://crossdomain.com](http://crossdomain.com/):9099，子域名是[http://child.crossdomain.com](http://child.crossdomain.com/):9099，这种情况下给两个页面指定一下document.domain即document.domain = crossdomain.com就可以访问各自的window对象了。

**3.canvas操作图片的跨域问题**
这个应该是一个比较冷门的跨域问题，张大神已经写过了我就不再班门弄斧了[解决canvas图片getImageData,toDataURL跨域问题](https://www.zhangxinxu.com/wordpress/2018/02/crossorigin-canvas-getimagedata-cors/)

## 最后

希望看完这篇文章之后，再有人问跨域的问题，你可以嘴角微微上扬，冷笑一声：“不要再问我跨域的问题了。”
扬长而去。

# [正确面对跨域，别慌](https://juejin.cn/post/6844903521163182088#heading-8)

> 前端开发中，跨域使我们经常遇到的一个问题，也是面试中经常被问到的一些问题，所以，这里，我们做个总结。小小问题，不足担心

原文地址：[YOU-SHOULD-KNOW-JS](https://github.com/Nealyang/YOU-SHOULD-KNOW-JS)

## 什么是跨域

跨域，是指浏览器不能执行其他网站的脚本。它是由浏览器的同源策略造成的，是浏览器对JavaScript实施的安全限制。

同源策略限制了一下行为：

- Cookie、LocalStorage 和 IndexDB 无法读取
- DOM 和 JS 对象无法获取
- Ajax请求发送不出去

## 常见的跨域场景

所谓的同源是指，域名、协议、端口均为相同。

```
http://www.nealyang.cn/index.html 调用   http://www.nealyang.cn/server.php  非跨域

http://www.nealyang.cn/index.html 调用   http://www.neal.cn/server.php  跨域,主域不同

http://abc.nealyang.cn/index.html 调用   http://def.neal.cn/server.php  跨域,子域名不同

http://www.nealyang.cn:8080/index.html 调用   http://www.nealyang.cn/server.php  跨域,端口不同

https://www.nealyang.cn/index.html 调用   http://www.nealyang.cn/server.php  跨域,协议不同

localhost   调用 127.0.0.1 跨域
复制代码
```

## 跨域的解决办法

### jsonp跨域

jsonp跨域其实也是JavaScript设计模式中的一种代理模式。在html页面中通过相应的标签从不同域名下加载静态资源文件是被浏览器允许的，所以我们可以通过这个“犯罪漏洞”来进行跨域。一般，我们可以动态的创建script标签，再去请求一个带参网址来实现跨域通信

```
//原生的实现方式
let script = document.createElement('script');

script.src = 'http://www.nealyang.cn/login?username=Nealyang&callback=callback';

document.body.appendChild(script);

function callback(res) {
  console.log(res);
}
复制代码
```

当然，jquery也支持jsonp的实现方式

```
$.ajax({
    url:'http://www.nealyang.cn/login',
    type:'GET',
    dataType:'jsonp',//请求方式为jsonp
    jsonpCallback:'callback',
    data:{
        "username":"Nealyang"
    }
})

复制代码
```

虽然这种方式非常好用，但是一个最大的缺陷是，只能够实现get请求

### document.domain + iframe 跨域

这种跨域的方式最主要的是要求主域名相同。什么是主域名相同呢？ www.nealyang.cn aaa.nealyang.cn ba.ad.nealyang.cn 这三个主域名都是nealyang.cn,而主域名不同的就不能用此方法。

假设目前a.nealyang.cn 和 b.nealyang.cn 分别对应指向不同ip的服务器。

a.nealyang.cn 下有一个test.html文件

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>html</title>
    <script type="text/javascript" src = "jquery-1.12.1.js"></script>
</head>
<body>
    <div>A页面</div>
    <iframe 
    style = "display : none" 
    name = "iframe1" 
    id = "iframe" 
    src="http://b.nealyang.cn/1.html" frameborder="0"></iframe>
    <script type="text/javascript">
        $(function(){
            try{
                document.domain = "nealyang.cn"
            }catch(e){}
            $("#iframe").load(function(){
                var jq = document.getElementById('iframe').contentWindow.$
                jq.get("http://nealyang.cn/test.json",function(data){
                    console.log(data);
                });
            })
        })
    </script>
</body>
</html>
复制代码
```

利用 iframe 加载 其他域下的文件（nealyang.cn/1.html）, 同时 document.domain 设置成 nealyang.cn ，当 iframe 加载完毕后就可以获取 nealyang.cn 域下的全局对象， 此时尝试着去请求 nealyang.cn 域名下的 test.json （此时可以请求接口），就会发现数据请求失败了~~ 惊不惊喜，意不意外！！！！！！！

数据请求失败，目的没有达到，自然是还少一步：

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>html</title>
    <script type="text/javascript" src = "jquery-1.12.1.js"></script>
    <script type="text/javascript">
        $(function(){
            try{
                document.domain = "nealyang.com"
            }catch(e){}
        })
    </script>
</head>
<body>
    <div id = "div1">B页面</div>
</body>
</html>
复制代码
```

此时在进行刷新浏览器，就会发现数据这次真的是成功了~~~~~

### window.name + iframe 跨域

window.name属性可设置或者返回存放窗口名称的一个字符串。他的神器之处在于name值在不同页面或者不同域下加载后依旧存在，没有修改就不会发生变化，并且可以存储非常长的name(2MB)

假设index页面请求远端服务器上的数据，我们在该页面下创建iframe标签，该iframe的src指向服务器文件的地址（iframe标签src可以跨域），服务器文件里设置好window.name的值，然后再在index.html里面读取改iframe中的window.name的值。完美~

```
<body>
  <script type="text/javascript"> 
    iframe = document.createElement('iframe'),
    iframe.src = 'http://localhost:8080/data.php';
    document.body.appendChild(iframe);
    iframe.onload = function() {
      console.log(iframe.contentWindow.name)
    };
  </script>
</body>
复制代码
```

当然，这样还是不够的。

因为规定如果index.html页面和和该页面里的iframe框架的src如果不同源，则也无法操作框架里的任何东西，所以就取不到iframe框架的name值了，告诉你我们不是一家的，你也休想得到我这里的数据。 既然要同源，那就换个src去指，前面说了无论怎样加载window.name值都不会变化，于是我们在index.html相同目录下，新建了个proxy.html的空页面，修改代码如下：

```
<body>
  <script type="text/javascript"> 
    iframe = document.createElement('iframe'),
    iframe.src = 'http://localhost:8080/data.php';
    document.body.appendChild(iframe);
    iframe.onload = function() {
      iframe.src = 'http://localhost:81/cross-domain/proxy.html';
      console.log(iframe.contentWindow.name)
    };
  </script>
</body>
复制代码
```

理想似乎很美好，在iframe载入过程中，迅速重置iframe.src的指向，使之与index.html同源，那么index页面就能去获取它的name值了！但是现实是残酷的，iframe在现实中的表现是一直不停地刷新， 也很好理解，每次触发onload时间后，重置src，相当于重新载入页面，又触发onload事件，于是就不停地刷新了（但是需要的数据还是能输出的）。修改后代码如下：

```
<body>
  <script type="text/javascript"> 
    iframe = document.createElement('iframe');
    iframe.style.display = 'none';
    var state = 0;
    
    iframe.onload = function() {
      if(state === 1) {
          var data = JSON.parse(iframe.contentWindow.name);
          console.log(data);
          iframe.contentWindow.document.write('');
          iframe.contentWindow.close();
        document.body.removeChild(iframe);
      } else if(state === 0) {
          state = 1;
          iframe.contentWindow.location = 'http://localhost:81/cross-domain/proxy.html';
      }
    };

    iframe.src = 'http://localhost:8080/data.php';
    document.body.appendChild(iframe);
  </script>
</body>
复制代码
```

所以如上，我们就拿到了服务器返回的数据，但是有几个条件是必不可少的：

- iframe标签的跨域能力
- window.names属性值在文档刷新后依然存在的能力

### location.hash + iframe 跨域

此跨域方法和上面介绍的比较类似，一样是动态插入一个iframe然后设置其src为服务端地址，而服务端同样输出一端js代码，也同时通过与子窗口之间的通信来完成数据的传输。

关于锚点相信大家都已经知道了，其实就是设置锚点，让文档指定的相应的位置。锚点的设置用a标签，然后href指向要跳转到的id，当然，前提是你得有个滚动条，不然也不好滚动嘛是吧。

而location.hash其实就是url的锚点。比如http://www.nealyang.cn#Nealyang的网址打开后，在控制台输入location.hash就会返回#Nealyang的字段。

基础知识补充完毕，下面我们来说下如何实现跨域

如果index页面要获取远端服务器的数据，动态的插入一个iframe，将iframe的src执行服务器的地址，这时候的top window 和包裹这个iframe的子窗口是不能通信的，因为同源策略，所以改变子窗口的路径就可以了，将数据当做改变后的路径的hash值加载路径上，然后就可以通信了。将数据加在index页面地址的hash上， index页面监听hash的变化，h5的hashchange方法

```
<body>
  <script type="text/javascript">
    function getData(url, fn) {
      var iframe = document.createElement('iframe');
      iframe.style.display = 'none';
      iframe.src = url;

      iframe.onload = function() {
        fn(iframe.contentWindow.location.hash.substring(1));
        window.location.hash = '';
        document.body.removeChild(iframe);
      };

      document.body.appendChild(iframe);
    }

    // get data from server
    var url = 'http://localhost:8080/data.php';
    getData(url, function(data) {
      var jsondata = JSON.parse(data);
      console.log(jsondata.name + ' ' + jsondata.age);
    });
  </script>
</body>
复制代码
```

> 补充说明：其实location.hash和window.name都是差不多的，都是利用全局对象属性的方法，然后这两种方法和jsonp也是一样的，就是只能够实现get请求

### postMessage跨域

这是由H5提出来的一个炫酷的API，IE8+，chrome,ff都已经支持实现了这个功能。这个功能也是非常的简单，其中包括接受信息的Message时间，和发送信息的postMessage方法。

发送信息的postMessage方法是向外界窗口发送信息

```
otherWindow.postMessage(message,targetOrigin);
复制代码
```

otherWindow指的是目标窗口，也就是要给哪一个window发送消息，是window.frames属性的成员或者是window.open方法创建的窗口。 Message是要发送的消息，类型为String，Object(IE8、9不支持Obj)，targetOrigin是限定消息接受范围，不限制就用星号 *

接受信息的message事件

```
var onmessage = function(event) {
  var data = event.data;
  var origin = event.origin;
}

if(typeof window.addEventListener != 'undefined'){
    window.addEventListener('message',onmessage,false);
}else if(typeof window.attachEvent != 'undefined'){
    window.attachEvent('onmessage', onmessage);
}
复制代码
```

举个栗子

a.html([www.nealyang.cn/a.html](http://www.nealyang.cn/a.html))

```
<iframe id="iframe" src="http://www.neal.cn/b.html" style="display:none;"></iframe>
<script>       
    var iframe = document.getElementById('iframe');
    iframe.onload = function() {
        var data = {
            name: 'aym'
        };
        // 向neal传送跨域数据
        iframe.contentWindow.postMessage(JSON.stringify(data), 'http://www.neal.cn');
    };

    // 接受domain2返回数据
    window.addEventListener('message', function(e) {
        alert('data from neal ---> ' + e.data);
    }, false);
</script>
复制代码
```

b.html([www.neal.cn/b.html](http://www.neal.cn/b.html))

```
<script>
    // 接收domain1的数据
    window.addEventListener('message', function(e) {
        alert('data from nealyang ---> ' + e.data);

        var data = JSON.parse(e.data);
        if (data) {
            data.number = 16;

            // 处理后再发回nealyang
            window.parent.postMessage(JSON.stringify(data), 'http://www.nealyang.cn');
        }
    }, false);
</script>
复制代码
```

### 跨域资源共享 CORS

因为是目前主流的跨域解决方案。所以这里多介绍点。

#### 简介

CORS是一个W3C标准，全称是"跨域资源共享"（Cross-origin resource sharing）。 它允许浏览器向跨源服务器，发出XMLHttpRequest请求，从而克服了AJAX只能同源使用的限制。

CORS需要浏览器和服务器同时支持。目前，所有浏览器都支持该功能，IE浏览器不能低于IE10。IE8+：IE8/9需要使用XDomainRequest对象来支持CORS。

整个CORS通信过程，都是浏览器自动完成，不需要用户参与。对于开发者来说，CORS通信与同源的AJAX通信没有差别，代码完全一样。浏览器一旦发现AJAX请求跨源，就会自动添加一些附加的头信息，有时还会多出一次附加的请求，但用户不会有感觉。 因此，实现CORS通信的关键是服务器。只要服务器实现了CORS接口，就可以跨源通信。

#### 两种请求

说起来很搞笑，分为两种请求，一种是简单请求，另一种是非简单请求。只要满足下面条件就是简单请求

- 请求方式为HEAD、POST 或者 GET
- http头信息不超出一下字段：Accept、Accept-Language 、 Content-Language、 Last-Event-ID、 Content-Type(限于三个值：application/x-www-form-urlencoded、multipart/form-data、text/plain)

为什么要分为简单请求和非简单请求，因为浏览器对这两种请求方式的处理方式是不同的。

#### 简单请求

##### 基本流程

对于简单请求，浏览器直接发出CORS请求。具体来说，就是在头信息之中，增加一个Origin字段。 下面是一个例子，浏览器发现这次跨源AJAX请求是简单请求，就自动在头信息之中，添加一个Origin字段。

```
GET /cors HTTP/1.1
Origin: http://api.bob.com
Host: api.alice.com
Accept-Language: en-US
Connection: keep-alive
User-Agent: Mozilla/5.0
...
复制代码
```

Origin字段用来说明，本次请求来自哪个源（协议 + 域名 + 端口）。服务器根据这个值，决定是否同意这次请求。

如果Origin指定的源，不在许可范围内，服务器会返回一个正常的HTTP回应。 浏览器发现，这个回应的头信息没有包含Access-Control-Allow-Origin字段（详见下文），就知道出错了，从而抛出一个错误，被XMLHttpRequest的onerror回调函数捕获。

注意，这种错误无法通过状态码识别，因为HTTP回应的状态码有可能是200。

如果Origin指定的域名在许可范围内，服务器返回的响应，会多出几个头信息字段。

```
   Access-Control-Allow-Origin: http://api.bob.com
   Access-Control-Allow-Credentials: true
   Access-Control-Expose-Headers: FooBar
   Content-Type: text/html; charset=utf-8
复制代码
```

上面的头信息之中，有三个与CORS请求相关的字段，都以Access-Control-开头

- Access-Control-Allow-Origin :该字段是必须的。它的值要么是请求时Origin字段的值，要么是一个*，表示接受任意域名的请求
- Access-Control-Allow-Credentials: 该字段可选。它的值是一个布尔值，表示是否允许发送Cookie。默认情况下，Cookie不包括在CORS请求之中。设为true，即表示服务器明确许可，Cookie可以包含在请求中，一起发给服务器。这个值也只能设为true，如果服务器不要浏览器发送Cookie，删除该字段即可。
- Access-Control-Expose-Headers:该字段可选。CORS请求时，XMLHttpRequest对象的getResponseHeader()方法只能拿到6个基本字段：Cache-Control、Content-Language、Content-Type、Expires、Last-Modified、Pragma。如果想拿到其他字段，就必须在Access-Control-Expose-Headers里面指定。

##### withCredentials 属性

上面说到，CORS请求默认不发送Cookie和HTTP认证信息。如果要把Cookie发到服务器，一方面要服务器同意，指定Access-Control-Allow-Credentials字段。

另一方面，开发者必须在AJAX请求中打开withCredentials属性。

```
var xhr = new XMLHttpRequest(); // IE8/9需用window.XDomainRequest兼容

// 前端设置是否带cookie
xhr.withCredentials = true;

xhr.open('post', 'http://www.domain2.com:8080/login', true);
xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
xhr.send('user=admin');

xhr.onreadystatechange = function() {
    if (xhr.readyState == 4 && xhr.status == 200) {
        alert(xhr.responseText);
    }
};

// jquery
$.ajax({
    ...
   xhrFields: {
       withCredentials: true    // 前端设置是否带cookie
   },
   crossDomain: true,   // 会让请求头中包含跨域的额外信息，但不会含cookie
    ...
});
复制代码
```

否则，即使服务器同意发送Cookie，浏览器也不会发送。或者，服务器要求设置Cookie，浏览器也不会处理。 但是，如果省略withCredentials设置，有的浏览器还是会一起发送Cookie。这时，可以显式关闭withCredentials。

需要注意的是，如果要发送Cookie，Access-Control-Allow-Origin就不能设为星号，必须指定明确的、与请求网页一致的域名。同时，Cookie依然遵循同源政策，只有用服务器域名设置的Cookie才会上传，其他域名的Cookie并不会上传，且（跨源）原网页代码中的document.cookie也无法读取服务器域名下的Cookie。

#### 非简单请求

非简单请求是那种对服务器有特殊要求的请求，比如请求方法是PUT或DELETE，或者Content-Type字段的类型是application/json。

非简单请求的CORS请求，会在正式通信之前，增加一次HTTP查询请求，称为"预检"请求（preflight）。

浏览器先询问服务器，当前网页所在的域名是否在服务器的许可名单之中，以及可以使用哪些HTTP动词和头信息字段。只有得到肯定答复，浏览器才会发出正式的XMLHttpRequest请求，否则就报错。

```
var url = 'http://api.alice.com/cors';
var xhr = new XMLHttpRequest();
xhr.open('PUT', url, true);
xhr.setRequestHeader('X-Custom-Header', 'value');
xhr.send();
复制代码
```

浏览器发现，这是一个非简单请求，就自动发出一个"预检"请求，要求服务器确认可以这样请求。下面是这个"预检"请求的HTTP头信息。

```
    OPTIONS /cors HTTP/1.1
   Origin: http://api.bob.com
   Access-Control-Request-Method: PUT
   Access-Control-Request-Headers: X-Custom-Header
   Host: api.alice.com
   Accept-Language: en-US
   Connection: keep-alive
   User-Agent: Mozilla/5.0...
复制代码
```

"预检"请求用的请求方法是OPTIONS，表示这个请求是用来询问的。头信息里面，关键字段是Origin，表示请求来自哪个源。

除了Origin字段，"预检"请求的头信息包括两个特殊字段。

- Access-Control-Request-Method：该字段是必须的，用来列出浏览器的CORS请求会用到哪些HTTP方法，上例是PUT。
- Access-Control-Request-Headers：该字段是一个逗号分隔的字符串，指定浏览器CORS请求会额外发送的头信息字段，上例是X-Custom-Header

##### 预检请求的回应

服务器收到"预检"请求以后，检查了Origin、Access-Control-Request-Method和Access-Control-Request-Headers字段以后，确认允许跨源请求，就可以做出回应

```
HTTP/1.1 200 OK
Date: Mon, 01 Dec 2008 01:15:39 GMT
Server: Apache/2.0.61 (Unix)
Access-Control-Allow-Origin: http://api.bob.com
Access-Control-Allow-Methods: GET, POST, PUT
Access-Control-Allow-Headers: X-Custom-Header
Content-Type: text/html; charset=utf-8
Content-Encoding: gzip
Content-Length: 0
Keep-Alive: timeout=2, max=100
Connection: Keep-Alive
Content-Type: text/plain
复制代码
```

上面的HTTP回应中，关键的是Access-Control-Allow-Origin字段，表示http://api.bob.com可以请求数据。该字段也可以设为星号，表示同意任意跨源请求。

如果浏览器否定了"预检"请求，会返回一个正常的HTTP回应，但是没有任何CORS相关的头信息字段。这时，浏览器就会认定，服务器不同意预检请求，因此触发一个错误，被XMLHttpRequest对象的onerror回调函数捕获。控制台会打印出如下的报错信息。

服务器回应的其他CORS相关字段如下：

```
Access-Control-Allow-Methods: GET, POST, PUT
Access-Control-Allow-Headers: X-Custom-Header
Access-Control-Allow-Credentials: true
Access-Control-Max-Age: 1728000
复制代码
```

- Access-Control-Allow-Methods：该字段必需，它的值是逗号分隔的一个字符串，表明服务器支持的所有跨域请求的方法。注意，返回的是所有支持的方法，而不单是浏览器请求的那个方法。这是为了避免多次"预检"请求。
- Access-Control-Allow-Headers：如果浏览器请求包括Access-Control-Request-Headers字段，则Access-Control-Allow-Headers字段是必需的。它也是一个逗号分隔的字符串，表明服务器支持的所有头信息字段，不限于浏览器在"预检"中请求的字段。
- Access-Control-Allow-Credentials： 该字段与简单请求时的含义相同。
- Access-Control-Max-Age： 该字段可选，用来指定本次预检请求的有效期，单位为秒。上面结果中，有效期是20天（1728000秒），即允许缓存该条回应1728000秒（即20天），在此期间，不用发出另一条预检请求。

##### 浏览器正常请求回应

一旦服务器通过了"预检"请求，以后每次浏览器正常的CORS请求，就都跟简单请求一样，会有一个Origin头信息字段。服务器的回应，也都会有一个Access-Control-Allow-Origin头信息字段。

```
PUT /cors HTTP/1.1
Origin: http://api.bob.com
Host: api.alice.com
X-Custom-Header: value
Accept-Language: en-US
Connection: keep-alive
User-Agent: Mozilla/5.0...
复制代码
```

浏览器的正常CORS请求。上面头信息的Origin字段是浏览器自动添加的。下面是服务器正常的回应。

```
Access-Control-Allow-Origin: http://api.bob.com
Content-Type: text/html; charset=utf-8
复制代码
```

Access-Control-Allow-Origin字段是每次回应都必定包含的

#### 结束语

CORS与JSONP的使用目的相同，但是比JSONP更强大。JSONP只支持GET请求，CORS支持所有类型的HTTP请求。JSONP的优势在于支持老式浏览器，以及可以向不支持CORS的网站请求数据。

### WebSocket协议跨域

WebSocket protocol是HTML5一种新的协议。它实现了浏览器与服务器全双工通信，同时允许跨域通讯，是server push技术的一种很好的实现。

原生WebSocket API使用起来不太方便，我们使用Socket.io，它很好地封装了webSocket接口，提供了更简单、灵活的接口，也对不支持webSocket的浏览器提供了向下兼容。

前端代码：

```
<div>user input：<input type="text"></div>
<script src="./socket.io.js"></script>
<script>
var socket = io('http://www.domain2.com:8080');

// 连接成功处理
socket.on('connect', function() {
    // 监听服务端消息
    socket.on('message', function(msg) {
        console.log('data from server: ---> ' + msg); 
    });

    // 监听服务端关闭
    socket.on('disconnect', function() { 
        console.log('Server socket has closed.'); 
    });
});

document.getElementsByTagName('input')[0].onblur = function() {
    socket.send(this.value);
};
</script>
复制代码
```

node Server

```
var http = require('http');
var socket = require('socket.io');

// 启http服务
var server = http.createServer(function(req, res) {
    res.writeHead(200, {
        'Content-type': 'text/html'
    });
    res.end();
});

server.listen('8080');
console.log('Server is running at port 8080...');

// 监听socket连接
socket.listen(server).on('connection', function(client) {
    // 接收信息
    client.on('message', function(msg) {
        client.send('hello：' + msg);
        console.log('data from client: ---> ' + msg);
    });

    // 断开处理
    client.on('disconnect', function() {
        console.log('Client socket has closed.'); 
    });
});
复制代码
```

### node代理跨域

node中间件实现跨域代理，是通过启一个代理服务器，实现数据的转发，也可以通过设置cookieDomainRewrite参数修改响应头中cookie中域名，实现当前域的cookie写入，方便接口登录认证。

利用node + express + http-proxy-middleware搭建一个proxy服务器

前端代码

```
var xhr = new XMLHttpRequest();

// 前端开关：浏览器是否读写cookie
xhr.withCredentials = true;

// 访问http-proxy-middleware代理服务器
xhr.open('get', 'http://www.domain1.com:3000/login?user=admin', true);
xhr.send();
复制代码
```

后端代码

```
var express = require('express');
var proxy = require('http-proxy-middleware');
var app = express();

app.use('/', proxy({
    // 代理跨域目标接口
    target: 'http://www.domain2.com:8080',
    changeOrigin: true,

    // 修改响应头信息，实现跨域并允许带cookie
    onProxyRes: function(proxyRes, req, res) {
        res.header('Access-Control-Allow-Origin', 'http://www.domain1.com');
        res.header('Access-Control-Allow-Credentials', 'true');
    },

    // 修改响应信息中的cookie域名
    cookieDomainRewrite: 'www.domain1.com'  // 可以为false，表示不修改
}));

app.listen(3000);
console.log('Proxy server is listen at port 3000...');
复制代码
```

### nginx代理跨域

NGINX其实个人没有怎么玩过，所以暂且也就不能误人子弟了，原谅笔者才疏尚浅~ 有机会学习研究再回来补充~~

## 交流

欢迎加入react技术栈、前端技术杂谈QQ群

> 前端技术杂谈:604953717
> react技术栈:398240621
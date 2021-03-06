# [服务端事件EventSource揭秘](https://www.cnblogs.com/accordion/p/7764460.html)

**阅读目录**

- [服务端推](https://www.cnblogs.com/accordion/p/7764460.html#_label0)
- [EventSource规范简析](https://www.cnblogs.com/accordion/p/7764460.html#_label1)
- [参考资料](https://www.cnblogs.com/accordion/p/7764460.html#_label2)

## 服务端推

服务端推，指的是由服务器主动的向客户端发送消息（响应）。在应用层的HTTP协议实现中，“请求-响应”是一个round trip，它的起点来自客户端，因此在应用层之上无法实现简易的服务端推功能。当前解决服务端推送的方案有这几个：

1. 客户端长轮询
2. websocket双向连接
3. iframe永久帧

长轮训虽然可以避免短轮训造成的服务端过载，但在服务端返回数据后仍需要客户端主动发起下一个长轮训请求，等待服务端响应，这样仍需要底层的连接建立而且服务端处理逻辑需要相应处理，不符合逻辑上的流程简单的服务端推送；

websocket连接相对而言功能最强大，但是它对服务器的版本有要求，在可以使用websocket协议的服务器上尽量采用此种方式；

iframe永久帧则是在在页面嵌入一个专用来接受数据的iframe页面，该页面由服务器输出相关信息，如，服务器不停的向iframe中写入类似的script标签和数据，实现另一种形式的服务端推送。不过永久帧的技术会导致主页面的加载条始终处于“loading”状态，体验很差。

HTML5规范中提供了服务端事件EventSource，浏览器在实现了该规范的前提下创建一个EventSource连接后，便可收到服务端的发送的消息，这些消息需要遵循一定的格式，对于前端开发人员而言，只需在浏览器中侦听对应的事件皆可。

相比较上文中提到的3中实现方式，EventSource流的实现方式对客户端开发人员而言非常简单，兼容性上出了IE系的浏览器（IE、Edge）外其他都良好；对于服务端，它可以兼容老的浏览器，无需upgrade为其他协议，在简单的服务端推送的场景下可以满足需求。在浏览器与服务端需要强交互的场景下，websocket仍是不二的选择。

## EventSource规范简析

### 浏览器端

浏览器端，需要创建一个EventSource对象，并且传入一个服务端的接口URI作为参数。

```
var evtSource = new EventSource('http://localhost:9111/es');
```

其中，'http://localhost:9111/es'为服务端吐出数据的接口。目前，EventSource在大多数浏览器端不支持
跨域，因此它不是一种跨域的解决方案。

默认EventSource对象通过侦听“message”事件获取服务端传来的消息，“open”事件则在http连接建立后触发，”error“事件会在通信错误（连接中断、服务端返回数据失败）的情况下触发。同时，EventSource规范允许服务端指定自定义事件，客户端侦听该事件即可。

```
evtSource.addEventListener('message',function(e){
    console.log(e.data);
});
evtSource.addEventListener('error',function(e){
    console.log(e);
})
```

### 服务端

事件流的对应MIME格式为**text/event-stream**，而且其基于HTTP长连接。针对HTTP1.1规范默认采用长连接，针对HTTP1.0的服务器需要特殊设置。

服务端返回数据需要特殊的格式，它分为四种消息类型：

```
event, data, id, retry
```

其中，event指定自定义消息的名称，如**event: customMessage\n**;

data指定具体的消息体，可以是对象或者字符串，如**data: `JSON.stringify(jsonObj)\n\n`**,在消息体后面有两个换行符\n，代表当前消息体发送完毕，一个换行符标识当前消息并未结束，浏览器需要等待后面数据的到来后再触发事件；

id为当前消息的标识符，可以不设置。一旦设置则在浏览器端的eventSource对象中就会有体现(假设服务端返回**id: 369\n**)，`eventSource.lastEventId == 369`。该字段使用场景不大;

retry设置当前http连接失败后，重新连接的间隔。EventSource规范规定，客户端在http连接失败后默认进行重新连接，重连间隔为3s，通过设置retry字段可指定重连间隔;

每个字段都有名称，紧接着有个”:“。当出现一个没有名称的字段而只有”:“时，这就会被服务端理解为”注释“，并不会被发送至浏览器端，如*: commision*。

由于EventSource是基于HTTP连接之上的，因此在一段没有数据的时期会出现超时问题。**服务器默认HTTP超时时间为2分钟，在node端可以通过response.connection.setTimeou(0)设置为默认的2min超时**， 因此需要服务端做心跳保活，否则客户端在连接超时的情况下出现**net::ERR_INCOMPLETE_CHUNKED_ENCODING**错误。通过阅读相关规范，发现注释行可以用来防止连接超时,服务器可以定期发送一条消息注释行,以保持连接不断。

下面提供koa的服务端代码：

```
var fs = require('fs');
var path = require('path');
var PassThrough = require('stream').PassThrough;
var Readable = require('stream').Readable;
var koa = require('koa');
var Router = require('koa-router');
var app = new koa();
var router = new Router();

function RR(){
    Readable.call(this,arguments);
}
RR.prototype = new Readable();
RR.prototype._read = function(data){
}

router.get('/',function(ctx,next){
    ctx.set('content-type','text/html');
    ctx.body = fs.readFileSync(path.join(process.cwd(),'eventServer.html'));
});

const sse = (stream,event, data) => {
    return stream.push(`event:${ event }\ndata: ${ JSON.stringify(data) }\n\n`)
//    return stream.write(`event:${ event }\ndata: ${ JSON.stringify(data) }\n\n`);
}
router.get('/es',function(ctx,next){
    var stream = new RR()//PassThrough();
    ctx.set({
        'Content-Type':'text/event-stream',
        'Cache-Control':'no-cache',
        Connection: 'keep-alive'
    });
    sse(stream,'test',{a: "yango",b: "tango"});
    ctx.body = stream;
    setInterval(()=>{
        sse(stream,'test',{a: "yango",b: Date.now()});
    },3000); 
});

app.use(router.routes());
app.listen(9111,function(){
    console.log('listening port 9111');
});
```

此处需要注意的是koa-router的返回值必须是一个Stream（Readable），这是由于koa的特殊性造成的。如果context.body不是Stream是一个字符串或者Buffer实例，会直接在node原生中调用res.end(buffer),结束了HTTP响应：

```
koa lib/application.js

// responses
if (Buffer.isBuffer(body)) return res.end(body);
if ('string' == typeof body) return res.end(body);
if (body instanceof Stream) return body.pipe(res);
```

因此造成了服务端事件流无法正确响应。而返回Stream类型的方式有几种，如通过扩展stream模块的Readable可读流返回或者直接采用PassThrough流返回，亦可通过through2模块或者Transform对象实现，归根到底保证可以从该stream对象中pipe出数据至http.ServerResponse对象中。

附页面代码

```
<!DOCTYPE html>
<html>
<head>
</head>
<body>
    <div>
        hello world
    </div>
    <p id="info"></p>
    <script>
        var infoShow = document.querySelector('#info');
        var se = new EventSource('http://localhost:9111/es');
        se.addEventListener('test',function(e){
            infoShow.textContent += e.data+'\n';
        });
        se.addEventListener('error',function(e){
            console.log(e);
        })
    </script>
</body>
</html>
```

## 参考资料

[使用服务器发送事件](https://developer.mozilla.org/zh-CN/docs/Server-sent_events/Using_server-sent_events)
[EventSource超时](https://stackoverflow.com/questions/8761025/why-is-eventsource-connection-closed-every-30-60-sec-when-no-data-transported-w)


# 浏览器输入URL到 请求全过程以及相应的性能优化

## 前言

对http 的理解，一直都处于看完资料，没过几天又忘记了下面这篇文章只是自己对`http`的整个过程一个梳理，并且从`http`的请求过来，来简单的进行性能优化进行一个梳理。 其中主要设计如下几个环节：

1. http请求全过程
2. DNS解析全过程(dns-prefetch, preconnect, preload, prefetch, def, async)
3. TCP 连接(三次握手，四次挥手(为什么需要三次握手，四次挥手))
4. 缓存处理(expires, cache-control(max-age, public/private, no-cache, no-store,Pragma, must-revalidation), last-modify(If-modify-since), etag(if-none-match))，浏览器缓存(内存缓存from memory cache)， 强缓存，协商缓存(from disk cache)
5. PageSpend 和LightHouse 来进行性能分析

对上面的几个环节的梳理，都是借鉴前辈们的分析成果，后面会列出所有的文章连接。

## http 请求全过程

参考文章 [当你输入一个网址的时候，实际会发生什么?](http://www.cnblogs.com/wenanry/archive/2010/02/25/1673368.html)

1. 在浏览器地址栏输入地址，比如说： `fecebook.com`
2. 浏览器通过域名查找IP地址(DNS解析)
3. 浏览器给Web服务器发送一个HTTP请求
4. facebook 服务器进行永久重定向

> 因为我们输入的`fecebook.com`,而不是`http://www.facebook.com/`所以服务器自动进行了永久重定向，返回的是**301** 状态码

> 为什么服务器一定要重定向而不是直接发会用户想看的网页内容呢？这个问题有好多有意思的答案。

其中一个原因跟搜索引擎排名有 关。你看，如果一个页面有两个地址，就像http://www.igoro.com/ 和http://igoro.com/，搜索引擎会认为它们是两个网站，结果造成每一个的搜索链接都减少从而降低排名。而搜索引擎知道301永久重定向是 什么意思，这样就会把访问带www的和不带www的地址归到同一个网站排名下。

还有一个是用不同的地址会造成缓存友好性变差。当一个页面有好几个名字时，它可能会在缓存里出现好几次。

1. 浏览器跟踪重定向地址
2. 服务器处理"请求
3. 服务器返回一个HTML响应
4. 浏览器解析HTML并绘制页面
5. 浏览器发送潜入在HTML中的对象，比如说图片，CSS样式，JS文件，字体等
6. 浏览器发送Ajax 请求

从上面我们已经知道从输入URL到展示页面的整个大致过程，下面我们会针对其中几个关键步骤再次深入分析

## DNS 解析过程

在上面我们已经知道了，我们输入一个URL，发起请求，其实接收请求的最终一个服务器，而每个服务器都一个IP地址，所以一般一个域名对一个一个IP地址(也有对应多个IP地址的，我们暂时值分析对一个IP地址的情况)， 但是浏览器怎么知道域名到底对应的是那个IP地址呢，这个就是涉及到怎么去域名解析了。 域名解析主要是如下过程：

1. 通过浏览器缓存来查找，如果缓存中存在，则就不会继续查找，直接用查找到的IP地址，我们可以在 Chrome 中查看我们浏览器中缓存的所有的DNS.
2. 如果浏览器没有查找到，我们就会在我们电脑中去查找是否保存了对应的域名信息
3. 如果本地没有保存，就会从路由器去查找
4. 如果路由器都没有，就会去ISP 中查找

从上面分析可知，我们输入一个域名需要去做DNS解析找到IP，但是在我们的代码中，经常将一些静态资源放在CDN中，每个CDN地址我们都要去做下DNS解析，这个会浪费时间，我们可以通过预先进行DNS解析，然后在请求的时候，DNS已经解析完成就不用等待了

```
<!--在head标签中，越早越好-->
<link rel="dns-prefetch" href="//example.com">
复制代码
```

## Tcp 连接

参考文章[探网络系列（1）-TCP三次握手&Render Tree页面渲染=>从输入URL到页面显示的过程？](https://segmentfault.com/a/1190000006921322)



![img](data:image/svg+xml;utf8,<?xml version="1.0"?><svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="719" height="800"></svg>)



### 第一次握手：建立连接

客户端发送连接请求报文段，将SYN值设为1，Sequence Number为x。客户端进入SYN_SEND状态，等待服务器的确认。

### 第二次握手：服务器收到SYN报文段

服务器收到客户端SYN报文段，需要对这个SYN报文段进行确认，设置Acknowledgment Number为x+1(Sequence Number+1)。同时，自己自己还要发送SYN请求信息，将SYN值设为1，Sequence Number设为y。服务器端将上述所有信息放到一个报文段（即SYN+ACK报文段）中，一并发送给客户端，服务器进入SYN_RECV状态。

### 第三次握手：客户端收到SYN+ACK报文段

客户端收到服务器的SYN+ACK报文段后将Acknowledgment Number设置为y+1，向服务器发送ACK报文段，这个报文段发送完毕以后，客户端和服务器端都进入ESTABLISHED状态，完成TCP三次握手。

完成三次握手，客户端与服务器开始传送数据，在上述过程中，还有一些重要的概念：

未连接队列：在三次握手协议中，服务器维护一个未连接队列，该队列为每个客户端的SYN包（syn=j）开设一个条目，该条目表明服务器已收到SYN包，并向客户发出确认，正在等待客户的确认包。这些条目所标识的连接在服务器处于Syn_RECV状态，当服务器收到客户的确认包时，删除该条目，服务器进入ESTABLISHED状态。 Backlog参数：表示未连接队列的最大容纳数目。

SYN-ACK 重传次数：服务器发送完SYN－ACK包，如果未收到客户确认包，服务器进行首次重传，等待一段时间仍未收到客户确认包，进行第二次重传，如果重传次数超过系统规定的最大重传次数，系统将该连接信息从未连接队列中删除。注意，每次重传等待的时间不一定相同。

未连接存活时间：是指未连接队列的条目存活的最长时间，也即服务从收到SYN包到确认这个报文无效的最长时间，该时间值是所有重传请求包的最长等待时间总和。有时我们也称未连接存活时间为Timeout时间、SYN_RECV存活时间。

### 为什么是三次握手

[参考文章](https://www.zhihu.com/question/24853633/answer/63668444)



![img](fromURLtoHTTP.assets/16802443da610767)



在谢希仁著《计算机网络》第四版中讲“三次握手”的目的是为了防止已失效的连接请求报文段突然又传送到了服务端，因而产生错误

“已失效的连接请求报文段”的产生在这样一种情况下：client发出的第一个连接请求报文段并没有丢失，而是在某个网络结点长时间的滞留了，以致延误到连接释放以后的某个时间才到达server。本来这是一个早已失效的报文段。但server收到此失效的连接请求报文段后，就误认为是client再次发出的一个新的连接请求。于是就向client发出确认报文段，同意建立连接。假设不采用“三次握手”，那么只要server发出确认，新的连接就建立了。由于现在client并没有发出建立连接的请求，因此不会理睬server的确认，也不会向server发送数据。但server却以为新的运输连接已经建立，并一直等待client发来数据。这样，server的很多资源就白白浪费掉了。采用“三次握手”的办法可以防止上述现象发生。例如刚才那种情况，client不会向server的确认发出确认。server由于收不到确认，就知道client并没有要求建立连接。”

作者：wuxinliulei

链接：[www.zhihu.com/question/24…](https://www.zhihu.com/question/24853633/answer/63668444)

来源：知乎

### 为什么是四次挥手

参考文章 [TCP四次挥手(图解)-为何要四次挥手](https://blog.csdn.net/daguairen/article/details/52673194)



![img](fromURLtoHTTP.assets/1680216537e7fbf0)

TCP协议是一种面向连接的、可靠的、基于字节流的运输层通信协议。TCP是全双工模式，这就意味着，当主机1发出FIN报文段时，只是表示主机1已经没有数据要发送了，主机1告诉主机2，它的数据已经全部发送完毕了；但是，这个时候主机1还是可以接受来自主机2的数据；当主机2返回ACK报文段时，表示它已经知道主机1没有数据发送了，但是主机2还是可以发送数据到主机1的；当主机2也发送了FIN报文段时，这个时候就表示主机2也没有数据要发送了，就会告诉主机1，我也没有数据要发送了，之后彼此就会愉快的中断这次TCP连接。如果要正确的理解四次分手的原理，就需要了解四次分手过程中的状态变化。



------

作者：李太白不白

来源：CSDN

原文：[blog.csdn.net/daguairen/a…](https://blog.csdn.net/daguairen/article/details/52673194)

1. 当主机1 发出FIN报文时，只是告诉主机2，我已经没有数据需要发送了， 但是还是可以接收主机2的数据(第一次)
2. 当主机2发出报文时，只是告诉主机1，我已经接收到信号，知道你没有数据再要发送了， 但是主机2还是可以继续发送数据给主机1(第二次)
3. 当主机2也真的没有数据要发送给主机1时，就会发送报文给主机1， 告诉主机1我也没有数据需要发送了(第三次)
4. 主机1收到报文后，再次发送报文给主机2，说明可以关闭连接了(第四次)

### 总结

从上面分析可知，每次请求资源都需要进行TCP连接，会有三次握手操作，才表示连接成功，连接成功后，服务器才会向客户端发送数据，如果每次请求资源时都才进行连接，是很浪费时间的，我们可以在请求资源之前，先预先连接，在真正请求的时候，就已经连接上，之前发送资源就可以，我们可以利用如下方式：

参考文章[Head标签里面的dns-prefetch，preconnect，prefetch和prerender](https://segmentfault.com/a/1190000011065339)

```
<link rel="preconnect" href="//example.com">
<link rel="preconnect" href="//cdn.example.com" crossorigin>
复制代码
```

浏览器会进行以下步骤：

1. 解释href的属性值，如果是合法的URL，然后继续判断URL的协议是否是http或者https否则就结束处理
2. 如果当前页面host不同于href属性中的host,crossorigin其实被设置为anonymous(就是不带cookie了)，如果希望带上cookie等信息可以加上crossorign属性,corssorign就等同于设置为use-credentials

## 缓存处理

我们已经建立了TCP连接，服务端已经可以往客户端(浏览器)发送资源了，但是如果如果已经请求过一次资源了，但是我们刷新页面，我们还需要重新请求资源，这样也太浪费请求了，浏览器解决再次请求有**缓存** 策略，缓存就是再次请求资源能尽量从已经请求的资源中获取最好从而减少了请求次数，也就是不需要再次进行TCP连接，但是如果浏览器每次都查看缓存中否已经有了资源就不再次请求，这样也会造成可能我们获取到的资源不是最新的，所以针对着这两种情况，浏览器缓存有如下两种策略：

1. 强缓存
2. 协商缓存(弱缓存)

下面我们来针对着两种策略来进行简单的分析。

### 强缓存

参考文章[当我们在谈论HTTP缓存时我们在谈论什么](https://juejin.im/post/6844903618890465294?utm_source=gold_browser_extension)

强缓存主要是浏览器根据请求头部的两个字段来判断的：

1. expires
2. cache-control

**强缓存命中 from memory cache & from disk cache**

在测试的时候，看到命中强缓存时，有两种状态，200 (from memory cache) cache & 200 (from disk cache)，于是去找了一下这两者的区别：

1. memory cache: 将资源存到内存中，从内存中获取。
2. disk cache：将资源缓存到磁盘中，从磁盘中获取。 二者最大的区别在于：当退出进程时，内存中的数据会被清空，而磁盘的数据不会。

其实如果我们一个页面中存在请求多个一样的图片资源，浏览器会自动处理，从内存缓存中自动获取(from memory cache), 但是我们关闭了页面或者刷新了页面，这个内存缓存就失效了， 不过这个缓存是浏览器自动帮我们处理的，我们做不了什么处理.

#### expires

expires 是http 1.0 里面的特性，通过指定资源指定缓存到期GMT的绝对时间 来判断资源是否过期，如果没有过期就用缓存，否则重新请求资源.

缺点: 由于使用具体时间，如果时间表示出错或者没有转换到正确的时区都可能造成缓存生命周期出错。

#### cache-control

Cache-Control 是`http1.1`中为了弥补Expires的缺陷而加入的，当Expires和Cache-Control同时存在时，Cache-Control优先级高于Expires。

下面我们梳理下`cache-control`的配置：

| 属性            | 描叙                                                         |
| --------------- | ------------------------------------------------------------ |
| max-age         | 设置缓存存储的最大周期，超过这个时间缓存被认为过期(单位秒)。`cache: max-age=60` 这里是60秒 |
| public/private  | public 表示服务器端和浏览器端都能缓存, `cache: max-age=60, public`, private 表示只能用户的浏览器才能缓存，路由器已经CDN不能缓存 |
| no-cache        | no-cache 不是说不缓存，而是必须需要从服务器去请求一次，如果缓存还生效，则就服务器只会返回304，不会返回请求相应体，请求不会减少，但是请求的资源可能减小( Express 缓存策略中，如果请求头部携带了`cache-control`而且设置了`no-cache`则只会重新返回新的资源，不会返回304 ) |
| no-store        | 不缓存，使用协商缓存                                         |
| must-revalidate | 缓存必须在使用之前验证旧资源的状态，并且不可使用过期资源。   |

如果cache-control 表示资源过期，或者设置了no-store, 并不是说明缓存的资源不能再使用，浏览器还可以配合来使用**协商缓存**, 下面我们就来分析协商缓存

### 协商缓存

如果强缓存(cache-control)资源失效，浏览器就会调用协商缓存策略，协商缓存策略主要是通过如下的两个请求头部来处理：

1. last-modified (if-modified-since) -> http 1.0
2. Etag(if-none-match) -> http 1.1

#### last-modified

浏览器在请求服务器资源时，服务器会将文件的最后修改时间，赋值给相应求头`last-modified`,如： last-moified: Fri,08 Jun 2018 10:2:30: GMT

再次请求这个资源时(刷新页面（不是强制刷新F5 + Ctrl），或者重新打开这个页面), 请求头部会添加一个`if-modified-since`的头部信息，其值就是`last-modified`的值, 如：if-modified-since：Fri,08 Jun 2018 10:2:30: GMT, 发送给服务器，服务器会根据这个值来判断缓存是否生效，如果缓存依旧生效，则返回一个**304**，和一个空的响应体 , 浏览器机会从缓存读取，否则返回**200** 并且返回请求结果

#### Etag

Etag 其实和last-modified 的效果一样，都是后端针对相应的资源，返回的一个标识，只是last-modified 是资源最后的修改时间，etag 是资源相应的标识，不同的服务器生成etag的策略是不一样的。比如说，express 框架生成etag 的规则是 `文件最后一次修改时间-文件的大小`

```
function stattag (stat) {
  // mtime 文件最后一次的修改时间
  // size 文件的大小
  var mtime = stat.mtime.getTime().toString(16)
  var size = stat.size.toString(16)

  return '"' + size + '-' + mtime + '"'
}
复制代码
```

再次请求资源时(刷新页面（不是强制刷新F5 + Ctrl），或者重新打开这个页面),请求头部会添加一个`if-none-match`的请求头发送给服务器，服务器会根据这个值来判断缓存是否生效， 如果缓存依旧生效，则返回一个**304**，和一个空的响应体 , 浏览器机会从缓存读取，否则返回**200** 并且返回请求结果。

从上面的分析感觉`last-modified` 和`etag`的功能，应该一样，为什么在HTTP 1.1 会出现etag 的概念呢，etag 主要是解决了如下问题：

1. 一些文件也许内容并不改变(仅仅改变的修改时间)，这个时候我们不希望文件重新加载。（Etag值会触发缓存，Last-Modified不会触发）( 从express 生成的etag 的规则来看，这个问题并不存在 )
2. If-Modified-Since能检查到的粒度是秒级的，当修改非常频繁时，Last-Modified会触发缓存，而Etag的值不会触发，重新加载。
3. 某些服务器不能精确的得到文件的最后修改时间。

#### 如果同时设置了`last-modified` 和`etag` 标签，那谁的优先级更高呢

如果同时设置了`last-modified` 和`etag` 标签，那谁的优先级更高呢？ 规定是etag优先生效， 那为什么etag 为什么会优先于last-modified 呢？是由浏览器决定的？

经过分析，不是由浏览器决定的，而是有**服务器** 决定的。浏览器只是在请求资源的时候携带**last-modified** 和**etag** 的请求头到服务器，接下来就由服务器来决定缓存是否可以用， 我们可以查看下**express** 的处理逻辑的源代码来分析：

```
    if (this.isCachable() && this.isFresh()) {
      this.notModified()
      return
    }
复制代码
```

其中`this.notModified()`就是直接返回一个`304`:

```
SendStream.prototype.notModified = function notModified () {
  var res = this.res
  debug('not modified')
  this.removeContentHeaderFields()
  res.statusCode = 304
  res.end()
}
复制代码
```

express 判断缓存是否生效最主要的逻辑是在`this.isFresh()`方法中实现：

```
function fresh (reqHeaders, resHeaders) {
  // fields
  var modifiedSince = reqHeaders['if-modified-since']
  var noneMatch = reqHeaders['if-none-match']

  // unconditional request
  if (!modifiedSince && !noneMatch) {
    return false
  }

  // Always return stale when Cache-Control: no-cache
  // to support end-to-end reload requests
  // https://tools.ietf.org/html/rfc2616#section-14.9.4
  var cacheControl = reqHeaders['cache-control']
  if (cacheControl && CACHE_CONTROL_NO_CACHE_REGEXP.test(cacheControl)) {
    return false
  }

  // if-none-match
  if (noneMatch && noneMatch !== '*') {
    var etag = resHeaders['etag']

    if (!etag) {
      return false
    }

    var etagStale = true
    var matches = parseTokenList(noneMatch)
    for (var i = 0; i < matches.length; i++) {
      var match = matches[i]
      if (match === etag || match === 'W/' + etag || 'W/' + match === etag) {
        etagStale = false
        break
      }
    }

    if (etagStale) {
      return false
    }
  }

  // if-modified-since
  if (modifiedSince) {
    var lastModified = resHeaders['last-modified']
    var modifiedStale = !lastModified || !(parseHttpDate(lastModified) <= parseHttpDate(modifiedSince))

    if (modifiedStale) {
      return false
    }
  }

  return true
}
复制代码
```

我们可以根据上面的代码来具体分析`express`具体是怎样来判断缓存是否生效

1. 如果请求头部没有携带`if-modified-since` 和`if-none-match`头部，就直接判断缓存失效

```
  var modifiedSince = reqHeaders['if-modified-since']
  var noneMatch = reqHeaders['if-none-match']
  if (!modifiedSince && !noneMatch) {
    return false
  }
复制代码
```

1. 如果请求头部有`cache-control`, 并且有设置**no-cache** , 则直接判断缓存失效(`var CACHE_CONTROL_NO_CACHE_REGEXP = /(?:^|,)\s*?no-cache\s*?(?:,|$)/`)

```
  var cacheControl = reqHeaders['cache-control']
  //
  if (cacheControl && CACHE_CONTROL_NO_CACHE_REGEXP.test(cacheControl)) {
    return false
  }
复制代码
```

1. 然后来判断`if-none-match`, 判断的方法就是重新获取一个`etag`, 然后判断`if-none-match`是否与`etag`相等， 如果不相等， 就直接判断缓存失效

```
  // if-none-match
  if (noneMatch && noneMatch !== '*') {
    var etag = resHeaders['etag']

    if (!etag) {
      return false
    }

    var etagStale = true
    var matches = parseTokenList(noneMatch)
    for (var i = 0; i < matches.length; i++) {
      var match = matches[i]
      if (match === etag || match === 'W/' + etag || 'W/' + match === etag) {
        etagStale = false
        break
      }
    }

    if (etagStale) {
      return false
    }
  }
复制代码
```

其中`var etag = resHeaders['etag']`是在请求时，重新获取的`etag`

1. 最后来判断`if-modified-since`,其判断的逻辑是，如果`last-modified`的值小于等于`if-modified-since`的值， 则直接判断缓存失效

```
  // if-modified-since
  if (modifiedSince) {
    var lastModified = resHeaders['last-modified']
    var modifiedStale = !lastModified || !(parseHttpDate(lastModified) <= parseHttpDate(modifiedSince))

    if (modifiedStale) {
      return false
    }
  }
复制代码
```

从上面的分析可知，其实`Express`的缓存**生效**机制并没有遵循`etag`的优先级高于`last-modified`,而是在判断**失效** 的机制遵循了`etag`的优先级高于`last-modified`.


作者：bluebrid
链接：https://juejin.cn/post/6844903750746767374
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
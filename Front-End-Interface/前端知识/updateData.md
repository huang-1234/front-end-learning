在这里，推荐大家用IE的F12开发者工具来抓网络包，当然Fiddler等也都可以，不过确实在这件事上，一个是没必要，一个可能Fiddler在修改IE端口指向8000之后可能会有问题。

回到话题，这里需要解释一下浏览器对客户端缓存看的是整条URL包括后面的参数，所以当你有个地方引用：

http://volnet.cnblogs.com/scripts/demo.js 的时候，你再次访问

http://volnet.cnblogs.com/scripts/demo.js?v=2 的时候，该缓存仍然在你的浏览器里呆着，当你下次继续访问不带参数的demo.js的时候，你引用的仍然还是旧的文件。

你可能对此表示不以为然，因为大部分的脚本通常都是你自己在引用，因此你更新他们的时候，总是很容易。但是有的时候，你的脚本会被第三方引用，当你变更脚本的时候，你希望他们尽量少去改动，这时候，你可能就会遇到客户端无法刷新脚本的问题。

这时候你可能会想到Last-Modified和ETag标签，这些标签的出现，既可以替代在js文件后面加版本号或者时间戳的问题，在服务器修改他们后，通常可以被监测到，并修改服务器的ETag值，当下次从客户浏览器传回If-None-Match和If-Modified-Since的时候就可以在服务器判断是应该返回304呢，还是返回200呢？看上去挺美好的事情，经常会有各种各样的意想不到。谁知道这些看上去很简单的东西，并不是每个浏览器都具备的能力，而且可能的原因还来自各种各样千奇百怪的客户端设置，抛开他们的问题而言。摆在眼前的事实就是，客户端的脚本就是因为304而不更新了，你能怎么办？你抓回来的包，可以证明你的服务器下发了ETag，但人家就是不给你返回If-None-Match，你也不太可能在服务器去修改脚本的版本号，难道你要让大家都按Ctrl+F5么？（可怜的事情还真不是发生在一些过时的浏览器上，今天找到的几个问题，IE9/IE8全都遇上了）。

这里有个问题需要说一下，就是当你的文件已经是304的时候，除非服务器支持ETag并且你的客户端带回If-None-Match标记，或者是Last-Modified和If-Modifed-Since组合的时候，原来那个链接，基本上都不会给你返回200，这或许是你早期的服务器设置所造成的，他不会因为你重新下发ETag，而让他们去给你返回这些值，除非你这次是200，并同时下发了那些用来缓存的标记。这个结论是我推导出来的，可能是IE9的行为bug，或者时设计使然。

我们如何避免他们呢？

我想来想去，既然服务器在我手里，我可以控制，并且它确实下发了ETag，那么我何不就借服务器的能力，让它把状态200发下去呢？激发它下发状态200，就是让它回传一个不一样的ETag值（在客户端叫If-None-Match），这样服务器自然就会下发了，而那些一直缓存不更新的客户，通常是因为没有带任何与之相关的参数，而宣布刷新资源失败。这里我用了XMLHttpRequest去发一个GET请求，并把驱动状态码200的必要条件给带上，就可以了。

```js
var httpCacheUtil = {
            createXHR: function () {
                if (typeof XMLHttpRequest != "undefined") {
                    return new XMLHttpRequest();
                }
                else if (typeof ActiveXObject != "undefined") {
                    if (typeof arguments.callee.activeXString != "string") {
                        var versions = ["MSXML2.XMLHttp.6.0", "MSXML2.XMLHttp.3.0", "MSXML2.XMLHttp"];
                        for (var i = 0, len = versions.length; i < len; ++i) {
                            try {
                                var xhr = new ActiveXObject(versions[i]);
                                arguments.callee.activeXString = versions[i];
                                return xhr;
                            }
                            catch (ex) {
                                // pass
                            }
                        }
                    }
                    return new ActiveXObject(arguments.callee.activeXString);
                }
                else {
                    throw new Error("No XHR object available");
                }
            },
            update: function(url){
                try {
                    var success = function(responseText) {
                    
                    };
                    var error = function(errorStatus) {
                    
                    };
                    var xhr = httpCacheUtil.createXHR();
                    if(typeof xhr != "undefined" && xhr != null) {
                        xhr.onreadystatechange = function (event) {
                            if (xhr.readyState == 4) {
                                if ((xhr.status >= 200 && xhr.status < 300) || xhr.status == 304) {
                                    if (typeof success === "function")
                                        success(xhr.responseText);
                                }
                                else {
                                    if (typeof error === "function")
                                        error(xhr.status);
                                }
                            }
                        };
                        xhr.open("GET", url, false);
                        xhr.setRequestHeader("If-None-Match","\"22426f327b8cd1:0\"");
                        xhr.setRequestHeader("If-Modified-Since", "Sat, 31 Dec 2011 02:51:00 GMT");
                        xhr.send(null);
                    }
                }
                catch(e){
                    // throw no exception
                }
            }
        };
        httpCacheUtil.update("http://volnet.cnblogs.com/Scripts/demo1.js");
        httpCacheUtil.update("http://volnet.cnblogs.com/Scripts/demo2.js");
```

那些关于ETag和Last-Modifed，Cache-Control:no-cache等的说明文档，在网上已经很多了，大家可以参考相关资料来了解浏览器缓存的相关知识。
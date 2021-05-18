# 开启网络线程到发出一个完整的http请求

## 什么是域名

# 什么是域名？

本文中我们讨论了域名是什么，域名是如何被构建的，以及如何获得一个域名。

| 前提: | 首先你得知道 [互联网是怎么工作的](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/How_does_the_Internet_work) 并理解 [什么是URL](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/What_is_a_URL)。 |
| :---- | ------------------------------------------------------------ |
| 目标: | 学习域名是什么，域名的工作方式，以及域名的重要性。           |

### [概述](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/What_is_a_domain_name#概述)

域名（Domain names）是互联网基础架构的关键部分。它们为互联网上任何可用的网页服务器提供了方便人类理解的地址。

任何连上互联网的电脑都可以通过一个公共[IP](https://developer.mozilla.org/en-US/docs/Glossary/IP)地址访问到，对于IPv4地址来说，这个地址有32位（它们通常写成四个范围在0~255以内，由点分隔的数字组成，比如173.194.121.32），而对于IPv6来说，这个地址有128位，通常写成八组由冒号分隔的四个十六进制数(e.g., `2027:0da8:8b73:0000:0000:8a2e:0370:1337`). 计算机可以很容易地处理这些IP地址, 但是对一个人来说很难找出谁在操控这些服务器以及这些网站提供什么服务。IP 地址很难记忆而且可能会随着时间的推移发生改变 。为了解决这些问题，我们使用方便记忆的地址，称作域名。

### [自主学习](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/What_is_a_domain_name#自主学习)

*还没有可用的资料。请考虑为此投稿[[Please, consider contributing](https://developer.mozilla.org/en-US/docs/MDN/Contribute/Getting_started)]。*

### [深入探索](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/What_is_a_domain_name#深入探索)

### [域名的结构](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/What_is_a_domain_name#域名的结构)

一个域名是由几部分（有可能只是一部分，也许是两部分，三部分...）组成的简单结构，它被点分隔，不同于中文书写顺序，它**需要从右到左阅读**。

![Anatomy of the MDN domain name](bNetWorkThreadhttpRequest.assets/structure.png)

域名的每一部分都提供着特定信息。

[TLD](https://developer.mozilla.org/en-US/docs/Glossary/TLD) （Top-Level Domain，顶级域名）

顶级域名可以告诉用户域名所提供的服务类型。最通用的顶级域名（.com, .org, .net）不需要web服务器满足严格的标准，但一些顶级域名则执行更严格的政策。比如：

- 地区的顶级域名，如.us，.fr，或.sh，可以要求必须提供给定语言的服务器或者托管在指定国家。这些TLD通常表明对应的网页服务从属于何种语言或哪个地区。
- 包含.gov的顶级域名只能被政府部门使用。
- .edu只能为教育或研究机构使用。

顶级域名既可以包含拉丁字母，也可以包含特殊字符。顶级域名最长可以达到63个字符，不过为了使用方便，大多数顶级域名都是两到三个字符。

顶级域名的完整列表是[ICANN](https://www.icann.org/resources/pages/tlds-2012-02-25-en)维护的。

- 标签 (或者说是组件)

  标签都是紧随着TLD的。标签由1到63个大小写不敏感的字符组成，这些字符包含字母A-z，数字0-9，甚至 “-” 这个符号（当然，“-” 不应该出现在标签开头或者标签的结尾）。举几个例子，`a`，`97`，或者 `hello-strange-person-16-how-are-you` 都是合法的标签。

- Secondary Level Domain, 二级域名

  刚好位于TLD前面的标签也被称为二级域名 (SLD)。一个域名可以有多个标签（或者说是组件），没有强制规定必须要3个标签来构成域名。例如，www.inf.ed.ac.uk 是一个正确的域名。当拥有了“上级”部分(例如 [mozilla.org](https://mozilla.org/))，你还可以创建另外的域名 (有时被称为 "子域名") (例如 [developer.mozilla.org](https://developer.mozilla.org/)).

### [购买域名](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/What_is_a_domain_name#购买域名)

#### 谁拥有域名？

你不能真正地 “购买一个域名”，你只能花钱获得一个域名在一年或多年内的使用权。不过你可以延长你的使用权，同时你的续期将优先于其他人的使用申请。但你从来都没有拥有过域名。

被称为域名注册商的公司通过域名登记来记录连接你和你的域名的技术与管理信息。

**提示 :** 对于一些域名，它可能不归属于某个域名注册商来负责记录。比如说，每个在.fire下的域名由Amazon管理。

#### 找个可用的域名

想要知道一个给定的域名是否可用，

- 去域名注册商的网站。它们大多会提供"whois"服务，告诉你一个域名是否可用。
- 另外，如果你使用系统的内置shell，可以在里面输入whois命令，下面显示的是mozilla.org网站的结果：

```text
$ whois mozilla.org
Domain Name:MOZILLA.ORG
Domain ID: D1409563-LROR
Creation Date: 1998-01-24T05:00:00Z
Updated Date: 2013-12-08T01:16:57Z
Registry Expiry Date: 2015-01-23T05:00:00Z
Sponsoring Registrar:MarkMonitor Inc. (R37-LROR)
Sponsoring Registrar IANA ID: 292
WHOIS Server:
Referral URL:
Domain Status: clientDeleteProhibited
Domain Status: clientTransferProhibited
Domain Status: clientUpdateProhibited
Registrant ID:mmr-33684
Registrant Name:DNS Admin
Registrant Organization:Mozilla Foundation
Registrant Street: 650 Castro St Ste 300
Registrant City:Mountain View
Registrant State/Province:CA
Registrant Postal Code:94041
Registrant Country:US
Registrant Phone:+1.6509030800
```

正如你所见，我不能注册`mozilla.org`，因为Mozilla基金会已经注册它了。

另外，如果你想看看我能不能注册`afunkydomainname.org`：

```
$ whois afunkydomainname.org
NOT FOUND
```

正如你所见，（在本文写作时）这个域名在whois数据库中不存在，所以我们可以要求去注册它。祝你好运吧！

#### 获得一个域名

过程很简单：

1. 去域名注册商的网站。
2. 通常那些网站上都有突出的"获得域名"宣传，点击它。
3. 按要求仔细填表。一定要**仔细检查**你是否有将你想要的域名拼错。一旦你给错误域名付款了，便为时已晚！
4. 注册商将会在域名正确注册后通知你。数小时之内，所有DNS服务器都会收到你的DNS信息。

**注意:** 在这个过程中注册商会要求你的真实住址。请保证你正确地填写了，因为在一些国家，如果你没有提供合法的地址，注册商会关闭你的域名。

#### DNS 刷新

DNS数据库存储在全球每个DNS服务器上，所有这些服务器都源于(refer to)几个被称为“权威名称服务器”或“顶级DNS服务器”。只要您的注册商创建或更新给定域名的任何信息，信息就必须在每个DNS数据库中刷新。 知道给定域名的每个DNS服务器都会存储一段时间的信息，然后再次刷新（DNS服务器再次查询权威服务器）。 因此，知道此域名的DNS服务器需要一些时间才能获取最新信息。

**注意 :** 这个时间一般被称为 **传播时间** 。 然而这个术语是不精准的，因为更新本身没有传播 (top → down)。被你电脑(down)查询的 DNS 服务器只在他需要的时候才从权威服务器(top)中获取信息。

### [DNS请求如何工作？](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/What_is_a_domain_name#dns请求如何工作？)

正如我们所看到的，当你想在浏览器中展示一个网页的时候，输入域名比输入IP简单多了。让我们看一下这个过程：

1. 在你的浏览器地址栏输入`mozilla.org`。
2. 您的浏览器询问您的计算机是否已经识别此域名所确定的IP地址（使用本地DNS缓存）。 如果是的话，这个域名被转换为IP地址，然后浏览器与网络服务器交换内容。结束。
3. 如果你的电脑不知道 `mozilla.org` 域名背后的IP, 它会询问一个DNS服务器，这个服务器的工作就是告诉你的电脑已经注册的域名所匹配的IP。
4. 现在电脑知道了要请求的IP地址，你的浏览器能够与网络服务器交换内容。

![Explanation of the steps needed to obtain the result to a DNS request](bNetWorkThreadhttpRequest.assets/2014-10-dns-request2.png)

### [下一步](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/What_is_a_domain_name#下一步)

好了,我们讲了许多有关的步骤和结构. 接下来.

- 如果你想亲自实践, 现在最好开始深入设计和探索 [对一个网页的剖析](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/Common_web_layouts).
- 关于建站需要的花销这类问题的讨论也是有价值的. 请参考 [建站需要花费多少钱 ](https://developer.mozilla.org/zh-CN/docs/Learn/Common_questions/How_much_does_it_cost).
- 或者在维基百科上阅读更多关于 [域名](http://en.wikipedia.org/wiki/Domain_name) .

## dns查询

## tcp/ip链接

## 五层因特网协议栈

## 优化方案，如dns-prefetch

### 诞生背景

Dns请求虽然占用了很少的带宽，但会有很高的延迟，由其以移动网络会更加明显。通过dns预解析技术可以很好的降低延迟

在firefox上使用dns-prefetch，dns预解析是与页面加载是并行处理的，且不用影响到页面加载的性能.

在以图片为主移动网站被访问时，在使用DNS预解析的情意中下，页面加载时间可以提升%5个点


### 一、什么是dns-prefetch？


DNS Prefetch 是一种 DNS 预解析技术。当你浏览网页时，浏览器会在加载网页时对网页中的域名进行解析缓存，这样在你单击当前网页中的连接时就无需进行 DNS 的解析，减少用户等待时间，提高用户体验。
目前每次DNS解析，通常在200ms以下。针对DNS解析耗时问题，一些浏览器通过DNS Prefetch 来提高访问的流畅性。


### 二、如何设置dns-prefetch？

DNS Prefetch 应该尽量的放在网页的前面，推荐放在
```html
<meta charset="UTF-8"> 后面。具体使用方法如下：
<meta http-equiv="x-dns-prefetch-control" content="on">

<link rel="dns-prefetch" href="//www.zhix.net">

<link rel="dns-prefetch" href="//api.share.zhix.net">

<link rel="dns-prefetch" href="//bdimg.share.zhix.net">

<link rel="dns-prefetch" href="http://renpengpeng.com" />
<!--如果不确定是http还是https连接的话建议如下写法 -->
<link rel="dns-prefetch" href="//renpengpeng.com" />
```
### 三、DNS Prefetching预解析实现原理与注意事项
```html
1.<meta>信息告诉浏览器，当前页面要做DNS预解析；

<meta http-equiv="x-dns-prefetch-control" content="on" />
2.</head>使用<link>标签来强制对DNS预解析；

<link rel="dns-prefetch" href="http://bdimg.share.baidu.com" />
```
3. dns-prefetch需慎用，多页面重复DNS预解析会增加重复DNS查询次数；

4. 浏览器对网站第一次的域名DNS解析查找流程：

浏览器缓存 -> 系统缓存 -> 路由器缓存 -> ISP -> DNS缓存 -> 递归搜素
5. 如果要禁止隐式的DNS Prefetch，可以使用以下标签
```html
<meta http-equiv="x-dns-prefetch-control" content="off">
```
### 四、典型案例;

淘宝：

支付宝：

网易：



 

### 注意;
> 虽然使用 DNS Prefetch 能够加快页面的解析速度，但是也不能滥用，因为有开发者指出 禁用DNS 预读取能节省每月100亿的DNS查询 

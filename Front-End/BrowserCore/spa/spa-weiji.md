**单页应用**（英语：single-page application，缩写**SPA**）是一种[网络应用程序](https://zh.wikipedia.org/wiki/网络应用程序)或[网站](https://zh.wikipedia.org/wiki/網站)的模型，它通过动态重写当前页面来与用户交互，而非传统的从服务器重新加载整个新页面。这种方法避免了页面之间切换打断[用户体验](https://zh.wikipedia.org/wiki/用户体验)，使应用程序更像一个[桌面应用程序](https://zh.wikipedia.org/wiki/应用软件)。在单页应用中，所有必要的代码（[HTML](https://zh.wikipedia.org/wiki/HTML)、[JavaScript](https://zh.wikipedia.org/wiki/JavaScript)和[CSS](https://zh.wikipedia.org/wiki/层叠样式表)）都通过单个页面的加载而检索[[1\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-Flanagan2006-1)，或者根据需要（通常是为响应用户操作）[动态装载](https://zh.wikipedia.org/wiki/動態裝載)适当的资源并添加到页面。尽管可以用[位置散列](https://zh.wikipedia.org/w/index.php?title=片段标识符&action=edit&redlink=1)或[HTML5](https://zh.wikipedia.org/wiki/HTML5)[历史API](https://zh.wikipedia.org/w/index.php?title=Comparison_of_layout_engines_(HTML5)&action=edit&redlink=1)来提供应用程序中单独逻辑页面的感知和导航能力，但页面在过程中的任何时间点都不会重新加载，也不会将控制转移到其他页面。[[2\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-2)与单页应用的交互通常涉及到与[网页服务器](https://zh.wikipedia.org/wiki/網頁伺服器)后端的动态通信。

## 目录



- [1历史](https://zh.wikipedia.org/wiki/单页应用#历史)
- 2技术举措
  - [2.1JavaScript框架](https://zh.wikipedia.org/wiki/单页应用#JavaScript框架)
  - [2.2Ajax](https://zh.wikipedia.org/wiki/单页应用#Ajax)
  - [2.3Websocket](https://zh.wikipedia.org/wiki/单页应用#Websocket)
  - [2.4服务器发送事件](https://zh.wikipedia.org/wiki/单页应用#服务器发送事件)
  - [2.5浏览器插件](https://zh.wikipedia.org/wiki/单页应用#浏览器插件)
  - [2.6数据传输（XML、JSON和Ajax）](https://zh.wikipedia.org/wiki/单页应用#数据传输（XML、JSON和Ajax）)
  - 2.7服务器架构
    - [2.7.1瘦服务器架构](https://zh.wikipedia.org/wiki/单页应用#瘦服务器架构)
    - [2.7.2胖的有状态服务器架构](https://zh.wikipedia.org/wiki/单页应用#胖的有状态服务器架构)
    - [2.7.3胖的无状态服务器架构](https://zh.wikipedia.org/wiki/单页应用#胖的无状态服务器架构)
- [3本地运行](https://zh.wikipedia.org/wiki/单页应用#本地运行)
- 4SPA模式带来的挑战
  - [4.1搜索引擎优化](https://zh.wikipedia.org/wiki/单页应用#搜索引擎优化)
  - [4.2客户端/服务器代码分区](https://zh.wikipedia.org/wiki/单页应用#客户端/服务器代码分区)
  - [4.3浏览器历史记录](https://zh.wikipedia.org/wiki/单页应用#浏览器历史记录)
  - [4.4分析](https://zh.wikipedia.org/wiki/单页应用#分析)
  - 4.5初次加载的速度
    - [4.5.1加快页面加载速度](https://zh.wikipedia.org/wiki/单页应用#加快页面加载速度)
- [5页面生命周期](https://zh.wikipedia.org/wiki/单页应用#页面生命周期)
- [6参考资料](https://zh.wikipedia.org/wiki/单页应用#参考资料)
- [7外部链接](https://zh.wikipedia.org/wiki/单页应用#外部链接)

## 历史[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=1)]

尽管早在2003年就讨论过这个概念，但单页应用（single-page application）一词的起源并不明晰。[[3\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-3)[Stuart (stunix) Morris](https://zh.wikipedia.org/w/index.php?title=Stuart_(stunix)_Morris&action=edit&redlink=1)在2002年4月编写的自主网站slashdotslash.com有着相同的目标和功能[[4\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-4)；同年稍晚，Lucas Birdeau、Kevin Hakman、Michael Peachey和Evan Yeh在美国专利8,136,109中描述了一个单页应用程序的实现。[[5\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-5)

在网页浏览器中可以使用JavaScript显示[用户界面](https://zh.wikipedia.org/wiki/用户界面)（UI）、运行应用程序逻辑，以及与Web服务器通信。成熟的开源库支持构建一个单页应用，从而减少开发人员要编写的JavaScript代码量。

## 技术举措[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=2)]

现今已有各种技术可以使网页浏览器停留在单个页面，并同时支持应用程序与服务器通信。

### JavaScript框架[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=3)]

诸如[AngularJS](https://zh.wikipedia.org/wiki/Angular)、[Ember.js](https://zh.wikipedia.org/wiki/Ember.js)、[Meteor.js](https://zh.wikipedia.org/w/index.php?title=Meteor_(web_framework)&action=edit&redlink=1)、[ExtJS](https://zh.wikipedia.org/wiki/Extjs)和[React](https://zh.wikipedia.org/wiki/React)等面向网页浏览器的JavaScript框架采纳了单页应用（SPA）原则。

- [AngularJS](https://zh.wikipedia.org/wiki/Angular)是一个全面的客户端侧框架。其模板基于双向[UI数据绑定](https://zh.wikipedia.org/w/index.php?title=UI数据绑定&action=edit&redlink=1)。数据绑定是一种自动方法，在模型改变时更新视图，以及在视图改变时更新模型。其HTML模板在浏览器中编译。编译步骤创建纯HTML，浏览器将其重新渲染到实时视图。该步骤会在随后的页面浏览中重复。在传统的服务器端HTML编程中，控制器和模型等概念在服务器进程中进行交互以产生新的HTML视图。在AngularJS框架中，控制器和模型状态在客户端的浏览器中维护，从而使生成新页面不依赖与服务器的交互。
- [Ember.js](https://zh.wikipedia.org/wiki/Ember.js)是基于模型-视图-控制器（[MVC](https://zh.wikipedia.org/wiki/MVC)）软件架构模型的客户端侧JavaScript Web应用程序框架。它允许开发人员在一个框架中通过常用的习惯用语和最佳实践来创建可伸缩的单页面应用程序。该框架提供丰富的对象模型、声明性双向数据绑定、计算属性，Handlebars.js提供的自动更新模板，以及一个路由器管理应用程序状态。
- [Meteor.js](https://zh.wikipedia.org/w/index.php?title=Meteor.js&action=edit&redlink=1)是一个专门为单页应用设计的全栈（客户端-服务器）JavaScript框架。它具有比Angular、Ember或ReactJS更简单的数据绑定特性[[6\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-6)，并且使用[Distributed Data Protocol](https://zh.wikipedia.org/w/index.php?title=Distributed_Data_Protocol&action=edit&redlink=1)[[7\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-7)和一个[发布/订阅](https://zh.wikipedia.org/wiki/发布/订阅)来自动将数据更改传播到客户端，无需开发人员编写任何同步代码。全栈反应确保从数据库到模板的所有层都可以在必要时自动更新。诸如服务器端渲染[[8\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-8)等生态系统包则解决搜索引擎优化（SEO）等问题。
- [Aurelia](http://aurelia.io/)是一个适用于移动设备、桌面和网页的JavaScript客户端框架。它类似[AngularJS](https://zh.wikipedia.org/wiki/Angular)，但更新、更符合标准，并采用模块化举措。Aurelia使用下一代[ECMAScript](https://zh.wikipedia.org/wiki/ECMAScript)编写。[[来源请求\]](https://zh.wikipedia.org/wiki/Wikipedia:列明来源)
- [Vue.js](https://zh.wikipedia.org/wiki/Vue.js)（通常称为Vue）是一个用于构建用户界面的开源渐进式JavaScript框架。
- [React](https://zh.wikipedia.org/wiki/React)（通常写为React.js或ReactJS）是一个构建用户界面的[JavaScript库](https://zh.wikipedia.org/wiki/JavaScript函式庫)。它由[Facebook](https://zh.wikipedia.org/wiki/Facebook)、[Instagram](https://zh.wikipedia.org/wiki/Instagram)和个人开发者以及企业社区维护。React最大的优势是易于使用——基本上任何熟悉HTML的开发人员都可以创建React应用程序。另一个所称的优势是可能使用相同的技术堆栈来同时创建Web与移动应用程序。有多家公司使用React和Redux库来让开发人员创建复杂但可扩展的Web应用程序。[[9\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-9)
- [Fulcro](https://zh.wikipedia.org/w/index.php?title=Fulcro&action=edit&redlink=1)是一个全栈库，它采用Netflix的Falcor，Facebook的Relay和Om Next对反应性，功能性，数据驱动软件进行改编的数据驱动原则。[[10\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-10)[[需要更好来源](https://zh.wikipedia.org/wiki/Wikipedia:列明来源)]

### Ajax[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=4)]

目前最常采用[Ajax](https://zh.wikipedia.org/wiki/AJAX)技术。主要从JavaScript使用[XMLHttpRequest](https://zh.wikipedia.org/wiki/XMLHttpRequest)/ActiveX对象（已不建议使用），其他Ajax方法包括使用IFRAME或script HTML元素。[jQuery](https://zh.wikipedia.org/wiki/JQuery)等流行的库可以为不同厂商的浏览器的Ajax行为标准化，进一步推广了Ajax技术。

### Websocket[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=5)]

[WebSocket](https://zh.wikipedia.org/wiki/WebSocket)是HTML5规范中的一个双向有状态实时客户端与服务器通信技术，在性能和简单性方面优于Ajax[[11\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-11)。

### 服务器发送事件[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=6)]

[服务器发送事件](https://zh.wikipedia.org/w/index.php?title=服务器发送事件&action=edit&redlink=1)（SSE）是一种服务器向浏览器客户端发起数据传输的技术。一旦创建了初始连接，事件流将保持打开状态，直到客户端关闭。该技术通过传统的HTTP发送，并具有WebSockets缺乏的各种功能，例如自动重新连接、事件ID以及发送任意事件的能力。[[12\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-12)

### 浏览器插件[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=7)]

可以使用浏览器插件技术（如[Silverlight](https://zh.wikipedia.org/wiki/Microsoft_Silverlight)、[Flash](https://zh.wikipedia.org/wiki/Adobe_Flash)或[Java applet](https://zh.wikipedia.org/wiki/Java_applet)）实现对服务器的异步调用。此种方法在业界已经过时。

### 数据传输（XML、JSON和Ajax）[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=8)]

对服务器的请求通常会带来原始数据（如[XML](https://zh.wikipedia.org/wiki/XML)或[JSON](https://zh.wikipedia.org/wiki/JSON)）或新[HTML](https://zh.wikipedia.org/wiki/HTML)的返回。在服务器返回HTML时，客户端上的JavaScript将更新[DOM](https://zh.wikipedia.org/wiki/文档对象模型)的部分区域。[[13\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-13)在返回原始数据时，客户端侧的JavaScript通常将其转换为HTML，然后用它来更新DOM的部分区域。

### 服务器架构[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=9)]

#### 瘦服务器架构[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=10)]

SPA技术将逻辑从服务器转移到了客户端。这导致Web服务器发展为一个纯数据API或Web服务。这种架构的转变在一些圈子中被称为“瘦服务器架构”，以强调复杂性已从服务端转移到客户端，并认为这最终降低了系统的整体复杂性。

#### 胖的有状态服务器架构[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=11)]

这种设计是服务器在内存中保存必要的客户端所处状态。这种模式下，当任何请求到达服务器（通常因用户操作）时，服务器发送适当的HTML和/或JavaScript，以及具体的更改，以使客户端达到新的期望状态（如添加、删除或更新部分客户端的DOM）。与此同时更新服务器中的状态。这种设计下的大部分逻辑都在服务器上运行，HTML通常也在服务器上呈现。在某些方面，服务器是模拟Web浏览器，接收事件并执行服务器状态下的增量更改，将这些更改自动传播到客户端。

这种方法需要更多的服务器内存和处理能力，但优点是简化的开发模型，因为：1、应用程序通常完全在服务器中编写；2、服务器中的数据和UI状态在相同的内存空间中共享，不需要自定义客户端/服务器通信隧道。

#### 胖的无状态服务器架构[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=12)]

这是有状态服务器方法的变体。客户端页面通常通过Ajax请求将表示其当前状态的数据发送到服务器。服务器使用这些数据能够重新构建需要修改的页面部分，并生成必要的数据或代码（如作为JSON或JavaScript），将其返回给客户端使其它达到新的状态。

此方法需要将更多数据发送给服务器，并可能需要更多计算资源才能部分或完全重建在服务器中的客户端页面状态。不过，这种方法更容易扩展，因为服务器中不存在每个客户端的页面数据，因此可以将Ajax请求分派到不同的服务器节点，而无需会话数据共享或服务器关联。

## 本地运行[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=13)]

部分单页应用可以使用[file URI方案](https://zh.wikipedia.org/w/index.php?title=File_URI方案&action=edit&redlink=1)依赖本地文件运行。这使用户可以从服务器上下载单页应用并在本地设备中运行，而不需要依赖与服务器的网络连接。这类单页应用如果想要存储或更新数据，则必须使用基于浏览器的[网页存储](https://zh.wikipedia.org/wiki/网页存储)。这些应用受益于[HTML5](https://zh.wikipedia.org/wiki/HTML5)提供的高级功能。[[14\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-14)

## SPA模式带来的挑战[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=14)]

由于单页应用偏离了最初为浏览器设计的无状态页面重绘模型，所以带来了一些新挑战。每个问题都有一个或一些有效的解决方案[[15\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-spimanifesto-15)：

- 客户端JavaScript库解决各种问题。
- 专门针对单页应用模型研发的服务器侧Web框架。[[16\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-16)[[17\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-17)[[18\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-18)
- 浏览器的发展以及为单页应用模型设计的HTML5规范。[[19\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-19)

### 搜索引擎优化[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=15)]

由于一些流行的[网络搜索引擎](https://zh.wikipedia.org/wiki/网络搜索引擎)的爬虫缺乏JavaScript执行能力[[20\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-20)，[搜索引擎优化](https://zh.wikipedia.org/wiki/搜尋引擎最佳化)（SEO）已成为面向公众的网站采用单页应用模型必须面对的一个问题。[[21\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-doogledevelopers-21)

在2009至2015年间，[Google网站管理员](https://zh.wikipedia.org/wiki/Google網站管理員)提出并推荐了一个“AJAX爬取方案”[[22\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-22)[[23\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-23)，其中使用起始为感叹号的片段标识符（`#!`）来标识有状态的[AJAX](https://zh.wikipedia.org/wiki/AJAX)页面。单页应用网站必须实现特殊行为才能允许搜索引擎的爬取工具提取相关的元数据。对于不支持此URL散列方案的搜索引擎，单页应用的散列网址会被视而不见。包括Jeni Tennison在内的许多作者认为这些“hash-bang”URI在W3C中被认为是存在问题的，因为它们使那些没有在浏览器中激活JavaScript的人无法访问页面。这也影响[HTTP引用地址](https://zh.wikipedia.org/wiki/HTTP參照位址)头，因为浏览器不允许在Referer头中发送片段标识符。[[24\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-Tennison2-24)2015年，Google不再建议使用散列AJAX爬取方案。[[25\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-25)

还有一些周边方法可以使网站表现为可抓取，它们都涉及创建反应单页应用内容的独立HTML页面。服务器可以创建基于HTML的网站版本并将此提供给爬取工具，也可以使用PhantomJS等无头浏览器运行JavaScript应用程序并输出生成的HTML。

这种方法需要付出不小的努力，最终可能给大型、复杂的网站带来很大的 维护成本，并且也有潜在风险。如果服务器生成的HTML被认为与单页应用存在较大差异，则网站排名将受到处罚。运行PhantomJS来输出HTML可能会降低页面的响应速度，一些搜索引擎（尤其是Google）可能因此对排名降级。[[26\]](https://zh.wikipedia.org/wiki/单页应用#cite_note-Holmes2015-26)

### 客户端/服务器代码分区[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=16)]

增加服务器与客户端之间所共享代码量的一种方法是使用如[Mustache](https://zh.wikipedia.org/w/index.php?title=Mustache_(template_system)&action=edit&redlink=1)、[Handlebars](https://zh.wikipedia.org/w/index.php?title=Handlebars_(template_system)&action=edit&redlink=1)等无逻辑模板语言。这种模板可以用不同的托管语言来呈现，如服务器上的[Ruby](https://zh.wikipedia.org/wiki/Ruby)和客户端的[JavaScript](https://zh.wikipedia.org/wiki/JavaScript)。但是，单纯共享模板通常需要重复使用[业务逻辑](https://zh.wikipedia.org/wiki/业务逻辑)来选择正确的模板，并使用数据填充它们。仅更新页面的一小部分（诸如大型模板中的一个文本的值）时，从模板呈现可能会产生负面的性能影响。替换整个模板也可能会干扰用户的选择或光标位置，只更新变更的值则可能不会。为避免这些问题，应用程序可以使用[UI数据绑定](https://zh.wikipedia.org/w/index.php?title=UI数据绑定&action=edit&redlink=1)或粒度[DOM](https://zh.wikipedia.org/wiki/文档对象模型)操作来更新页面的相应部分，而不是重新呈现整个模板。

### 浏览器历史记录[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=17)]

根据单页应用（SPA）模型的定义，它只有“单个页面”，因此这打破了浏览器为页面历史记录导航所设计的“前进/后退”功能。当用户按下后退按钮时，可能会遇到可用性障碍，页面可能返回真正的上一个页面，而非用户所期望的上一个页面。

传统的解决方案是不断更改浏览器网址（URL）的散列[片段标识符](https://zh.wikipedia.org/w/index.php?title=片段标识符&action=edit&redlink=1)以保持与当前的屏幕状态一致。这种方案可以通过JavaScript实现，并在浏览器中创建起网址历史事件。只要单页应用能根据网址散列所包含的信息重新生成相同的屏幕状态，就能实现预期的后退按钮行为。

而为进一步解决此问题，HTML5规范引入了[pushState](http://www.w3.org/html/wg/drafts/html/master/browsers.html#dom-history-pushstate)和[replaceState](http://www.w3.org/html/wg/drafts/html/master/browsers.html#dom-history-replacestate)来提供代码对实际网址和浏览器历史的访问。

### 分析[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=18)]

诸如[Google分析](https://zh.wikipedia.org/wiki/Google分析)等分析工具高度依赖在浏览器中加载全新的页面，而单页应用的工作方式不同于此。

### 初次加载的速度[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=19)]

单页应用的第一页加载会比基于服务器的应用慢。这是因为首次加载必须先拿到框架和应用程序的代码，再在浏览器中呈现所需的视图。基于服务器的应用程序只需将所需的HTML推送到浏览器，从而减少了延迟和下载用时。

#### 加快页面加载速度[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=20)]

有一些方法可以加快单页应用的初次加载速度，比如采用多项缓存措施、需要时再加载某些模块（懒加载）。但这依旧不可能摆脱需要下载框架的事实，某些部分必须在呈现前下载。这是一个“现在支付，或者稍后支付”的问题。性能与等待时间的权衡是开发者必须作出的权衡。

## 页面生命周期[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=21)]

单页应用在初始页面加载时被完全加载，然后页面区域被替换或更新为按需从服务器加载的新页面片段。为避免过度下载未使用的功能，单页应用通常会逐渐下载更多内容，如所需要的功能、页面的一小块，或者完整的一页。

单页应用（SPA）举措与原生桌面应用程序所使用的[多文件接口](https://zh.wikipedia.org/wiki/多文件介面)（MDI）呈现技术类似。

## 参考资料[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=22)]

1. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-Flanagan2006_1-0)** Flanagan, David, "JavaScript - The Definitive Guide", 5th ed., *O'Reilly, Sebastopol, CA, 2006*, p.497
2. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-2)** [Fixing the Back Button: SPA Behavior using Location Hash](https://web.archive.org/web/20160213175400/http://blog.falafel.com/fixing-back-button-simple-spa-behavior-using-location-hash/). [2016-01-18]. （[原始内容](http://blog.falafel.com/fixing-back-button-simple-spa-behavior-using-location-hash/)存档于2016-02-13） **（美国英语）**.
3. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-3)** [Inner-Browsing: Extending Web Browsing the Navigation Paradigm](https://developer.mozilla.org/en-US/docs/Inner-browsing_extending_the_browser_navigation_paradigm).[2011-02-03].
4. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-4)** [Slashdotslash.com: A self contained website using DHTML](http://stu-rl.eu/slash). [2012-07-06].
5. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-5)** [US patent 8,136,109](http://www.google.com/patents/US8136109). [2002-04-12].
6. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-6)** [Meteor Blaze](https://www.meteor.com/blaze). Meteor Blaze is a powerful library for creating live-updating user interfaces. Blaze fulfills the same purpose as Angular, Backbone, Ember, React, Polymer, or Knockout, but is much easier to use. We built it because we thought that other libraries made user interface programming unnecessarily difficult and confusing.
7. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-7)** [Introducing DDP](http://meteor.com/blog/2012/03/21/introducing-ddp), March 21, 2012
8. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-8)** [Server Side Rendering for Meteor](https://web.archive.org/web/20150320063111/https://meteorhacks.com/server-side-rendering.html). [31 January 2015]. （[原始内容](https://meteorhacks.com/server-side-rendering.html)存档于2015年3月20日）.
9. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-9)** blak-it.com, BLAKIT,. [Single-page applications vs. multiple-page applications: pros, cons, pitfalls - BLAKIT - IT Solutions](https://web.archive.org/web/20171019164105/https://blak-it.com/spa-advantages/). BLAKIT - IT Solutions. 2017-10-17[2017-10-19]. （[原始内容](https://blak-it.com/spa-advantages/)存档于2017-10-19） **（美国英语）**.
10. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-10)** [The Benefits of Fulcro](https://fulcrologic.github.io/fulcro/benefits.html). 2017-11-02.
11. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-11)** [Real-Time Monitoring using AJAX and WebSockets](http://www.computer.org/csdl/proceedings/ecbs/2013/4991/00/4991a110-abs.html). [2016-06-01].
12. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-12)** [Server-Sent Events](http://www.w3.org/TR/eventsource/). W3C. 17 July 2013.
13. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-13)** [Using InnerHTML](http://www.webrocketx.com/innerHTML.html). [2016-01-21].
14. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-14)** [Unhosted web apps](https://unhosted.org/).
15. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-spimanifesto_15-0)** [The Single Page Interface Manifesto](http://itsnat.sourceforge.net/php/spim/spi_manifesto_en.php). [2014-04-25].
16. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-16)** [Derby](http://derbyjs.com/). [2011-12-11]. （原始内容[存档](https://web.archive.org/web/20150801072933/http://derbyjs.com/)于2015-08-01）.
17. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-17)** [Sails.js](https://github.com/balderdashy/sails). [2013-02-20].
18. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-18)** [Tutorial: Single Page Interface Web Site With ItsNat](http://itsnat.sourceforge.net/index.php?_page=support.tutorial.spi_site). [2011-01-13].
19. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-19)** [HTML5](https://en.wikipedia.org/wiki/HTML5)
20. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-20)** [What the user sees, what the crawler sees](https://developers.google.com/webmasters/ajax-crawling/docs/learn-more). [January 6, 2014]. the browser can execute JavaScript and produce content on the fly - the crawler cannot
21. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-doogledevelopers_21-0)** [Making Ajax Applications Crawlable](https://developers.google.com/webmasters/ajax-crawling/). [January 6, 2014]. Historically, Ajax applications have been difficult for search engines to process because Ajax content is produced
22. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-22)** [Proposal for making AJAX crawlable](http://googlewebmastercentral.blogspot.com/2009/10/proposal-for-making-ajax-crawlable.html). Google. October 7, 2009 [July 13,2011].
23. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-23)** [(Specifications) Making AJAX Applications Crawlable](https://developers.google.com/webmasters/ajax-crawling/). Google. [March 4,2013].
24. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-Tennison2_24-0)** [Hash URIs](http://www.w3.org/QA/2011/05/hash_uris.html). W3C Blog. May 12, 2011 [July 13, 2011].
25. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-25)** [Deprecating our AJAX crawling scheme](https://webmasters.googleblog.com/2015/10/deprecating-our-ajax-crawling-scheme.html). Official Google Webmaster Central Blog. [2017-02-23] **（美国英语）**.
26. **[^](https://zh.wikipedia.org/wiki/单页应用#cite_ref-Holmes2015_26-0)** Holmes, Simone (2015). *Getting MEAN with Mongo, Express, Angular, and Node*. Manning Publications. [ISBN](https://zh.wikipedia.org/wiki/国际标准书号) [978-1-6172-9203-3](https://zh.wikipedia.org/wiki/Special:网络书源/978-1-6172-9203-3)

## 外部链接[[编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit&section=23)]

- [Migrating Multi-page Web Applications to Single-page Ajax Interfaces (Delft University of Technology)](https://arxiv.org/abs/cs/0610094)
- [The Single Page Interface Manifesto](http://itsnat.sourceforge.net/php/spim/spi_manifesto_en.php)

[分类](https://zh.wikipedia.org/wiki/Special:页面分类)：

- [网络应用程序](https://zh.wikipedia.org/wiki/Category:网络应用程序)

## 导航菜单

- 没有登录
- [讨论](https://zh.wikipedia.org/wiki/Special:我的讨论页)
- [贡献](https://zh.wikipedia.org/wiki/Special:我的贡献)
- [创建账户](https://zh.wikipedia.org/w/index.php?title=Special:创建账户&returnto=单页应用)
- [登录](https://zh.wikipedia.org/w/index.php?title=Special:用户登录&returnto=单页应用)

- [条目](https://zh.wikipedia.org/wiki/单页应用)
- [讨论](https://zh.wikipedia.org/wiki/Talk:单页应用)

### 大陆简体

- [汉漢](https://zh.wikipedia.org/wiki/单页应用#)

- [阅读](https://zh.wikipedia.org/wiki/单页应用)
- [编辑](https://zh.wikipedia.org/w/index.php?title=单页应用&action=edit)
- [查看历史](https://zh.wikipedia.org/w/index.php?title=单页应用&action=history)

### 搜索

- [首页](https://zh.wikipedia.org/wiki/Wikipedia:首页)
- [分类索引](https://zh.wikipedia.org/wiki/Wikipedia:分类索引)
- [特色内容](https://zh.wikipedia.org/wiki/Portal:特色內容)
- [新闻动态](https://zh.wikipedia.org/wiki/Portal:新聞動態)
- [最近更改](https://zh.wikipedia.org/wiki/Special:最近更改)
- [随机条目](https://zh.wikipedia.org/wiki/Special:随机页面)
- [资助维基百科](https://donate.wikimedia.org/?utm_source=donate&utm_medium=sidebar&utm_campaign=spontaneous&uselang=zh-hans)

### 帮助

- [帮助](https://zh.wikipedia.org/wiki/Help:目录)
- [维基社群](https://zh.wikipedia.org/wiki/Wikipedia:社群首页)
- [方针与指引](https://zh.wikipedia.org/wiki/Wikipedia:方針與指引)
- [互助客栈](https://zh.wikipedia.org/wiki/Wikipedia:互助客栈)
- [知识问答](https://zh.wikipedia.org/wiki/Wikipedia:知识问答)
- [字词转换](https://zh.wikipedia.org/wiki/Wikipedia:字词转换)
- [IRC即时聊天](https://zh.wikipedia.org/wiki/Wikipedia:IRC聊天频道)
- [联络我们](https://zh.wikipedia.org/wiki/Wikipedia:联络我们)
- [关于维基百科](https://zh.wikipedia.org/wiki/Wikipedia:关于)

### 工具

- [链入页面](https://zh.wikipedia.org/wiki/Special:链入页面/单页应用)
- [相关更改](https://zh.wikipedia.org/wiki/Special:链出更改/单页应用)
- [上传文件](https://zh.wikipedia.org/wiki/Project:上传)
- [特殊页面](https://zh.wikipedia.org/wiki/Special:特殊页面)
- [固定链接](https://zh.wikipedia.org/w/index.php?title=单页应用&oldid=63427051)
- [页面信息](https://zh.wikipedia.org/w/index.php?title=单页应用&action=info)
- [引用本页](https://zh.wikipedia.org/w/index.php?title=Special:引用此页面&page=单页应用&id=63427051&wpFormIdentifier=titleform)
- [维基数据项](https://www.wikidata.org/wiki/Special:EntityPage/Q1990286)

### 打印/导出

- [下载为PDF](https://zh.wikipedia.org/w/index.php?title=Special:DownloadAsPdf&page=单页应用&action=show-download-screen)
- [打印版本](javascript:print();)



### 其他语言

- [العربية](https://ar.wikipedia.org/wiki/تطبيق_الصفحة_الواحدة_(ويب))
- [Deutsch](https://de.wikipedia.org/wiki/Single-Page-Webanwendung)
- [English](https://en.wikipedia.org/wiki/Single-page_application)
- [Español](https://es.wikipedia.org/wiki/Single-page_application)
- [Français](https://fr.wikipedia.org/wiki/Application_web_monopage)
- [日本語](https://ja.wikipedia.org/wiki/シングルページアプリケーション)
- [한국어](https://ko.wikipedia.org/wiki/싱글_페이지_애플리케이션)
- [Português](https://pt.wikipedia.org/wiki/Aplicativo_de_página_única)
- [Русский](https://ru.wikipedia.org/wiki/Одностраничное_приложение)

[编辑链接](https://www.wikidata.org/wiki/Special:EntityPage/Q1990286#sitelinks-wikipedia)



- 本页面最后修订于2020年12月26日 (星期六) 01:14。
- 本站的全部文字在[知识共享 署名-相同方式共享 3.0协议](https://zh.wikipedia.org/wiki/Wikipedia:CC-BY-SA-3.0协议文本)之条款下提供，附加条款亦可能应用。（请参阅[使用条款](https://foundation.wikimedia.org/wiki/Terms_of_Use)）
  Wikipedia®和维基百科标志是[维基媒体基金会](https://wikimediafoundation.org/)的注册商标；维基™是维基媒体基金会的商标。
  维基媒体基金会是按美国国内税收法501(c)(3)登记的[非营利慈善机构](https://donate.wikimedia.org/wiki/Tax_deductibility)。
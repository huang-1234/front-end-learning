# 理解OAuth 2.0

作者： [阮一峰](http://www.ruanyifeng.com/)

日期： [2014年5月12日](http://www.ruanyifeng.com/blog/2014/05/)

[rfc6749英文](http://www.rfcreader.com/#rfc6749)

[OAuth](http://en.wikipedia.org/wiki/OAuth)是一个关于授权（authorization）的开放网络标准，在全世界得到广泛应用，目前的版本是2.0版。

本文对OAuth 2.0的设计思路和运行流程，做一个简明通俗的解释，主要参考材料为[RFC 6749](http://www.rfcreader.com/#rfc6749)。

![OAuth Logo](LoginMethod.assets/bg2014051201.png)

> 更新：我后来又写了一组三篇的[ 《OAuth 2.0 教程》](http://www.ruanyifeng.com/blog/2019/04/oauth_design.html)，更加通俗，并带有代码实例，欢迎阅读。

## 一、应用场景

为了理解OAuth的适用场合，让我举一个假设的例子。

有一个"云冲印"的网站，可以将用户储存在Google的照片，冲印出来。用户为了使用该服务，必须让"云冲印"读取自己储存在Google上的照片。

![云冲印](LoginMethod.assets/bg2014051202.png)

问题是只有得到用户的授权，Google才会同意"云冲印"读取这些照片。那么，"云冲印"怎样获得用户的授权呢？

传统方法是，用户将自己的Google用户名和密码，告诉"云冲印"，后者就可以读取用户的照片了。这样的做法有以下几个严重的缺点。

> （1）"云冲印"为了后续的服务，会保存用户的密码，这样很不安全。
>
> （2）Google不得不部署密码登录，而我们知道，单纯的密码登录并不安全。
>
> （3）"云冲印"拥有了获取用户储存在Google所有资料的权力，用户没法限制"云冲印"获得授权的范围和有效期。
>
> （4）用户只有修改密码，才能收回赋予"云冲印"的权力。但是这样做，会使得其他所有获得用户授权的第三方应用程序全部失效。
>
> （5）只要有一个第三方应用程序被破解，就会导致用户密码泄漏，以及所有被密码保护的数据泄漏。

OAuth就是为了解决上面这些问题而诞生的。

## 二、名词定义

在详细讲解OAuth 2.0之前，需要了解几个专用名词。它们对读懂后面的讲解，尤其是几张图，至关重要。

> （1） **Third-party application**：第三方应用程序，本文中又称"客户端"（client），即上一节例子中的"云冲印"。
>
> （2）**HTTP service**：HTTP服务提供商，本文中简称"服务提供商"，即上一节例子中的Google。
>
> （3）**Resource Owner**：资源所有者，本文中又称"用户"（user）。
>
> （4）**User Agent**：用户代理，本文中就是指浏览器。
>
> （5）**Authorization server**：认证服务器，即服务提供商专门用来处理认证的服务器。
>
> （6）**Resource server**：资源服务器，即服务提供商存放用户生成的资源的服务器。它与认证服务器，可以是同一台服务器，也可以是不同的服务器。

知道了上面这些名词，就不难理解，OAuth的作用就是让"客户端"安全可控地获取"用户"的授权，与"服务商提供商"进行互动。

## 三、OAuth的思路

OAuth在"客户端"与"服务提供商"之间，设置了一个授权层（authorization layer）。"客户端"不能直接登录"服务提供商"，只能登录授权层，以此将用户与客户端区分开来。"客户端"登录授权层所用的令牌（token），与用户的密码不同。用户可以在登录的时候，指定授权层令牌的权限范围和有效期。

"客户端"登录授权层以后，"服务提供商"根据令牌的权限范围和有效期，向"客户端"开放用户储存的资料。

## 四、运行流程

OAuth 2.0的运行流程如下图，摘自RFC 6749。

![OAuth运行流程](LoginMethod.assets/bg2014051203.png)

> （A）用户打开客户端以后，客户端要求用户给予授权。
>
> （B）用户同意给予客户端授权。
>
> （C）客户端使用上一步获得的授权，向认证服务器申请令牌。
>
> （D）认证服务器对客户端进行认证以后，确认无误，同意发放令牌。
>
> （E）客户端使用令牌，向资源服务器申请获取资源。
>
> （F）资源服务器确认令牌无误，同意向客户端开放资源。

不难看出来，上面六个步骤之中，B是关键，即用户怎样才能给于客户端授权。有了这个授权以后，客户端就可以获取令牌，进而凭令牌获取资源。

下面一一讲解客户端获取授权的四种模式。

## 五、客户端的授权模式

客户端必须得到用户的授权（authorization grant），才能获得令牌（access token）。OAuth 2.0定义了四种授权方式。

- 授权码模式（authorization code）
- 简化模式（implicit）
- 密码模式（resource owner password credentials）
- 客户端模式（client credentials）

## 六、授权码模式

授权码模式（authorization code）是功能最完整、流程最严密的授权模式。它的特点就是通过客户端的后台服务器，与"服务提供商"的认证服务器进行互动。

![授权码模式](LoginMethod.assets/bg2014051204.png)

它的步骤如下：

> （A）用户访问客户端，后者将前者导向认证服务器。
>
> （B）用户选择是否给予客户端授权。
>
> （C）假设用户给予授权，认证服务器将用户导向客户端事先指定的"重定向URI"（redirection URI），同时附上一个授权码。
>
> （D）客户端收到授权码，附上早先的"重定向URI"，向认证服务器申请令牌。这一步是在客户端的后台的服务器上完成的，对用户不可见。
>
> （E）认证服务器核对了授权码和重定向URI，确认无误后，向客户端发送访问令牌（access token）和更新令牌（refresh token）。

下面是上面这些步骤所需要的参数。

A步骤中，客户端申请认证的URI，包含以下参数：

- response_type：表示授权类型，必选项，此处的值固定为"code"
- client_id：表示客户端的ID，必选项
- redirect_uri：表示重定向URI，可选项
- scope：表示申请的权限范围，可选项
- state：表示客户端的当前状态，可以指定任意值，认证服务器会原封不动地返回这个值。

下面是一个例子。

> ```http
> GET /authorize?response_type=code&client_id=s6BhdRkqt3&state=xyz
>         &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb HTTP/1.1
> Host: server.example.com
> ```

C步骤中，服务器回应客户端的URI，包含以下参数：

- code：表示授权码，必选项。该码的有效期应该很短，通常设为10分钟，客户端只能使用该码一次，否则会被授权服务器拒绝。该码与客户端ID和重定向URI，是一一对应关系。
- state：如果客户端的请求中包含这个参数，认证服务器的回应也必须一模一样包含这个参数。

下面是一个例子。

> ```http
> HTTP/1.1 302 Found
> Location: https://client.example.com/cb?code=SplxlOBeZQQYbYS6WxSbIA
>           &state=xyz
> ```

D步骤中，客户端向认证服务器申请令牌的HTTP请求，包含以下参数：

- grant_type：表示使用的授权模式，必选项，此处的值固定为"authorization_code"。
- code：表示上一步获得的授权码，必选项。
- redirect_uri：表示重定向URI，必选项，且必须与A步骤中的该参数值保持一致。
- client_id：表示客户端ID，必选项。

下面是一个例子。

> ```http
> POST /token HTTP/1.1
> Host: server.example.com
> Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
> Content-Type: application/x-www-form-urlencoded
> 
> grant_type=authorization_code&code=SplxlOBeZQQYbYS6WxSbIA
> &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb
> ```

E步骤中，认证服务器发送的HTTP回复，包含以下参数：

- access_token：表示访问令牌，必选项。
- token_type：表示令牌类型，该值大小写不敏感，必选项，可以是bearer类型或mac类型。
- expires_in：表示过期时间，单位为秒。如果省略该参数，必须其他方式设置过期时间。
- refresh_token：表示更新令牌，用来获取下一次的访问令牌，可选项。
- scope：表示权限范围，如果与客户端申请的范围一致，此项可省略。

下面是一个例子。

> ```http
>      HTTP/1.1 200 OK
>      Content-Type: application/json;charset=UTF-8
>      Cache-Control: no-store
>      Pragma: no-cache
> 
>      {
>        "access_token":"2YotnFZFEjr1zCsicMWpAA",
>        "token_type":"example",
>        "expires_in":3600,
>        "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
>        "example_parameter":"example_value"
>      }
> ```

从上面代码可以看到，相关参数使用JSON格式发送（Content-Type: application/json）。此外，HTTP头信息中明确指定不得缓存。

## 七、简化模式

简化模式（implicit grant type）不通过第三方应用程序的服务器，直接在浏览器中向认证服务器申请令牌，跳过了"授权码"这个步骤，因此得名。所有步骤在浏览器中完成，令牌对访问者是可见的，且客户端不需要认证。

![简化模式](LoginMethod.assets/bg2014051205.png)

它的步骤如下：

> （A）客户端将用户导向认证服务器。
>
> （B）用户决定是否给于客户端授权。
>
> （C）假设用户给予授权，认证服务器将用户导向客户端指定的"重定向URI"，并在URI的Hash部分包含了访问令牌。
>
> （D）浏览器向资源服务器发出请求，其中不包括上一步收到的Hash值。
>
> （E）资源服务器返回一个网页，其中包含的代码可以获取Hash值中的令牌。
>
> （F）浏览器执行上一步获得的脚本，提取出令牌。
>
> （G）浏览器将令牌发给客户端。

下面是上面这些步骤所需要的参数。

A步骤中，客户端发出的HTTP请求，包含以下参数：

- response_type：表示授权类型，此处的值固定为"token"，必选项。
- client_id：表示客户端的ID，必选项。
- redirect_uri：表示重定向的URI，可选项。
- scope：表示权限范围，可选项。
- state：表示客户端的当前状态，可以指定任意值，认证服务器会原封不动地返回这个值。

下面是一个例子。

> ```http
>     GET /authorize?response_type=token&client_id=s6BhdRkqt3&state=xyz
>         &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb HTTP/1.1
>     Host: server.example.com
> ```

C步骤中，认证服务器回应客户端的URI，包含以下参数：

- access_token：表示访问令牌，必选项。
- token_type：表示令牌类型，该值大小写不敏感，必选项。
- expires_in：表示过期时间，单位为秒。如果省略该参数，必须其他方式设置过期时间。
- scope：表示权限范围，如果与客户端申请的范围一致，此项可省略。
- state：如果客户端的请求中包含这个参数，认证服务器的回应也必须一模一样包含这个参数。

下面是一个例子。

> ```http
>      HTTP/1.1 302 Found
>      Location: http://example.com/cb#access_token=2YotnFZFEjr1zCsicMWpAA
>                &state=xyz&token_type=example&expires_in=3600
> ```

在上面的例子中，认证服务器用HTTP头信息的Location栏，指定浏览器重定向的网址。注意，在这个网址的Hash部分包含了令牌。

根据上面的D步骤，下一步浏览器会访问Location指定的网址，但是Hash部分不会发送。接下来的E步骤，服务提供商的资源服务器发送过来的代码，会提取出Hash中的令牌。

## 八、密码模式

密码模式（Resource Owner Password Credentials Grant）中，用户向客户端提供自己的用户名和密码。客户端使用这些信息，向"服务商提供商"索要授权。

在这种模式中，用户必须把自己的密码给客户端，但是客户端不得储存密码。这通常用在用户对客户端高度信任的情况下，比如客户端是操作系统的一部分，或者由一个著名公司出品。而认证服务器只有在其他授权模式无法执行的情况下，才能考虑使用这种模式。

![密码模式](LoginMethod.assets/bg2014051206.png)

它的步骤如下：

> （A）用户向客户端提供用户名和密码。
>
> （B）客户端将用户名和密码发给认证服务器，向后者请求令牌。
>
> （C）认证服务器确认无误后，向客户端提供访问令牌。

B步骤中，客户端发出的HTTP请求，包含以下参数：

- grant_type：表示授权类型，此处的值固定为"password"，必选项。
- username：表示用户名，必选项。
- password：表示用户的密码，必选项。
- scope：表示权限范围，可选项。

下面是一个例子。

> ```http
>      POST /token HTTP/1.1
>      Host: server.example.com
>      Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
>      Content-Type: application/x-www-form-urlencoded
> 
>      grant_type=password&username=johndoe&password=A3ddj3w
> ```

C步骤中，认证服务器向客户端发送访问令牌，下面是一个例子。

> ```http
>      HTTP/1.1 200 OK
>      Content-Type: application/json;charset=UTF-8
>      Cache-Control: no-store
>      Pragma: no-cache
> 
>      {
>        "access_token":"2YotnFZFEjr1zCsicMWpAA",
>        "token_type":"example",
>        "expires_in":3600,
>        "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
>        "example_parameter":"example_value"
>      }
> ```

上面代码中，各个参数的含义参见《授权码模式》一节。

整个过程中，客户端不得保存用户的密码。

## 九、客户端模式

客户端模式（Client Credentials Grant）指客户端以自己的名义，而不是以用户的名义，向"服务提供商"进行认证。严格地说，客户端模式并不属于OAuth框架所要解决的问题。在这种模式中，用户直接向客户端注册，客户端以自己的名义要求"服务提供商"提供服务，其实不存在授权问题。

![客户端模式](LoginMethod.assets/bg2014051207.png)

它的步骤如下：

> （A）客户端向认证服务器进行身份认证，并要求一个访问令牌。
>
> （B）认证服务器确认无误后，向客户端提供访问令牌。

A步骤中，客户端发出的HTTP请求，包含以下参数：

- grant*type：表示授权类型，此处的值固定为"client*credentials"，必选项。
- scope：表示权限范围，可选项。

> ```http
>      POST /token HTTP/1.1
>      Host: server.example.com
>      Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
>      Content-Type: application/x-www-form-urlencoded
> 
>      grant_type=client_credentials
> ```

认证服务器必须以某种方式，验证客户端身份。

B步骤中，认证服务器向客户端发送访问令牌，下面是一个例子。

> ```http
>      HTTP/1.1 200 OK
>      Content-Type: application/json;charset=UTF-8
>      Cache-Control: no-store
>      Pragma: no-cache
> 
>      {
>        "access_token":"2YotnFZFEjr1zCsicMWpAA",
>        "token_type":"example",
>        "expires_in":3600,
>        "example_parameter":"example_value"
>      }
> ```

上面代码中，各个参数的含义参见《授权码模式》一节。

## 十、更新令牌

如果用户访问的时候，客户端的"访问令牌"已经过期，则需要使用"更新令牌"申请一个新的访问令牌。

客户端发出更新令牌的HTTP请求，包含以下参数：

- grant*type：表示使用的授权模式，此处的值固定为"refresh*token"，必选项。
- refresh_token：表示早前收到的更新令牌，必选项。
- scope：表示申请的授权范围，不可以超出上一次申请的范围，如果省略该参数，则表示与上一次一致。

下面是一个例子。

> ```http
>      POST /token HTTP/1.1
>      Host: server.example.com
>      Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
>      Content-Type: application/x-www-form-urlencoded
> 
>      grant_type=refresh_token&refresh_token=tGzv3JOkF0XG5Qx2TlKWIA
> ```

（完）

# OAuth 2.0 的一个简单解释

作者： [阮一峰](http://www.ruanyifeng.com/)

日期： [2019年4月 4日](http://www.ruanyifeng.com/blog/2019/04/)

[OAuth 2.0](http://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html) 是目前最流行的授权机制，用来授权第三方应用，获取用户数据。

这个标准比较抽象，使用了很多术语，初学者不容易理解。其实说起来并不复杂，下面我就通过一个简单的类比，帮助大家轻松理解，OAuth 2.0 到底是什么。

## 一、快递员问题

我住在一个大型的居民小区。

![img](LoginMethod.assets/bg2019040401.jpg)

小区有门禁系统。

![img](LoginMethod.assets/bg2019040402.jpg)

进入的时候需要输入密码。

![img](LoginMethod.assets/bg2019040403.jpg)

我经常网购和外卖，每天都有快递员来送货。我必须找到一个办法，让快递员通过门禁系统，进入小区。

![img](LoginMethod.assets/bg2019040404.jpg)

如果我把自己的密码，告诉快递员，他就拥有了与我同样的权限，这样好像不太合适。万一我想取消他进入小区的权力，也很麻烦，我自己的密码也得跟着改了，还得通知其他的快递员。

有没有一种办法，让快递员能够自由进入小区，又不必知道小区居民的密码，而且他的唯一权限就是送货，其他需要密码的场合，他都没有权限？

## 二、授权机制的设计

于是，我设计了一套授权机制。

第一步，门禁系统的密码输入器下面，增加一个按钮，叫做"获取授权"。快递员需要首先按这个按钮，去申请授权。

第二步，他按下按钮以后，屋主（也就是我）的手机就会跳出对话框：有人正在要求授权。系统还会显示该快递员的姓名、工号和所属的快递公司。

我确认请求属实，就点击按钮，告诉门禁系统，我同意给予他进入小区的授权。

第三步，门禁系统得到我的确认以后，向快递员显示一个进入小区的令牌（access token）。令牌就是类似密码的一串数字，只在短期内（比如七天）有效。

第四步，快递员向门禁系统输入令牌，进入小区。

有人可能会问，为什么不是远程为快递员开门，而要为他单独生成一个令牌？这是因为快递员可能每天都会来送货，第二天他还可以复用这个令牌。另外，有的小区有多重门禁，快递员可以使用同一个令牌通过它们。

## 三、互联网场景

我们把上面的例子搬到互联网，就是 OAuth 的设计了。

首先，居民小区就是储存用户数据的网络服务。比如，微信储存了我的好友信息，获取这些信息，就必须经过微信的"门禁系统"。

其次，快递员（或者说快递公司）就是第三方应用，想要穿过门禁系统，进入小区。

最后，我就是用户本人，同意授权第三方应用进入小区，获取我的数据。

**简单说，OAuth 就是一种授权机制。数据的所有者告诉系统，同意授权第三方应用进入系统，获取这些数据。系统从而产生一个短期的进入令牌（token），用来代替密码，供第三方应用使用。**

## 四、令牌与密码

令牌（token）与密码（password）的作用是一样的，都可以进入系统，但是有三点差异。

（1）令牌是短期的，到期会自动失效，用户自己无法修改。密码一般长期有效，用户不修改，就不会发生变化。

（2）令牌可以被数据所有者撤销，会立即失效。以上例而言，屋主可以随时取消快递员的令牌。密码一般不允许被他人撤销。

（3）令牌有权限范围（scope），比如只能进小区的二号门。对于网络服务来说，只读令牌就比读写令牌更安全。密码一般是完整权限。

上面这些设计，保证了令牌既可以让第三方应用获得权限，同时又随时可控，不会危及系统安全。这就是 OAuth 2.0 的优点。

注意，只要知道了令牌，就能进入系统。系统一般不会再次确认身份，所以**令牌必须保密，泄漏令牌与泄漏密码的后果是一样的。** 这也是为什么令牌的有效期，一般都设置得很短的原因。

OAuth 2.0 对于如何颁发令牌的细节，规定得非常详细。具体来说，一共分成四种授权类型（authorization grant），即四种颁发令牌的方式，适用于不同的互联网场景。[下一篇文章](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html)，我就来介绍这四种类型，并给出代码实例。

（完）

# OAuth 2.0 的四种方式

作者： [阮一峰](http://www.ruanyifeng.com/)

日期： [2019年4月 9日](http://www.ruanyifeng.com/blog/2019/04/)

[上一篇文章](http://www.ruanyifeng.com/blog/2019/04/oauth_design.html)介绍了 OAuth 2.0 是一种授权机制，主要用来颁发令牌（token）。本文接着介绍颁发令牌的实务操作。

![img](LoginMethod.assets/bg2019040901.jpg)

下面我假定，你已经理解了 OAuth 2.0 的含义和设计思想，否则请先阅读这个系列的[上一篇文章](http://www.ruanyifeng.com/blog/2019/04/oauth_design.html)。

> 进入正文之前，插播一则活动消息。
>
> 4月22日（周一）到4月29日（下周一），每天晚上八点都有两小时的免费直播课，体系化介绍高级前端开发知识，网易云课堂主办。[详细介绍](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#support)请看本文结尾，欢迎关注。

## RFC 6749

OAuth 2.0 的标准是 [RFC 6749](https://tools.ietf.org/html/rfc6749) 文件。该文件先解释了 OAuth 是什么。

> OAuth 引入了一个授权层，用来分离两种不同的角色：客户端和资源所有者。......资源所有者同意以后，资源服务器可以向客户端颁发令牌。客户端通过令牌，去请求数据。

这段话的意思就是，**OAuth 的核心就是向第三方应用颁发令牌。**然后，RFC 6749 接着写道：

> （由于互联网有多种场景，）本标准定义了获得令牌的四种授权方式（authorization grant ）。

也就是说，**OAuth 2.0 规定了四种获得令牌的流程。你可以选择最适合自己的那一种，向第三方应用颁发令牌。**下面就是这四种授权方式。

> - 授权码（authorization-code）
> - 隐藏式（implicit）
> - 密码式（password）：
> - 客户端凭证（client credentials）

注意，不管哪一种授权方式，第三方应用申请令牌之前，都必须先到系统备案，说明自己的身份，然后会拿到两个身份识别码：客户端 ID（client ID）和客户端密钥（client secret）。这是为了防止令牌被滥用，没有备案过的第三方应用，是不会拿到令牌的。

## 第一种授权方式：授权码

**授权码（authorization code）方式，指的是第三方应用先申请一个授权码，然后再用该码获取令牌。**

这种方式是最常用的流程，安全性也最高，它适用于那些有后端的 Web 应用。授权码通过前端传送，令牌则是储存在后端，而且所有与资源服务器的通信都在后端完成。这样的前后端分离，可以避免令牌泄漏。

第一步，A 网站提供一个链接，用户点击后就会跳转到 B 网站，授权用户数据给 A 网站使用。下面就是 A 网站跳转 B 网站的一个示意链接。

> ```javascript
> https://b.com/oauth/authorize?
>   response_type=code&
>   client_id=CLIENT_ID&
>   redirect_uri=CALLBACK_URL&
>   scope=read
> ```

上面 URL 中，`response_type`参数表示要求返回授权码（`code`），`client_id`参数让 B 知道是谁在请求，`redirect_uri`参数是 B 接受或拒绝请求后的跳转网址，`scope`参数表示要求的授权范围（这里是只读）。

![img](LoginMethod.assets/bg2019040902.jpg)

第二步，用户跳转后，B 网站会要求用户登录，然后询问是否同意给予 A 网站授权。用户表示同意，这时 B 网站就会跳回`redirect_uri`参数指定的网址。跳转时，会传回一个授权码，就像下面这样。

> ```javascript
> https://a.com/callback?code=AUTHORIZATION_CODE
> ```

上面 URL 中，`code`参数就是授权码。

![img](LoginMethod.assets/bg2019040907.jpg)

第三步，A 网站拿到授权码以后，就可以在后端，向 B 网站请求令牌。

> ```javascript
> https://b.com/oauth/token?
>  client_id=CLIENT_ID&
>  client_secret=CLIENT_SECRET&
>  grant_type=authorization_code&
>  code=AUTHORIZATION_CODE&
>  redirect_uri=CALLBACK_URL
> ```

上面 URL 中，`client_id`参数和`client_secret`参数用来让 B 确认 A 的身份（`client_secret`参数是保密的，因此只能在后端发请求），`grant_type`参数的值是`AUTHORIZATION_CODE`，表示采用的授权方式是授权码，`code`参数是上一步拿到的授权码，`redirect_uri`参数是令牌颁发后的回调网址。

![img](LoginMethod.assets/bg2019040904.jpg)

第四步，B 网站收到请求以后，就会颁发令牌。具体做法是向`redirect_uri`指定的网址，发送一段 JSON 数据。

> ```javascript
> {    
>   "access_token":"ACCESS_TOKEN",
>   "token_type":"bearer",
>   "expires_in":2592000,
>   "refresh_token":"REFRESH_TOKEN",
>   "scope":"read",
>   "uid":100101,
>   "info":{...}
> }
> ```

上面 JSON 数据中，`access_token`字段就是令牌，A 网站在后端拿到了。

![img](LoginMethod.assets/bg2019040905.jpg)

## 第二种方式：隐藏式

有些 Web 应用是纯前端应用，没有后端。这时就不能用上面的方式了，必须将令牌储存在前端。**RFC 6749 就规定了第二种方式，允许直接向前端颁发令牌。这种方式没有授权码这个中间步骤，所以称为（授权码）"隐藏式"（implicit）。**

第一步，A 网站提供一个链接，要求用户跳转到 B 网站，授权用户数据给 A 网站使用。

> ```javascript
> https://b.com/oauth/authorize?
>   response_type=token&
>   client_id=CLIENT_ID&
>   redirect_uri=CALLBACK_URL&
>   scope=read
> ```

上面 URL 中，`response_type`参数为`token`，表示要求直接返回令牌。

第二步，用户跳转到 B 网站，登录后同意给予 A 网站授权。这时，B 网站就会跳回`redirect_uri`参数指定的跳转网址，并且把令牌作为 URL 参数，传给 A 网站。

> ```javascript
> https://a.com/callback#token=ACCESS_TOKEN
> ```

上面 URL 中，`token`参数就是令牌，A 网站因此直接在前端拿到令牌。

注意，令牌的位置是 URL 锚点（fragment），而不是查询字符串（querystring），这是因为 OAuth 2.0 允许跳转网址是 HTTP 协议，因此存在"中间人攻击"的风险，而浏览器跳转时，锚点不会发到服务器，就减少了泄漏令牌的风险。

![img](LoginMethod.assets/bg2019040906.jpg)

这种方式把令牌直接传给前端，是很不安全的。因此，只能用于一些安全要求不高的场景，并且令牌的有效期必须非常短，通常就是会话期间（session）有效，浏览器关掉，令牌就失效了。

## 第三种方式：密码式

**如果你高度信任某个应用，RFC 6749 也允许用户把用户名和密码，直接告诉该应用。该应用就使用你的密码，申请令牌，这种方式称为"密码式"（password）。**

第一步，A 网站要求用户提供 B 网站的用户名和密码。拿到以后，A 就直接向 B 请求令牌。

> ```javascript
> https://oauth.b.com/token?
>   grant_type=password&
>   username=USERNAME&
>   password=PASSWORD&
>   client_id=CLIENT_ID
> ```

上面 URL 中，`grant_type`参数是授权方式，这里的`password`表示"密码式"，`username`和`password`是 B 的用户名和密码。

第二步，B 网站验证身份通过后，直接给出令牌。注意，这时不需要跳转，而是把令牌放在 JSON 数据里面，作为 HTTP 回应，A 因此拿到令牌。

这种方式需要用户给出自己的用户名/密码，显然风险很大，因此只适用于其他授权方式都无法采用的情况，而且必须是用户高度信任的应用。

## 第四种方式：凭证式

**最后一种方式是凭证式（client credentials），适用于没有前端的命令行应用，即在命令行下请求令牌。**

第一步，A 应用在命令行向 B 发出请求。

> ```javascript
> https://oauth.b.com/token?
>   grant_type=client_credentials&
>   client_id=CLIENT_ID&
>   client_secret=CLIENT_SECRET
> ```

上面 URL 中，`grant_type`参数等于`client_credentials`表示采用凭证式，`client_id`和`client_secret`用来让 B 确认 A 的身份。

第二步，B 网站验证通过以后，直接返回令牌。

这种方式给出的令牌，是针对第三方应用的，而不是针对用户的，即有可能多个用户共享同一个令牌。

## 令牌的使用

A 网站拿到令牌以后，就可以向 B 网站的 API 请求数据了。

此时，每个发到 API 的请求，都必须带有令牌。具体做法是在请求的头信息，加上一个`Authorization`字段，令牌就放在这个字段里面。

> ```bash
> curl -H "Authorization: Bearer ACCESS_TOKEN" \
> "https://api.b.com"
> ```

上面命令中，`ACCESS_TOKEN`就是拿到的令牌。

## 更新令牌

令牌的有效期到了，如果让用户重新走一遍上面的流程，再申请一个新的令牌，很可能体验不好，而且也没有必要。OAuth 2.0 允许用户自动更新令牌。

具体方法是，B 网站颁发令牌的时候，一次性颁发两个令牌，一个用于获取数据，另一个用于获取新的令牌（refresh token 字段）。令牌到期前，用户使用 refresh token 发一个请求，去更新令牌。

> ```javascript
> https://b.com/oauth/token?
>   grant_type=refresh_token&
>   client_id=CLIENT_ID&
>   client_secret=CLIENT_SECRET&
>   refresh_token=REFRESH_TOKEN
> ```

上面 URL 中，`grant_type`参数为`refresh_token`表示要求更新令牌，`client_id`参数和`client_secret`参数用于确认身份，`refresh_token`参数就是用于更新令牌的令牌。

B 网站验证通过以后，就会颁发新的令牌。

写到这里，颁发令牌的四种方式就介绍完了。[下一篇文章](http://www.ruanyifeng.com/blog/2019/04/github-oauth.html)会编写一个真实的 Demo，演示如何通过 OAuth 2.0 向 GitHub 的 API 申请令牌，然后再用令牌获取数据。

（正文完）



## 前端高级开发工程师免费直播课

经过多年的发展，前端工程师的地位日益提升，越来越多的人想往前端的方向发展。

但是，市场对前端工程师的要求也越来越高，深入掌握底层技术的高级前端，才能在市场上找到自己立足之地。

![img](LoginMethod.assets/bg2019040908.jpg)

为了帮助大家深入了解高级前端的学习要点，4月22日（周一）到4月29日（下周一），网易云课堂推出了[前端进阶免费直播课](https://url.163.com/mYh)。

> - 周一（4月22日）：《前端不会点 node 怎么行，node http 模块详解》
> - 周二（4月23日）：《进阶面试必备的三大技术题》
> - 周三（4月24日）：《前端高级工程师核心装备之柯里化》
> - 周四（4月25日）：《手把手带你实现 Vue 的 MVVM》
> - 周五（4月26日）：《JQuery 原理分析》
> - 周六（4月27日）：《用迭代器模式让你的脱离繁重的数据处理 》
> - 周日（4月28日）：《前端性能--JS的防抖节流实现与案例场景》
> - 周一（4月29日）：《阿里巴巴 P5 面试题讲解》
>
> （更多介绍[点击这里](https://url.163.com/mYh)）

他们邀请了[网易资深前端工程师](https://url.163.com/mYh)，免费直播分享实战中的经验方法。内容涉及网易内部自定组件库工具分享，前端开发相关知识，深度剖析 JavaScript 等。

这个直播面向前端初、中级开发工程师，每天2个小时，都是一些干货分享并且不收费，建议想进阶的同学坚持学习。大家可以微信扫码，添加助教，获取听课地址。

![img](LoginMethod.assets/bg2019040911.jpg)

（完）

### 文档信息

- 版权声明：自由转载-非商用-非衍生-保持署名（[创意共享3.0许可证](http://creativecommons.org/licenses/by-nc-nd/3.0/deed.zh)）
- 发表日期： 2019年4月 9日



## 相关文章

- 2020.12.13: [《SSH 入门教程》发布了](http://www.ruanyifeng.com/blog/2020/12/ssh-tutorial.html)

  SSH 是登录 Linux 服务器的必备工具，只要你在做互联网开发，多多少少都会用到它。

- 2020.11.02: [微信小程序入门教程之四：API 使用](http://www.ruanyifeng.com/blog/2020/11/wechat-miniprogram-tutorial-part-four.html)

  今天是这个系列教程的最后一篇。

- 2020.10.29: [微信小程序入门教程之三：脚本编程](http://www.ruanyifeng.com/blog/2020/10/wechat-miniprogram-tutorial-part-three.html)

  这个系列教程的前两篇，介绍了小程序的项目结构和页面样式。

- 2020.10.27: [微信小程序入门教程之二：页面样式](http://www.ruanyifeng.com/blog/2020/10/wechat-miniprogram-tutorial-part-two.html)

  这个系列的上一篇教程，教大家写了一个最简单的 Hello world 微信小程序。

## 留言（46条）

***\*[chrisyue](https://chrisyue.com/)\** 说：**

Implicit Flow 返回 access token 时，不应该用 query (?token=TOKEN-xxx) 而是 fragment (#TOKEN-xxx)

这在 RFC 6749 里是有规定的 https://tools.ietf.org/html/rfc6749#section-4.2

在 implicit 中使用 fragment 传递 token 是很巧妙的设计，具体原因可见：https://www.chrisyue.com/?p=3178

2019年4月 9日 11:28 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410448) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*阮一峰\** 说：**

@chrisyue：

谢谢指出，这一点真没注意到，涨知识了。我一会就把原文改掉。

2019年4月 9日 11:49 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410449) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*[Ceniy](https://gensfit.info/)\** 说：**

Demo 会使用 vue 和axios吗？ 还是原始的ajax，最近正好碰到这个问题了，token过期后，底层需要能自动去刷新token，还得避免 有多个并发请求的时候，会不会导致这些请求同时都在进行刷新token ？

2019年4月 9日 14:26 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410451) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*skywalker\** 说：**

阮老师写的通俗易懂

2019年4月 9日 15:52 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410455) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*kergee\** 说：**

单点登录一般采用哪种比较多？

2019年4月 9日 19:22 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410460) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*coderlim\** 说：**

授权码方式，前端去后端拿了一个授权码，然后拿着授权码再去后端拿令牌，授权码和令牌都是后端产生的，为什么这种方式比直接拿令牌安全呢？

2019年4月10日 10:07 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410466) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*LouXudong\** 说：**

> ```
> 引用coderlim的发言：
> ```
>
> 授权码方式，前端去后端拿了一个授权码，然后拿着授权码再去后端拿令牌，授权码和令牌都是后端产生的，为什么这种方式比直接拿令牌安全呢？

因为获取授权码的方式是通过浏览器跳页(get请求)，返回的授权码展示在地址栏，安全性不高。而获取令牌可以使用post请求。另外，因为授权码与发起请求的URL是关联的，所以另一个网站使用你的授权码是无法成功得到令牌的。

2019年4月10日 18:41 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410474) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*[DanielDuan](http://895004881@qq.com/)\** 说：**

请问一下：A网站拿到B网站颁发的令牌后，是否直接将token返回给访问A网站的浏览器？如果是，当用户再次通过浏览器、携带token访问A网站的时候，A如何校验该令牌是否有效呢？A网站的后端会保存B网站之前返回的token，然后直接比较是否相等，还是A网站携带浏览器发出的token，去B网站校验？

2019年4月17日 21:51 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410599) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*wangyifei\** 说：**

> ```
> 引用DanielDuan的发言：
> ```
>
> 请问一下：A网站拿到B网站颁发的令牌后，是否直接将token返回给访问A网站的浏览器？如果是，当用户再次通过浏览器、携带token访问A网站的时候，A如何校验该令牌是否有效呢？A网站的后端会保存B网站之前返回的token，然后直接比较是否相等，还是A网站携带浏览器发出的token，去B网站校验？

首先作者说的获取令牌有多种方式，如果是通过授权码，令牌是发到A后台的，如果是隐藏式，那么是发到前端的，也就是给浏览器的。这个token是B产生的，当然是在访问B资源的时候在B验证

2019年4月18日 17:09 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410616) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*wangyifei\** 说：**

> ```
> 引用LouXudong的发言：
> ```
>
> 因为获取授权码的方式是通过浏览器跳页(get请求)，返回的授权码展示在地址栏，安全性不高。而获取令牌可以使用post请求。另外，因为授权码与发起请求的URL是关联的，所以另一个网站使用你的授权码是无法成功得到令牌的。

授权码是B应用用来验证A应用的请求是经过用户登陆验证的

2019年4月18日 18:08 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410619) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*Sky、Memory\** 说：**

第一种授权方式里面，获取access_token时带上的redirect_uri参数，RFC 6749里面的解释是拿来做验证的，具体可见: https://tools.ietf.org/html/rfc6749#section-4.1

2019年4月24日 21:14 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410795) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*Chenyang\** 说：**

是不是意味着A网站持有用户授权过的B网站access token和refresh token的话，自身不需要用户再次授权就可以一直访问B网站上的资源.

2019年5月 1日 20:45 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-410971) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*咔咔咔\** 说：**

老师你好 如果要做一个api平台 ,做成两个系统 , 一个是后台系统 给用户授权可用的接口 一个是客户访问的系统 后台系统管理员授权之后 客户可以调用已授权的接口 , 这种应用场景 适用于哪种授权模式呢? 请老师指教一下

2019年5月 8日 10:28 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-411056) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*dechy\** 说：**

用户对什么资源进行授权，这里并没有体现出来。客户端想要获取用户的资源可能是各种各样的，而认证的流程是一样的。

是不是应该有参数让客户端指定获取用户哪方面的资源呢？

2019年5月22日 20:13 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-411318) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*thomas\** 说：**

嗯呢，不错，很容易的就了解了登录授权机制
但是我有一个问题，我从YouTobe的视频APP中分享视频到Twitter APP中，却可以直接唤起Twitter APP，并没有经过登录与授权的步骤，这会是神马原因呢？

2019年5月31日 16:39 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-411531) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*Alex\** 说：**

建议微信文档直接链接此文章, 清晰多了

2019年6月11日 18:31 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-411697) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*pangtu\** 说：**

关于授权码模式的疑问：
文中写到“第四步，B 网站收到请求以后，就会颁发令牌。具体做法是向redirect_uri指定的网址，发送一段 JSON 数据”

问题是：既然是后端获取，我理解应该直接是A在后端拿到code后直接带着授权码发请求给B，B直接响应给A token就可以了
但是为什么是B又多了一道子，b在请求redirct_uri，向这个地址发送请求给A，A在接收token。

2019年6月12日 12:55 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-411705) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*wenxin667\** 说：**

> ```
> 引用coderlim的发言：
> ```
>
> 授权码方式，前端去后端拿了一个授权码，然后拿着授权码再去后端拿令牌，授权码和令牌都是后端产生的，为什么这种方式比直接拿令牌安全呢？

不一样，这里面有三者参与：A_C【浏览器】、B_S【授权中心】、A_S【网站A的后端】
A_C 先去与 B_S 交互，拿到 code
然后code 给A_S
A_S 与 B_S 交互，拿到 Token。 Token 不会暴露给 A_C
【我的疑惑在于，难道之后A_C 请求用户 在B_S 的个人数据，都需要 经过A_S的中转吗？】

2019年6月17日 17:48 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-411790) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*wenxin667\** 说：**

1、授权码的方式：
为了保证令牌的不泄露，是否所有的A浏览器 向B请求数据，都需要 经过 A的后端去转发呢？
2、隐藏式：
看文中的例子，似乎没有向B提供密码呢？难道纯前端的应用，无须向B备案，无须密码就可以直接获取令牌吗？
3、凭证式：
关于凭证式没有理解到何为 针对第三方应用？而且 密码也是直接暴露在A端的了吗？

2019年6月17日 18:34 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-411791) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*wenxin667\** 说：**

突然想通了 1、令牌就是要暴露出去的，而不用暴露出去的是 A的后端的 secret

2019年6月17日 18:36 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-411792) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*[jk2k](https://jk2k.com/)\** 说：**

@wenxin667：

文章里应该写错了，redirect_uri参数 只是用来验证是否有效，authorization server 会直接响应 access_token 数据

2019年6月26日 16:55 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-411907) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*天亮前说晚安\** 说：**

其实我想知道点击同意授权，B的客户端做了什么？看了很多篇，都有点蒙蒙的，觉得没讲明白是因为：没说明白哪部分是第三方应用客户端做的，还是第三方应用服务端做的。

2019年7月16日 17:38 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-412233) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*天亮前说晚安\** 说：**

第一步的clientid 是B的客户端id还是A的客户端id啊？

2019年7月16日 17:41 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-412234) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*Xanthuim\** 说：**

大佬能讲一讲access_token前面的Bearer是啥意思吗？

2019年7月22日 13:10 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-412329) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*seaver\** 说：**

> ```
> 引用天亮前说晚安的发言：
> ```
>
> 第一步的clientid 是B的客户端id还是A的客户端id啊？

是 A 网站的。因为之前 A 网站要在授权服务器那注册，会被分配一个 id。后面去交互时候要带上 id 来标识自己身份。

2019年8月 9日 09:57 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-412642) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*navy\** 说：**

> ```
> 引用pangtu的发言：
> ```
>
> 关于授权码模式的疑问：
> 文中写到“第四步，B 网站收到请求以后，就会颁发令牌。具体做法是向redirect_uri指定的网址，发送一段 JSON 数据”
>
> 问题是：既然是后端获取，我理解应该直接是A在后端拿到code后直接带着授权码发请求给B，B直接响应给A token就可以了
> 但是为什么是B又多了一道子，b在请求redirct_uri，向这个地址发送请求给A，A在接收token。

为了进一步保证安全，即使你拿到了 A 的 AUTHORIZATION_CODE、client_i，甚至client_secret，但你没有控制 A 的网站，你依然拿不到 access_token。access_token只发向已经在 B 注册的域名。

2019年8月22日 10:25 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-412880) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*[黑鸦](http://blacklotus.xin/)\** 说：**

授权码模式，token只存在后端的话，那同一用户每次访问资源，后端如何辨别出该用户对应的token呢？

2019年8月30日 09:40 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-413071) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*anne\** 说：**

老师，看了你的文章对oauth2有了基本的了解。多谢！

另外，我想请教使用vue前端+springboot后台如何实现授权码登录认证，不知道该怎么跳转？

2019年10月22日 18:05 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-414102) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*DaemonSu\** 说：**

第二种认证方式最后有这样一段话：

这种方式把令牌直接传给前端，是很不安全的。因此，只能用于一些安全要求不高的场景，并且令牌的有效期必须非常短，通常就是会话期间（session）有效，浏览器关掉，令牌就失效了。

这个session是B的session还是A的呢。如果是用户在A中的sessison，那么session是否终结B应用应该是不知道的。反之亦然。所以，对session失效令牌就失效了这句话感到不理解，希望老师能够讲解下

2019年10月29日 18:52 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-414237) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*[沁园](http://dqyuan.top/)\** 说：**

client secret 是在什么时候进行校验的呢？按照文中的协议，似乎 client id 很容易就被盗用，因为从头到尾都没有校验 client secret

2020年1月25日 19:19 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-416027) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*遗忘\** 说：**

授权码方式有点疑问，拿使用微信小程序来说，用户A想使用小程序B的功能，需要一个微信用户中心C的授权码，实际用户A只是拿C给的授权码访问小程序B的资源，这个场景好像和楼主说的不一样吧？后续用户A是使用授权码访问小程序B的资源，其实任何人都可以使用A的授权码都可以访问B

2020年3月18日 09:52 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-416896) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*He.Chun\** 说：**

寫的太棒了!

想請問一下，文中的
https://b.com/oauth/token?
https://oauth.b.com/token?
這兩個url我可以想成是同一個url嗎

2020年4月15日 14:09 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-417714) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*[Heropoo](https://metmoon.com/)\** 说：**

一直收藏着，今天又看了一遍

2020年4月29日 14:03 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-418068) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*Junlong\** 说：**

当使用授权码模式的时候，不向提供第三方应用的用户名和密码怎么知道用户的身份？

2020年5月15日 16:15 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-418348) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*[randyfield](http://www.randyfield.cn/)\** 说：**

> ```
> 引用Junlong的发言：
> ```
>
> 当使用授权码模式的时候，不向提供第三方应用的用户名和密码怎么知道用户的身份？

说明你没有看懂文章，
不管哪一种授权方式，第三方应用申请令牌之前，都必须先到系统备案，说明自己的身份，然后会拿到两个身份识别码：

\- 客户端 ID（client ID）
\- 客户端密钥（client secret）

2020年6月24日 15:59 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-419687) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*yexiaoqian\** 说：**

第一种授权码，是不是就是适用于好像微信这种登录第三方网站，第三种密码式的，是不是就适用于一般项目凭密码登录这种

2020年7月20日 11:10 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-420484) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*GY\** 说：**

这种方式是最常用的流程，安全性也最高，”它适用于那些有后端的 Web 应用“。授权码通过前端传送，”令牌则是储存在后端“，而且所有与资源服务器的通信都在后端完成。


”它适用于那些有后端的 Web 应用“ 和 ”令牌则是储存在后端“ 这两句话是不是前后矛盾了

2020年7月27日 12:01 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-420714) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*Jacklondon Chen\** 说：**

> ```
> 引用kergee的发言：
> ```
>
> 单点登录一般采用哪种比较多？

单点登录系统，有商业产品，也有开源软件产品。
国外的，IBM 有相关软件产品，价格未知；
国内的上海折桂软件也有一款软件产品，价格未知；
开源免费的有 CAS , 文档都是英文的，啃起来要花一点时间。
比较早期的有 Netscape 公司、Sun 公司，都推出过相应的软件，不值得公司被收购后还是否继续维护与销售。

2020年8月 4日 10:36 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-420975) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*Jacklondon Chen\** 说：**

> ```
> 引用黑鸦的发言：
> ```
>
> 授权码模式，token只存在后端的话，那同一用户每次访问资源，后端如何辨别出该用户对应的token呢？

您所理解的“资源”，与 OAuth 概念中的资源，可能不是一回事。

举例来说，用户 Tom 用 IE 访问 sohu 网站，假定 sohu 网站支持 qq 账号，然后 sohu 网站将用户 IE 自动重定向到 qq 网站，让他用户录入密码进行登录、并勾选"允许 sohu 网站查看我的 qq 基本信息(qq号、性别等)"。
用户在 qq 网站登录完成(完成录入密码、完成勾选允许...)，qq 网站将用户 IE 自动重定向回 sohu 网站并给一个授权码, sohu 网站后台使用授权码，向 qq 网站索要 token；sohu 网站得到 token 后，向qq 网站索要当前 IE 远端用户的 qq 基本信息(qq号、性别等)。
之后 sohu 网站标记此 qq 用户为"本网站已登录、已注册用户"，允许sohu 网站访问本网站的内容(论坛等)。

OAuth 所说的"资源"，是登录网站的qq 基本信息(qq号、性别等), 不是指 sohu 网站的内容(论坛等).

2020年8月 4日 10:49 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-420976) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*Jacklondon Chen\** 说：**

> ```
> 引用黑鸦的发言：
> ```
>
> 授权码模式，token只存在后端的话，那同一用户每次访问资源，后端如何辨别出该用户对应的token呢？

用户不访问资源(比如，qq 基本信息)，后端应用(比如，sohu网站)才访问资源。而且，后端应用，只访问一次资源。
后端应用(比如，sohu网站)自行维护 http session id 与 token 关系。每次用户 IE 访问后端应用(比如，sohu网站)，一段时间内，都会带同一个 http session id 的。

2020年8月 4日 10:58 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-420977) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*Jacklondon Chen\** 说：**

> ```
> 引用Chenyang的发言：
> ```
>
> 是不是意味着A网站持有用户授权过的B网站access token和refresh token的话，自身不需要用户再次授权就可以一直访问B网站上的资源.

access token和refresh token 都有有效期。
再说，这里的资源，一般仅仅指单个用户账号的信息(不包含密码)，访问一次就行了，没必要"一直访问"。另外，只能读、不能写，也做不了什么坏事。

2020年8月 4日 11:06 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-420978) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*jason\** 说：**

什么是没有后端的纯前端应用？

2020年9月 9日 18:08 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-422149) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*conorzhong\** 说：**

> ```
> 引用jason的发言：
> ```
>
> 什么是没有后端的纯前端应用？

比如说浏览器插件

2020年11月 4日 09:42 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-423633) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*Polar\** 说：**

想问一下，您这介绍的我可以理解为是opendId＋Auth2.0的方式吗

2021年1月14日 10:16 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-424986) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*hanszhao\** 说：**

> ```
> 引用dechy的发言：
> ```
>
> 用户对什么资源进行授权，这里并没有体现出来。客户端想要获取用户的资源可能是各种各样的，而认证的流程是一样的。
>
> 是不是应该有参数让客户端指定获取用户哪方面的资源呢？

建议看看第三方应用使用微信登录的授权过程，这个授权过程就是微信基于OAuth2.0的第一种授权码的方式实现的，微信开放平台中的这方面的文档详细说明了整个过程，对理解授权码方式很有帮助。

2021年2月26日 10:34 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-425624) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)

***\*女武神\** 说：**

@Jacklondon Chen：

请问，那如果sessionid被伪造了该怎么办呢

2021年3月22日 18:07 | [#](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-426057) | [引用](http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html#comment-text)
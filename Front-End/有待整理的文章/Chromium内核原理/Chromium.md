# Chromium内核原理之进程间通信(IPC)

[《Chromium内核原理之blink内核工作解密》](https://www.jianshu.com/p/2a2424bdc057)
 [《Chromium内核原理之多进程架构》](https://www.jianshu.com/p/bb50ea1a5e92)
 [《Chromium内核原理之进程间通信(IPC)》](https://www.jianshu.com/p/c9703029671b)
 [《Chromium内核原理之网络栈》](https://www.jianshu.com/p/dcc6944b2a80)
 [《Chromium内核原理之网络栈HTTP Cache》](https://www.jianshu.com/p/e6fb8fddf656)
 [《Chromium内核原理之Preconnect》](https://www.jianshu.com/p/1b26c3f04158)
 [《Chromium内核原理之Prerender》](https://www.jianshu.com/p/2f68e2233de1)
 [《Chromium内核原理之cronet独立化》](https://www.jianshu.com/p/79a959b038fd)

> **1.进程间通信概述**
>
> > **1.1 browser端的IPC**
> >  **1.2 renderer端的IPC**
>
> **2.消息机制**
>
> > **2.1 消息类型**
> >  **2.2 消息声明**
> >  **2.3 发送消息**
> >  **2.4 处理消息**
> >  **2.5 安全策略**
>
> **3.Channels通道**
>  **4.同步消息**
>
> > **4.1 声明同步消息**
> >  **4.2 发送同步消息**
> >  **4.3 处理同步消息**
> >  **4.4 将消息类型转换为消息名称**
>
> **5.IPC方式总结**

#### 1.进程间通信概述

Chromium具有多进程架构，这意味着我们有许多进程相互通信。我们的主要进程间通信原语是命名管道。在Linux和OS X上，我们使用socketpair（）。为每个渲染器进程分配命名管道，以便与浏览器进程通信。管道以异步模式使用，以确保两端都不会被阻塞等待另一端。

有关如何编写安全IPC端点的建议，请参阅IPC安全提示。

##### 1.1 browser端的IPC

在浏览器中，与渲染器的通信在单独的I / O线程中完成。然后，必须使用ChannelProxy将进出视图的消息代理到主线程。此方案的优点是资源请求（对于网页等）是最常见和性能关键的消息，可以完全在I / O线程上处理，而不是阻止用户界面。这些是通过使用ChannelProxy :: MessageFilter完成的，它由RenderProcessHost插入到通道中。此过滤器在I / O线程中运行，拦截资源请求消息，并将它们直接转发到资源调度程序主机。有关资源加载的详细信息，请参阅多进程资源加载。

##### 1.2 renderer端的IPC

每个渲染器还有一个管理通信的线程（在本例中为主线程），渲染和大多数处理发生在另一个线程上（参见多进程架构中的图表）。大多数消息通过主渲染器线程从浏览器发送到WebKit线程，反之亦然。这个额外的线程是支持同步渲染器到浏览器的消息（参见下面的“同步消息”）。

#### 2.消息机制

##### 2.1 消息类型

我们有两种主要类型的消息：“路由”和“控制”。控制消息由创建管道的类处理。有时，该类将允许其他人通过拥有其他侦听器可以注册的MessageRouter对象来接收消息，并接收以其唯一（每个管道）id发送的“路由”消息。

例如，在渲染时，控制消息不是特定于给定视图，而是由RenderProcess（渲染器）或RenderProcessHost（浏览器）处理。对资源的请求或修改剪贴板不是特定于视图的，因此控制消息也是如此。路由消息的示例是要求视图绘制区域的消息。

历史上已使用路由消息将消息发送到特定的RenderViewHost。但是，从技术上讲，任何类都可以通过使用RenderProcessHost :: GetNextRoutingID并使用RenderProcessHost :: AddRoute注册自己来接收路由消息。目前，RenderViewHost和RenderFrameHost实例都有自己的路由ID。

与消息类型无关的是消息是从浏览器发送到渲染器，还是从渲染器发送到浏览器。与从浏览器发送到渲染器的文档框架相关的消息称为框架消息，因为它们被发送到RenderFrame。同样，从渲染器发送到浏览器的消息称为FrameHost消息，因为它们被发送到RenderFrameHost。您会注意到frame_messages.h中定义的消息是两个部分，一个用于Frame，另一个用于FrameHost消息。

可以参考frame_message.h的代码：
 https://cs.chromium.org/chromium/src/content/common/frame_messages.h

插件也有单独的进程。与渲染消息一样，有PluginProcess消息（从浏览器发送到插件进程）和PluginProcessHost消息（从插件进程发送到浏览器）。这些消息都在plugin_process_messages.h中定义。自动化消息（用于从UI测试控制浏览器）以类似的方式完成。

同一组织适用于在浏览器和渲染器之间交换的其他消息组，以及在view_messages.h中定义的RenderViewHost和RenderView之间交换的View和ViewHost标记消息。

可以参考view_messages.h的代码：
 https://cs.chromium.org/chromium/src/content/common/view_messages.h

##### 2.2 消息声明

特殊宏用于声明消息。要从呈现器向浏览器声明路由消息（例如，特定于帧的FrameHost消息），其中包含URL和整数作为参数，请写入：
 `IPC_MESSAGE_ROUTED2(FrameHostMsg_MyMessage, GURL, int)`

要声明从浏览器到渲染器的控制消息（例如，不是特定于帧的帧消息），不包含任何参数，请写入：
 `IPC_MESSAGE_CONTROL0(FrameMsg_MyMessage)`

使用ParamTraits模板将参数序列化并反序列化为消息体。为ipc_message_utils.h中的大多数常见类型提供了此模板的特化。如果您定义自己的类型，则还必须为其定义自己的ParamTraits专门化。

有时，消息中包含太多值，无法合理地放入消息中。在这种情况下，我们定义一个单独的结构来保存值。例如，对于FrameMsg_Navigate消息，在navigation_params.h中定义了CommonNavigationParams结构。 frame_messages.h使用IPC_STRUCT_TRAITS宏系列定义结构的ParamTraits特化。

##### 2.3 发送消息

您通过“Channels”通道发送消息（见下文）。在浏览器中，RenderProcessHost包含用于将消息从浏览器的UI线程发送到渲染器的通道。 RenderWidgetHost（RenderViewHost的基类）提供了一个方便使用的Send函数。
 消息由指针发送，并在调度后由IPC层删除。因此，一旦找到合适的发送功能，只需使用新消息调用它：
 `Send(new ViewMsg_StopFinding(routing_id_));`

请注意，您必须指定路由ID，以便将消息路由到接收端的正确View / ViewHost。 RenderWidgetHost（RenderViewHost的基类）和RenderWidget（RenderView的基类）都有可以使用的GetRoutingID（）成员。

##### 2.4 处理消息

消息通过实现IPC :: Listener接口来处理，该接口是OnMessageReceived最重要的功能。我们有各种各样的宏来简化此函数中的消息处理，最好通过示例来说明：



```php
MyClass::OnMessageReceived(const IPC::Message& message) {
  IPC_BEGIN_MESSAGE_MAP(MyClass, message)
    // Will call OnMyMessage with the message. The parameters of the message will be unpacked for you.
    IPC_MESSAGE_HANDLER(ViewHostMsg_MyMessage, OnMyMessage)  
    ...
    IPC_MESSAGE_UNHANDLED_ERROR()  // This will throw an exception for unhandled messages.
  IPC_END_MESSAGE_MAP()
}

// This function will be called with the parameters extracted from the ViewHostMsg_MyMessage message.
MyClass::OnMyMessage(const GURL& url, int something) {
  ...
}
```

您也可以使用IPC_DEFINE_MESSAGE_MAP为您实现功能定义。在这种情况下，不要指定消息变量名，它将在给定的类上声明OnMessageReceived函数并实现其内容。

其他的宏定义：IPC_MESSAGE_FORWARD：这与IPC_MESSAGE_HANDLER相同，但您可以指定自己的类来发送消息，而不是将其发送到当前类。

```
IPC_MESSAGE_FORWARD(ViewHostMsg_MyMessage, some_object_pointer, SomeObject::OnMyMessage)`
 IPC_MESSAGE_HANDLER_GENERIC：这允许您编写自己的代码，但您必须自己从消息中解压缩参数：
 `IPC_MESSAGE_HANDLER_GENERIC(ViewHostMsg_MyMessage, printf("Hello, world, I got the message."))
```

##### 2.5 安全策略

IPC中的安全漏洞可能会产生令人讨厌的后果（文件被盗，沙箱逃逸，远程代码执行）。查看我们的IPC文档安全性，获取有关如何避免常见陷阱的提示。

#### 3.Channels通道

IPC :: Channel（在ipc / ipc_channel.h中定义）定义了跨管道通信的方法。 IPC :: SyncChannel提供了同步等待对某些消息的响应的附加功能（呈现器进程使用它，如下面“同步消息”部分所述，但浏览器进程从不这样做）。

通道不是线程安全的。我们经常想在另一个线程上使用频道发送消息。例如，当UI线程想要发送消息时，它必须通过I / O线程。为此，我们使用IPC :: ChannelProxy。它具有与常规通道对象类似的API，但将消息代理到另一个线程以发送它们，并在接收时将消息代理回原始线程。它允许您的对象（通常在UI线程上）在通道线程（通常是I / O线程）上安装IPC :: ChannelProxy :: Listener，以过滤掉代理的某些消息。我们将此用于资源请求和可以直接在I / O线程上处理的其他请求。 RenderProcessHost安装一个RenderMessageFilter对象来执行此过滤。

#### 4.同步消息

从渲染器的角度来看，某些消息应该是同步的。这种情况主要发生在我们应该返回某个WebKit调用时，但我们必须在浏览器中执行此操作。此类消息的示例包括拼写检查和获取JavaScript的cookie。禁止同步浏览器到渲染器IPC以防止在可能存在碎片的渲染器上阻塞用户界面。

**注意：不要在UI线程中处理任何同步消息！您必须仅在I / O线程中处理它们。否则，应用程序可能会死锁，因为插件需要从UI线程进行同步绘制，并且当渲染器等待来自浏览器的同步消息时，这些将被阻止。**

##### 4.1 声明同步消息

使用`IPC_SYNC_MESSAGE_ *`宏声明同步消息。这些宏具有输入和返回参数（非同步消息缺少返回参数的概念）。对于带有两个输入参数并返回一个参数的控制函数，您可以将2_1附加到宏名称以获取：



```cpp
IPC_SYNC_MESSAGE_CONTROL2_1(SomeMessage,  // Message name
                            GURL, //input_param1
                            int, //input_param2
                            std::string); //result
```

同样，您也可以将消息路由到视图，在这种情况下，您可以将“control”替换为“routed”以获取`IPC_SYNC_MESSAGE_ROUTED2_1`。您还可以有0个输入或返回参数。当渲染器必须等待浏览器执行某些操作但不需要任何结果时，将使用没有返回参数。我们将它用于某些打印和剪贴板操作。

##### 4.2 发送同步消息

当WebKit线程发出同步IPC请求时，请求对象（从IPC :: SyncMessage派生）通过IPC :: SyncChannel对象（同一个也用于发送所有异步消息）被分派到渲染器上的主线程。 。 SyncChannel在收到同步消息时将阻塞调用线程，并且只在收到回复时才解除阻塞。

当WebKit线程正在等待同步回复时，主线程仍然从浏览器进程接收消息。这些消息将被添加到WebKit线程的队列中，以便在唤醒时进行处理。收到同步消息回复后，线程将被取消阻止。请注意，这意味着可以无序处理同步消息回复。

同步消息的发送方式与普通消息的发送方式相同，输出参数将提供给构造函数。例如：



```cpp
const GURL input_param("http://www.google.com/");
std::string result;
content::RenderThread::Get()->Send(new MyMessage(input_param, &result));
printf("The result is %s\n", result.c_str());
```

##### 4.3 处理同步消息

同步消息和异步消息使用相同的IPC_MESSAGE_HANDLER等宏来分派消息。消息的处理函数将具有与消息构造函数相同的签名，该函数将简单地将输出写入输出参数。对于上面的消息，您将添加`IPC_MESSAGE_HANDLER(MyMessage, OnMyMessage)`到OnMessageReceived 函数中。



```cpp
void RenderProcessHost::OnMyMessage(GURL input_param, std::string* result) {
  *result = input_param.spec() + " is not available";
}
```

##### 4.4 将消息类型转换为消息名称

如果您遇到崩溃并且您有消息类型，则可以将其转换为消息名称。消息类型为32位值，高16位为类，低16位为id。该类基于ipc / ipc_message_start.h中的枚举，id基于定义消息的文件中的行号。这意味着您需要获取Chromium的确切修订版才能准确获取消息名称。

#### 5.IPC方式总结

Chromium为解决这些问题，使用了 非阻塞式，多线程，配合状态监听的解决方案!  主要运用了以下关键技术:

> - Unix Domain Socket (POSIX下使用的IPC机制)
> - libevent (轻型事件驱动的网络库，用于监听IPC中的端口(文件描述符))
> - ChannelProxy (为Channel提供线程安全的机制)
> - 闭包 (线程的运作方式)

Libevent是一个轻量级的开源高性能网络库．有几个显著的亮点：

- a. 事件驱动（event-driven）
- b. 高性能 轻量级，专注于网络，不如ACE那么臃肿庞大
- c. 注册事件优先级

------

分发消息时，分为广播和专线两种方式。在Chromium中一个页面在不同线程，Browser和Renderer两端以routed id为标识彼此。如果要说悄悄话，就指定一个routed id， 这类消息称为Routed Message，是专线。 另一类消息，则是进行广播，不区分身份，这类消息为Control Message。

------

参考：
 https://www.chromium.org/developers/design-documents/inter-process-communication

https://blog.csdn.net/HorkyChen/article/details/44516633



作者：码上就说
链接：https://www.jianshu.com/p/c9703029671b
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
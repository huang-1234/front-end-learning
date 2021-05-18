## flex布局

Flex是Flexible Box 的缩写，意为"弹性布局"，是CSS3的一种布局模式。通过Flex布局，可以很优雅地解决很多CSS布局的问题。下面会分别介绍容器的6个属性和项目的6个属性。每个属性会附上效果图，具体实现代码会以github路径形式更新于此。

# 1.浏览器支持情况

可以[点击](https://www.caniuse.com/#search=flex)查看各浏览器的兼容情况

# 2.容器的属性

注意，设为 Flex 布局以后，子元素的float、clear和vertical-align属性将失效。

容器的属性有6个，分别是：

flex-direction

flex-wrap

flex-flow

justify-content

align-items

align-content

(1)flex-direcion属性:

作用：控制主轴的方向

flex-direction: row | row-reverse | column | column-reverse;

默认值：row



![img](flexLayoutgif.assets/167a5aefae675d7a)



(2)flex-wrap属性：

作用：默认情况下，项目都排在一条线（又称"轴线"）上。flex-wrap属性定义，如果一条轴线排不下，如何换行。

flex-wrap: nowrap | wrap | wrap-reverse;

默认值：nowrap



![img](flexLayoutgif.assets/167a5aefae8a2532)



(3)flex-flow属性

作用：该属性是flex-direction属性和flex-wrap属性的简写形式

默认值：row nowrap

(4)justify-content属性

作用：定义项目在主轴上的对齐方式

justify-content: flex-start | flex-end | center | space-between | space-around;

默认值：flex-start



![img](data:image/svg+xml;utf8,<?xml version="1.0"?><svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="600" height="558"></svg>)



(5)align-items属性

作用：定义项目在交叉轴上如何对齐。

align-items: flex-start | flex-end | center | baseline | stretch

默认值：flex-start



![img](flexLayoutgif.assets/167a5aefb0580b27)



注意：如果align-items为stretch，想看到每个flex-item铺满整个交叉轴的话，需要设置所有的flex-item的高度：height:auto，否则达不到效果。

(6)align-content属性

属性定义了多根轴线的对齐方式。如果项目只有一根轴线，该属性不起作用。

align-content: flex-start | flex-end | center | space-between | space-around | stretch;

默认值：stretch

flex-start：与交叉轴的起点对齐。

flex-end：与交叉轴的终点对齐。

center：与交叉轴的中点对齐。

space-between：与交叉轴两端对齐，轴线之间的间隔平均分布。

space-around：每根轴线两侧的间隔都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍。

stretch：轴线占满整个交叉轴。



![img](flexLayoutgif.assets/167a5aefaeca4cc4)



# 3.项目的属性

项目的属性有6个，分别是：

order

flex-grow

flex-shrink

flex-basis

flex

align-self

(1)order属性：

作用：定义项目的排列顺序，数值越小，排列越靠前。

默认值：0



![img](flexLayoutgif.assets/167a5aefb000e8c1)



(2)flex-grow属性

作用：如果存在剩余空间，项目放大的比例。相当于是各个项目根据这个比例，来分配剩余空间。

默认值：0（不放大）



![img](flexLayoutgif.assets/167a5aefd6aecdfa)



(3)flex-shrink属性

作用：flex-shrink：如果存在空间不足，项目的“缩小比例”。0表示当空间不足时，不缩小。

默认值：1

负值对该属性无效



![img](flexLayoutgif.assets/167a5aefe3ae3120)



(4)flex-basis属性

作用：定义项目在主轴方向上占据空间大小的初值。

默认值：auto(项目本来的大小)

(5)flex属性

作用：是flex-grow、flex-shrink、flex-basis属性的缩写形式；

flex: none | [<'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]

注：几种常见缩写形式；

flex: auto;  === flex: 1 1 auto;

flex: none; === flex: 0 0 auto;

flex: initial; === flex: 0 1 auto;

flex: ; === flex: 1 auto;

flex: 1; === flex: 1 1 auto;

建议优先使用这个属性，而不是单独写三个分离的属性，因为浏览器会推算相关值

(6)align-self属性

作用：属性允许单个项目有与其他项目不一样的对齐方式，可覆盖align-items属性。

align-self: auto | flex-start | flex-end | center | baseline | stretch;

默认值：auto，表示继承父元素的align-items属性，如果没有父元素，则等同于stretch。



![img](flexLayoutgif.assets/167a5aefe3b3c820)



# 4.小结

本文分别介绍了容器的6个属性和flex-item项目的6个属性。建议跟着demo整体做一遍，有助于加深理解。如有问题，欢迎指正。

**此文已由作者授权腾讯云+社区发布**


作者：腾讯云加社区
链接：https://juejin.cn/post/6844903736582602760
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
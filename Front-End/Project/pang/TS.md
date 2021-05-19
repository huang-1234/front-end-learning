# TypeScript 从入门到精通

我原本准备更新 Vue3.x 教程的，由于官方文档一直不出，我又不敢瞎讲，所以干脆先来一个 TypeScript 教程热身，TypeScript 已经在我们公司全面使用了，现在招聘的环节也增加了一个要求，就是要求必须熟练使用 TypeScript。我以前也出过 TypeScript 的教程，不过那个太简单，不够深入。所以在这个空档期，准备自己重学一下 TypeScript，然后也也出一个比较完全的教程。

努力做到全网最好的免费 TypeScript 图文视频教程。

[01.TypeScript 简介和课程介绍](https://jspang.com/detailed?id=63#toc21)

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=212444579&amp;page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

以前的 TypeScript 教程看这里：[TypeScript 免费视频教程 ，Deno 前置知识 (共 15 集)](https://jspang.com/detailed?id=38)

这里我建议你耐心点，跟我一起学习这版最新的《TypeScript 从入门到精通图文视频教程》，这样能更好的对 TypeScript 有全面的了解。

[TypeScript 简介](https://jspang.com/detailed?id=63#toc32)

TypeScript 是由微软公司在 2012 年正式发布，现在也有 8 年的不断更新和维护了，TypeScript 的成长速度是非常快的，现在已经变成了前端必会的一门技能。TypeScript 其实就是 JavaScript 的超集，也就是说 TypeScript 是建立在 JavaScript 之上的，最后都会转变成 JavaScript。这就好比漫威里的钢铁侠，没穿装甲之前，他实力一般，虽然聪明有钱，但还是接近人类。但是有了装甲，他就厉害太多了，甚至可以和神干一架。

也许你会觉的我这说的太夸张，我刚开始学习时，也是这样想的，但是用了 2 年左右，特别是大型项目中，真的好用。比如说它的扩展语法、面向对象、静态类型。如果一个前端项目我可以做主，我会在强烈的要求所有人都使用 TypeScript 的语法进行编程。

[使用 VSCode 进行编写代码](https://jspang.com/detailed?id=63#toc33)

我的所有前端课程都是使用 VSCode 进行编写代码的，因为这是我在工作中用的最多的编辑器，也是目前我认为最好用的编辑器。

> 下载地址：https://code.visualstudio.com/

如果你已经参加了工作，我相信你身边至少有 80%以上的前端，在使用这款编辑器。

使用 VSCode 讲解，还有一个主要的愿意就是他们都是微软出的产品，所以有很好的兼容性和支持，VSCode 上有很多专门为 TypeScript 专门作的语法适配，所以在编写时就会轻松快乐起来。

[TypeScript 开发环境搭建](https://jspang.com/detailed?id=63#toc34)

如果你想使用 TypeScript 来编写代码，你需要先安装一下它的开发环境，这并不复杂。

**1.安装 Node 的运行环境**

你可以到`Node.js`官网去下载 Node 进行安装([https://node.js.org](https://node.js.org/))，建议你下载`LTS`版本,也就是长期支持版本。安装的过程我就不演示了，这个过程就和安装 QQ 一样，没有任何难度。

如果你已经安装了，可以打开命令行工具，然后使用`node -v`命令查看安装的版本，但是一般还有一个命令需要检测一下，就是`npm -v`,如果两个命令都可以输出版本号，说明你的 Node 安装已经没有任何问题了。

**2.全局安装 typeScript**

你要使用 TypeScript 先要在你的系统中全局安装一下`TypeScript`，这里你可以直接在 VSCode 中进行安装，安装命令可以使用 npm 也可以使用 yarn

```js
npm install typescript -g
yarn global add typescript
```

这两个你使用那个都是可以的，根据喜好自行选择，我在视频中使用的`npm`进行安装。

**3.建立项目目录和编译 TS 文件**

在`E盘`(当然你可以在你喜欢的任何一个地方安装)，新建一个目录，我这里起的目录名字叫做`TypeScriptDemo`，然后把这个文件在 VSCode 中打开。 我在视频里用了命令行的形式建立，直接使用`ctrl+r`打开运行，然后在运行的文本框里输入`cmd`，回车后，打开命令行工具，在命令行中输入下面的命令。

```js
e:
mkdir TypeScriptDemo
```

完成后，打开 E 盘，打开 VSCode，把新建立的文件夹拖入到 VSCode 当中，新建一个`Demo1.ts`文件，写入下面代码：

```js
function jspang() {
  let web: string = "Hello World";
  console.log(web);
}

jspang();
```

这时候你使用`node Demo1.ts`是执行不成功的，因为 Node 不能直接运行`TypeScript`文件，需要用`tsc Demo1.ts`转换一下，转换完成后`typeScript`代码被编译成了`javaScript`代码,新生成一个`demo1.js`的文件，这时候你在命令行输入`node Demo1.js`,在终端里就可以顺利的输出`jspang`的字符了。

**4.ts-node 的安装和使用**

但是这样操作的效率实在是太低了，你可以使用`ts-node`插件来解决这个问题，有了这个插件，我们就不用再编译了，而使用`ts-node`就可以直接看到编写结果。

使用`npm`命令来全局安装，直接在命令行输入下面的命令：

```js
npm install -g ts-node
```

安装完成后，就可以在命令中直接输入如下命令，来查看结果了。

```js
ts-node Demo1.ts
```

好了，今天就学这么多吧，恭喜你有学会了新的编程技能，小伙伴们，加油！！！

------

[02.TypeScript 的静态类型](https://jspang.com/detailed?id=63#toc25)

TypeScript 的一个最主要特点就是可以定义静态类型，英文是 Static Typing。那到底是什么意思那？太复杂的概念性东西这里就不讲了，你可以简单的理解“静态类型”为，就是你一旦定义了，就不可以再改变了。比如你是男人就是男人，一辈子都要作男人；是女人就是女人，一辈子都是女人。这个事不可以改变！呃....好像现在也可以随便变来变去啊，这里说的是正常情况。但是它还有一些特性，这个并不像表面的那么简单。现在我们就来学习。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=213553779&amp;page=2" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[如何定义静态类型](https://jspang.com/detailed?id=63#toc36)

你可以在上节课的文件夹下建立一个新的`demo2.ts`文件，然后写下这段代码：

```js
const count: number = 1;
```

这就是最简单的定义一个数字类型的`count`的变量，这里的`: number`就是定义了一个静态类型。这样定义后`count`这个变量在程序中就永远都是数字类型了，不可以改变了。比如我们这时候给`count`复制一个字符串，它就报错了。

```js
//错误代码
const count: number = 1;
count = "jspang";
```

但这只是最简单的理解，再往深一层次理解，你会发现这时候的`count`变量,可以使用`number`类型上所有的属性和方法。我们可以通过在`count`后边打上一个`.`看出这个特性，并且编辑器会给你非常好的提示。这也是为什么我喜欢用`VScode`编辑器的一个原因。

[自定义静态类型](https://jspang.com/detailed?id=63#toc37)

你还可以自己去定义一个静态类型，比如现在你定义一个`小姐姐`的类型，然后在声明变量的时候，就可以使用这个静态类型了，看下面的代码。

```js
interface XiaoJieJie {
  uname: string;
  age: number;
}

const xiaohong: XiaoJieJie = {
  uname: "小红",
  age: 18,
};
```

这时候你如果声明变量，跟自定义不一样，`VSCode`直接就会报错。需要注意的是，这时候`xiaohong`变量也具有`uname`和`age`属性了。

这节课你需要记住的是，如果使用了静态类型，不仅意味着变量的类型不可以改变，还意味着类型的属性和方法也跟着确定了。这个特点就大大提高了程序的健壮性，并且编辑器这时候也会给你很好的语法提示，加快了你的开发效率。

随着你不断的深入学习，你会对这两个优点有更深的理解。

[03.TypeScript 基础静态类型和对象类型](https://jspang.com/detailed?id=63#toc28)

在 TypeScript 静态类型分为两种，一种是基础静态类型，一种是对象类型，这两种都经常使用，非常重要，我们先来看一下什么是基础静态类型。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=213957275&amp;page=3" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[基础静态类型](https://jspang.com/detailed?id=63#toc39)

基础静态类型非常简单，只要在声明变量的后边加一个`:`号，然后加上对应的类型哦。比如下面的代码，就是声明了一个数字类型的变量，叫做`count`。

```js
const count : number = 918;
const myName ：string = 'jspang'
```

类似这样常用的基础类型还有，我这里就举几个最常用的哦,`null`,`undefinde`,`symbol`,`boolean`，`void`这些都是最常用的基础数据类型，至于例子，我这里就不详细的写了，后面碰到，我们再继续讲解。

[对象类型](https://jspang.com/detailed?id=63#toc310)

我们先来看一个例子，通过例子有经验的小伙伴就知道个大概了，然后我们再来讲解(其实上节课我们也讲到了，我们这里就当复习了)。新建一个文件`demo3.ts`（你可以跟我不一样）,然后写下如下代码。

```js
const xiaoJieJie: {
  name: string,
  age: number,
} = {
  name: "大脚",
  age: 18,
};
console.log(xiaoJieJie.name);
```

写完后，我们在`terminal`（终端）中输入`ts-node demo3.ts`，可以看到结果输出了`大脚`。这就是一个经典的对象类型，也是最简单的对象类型。对象类型也可以是数组，比如现在我们需要很多小姐姐，我们就可以这样写。

```js
const xiaoJieJies: String[] = ["谢大脚", "刘英", "小红"];
```

这时候的意思是，变量`xiaoJieJies`必须是一个数组，数组里的内容必须是字符串。你可以试着把字符串改为数字，`VSCode`会直接给我们报错。

```js
const xiaoJieJies: String[] = ["谢大脚", "刘英", 123];
```

现在都讲究面向对象编程，我这面向对象编程这么多年了，也没再多编出来一个。我们再来看看下面的代码。这个代码就是用类的形式，来定义变量。

```js
class Person {}
const dajiao: Person = new Person();
```

这个意思就是`dajiao`必须是一个`Person`类对应的对象才可以。我们还可以定义一个函数类型，并确定返回值。代码如下：

```js
const jianXiaoJieJie: () => string = () => {
  return "大脚";
};
```

那我们现在总结一下对象类型可以有几种形式：

- 对象类型
- 数组类型
- 类类型
- 函数类型

这几种形式我们在`TypeScript`里叫做对象类型。

这节课我们就主要学习了基础类型和对象类型的概念，希望小伙伴都能学会，再次提醒，动手练习会有更好的效果。小伙伴们，加油。

[04.TypeScript 中的类型注释和类型推断](https://jspang.com/detailed?id=63#toc211)

这节课我们学习一下 TypeScript 中的两个基本概念：`类型注解`和`类型推断`，这两个概念在我们编写 TypeScript 代码时会一直使用(重点)，但很多教程都没有讲解，不过在官方文档中有比较好的解释。你现在可能还不能完全理解我说的这两个概念，但是你看完文章后就会有很直观的了解啦。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=217243264&amp;page=4" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[type annotation 类型注解](https://jspang.com/detailed?id=63#toc312)

这个概念我们在前三节课中一直使用，只是我没明确这个概念和关系，所以你会觉的很陌生。这就好比，你身边有一个特别漂亮的姑娘，她一直很喜欢你，你也很喜欢她，但窗户纸一直没捅破，直到有一天你们喝多后，去了如家酒店（谈了谈心），你们的关系就明确了。

学程序并没有这么复杂，我们直接点，新建一个文件`demo4.ts` ,然后看代码：

```js
let count: number;
count = 123;
```

这段代码就是类型注解，意思是显示的告诉代码，我们的`count`变量就是一个数字类型，这就叫做`类型注解`。是不是一下就明白了，其实程序这东西就这么简单，真正复杂的是人。

[type inferrence 类型推断](https://jspang.com/detailed?id=63#toc313)

当你明白了`类型注解`的概念之后，再学类型推断就更简单了，先来看一段代码。还是在`Demo4.ts`文件中写入下面的代码。

```js
let countInference = 123;
```

这时候我并没有显示的告诉你变量`countInference`是一个数字类型，但是如果你把鼠标放到变量上时，你会发现 TypeScript 自动把变量注释为了`number`（数字）类型，也就是说它是有某种推断能力的，通过你的代码 TS 会自动的去尝试分析变量的类型。这个就彷佛是人的情商比较高，还没等女生表白那，你就已经看出她的心思。

[工作使用问题（潜规则）](https://jspang.com/detailed?id=63#toc314)

- 如果 `TS` 能够自动分析变量类型， 我们就什么也不需要做了
- 如果 `TS` 无法分析变量类型的话， 我们就需要使用类型注解

先来看一个不用写类型注解的例子：

```js
const one = 1;
const two = 2;
const three = one + two;
```

再来看一个用写类型注解的例子：

```js
function getTotal(one, two) {
  return one + two;
}

const total = getTotal(1, 2);
```

这种形式，就需要用到类型注释了，因为这里的`one`和`two`会显示为`any`类型。这时候如果你传字符串，你的业务逻辑就是错误的，所以你必须加一个`类型注解`，把上面的代码写成下面的样子。

```js
function getTotal(one: number, two: number) {
  return one + two;
}

const total = getTotal(1, 2);
```

这里有的一个问题是，为什么`total`这个变量不需要加类型注解，因为当`one`和`two`两个变量加上注解后，TypeScript 就可以自动通过类型推断，分析出变量的类型。

当然 TypeScript 也可以推断出对象中属性的类型，比如现在写一个小姐姐的对象，然后里边有两个属性。

```js
const XiaoJieJie = {
  name: "刘英",
  age: 18,
};
```

写完后你把鼠标放在`XiaoJieJie`对象上面，就会提示出他里边的属性，这表明 TypeScript 也分析出了对象的属性的类型。

在写 TypeScript 代码的一个重要宗旨就是每个变量，每个对象的属性类型都应该是固定的，如果你推断就让它推断，推断不出来的时候你要进行注释。

[05.TypeScript 函数参数和返回类型定义](https://jspang.com/detailed?id=63#toc215)

这节主要学习一下函数的参数类型定义和返回值的定义，学完这节内容后，你会对函数的参数和返回值类型定义都有通透的了解。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=217632211&amp;page=5" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[简单类型定义](https://jspang.com/detailed?id=63#toc316)

上节课我们写了一个`getTotal`的函数，并且对传入的参数作了定义，我们再复习一遍。

新建一个文件`demo5.ts`,然后写入代码

```js
function getTotal(one: number, two: number) {
  return one + two;
}

const total = getTotal(1, 2);
```

这时候我们写的代码其实是有一个小坑的，就是我们并没有定义`getTotal`的返回值类型，虽然`TypeScript`可以自己推断出返回值是`number`类型。 但是如果这时候我们的代码写错了，比如写程了下面这个样子。

```js
function getTotal(one: number, two: number) {
  return one + two + "";
}

const total = getTotal(1, 2);
```

这时候`total`的值就不是`number`类型了，但是不会报错。有的小伙伴这时候可能会说，可以直接给`total`一个类型注解，比如写成这个样子。

```js
const total: number = getTotal(1, 2);
```

这样写虽然可以让编辑器报错，但是这还不是很高明的算法，因为你没有找到错误的根本，这时错误的根本是`getTotal()`函数的错误，所以合适的做法是给函数的返回值加上类型注解，代码如下：

```js
function getTotal(one: number, two: number): number {
  return one + two;
}

const total = getTotal(1, 2);
```

这段代码就比较严谨了，所以小伙伴们在写代码时，尽量让自己的代码更加严谨。

[函数无返回值时定义方法](https://jspang.com/detailed?id=63#toc317)

有时候函数是没有返回值的，比如现在定义一个`sayHello`的函数，这个函数只是简单的`terminal`打印，并没有返回值。

```js
function sayHello() {
  console.log("hello world");
}
```

这就是没有返回值的函数，我们就可以给他一个类型注解`void`，代表没有任何返回值。

```js
function sayHello(): void {
  console.log("hello world");
}
```

如果这样定义后，你再加入任何返回值，程序都会报错。

[never 返回值类型](https://jspang.com/detailed?id=63#toc318)

如果一个函数是永远也执行不完的，就可以定义返回值为`never`，那什么样的函数是永远也执行不完的那?我们先来写一个这样的函数(比如执行执行的时候，抛出了异常，这时候就无法执行完了)。

```js
function errorFuntion(): never {
  throw new Error();
  console.log("Hello World");
}
```

还有一种是一直循环，也是我们常说的死循环，这样也运行不完，比如下面的代码：

```js
function forNever(): never {
  while (true) {}
  console.log("Hello JSPang");
}
```

[函数参数为对象(解构)时](https://jspang.com/detailed?id=63#toc319)

这个坑有很多小伙伴掉下去过，就是当一个函数的参数是对象时，我们如何定义参数对象的属性类型。我先写个一般`javaScript`的写法。

```js
function add({ one, two }) {
  return one + two;
}

const total = add({ one: 1, two: 2 });
```

在浏览器中你会看到直接报错了，意思是`total`有可能会是任何类型，那我们要如何给这样的参数加`类型注解`那？最初你可能会这样写。

```js
function add({ one: number, two: number }) {
  return one + two;
}

const total = add({ one: 1, two: 2 });
```

你在编辑器中会看到这种写法是完全错误的。那正确的写法应该是这样的。

```js
function add({ one, two }: { one: number, two: number }): number {
  return one + two;
}

const three = add({ one: 1, two: 2 });
```

如果参数是对象，并且里边只有一个属性时，我们更容易写错。 错误代码如下：

```js
function getNumber({ one }: number) {
  return one;
}

const one = getNumber({ one: 1 });
```

看着好像没什么问题，但实际这是有问题的，正确的代码应该时这样的。

```js
function getNumber({ one }: { one: number }): number {
  return one;
}

const one = getNumber({ one: 1 });
```

这样写才是正确的写法，小伙伴们赶快动手练习一下吧，刚开始学你可能会觉的很麻烦，但是你写的时间长了，你就会发现有规矩还是好的。人向往自由，缺鲜有人能屈驾自由。

[06.TypeScript 中数组类型的定义](https://jspang.com/detailed?id=63#toc220)

这节课学习一下 TypeScript 中的数组类型，一般的数组类型定义我们已经接触过了，只是没有单独拿出来讲，所以先来复习一下。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=218419479&amp;page=6" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[一般数组类型的定义](https://jspang.com/detailed?id=63#toc321)

现在我们可以定义一个最简单的数组类型，比如就是数字类型，那么就可以这么写：

```js
const numberArr = [1, 2, 3];
```

这时候你把鼠标放在`numberArr`上面可以看出，这个数组的类型就是 number 类型。这是 TypeScript 通过`类型推断`自己推断出来的。 如果你要显示的注解，也非常简单，可以写成下面的形式。

```js
const numberArr: number[] = [1, 2, 3];
```

同样道理，如果你的数组各项是字符串，你就可以写成这样。

```js
const stringArr: string[] = ["a", "b", "c"];
```

也就是说你可以定义任意类型的数组，比如是`undefined`。

```js
const undefinedArr: undefined[] = [undefined, undefined];
```

这时候问题来了，如果数组中有多种类型，比如既有数字类型，又有字符串的时候。那我们要如何定义那。 很简单，只要加个`()`，然后在里边加上`|`就可以了，具体看代码。

```js
const arr: (number | string)[] = [1, "string", 2];
```

数组简单类型的定义就是这样了，并不难。

[数组中对象类型的定义](https://jspang.com/detailed?id=63#toc322)

如果你作过一些项目，你就会知道真实的项目中数组中一定会有对象的出现。那对于这类带有对象的数组定义就稍微麻烦点了。 比如现在我们要定义一个有很多小姐姐的数组，每一个小姐姐都是一个对象。这是的定义就编程了这样。

```js
const xiaoJieJies: { name: string, age: Number }[] = [
  { name: "刘英", age: 18 },
  { name: "谢大脚", age: 28 },
];
```

这种形式看起来比较麻烦，而且如果有同样类型的数组，写代码也比较麻烦，TypeScript 为我们准备了一个概念，叫做`类型别名`(type alias)。

比如刚才的代码，就可以定义一个`类型别名`，定义别名的时候要以`type`关键字开始。现在定义一个`Lady`的别名。

```js
type Lady = { name: string, age: Number };
```

有了这样的类型别名以后哦，就可以把上面的代码改为下面的形式了。

```js
type Lady = { name: string, age: Number };

const xiaoJieJies: Lady[] = [
  { name: "刘英", age: 18 },
  { name: "谢大脚", age: 28 },
];
```

这样定义是完全起作用的，比如我们下面在对象里再加入一个属性，这时候编译器就会直接给我们报错了。

这时候有的小伙伴就会问了，我用类进行定义可以吗？答案是可以的，比如我们定义一个`Madam`的类,然后用这个类来限制数组的类型也是可以的。

```js
class Madam {
  name: string;
  age: number;
}

const xiaoJieJies: Madam[] = [
  { name: "刘英", age: 18 },
  { name: "谢大脚", age: 28 },
];
```

可以看到结果，我们这么写也是完全可以的。

这就是这节课的所有内容了，希望小伙伴们可以学会，并动手练习一下。

------

[07.TypeScript 中元组的使用和类型约束](https://jspang.com/detailed?id=63#toc223)

TypeScript 中提供了`元组`的概念，这个概念是`JavaScript`中没有的。但是不要慌张，其实元组在开发中并不常用，也可能是我的精力还不够。一般只在数据源是`CVS`这种文件的时候，会使用元组。其实你可以把元组看成数组的一个加强，它可以更好的控制或者说规范里边的类型。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=223590735&amp;page=7" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[元组的基本应用](https://jspang.com/detailed?id=63#toc324)

我们先来看一个数组和这个数组注解的缺点，比如我们有一个小姐姐数组，数组中有姓名、职业和年龄，代码如下：

```js
const xiaojiejie = ["dajiao", "teacher", 28];
```

这时候把鼠标放到`xiaojiejie`变量上面，可以看出推断出来的类型。我们就用类型注解的形式给他作一个注解，代码如下：

```js
const xiaojiejie: (string | number)[] = ["dajiao", "teacher", 28];
```

这时候你已经增加了代码注解，但是这并不能很好的限制，比如我们把代码改成下面的样子，`TypeScript`依然不会报错。

```js
const xiaojiejie: (string | number)[] = ["dajiao", 28, "teacher"];
```

我们只是简单的把数组中的位置调换了一下，但是`TypeScript`并不能发现问题，这时候我们需要一个更强大的类型，来解决这个问题，这就是元组。

元组和数组类似，但是类型注解时会不一样。

```js
const xiaojiejie: [string, string, number] = ["dajiao", "teacher", 28];
```

这时候我们就把数组中的每个元素类型的位置给固定住了，这就叫做元组。

[元组的使用](https://jspang.com/detailed?id=63#toc325)

目前我的工作中不经常使用元组，因为如果要使用元组，完全可以使用对象的形式来代替，但是如果你维护老系统，你会发现有一种数据源时`CSV`,这种文件提供的就是用逗号隔开的，如果要严谨的编程就需要用到元组了。例如我们有这样一组由`CSV`提供的（注意这里只是模拟数据）。

```js
"dajiao", "teacher", 28;
"liuying", "teacher", 18;
"cuihua", "teacher", 25;
```

如果数据源得到的数据时这样的，你就可以使用元组了。

```js
const xiaojiejies: [string, string, number][] = [
  ["dajiao", "teacher", 28],
  ["liuying", "teacher", 18],
  ["cuihua", "teacher", 25],
];
```

这节课你的主要内容是，你要搞清楚元组和数组的区别，在理解后能在项目中适当的时候使用不同的类型。

[08.TypeScript 中的 interface 接口](https://jspang.com/detailed?id=63#toc226)

现在红浪漫洗浴中心要开始招聘小姐姐了，这时候你需要一些小姐姐的简历投递和自动筛选功能，就是不符合简历要求的会直接被筛选掉，符合的才可以进入下一轮的面试。那最好的解决方法就是写一个接口。TypeScript 中的接口，就是用来规范类型的。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=223992359&amp;page=8" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[Interface 接口初步了解](https://jspang.com/detailed?id=63#toc327)

现在我们要作一个简历的自动筛选程序，很简单。年龄小于 25 岁，胸围大于 90 公分的，可以进入面试环节。我们最开始的写法是这样的。（新建一个文件 Demo8.ts,然后编写如下代码）

```js
const screenResume = (name: string, age: number, bust: number) => {
  age < 24 && bust >= 90 && console.log(name + "进入面试");
  age > 24 || (bust < 90 && console.log(name + "你被淘汰"));
};

screenResume("大脚", 18, 94);
```

写好后，好像我们的程序写的不错，可以在终端中使用`ts-node demo8.ts`进行查看。这时候老板又增加了需求，说我必须能看到这些女孩的简历。于是你又写了这样一个方法。

```js
const getResume = (name: string, age: number, bust: number) => {
  console.log(name + "年龄是：" + age);
  console.log(name + "胸围是：" + bust);
};
getResume("大脚", 18, 94);
```

这时候问题来了，程序开发中一直强调“代码重用”，两个方法用的类型注解一样，需要作个统一的约束。大上节课我们学了一个`类型别名`的知识可以解决代码重复的问题，这节课我们就学习一个更常用的语法`接口`（Interface）.

我们可以把这两个重复的类型注解，定义成统一的接口。代码如下：

```js
interface Girl {
  name: string;
  age: number;
  bust: number;
}
```

有了接口后，我们的程序也要作一些修改，需要写成下面的样子。这样就更像是面向对象编程了。

```js
const screenResume = (girl: Girl) => {
  girl.age < 24 && girl.bust >= 90 && console.log(girl.name + "进入面试");
  girl.age > 24 || (girl.bust < 90 && console.log(girl.name + "你被淘汰"));
};

const getResume = (girl: Girl) => {
  console.log(girl.name + "年龄是：" + girl.age);
  console.log(girl.name + "胸围是：" + girl.bust);
};
const girl = {
  name: "大脚",
  age: 18,
  bust: 94,
};

screenResume(girl);
getResume(girl);
```

这时候我们代码就显得专业了很多，以后再用到同样的接口也不怕了，直接使用`girl`就可以了。

[接口和类型别名的区别](https://jspang.com/detailed?id=63#toc328)

现在我们学了`接口`，也学过了`类型别名`，这两个语法和用处好像一样，我先表个态，确实用起来基本一样，但是也有少许的不同。

> 类型别名可以直接给类型，比如`string`，而接口必须代表对象。

比如我们的`类型别名`可以写出下面的代码：

```js
type Girl1 = stirng;
```

但是接口就不能这样写，它必须代表的是一个对象，也就是说，你初始化`girl`的时候，必须写出下面的形式.

```js
const girl = {
  name: "大脚",
  age: 18,
  bust: 94,
};
```

[接口非必选值得定义](https://jspang.com/detailed?id=63#toc329)

这节课我们多学一点，因为接口这里的知识点还是挺多的。比如这时候老板又有了新的要求，要求尽量能看到小姐姐的腰围，但是不作强制要求，就是可选值吗。那接口如何定义那？其实`typeScript`已经为我们准备好了相应的办法，就是在`:`号前加一个`?`

比如把`Girl`的接口写成这样。

```js
interface Girl {
  name: string;
  age: number;
  bust: number;
  waistline?: number;
}
```

然后我们再修改一下`getResume`方法，写成这样。

```js
const getResume = (girl: Girl) => {
  console.log(girl.name + "年龄是：" + girl.age);
  console.log(girl.name + "胸围是：" + girl.bust);
  girl.waistline && console.log(girl.name + "腰围是：" + girl.waistline);
};
```

这时候在定义`girl`对象的时候，就可以写`saistline`（腰围），也可以不写了。

好了，这节课就先到这里，`Interface`(接口)的知识并没有讲完，我们下节课接着讲。

[09.TypeScript 中的 interface 接口 2](https://jspang.com/detailed?id=63#toc230)

我们接着上节课继续讲接口，接口部分的内容还是比较多的。所以小伙伴们不要着急，我们马上开始学习。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=224557106&amp;page=9" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[允许加入任意值](https://jspang.com/detailed?id=63#toc331)

简历一般是有自由发挥的空间的，所以这时候需要一些任意值，就是自己愿意写什么就写什么。这时候`interface`接口也是支持的。方法如下： 我们接着上节课的代码，新建一个`Demo9.ts`，然后把上节课代码拷贝过来。

```js
interface Girl {
  name: string;
  age: number;
  bust: number;
  waistline?: number;
  [propname: string]: any;
}
```

这个的意思是，属性的名字是字符串类型，属性的值可以是任何类型。

这时候我们在对象里给一个性别,代码如下：

```js
const girl = {
  name: "大脚",
  age: 18,
  bust: 94,
  waistline: 21,
  sex: "女",
};
```

再修改一下代码，这首就没有错误了。

```js
const getResume = (girl: Girl) => {
  console.log(girl.name + "年龄是：" + girl.age);
  console.log(girl.name + "胸围是：" + girl.bust);
  girl.waistline && console.log(girl.name + "腰围是：" + girl.waistline);
  girl.sex && console.log(girl.name + "性别是：" + girl.sex);
};
```

这时候我们的程序是不报错的，但是如果我们去掉刚才的设置，就会报错。

```js
[propname:string]:any;  //去掉
```

[接口里的方法](https://jspang.com/detailed?id=63#toc332)

接口里不仅可以存属性，还可以存方法，比如这时候有个`say()`方法，返回值是`string`类型。这时候你就不要再想成简历了，你需要更面向对象化的编程，想象成一个人。

```js
interface Girl {
  name: string;
  age: number;
  bust: number;
  waistline?: number;
  [propname: string]: any;
  say(): string;
}
```

加上这个`say()`方法后，程序马上就会报错，因为我们对象里没有 say 方法。那我们就要给对象一个 say 方法

```js
const girl = {
  name: "大脚",
  age: 18,
  bust: 94,
  waistline: 21,
  sex: "女",
  say() {
    return "欢迎光临 ，红浪漫洗浴！！";
  },
};
```

[接口和类的约束](https://jspang.com/detailed?id=63#toc333)

我们都知道 JavaScript 从`ES6`里是有类这个概念的，类可以和接口很好的结合，我们先来看一个例子。下面的

```js
class XiaoJieJie implements Girl {}
```

这时候类会直接报错，所以我们需要把这个类写的完全点。

```js
class XiaoJieJie implements Girl {
  name = "刘英";
  age = 18;
  bust = 90;
  say() {
    return "欢迎光临 ，红浪漫洗浴！！";
  }
}
```

[接口间的继承](https://jspang.com/detailed?id=63#toc334)

接口也可以用于继承的，比如你新写一个`Teacher`接口，继承于`Person`接口。

```js
interface Teacher extends Girl {
  teach(): string;
}
```

比如这时候老板说了，只看 Teacher 级别的简历，那我们需要修改`getResume()`方法。

```js
const getResume = (girl: Teacher) => {
  console.log(girl.name + "年龄是：" + girl.age);
  console.log(girl.name + "胸围是：" + girl.bust);
  girl.waistline && console.log(girl.name + "腰围是：" + girl.waistline);
  girl.sex && console.log(girl.name + "性别是：" + girl.sex);
};
```

修改后，你就会发现下面我们调用`getResume()`方法的地方报错了,因为这时候传的值必须有`Teach`方法，

```js
getResume(girl);
```

修改`girle`对象，增加`teach（）`方法，这时候就不会报错了。

```js
const girl = {
  name: "大脚",
  age: 18,
  bust: 94,
  waistline: 21,
  sex: "女",
  say() {
    return "欢迎光临 ，红浪漫洗浴！！";
  },
  teach() {
    return "我是一个老师";
  },
};
```

关于接口的知识就讲到这里吧，这基本包含了接口 80%的知识，还有些基本不用的语法，我就不讲了。如果课程中遇到，我们再讲。学会了接口，你还需要明白一件事，就是接口只是对我们开发的约束，在生产环境中并没有体现。也可以说接口只是在 TypeScript 里帮我们作语法校验的工具，编译成正式的`js`代码，就不会有任何用处了。

[10.TypeScript 中类的概念和使用](https://jspang.com/detailed?id=63#toc235)

前几天腰疾又犯，寝食难安，有所耽误，现稍有好转，继续录课。TypeScript 中类的概念和 ES6 中原生类的概念大部分相同，但是也额外增加了一些新的特性。我在这里会完全从一个新手的角度，讲解类的各项知识点。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=230039992&amp;page=10" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[类的基本使用](https://jspang.com/detailed?id=63#toc336)

新建一个文件，叫做`demo10.ts`,然后定义一个最简单的`Lady`类,这里要使用关键字`class`,类里边有姓名属性和一个得到姓名的方法，代码如下：

```js
class Lady {
  content = "Hi，帅哥";
  sayHello() {
    return this.content;
  }
}

const goddess = new Lady();
console.log(goddess.sayHello());
```

写完代码后，可以使用`ts-node demo10.ts`来查看一下结果。

这是一个最简单的类了，如果你有些编程经验，对这个一定很熟悉，工作中几乎每天都会用到。

[类的继承](https://jspang.com/detailed?id=63#toc337)

这里提前说一下 TypeScrip 的继承和`ES6`中的继承是一样的。关键字也是`extends`,比如我们这里新建一个`XiaoJieJie`的类，然后继承自`Lady`类，在`XiaoJieJie`类里写一个新的方法，叫做`sayLove`,具体代码如下。

```js
class Lady {
  content = "Hi，帅哥";
  sayHello() {
    return this.content;
  }
}
class XiaoJieJie extends Lady {
  sayLove() {
    return "I love you";
  }
}

const goddess = new XiaoJieJie();
console.log(goddess.sayHello());
console.log(goddess.sayLove());
```

类写好以后，我们声明的对象是`XiaoJieJie`这个类，我们同时执行`sayHello()`和`sayLove()`都是可以执行到的，这说明继承起作用了。

[类的重写](https://jspang.com/detailed?id=63#toc338)

讲了继承，那就必须继续讲讲`重写`，重写就是子类可以重新编写父类里边的代码。现在我们在`XiaoJieJie`这个类里重写父类的`sayHello()`方法，比如现在我们觉的叫的不够亲切，我们改成下面这个样子。

```js
class XiaoJieJie extends Lady {
  sayLove() {
    return "I love you!";
  }
  sayHello() {
    return "Hi , honey!";
  }
}
```

然后我们再次运行`ts-node demo10.ts`来查看结果。

[super 关键字的使用](https://jspang.com/detailed?id=63#toc339)

我们再多讲一点，就是`super`关键字的使用，比如我们还是想使用`Lady`类中说的话，但是在后面，加上`你好`两个字就可以了。这时候就可以使用`super`关键字，它代表父类中的方法。那我们的代码就可以写成这个样子了。

```js
class XiaoJieJie extends Lady {
  sayLove() {
    return "I love you!";
  }
  sayHello() {
    return super.sayHello() + "。你好！";
  }
}
```

通过这节课我们至少要知道`TypoeScript`中的类是如何定义和继承的。类中还有很多知识点要讲，这节课先到这里，下节课继续。

[11.TypeScript 中类的访问类型](https://jspang.com/detailed?id=63#toc240)

上节已经简单学习了`TypeScript`中类的使用，这节我们继续学习一下类中的访问类型。其实类的访问类型就是基于三个关键词`private`、`protected`和`public`,也是三种访问类型，这节课的主要内容也是讲一下这三个访问类型如何使用，都代表什么意思。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=230046204&amp;page=11" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[先写一个简单的类](https://jspang.com/detailed?id=63#toc341)

我们新建一个`Demo11.ts`文件，然后注释掉以前写的代码，防止由于重名而产生冲突。在新的文件里，我们定义一个 Person 类，然后使用这个类的对象，进行赋值，最后打印在控制台上。具体代码如下：

```js
class Person {
  name: string;
}

const person = new Person();
person.name = "jspang.com";

console.log(person.name);
```

写完后我们直接可以在`Terminal`(中),输入`ts-node demo11.ts`进行查看结果，结果会打印出`jspang.com`。

[public 访问属性讲解](https://jspang.com/detailed?id=63#toc342)

这时候可以打出`jspang.com`是因为我们如果不在类里对`name`的访问属性进行定义，那么它就会默认是`public`访问属性。

这就相当于下面的这段代码：

```js
class Person {
    public name:string;
}
```

> `public`从英文字面的解释就是`公共的`或者说是`公众的`，在程序里的意思就是允许在类的内部和外部被调用.

比如我们在类内调用，我们在写一个`sayHello`的方法，代码如下：

```js
class Person {
    public name:string;
    public sayHello(){
        console.log(this.name + ' say Hello')
    }
}
```

这是的`this.name`就是类的内部调用。我们在下面在执行一下这个方法`person.sayHello()`,终端中可以看到一切正常运行了，顺利打印出了`jspang.com say Hello`这句话。

在类的外部调用，我们就可以很简单的看出来了，比如下面的代码，从注释横线下，全部是类的外部。

```js
class Person {
    public name:string;
    public sayHello(){
        console.log(this.name + 'say Hello')
    }
}
//-------以下属于类的外部--------
const person = new Person()
person.name = 'jspang.com'
person.sayHello()
console.log(person.name)
```

结果我就不演示了，一定是可以被调用的，接下来我们再来看`private`属性。

[private 访问属性讲解](https://jspang.com/detailed?id=63#toc343)

> private 访问属性的意思是，只允许再类的内部被调用，外部不允许调用

比如现在我们把 name 属性改成`private`,这时候在类的内部使用不会提示错误，而外部使用`VSCode`直接会报错。

```js
class Person {
    private name:string;
    public sayHello(){
        console.log(this.name + 'say Hello')  //此处不报错
    }
}
//-------以下属于类的外部--------
const person = new Person()
person.name = 'jspang.com'    //此处报错
person.sayHello()
console.log(person.name)  //此处报错
```

[protected 访问属性讲解](https://jspang.com/detailed?id=63#toc344)

> protected 允许在类内及继承的子类中使用

做一个例子，把`name`的访问属性换成`protected`,这时候外部调用`name`的代码会报错，内部的不会报错，和`private`一样。这时候我们再写一个`Teacher`类，继承于`Person`,代码如下：

```js
class Person {
    protected name:string;
    public sayHello(){
        console.log(this.name + 'say Hello')  //此处不报错
    }
}

class Teacher extends Person{
    public sayBye(){
        this.name;
    }
}
```

这时候在子类中使用`this.name`是不报错的。

通过这个小例子相信你一定指导什么是类的内部和类的外部，也知道了三个访问类型的区别了。其实我最开始学 java 的时候，这个概念还真的比较难懂，但是你先掌握了类内和类外的概念后，这三个访问类型就非常好理解了。

[12.TypeScript 类的构造函数](https://jspang.com/detailed?id=63#toc245)

这节课继续学习类的知识，如果你学过`Java`的话，对构造函数一定不陌生，构造函数就是在类被初始化的时候，自动执行的一个方法。我们通过这个构造方法经常作很多需要提前完成的工作，比如显示页面前我们要从后台得到数据。直接看例子。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=230616330&amp;page=12" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[类的构造函数](https://jspang.com/detailed?id=63#toc346)

新建立一个页面`Demo12.ts`,然后在页面里新建一个 Person 类，类的里边定义一个`name`，但是`name`我们并不给他值,然后我们希望在`new`出对象的时候，直接通过传递参数的形式，给`name`赋值，并打印出来。这时候我们就需要用到构造函数了，构造函数的关键字是`constructor`。

```js
class Person{
    public name :string ;
    constructor(name:string){
        this.name=name
    }

}

const person= new Person('jspang')
console.log(person.name)
```

写完后使用`ts-node demo12.ts`进行查看，应该可以打出`jspang`的字样。这是最常规和好理解的写法，那有没有更简单的写法那?当然有。

```js
class Person{
    constructor(public name:string){
    }
}

const person= new Person('jspang')
console.log(person.name)
```

这种写法就相当于你定义了一个`name`,然后在构造函数里进行了赋值，这是一种简化的语法，在工作中我们使用这种语法的时候会更多一些。

[类继承中的构造器写法](https://jspang.com/detailed?id=63#toc347)

普通类的构造器我们已经会了，在子类中使用构造函数需要用`super()`调用父类的构造函数。这时候你可能不太理解我说的话，我们还是通过代码来说明(详细说明在视频中讲述)。

```js
class Person{
    constructor(public name:string){}
}

class Teacher extends Person{
    constructor(public age:number){
        super('jspang')
    }
}

const teacher = new Teacher(18)
console.log(teacher.age)
console.log(teacher.name)
```

这就是子类继承父类并有构造函数的原则，就是在子类里写构造函数时，必须用`super()`调用父类的构造函数，如果需要传值，也必须进行传值操作。就是是父类没有构造函数，子类也要使用`super()`进行调用，否则就会报错。

```js
class Person{}

class Teacher extends Person{
    constructor(public age:number){
        super()
    }
}

const teacher = new Teacher(18)
console.log(teacher.age)
```

好了，这就是这节课我们所学的内容了，主要讲的就是类中的构造函数（也有叫构造器的），构造函数在工作中用的很多，所以你要学会并作充分的练习。

[13.TypeScript 类的 Getter、Setter 和 static 使用](https://jspang.com/detailed?id=63#toc248)

有小伙伴留言，学了类的访问类型`private`，那这个东西如何使用？其实他的最大用处是封装一个属性，然后通过 Getter 和 Setter 的形式来访问和修改这个属性。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=231286272&amp;page=13" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[类的 Getter 和 Setter](https://jspang.com/detailed?id=63#toc349)

我们新建一个文件`Demo13.ts`，然后声明一个`XiaoJieJie`（小姐姐）类，都知道小姐姐的年龄是不能随便告诉人，所以使用了`private`,这样别人就都不知道她的真实年龄，而只有她自己知道。

代码如下：

```js
class Xiaojiejie {
  constructor(private _age:number){}
}
```

如果别人想知道，就必须通过`getter`属性知道,注意我这里用的是属性，对他就是一个属性。`getter`属性的关键字是`get`,后边跟着类似方法的东西,但是你要注意，它并不是方法，归根到底还是属性。

```js
class Xiaojiejie {
  constructor(private _age:number){}
  get age(){
      return this._age
  }
}

const dajiao = new Xiaojiejie(28)

console.log(dajiao.getAge)
```

这时候你会觉的这么写不是多此一举吗?玄妙就在于`getter`里，我们可以对`_age`进行处理，比如别人问的时候我们就偷摸的减少 10 岁。代码可以写成这样。

```js
class Xiaojiejie {
  constructor(private _age:number){}
  get age(){
      return this._age-10
  }
}
```

这时候大脚的年龄就编程了迷人的 18 岁，是不是通过这个小例子，一下子就明白了`private`和`getter`的用处。 `_age`是私有的，那类的外部就没办法改变，所以这时候可以用`setter`属性进行改变，代码如下：

```js
class Xiaojiejie {
  constructor(private _age:number){}
  get age(){
      return this._age-10
  }
  set age(age:number){
    this._age=age
  }
}

const dajiao = new Xiaojiejie(28)
dajiao.age=25
console.log(dajiao.age)
```

其实`setter`也是可以保护私有变量的，现在大脚的年龄输出是 15 岁，这肯定不行，不符合法律哦，这样是我们在`setter`里给他加上个 3 岁，就可以了。

```js
 set age(age:number){
    this._age=age+3
  }
```

这是想通过这个例子让小伙伴们清楚的明白`getter`和`setter`的使用，很多小伙伴刚学这部分，都不太清楚为什么要使用`getter`和`setter`，你也能更清楚`private`访问类型的意义。

[类中的 static](https://jspang.com/detailed?id=63#toc350)

学习类，都知道要想使用这个类的实例，就要先`New`出来（），但有时候人们就是喜欢走捷径，在们有对象的情况下，也想享受青春的躁动，有没有方法？肯定是有方法的。

比如我们先写一下最常规的写法：

```js
class Girl {
  sayLove() {
    return "I Love you";
  }
}

const girl = new Girl();
console.log(girl.sayLove());
```

但是现在你不想`new`出对象，而直接使用这个方法，那`TypeScript`为你提供了快捷的方式，用`static`声明的属性和方法，不需要进行声明对象，就可以直接使用，代码如下。

```js
class Girl {
  static sayLove() {
    return "I Love you";
  }
}
console.log(Girl.sayLove());
```

这节课我们就学到了这里，复习一下，我们学了`private`的使用意义，学了`getter`和`setter`属性，还学习了静态修饰符`static`，这样就不用 new 出对象就可以使用类里的方法了。

[14. 类的只读属性和抽象类](https://jspang.com/detailed?id=63#toc251)

这节主要讲一下类里的一个概念就是抽象类，抽象类很父类很像，都需要继承，但是抽象类里一般都有抽象方法。继承抽象类的类必须实现抽象方法才可以。在讲抽象类之前，我想把上节课我遗忘的一个知识点给大家不上，那就是类里的只读属性`readonly`.

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=231577369&amp;page=14" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[类里的只读属性 readonly](https://jspang.com/detailed?id=63#toc352)

新建一个文件`Demo14.ts`,然后写下面一个类，并进行实例化和赋值操作，代码如下：

```js
class Person {
    constructor(public name:string ){ }
}

const person = new Person('jspang')
console.log(person.name)
```

写完后我们可以在终端(Terminal)中看一下结果,结果就应该是`jspang`。

比如我现在有一个需求，就是在实例化对象时赋予的名字，以后不能再更改了，也就是我们常说的只读属性。我们先来看现在这种情况是可以随意更改的，比如我写下面的代码。

```js
class Person {
    constructor(public name:string ){ }
}

const person = new Person('jspang')
person.name= '谢广坤'
console.log(person.name)
```

这时候就可以用一个关键词`readonly`,也就是只读的意思，来修改`Person`类代码。

```js
class Person {
    public readonly _name :string;
    constructor(name:string ){
        this._name = name;
    }
}

const person = new Person('jspang')
person._name= '谢广坤'
console.log(person._name)
```

这样写完后，`VSCode`就回直接给我们报错，告诉我们`_name`属性是只读属性，不能修改。这是上节课遗忘的一个知识点，我在这里给你补上了。

[抽象类的使用](https://jspang.com/detailed?id=63#toc353)

什么是抽象类那？我给大家举个例子，比如我开了一个红浪漫洗浴中心，里边有服务员，有初级技师，高级技师，每一个岗位我都写成一个类，那代码就是这样的。（注释掉刚才写的代码）

```js
class Waiter {}

class BaseTeacher {}

class seniorTeacher {}
```

我作为老板，我要求无论是什么职位，都要有独特的技能，比如服务员就是给顾客倒水，初级技师要求会泰式按摩，高级技师要求会 SPA 全身按摩。这是一个硬性要求，但是每个职位的技能有不同，这时候就可以用抽象类来解决问题。

抽象类的关键词是`abstract`,里边的抽象方法也是`abstract`开头的，现在我们就写一个`Girl`的抽象类。

```js
abstract class Girl{
    abstract skill()  //因为没有具体的方法，所以我们这里不写括号

}
```

有了这个抽象类，三个类就可以继承这个类，然后会要求必须实现`skill()`方法，代码如下：

```js
abstract class Girl{
    abstract skill()  //因为没有具体的方法，所以我们这里不写括号

}

class Waiter extends Girl{
    skill(){
        console.log('大爷，请喝水！')
    }
}

class BaseTeacher extends Girl{
    skill(){
        console.log('大爷，来个泰式按摩吧！')
    }
}

class seniorTeacher extends Girl{
    skill(){
        console.log('大爷，来个SPA全身按摩吧！')
    }
}
```

我希望通过这个例子，你能对抽象类和抽象方法有一个比较深的认识。其实在工作中我们也会把这样的需求用接口来实现。

[15. 配置文件-初识 tsconfig.json](https://jspang.com/detailed?id=63#toc254)

有人在 QQ 群里留言问我`tsconfig.json`是作什么的，我才意识到，我是应该详细的讲一下这个文件了，这个是 TypeScript 的文件，虽然不常用，但是很重要。有必要拿出几节课详细的讲一下这个文件。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=234054736&amp;page=15" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[生成 tsconfig.json 文件](https://jspang.com/detailed?id=63#toc355)

这个文件是通过`tsc --init`命令生成的，在桌面上新建一个文件夹`TsDemo`,然后打开`VSCode`，把文件托到编辑器中，然后打开终端`Terminal`,输入`tsc --init`。

输入完成后，就会出现`tsconfig.json`文件，你可以打开简单的看一下，不过此时你可能看不懂。

其实它就是用来配置如何对`ts`文件进行编译的，我们都叫它 typescript 的编译配置文件。

> 如果此时你的`tsc`执行不了，很有可能是你没有全局安装 TypeScript,可以全局安装一下。

[让 tsconfig.json 文件生效](https://jspang.com/detailed?id=63#toc356)

你现在可以在文件夹跟目录建立一个`demo.ts`文件，然后编写一些最简单的代码，代码如下:

```js
const person: string = "jspang";
```

这时候我们不在使用`ts-node`直接执行了，需要用`tsc demo.ts`进行编译，编译后会得到`demo.js`文件。 生成的代码如下:

```js
var person = "jspang";
```

这时候好像一切都是正常的，但是我要告诉你的真相是`tsconfig.json`这个编译配置文件并没有生效。

此时我们打开`tsconfig.json`文件，找到`complilerOptions`属性下的`removeComments:true`选项，把注释去掉。

这个配置项的意思是，编译时不显示注释，也就是编译出来的`js`文件不显示注释内容。

现在你在文件中加入一些注释，比如：

```js
// I love jspang
const person: string = "jspang";
```

这时候再运行编译代码`tsc demo.ts`，编译后打开`demo.js`文件，你会发现注释依然存在，说明`tsconfig.json`文件没有起作用。

如果要想编译配置文件起作用，我们可以直接运行`tsc`命令，这时候`tsconfig.json`才起作用，可以看到生成的`js`文件已经不带注释了。

[include 、exclude 和 files](https://jspang.com/detailed?id=63#toc357)

那现在又出现问题了，如果我们的跟目录下有多个`ts`文件，我们却只想编译其中的一个文件时，如何作？

我们在项目根目录，新建一个文件`demo2.ts`文件，然后也写一段最简单的 ts 代码。

```js
const person2: string = "jspang.com";
```

如果这时候我们在终端里运行`tsc`,虽然`tsconfig.json`生效了，但是两个文件都被我们编译了。这不是你想要的结果，我们可以用三种办法解决这个问题。

1. 第一种：使用 include 配置

`include`属性是用来指定要编译的文件的，比如现在我们只编译`demo.ts`文件，而不编译`demo2.ts`文件，就可以这样写。

写配置文件时有个坑需要注意，就是配置文件不支持单引号，所以里边都要使用双引号。

```js
{
  "include":["demo.ts"],
  "compilerOptions": {
      //any something
      //........
  }
}
```

这时候再编译，就只编译`demo.ts`文件了。

1. 第二种：使用 exclude 配置

`include`是包含的意思，`exclude`是不包含，除什么文件之外，意思是写再这个属性之外的而文件才进行编译。比如你还是要编译`demo.ts`文件，这时候的写法就应该是这样了。

```js
{
   "exclude":["demo2.ts"],
  "compilerOptions": {
      //any something
      //........
  }
}
```

这样写依然只有`demo.ts`被编译成了`js`文件。

1. 第三种：使用 files 配置

`files`的配置效果和`include`几乎一样，我是没找出有什么不同，只要配置到里边的文件都可以编译，如果有小伙伴知道有什么不同的，欢迎在视频下方留言，然后一起学习。

```js
{
  "files":["demo.ts"],
  "compilerOptions": {
      //any something
      //........
  }
}
```

结果是依然只有`demo.ts`文件被编译。这节课我们就学到这里，目的只是让大家初步了解一下`tsconfig.js`文件和它的使用方法，文件里边还有很多配置项，这些我们都会逐步讲到。

[16. 配置文件-初识 compilerOptions 配置项](https://jspang.com/detailed?id=63#toc258)

这节我们主要学习一下`compilerOptions`配置项，它是告诉`TypeScript`具体如何编译成`js`文件的，里边的配置项非常多，这节我们先来讲几个简单的配置项，目的是让你熟悉`compilerOptions`的使用方法。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=234060903&amp;page=16" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[removeComments 属性](https://jspang.com/detailed?id=63#toc359)

`removeComments`是`complerOptions`里的一个子属性，它的用处是告诉`TypeScript`对编译出来的`js`文件是否显示注释（注解）。比如我们现在把`removeComments`的值设置为`true`，就是在`js`中不显示注释。

我们把上节课文件没有的`Demo2.ts`和生成的 JS 文件都删除掉，只留`Demo.ts`文件，然后再`Demo.ts`文件里，加入一个注释。

```js
// I‘m JSPang
const person: string = "jspang";
```

写完注释后，直接再终端`Terminal`里，输入`tsc`,输入完成后，很快就会生成一个`demo.js`文件，打开后会看到下面的代码。

```js
"use strict";
var person = "jspang";
```

你写的注释并没有编译到`demo.js`里。如果我们反之，把`removeComments`的值，设置为`false`,这时候`demo.js`里就会有注释内容了。

```js
"use strict";
// I‘m JSPang
var person = "jspang";
```

[strict 属性](https://jspang.com/detailed?id=63#toc360)

`strict`属性如果设置为`true`,就代表我们的编译和书写规范，要按照`TypeScript`最严格的规范来写，如果我们把这个设置为`false`或者注释掉，意思是我们可以对设置一些不严格的写法。

[noImplicitAny 属性](https://jspang.com/detailed?id=63#toc361)

`noImplicitAny`属性的作用是，允许你的注解类型 any 不用特意表明，只听概念很难理解。这就是看我视频的一个好处，如果你只看官方 API，你可能要迷糊一阵啥叫`允许你的注解类型any不用特意表明`,这就是每个汉字我都认识，连在一期就不知道啥意思的最好诠释。

为了更好的说明，我们举个例子,在`demo.ts`里，删除刚才的代码，然后写一个方法，方法的参数我们设置成任意类型(any)。

```js
function jspang(name) {
  return name;
}
```

这时候我们的`TypeScript`是进行报错的，我们用`tsc`编译也是报错的。这就是因为我们开启了`strict:true`,我们先注释掉，然后把`noImplicitAny`的值设置为`false`,就不再报错了。

如果设置为`noImplicitAny:true`,意思就是值就算是 any（任意值），你也要进行类型注释。

```js
function jspang(name: any) {
  return name;
}
```

你可以简单的理解为，设置为 true，就是必须明确置顶 any 类型的值。

[strictNullChecks 属性](https://jspang.com/detailed?id=63#toc362)

我们先把`strictNullChecks`设置为`false`,它的意思就是，**不强制检查 NULL 类型。**我们举个例子，让你能一下子就明白，还是删除`demo.ts`里的代码，然后编写代码.

```js
const jspang: string = null;
```

代码写完后，你会发现这段代码是不报错的，如果是以前，一定是报错的，这就是我们配置了“不强制检验 null 类型”。如果你设成`strictNullChecks:true`，这时候就报错了。

[ts-node 遵循 tsconfig.js 文件](https://jspang.com/detailed?id=63#toc363)

有的小伙伴问我了，`tsc fileName` 是没办法遵循`tsconfig.js`文件的，那`ts-node`是否遵循?

这里直接告诉你答案，`ts-node`是遵循的，感兴趣的可以自行试一下。

这节课我们就是简单的认识一下`compilerOptions`属性的配置，其实这些你只要掌握方法，并不需要记忆，我也是记不住每一项是干嘛的，用的时候会查 API 就可以了。下节课我们继续学习配置文件。

[17. 配置文件- compilerOptions 配置内容详解](https://jspang.com/detailed?id=63#toc264)

这节我们继续讲`complierOptions`里的配置项，里边的内容很多，我只能选几个重要的给大家讲讲，然后在这节最后，我会给出大家自己查询的方法。需要再次说明的是，这些配置项没必要记，因为他们真的不是每天都需要用到，所以你只要知道如何配置和重要的几项，学会在自己需要时如何查询就可以了。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=235021949&amp;page=17" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[rootDir 和 outDir](https://jspang.com/detailed?id=63#toc365)

现在你的`js`文件直接编译到了根目录下，和`ts`文件混在了一起。我们当然是不喜欢这种方法的，工作中我们希望打包的`js`都生成在特定的一个文件夹里,比如`build`。

这时候你就可以通过配置`outDir`来配置，当然你也可以通过`rootDir`来指定`ts`文件的位置，比如我们把所有的 ts 文件都放到 src 下。那配置文件就应该这样写。

```js
{
    "outDir": "./build" ,
    "rootDir": "./src" ,
}
```

这时候你再在`Terminal`中输入`tsc`,就会有不同的效果了。

[编译 ES6 语法到 ES5 语法-allowJs](https://jspang.com/detailed?id=63#toc366)

现在你在`src`目录下用`ES6`的语法写了一个`demo2.js`文件，代码如下。

```js
export const name = "jspang";
```

如果你不做任何配置，这时候试用`tsc`是没有效果的。你需要到`tsconfig.js`文件里进行修改，修改的地方有两个。

```js
"target":'es5' ,  // 这一项默认是开启的，你必须要保证它的开启，才能转换成功
"allowJs":true,   // 这个配置项的意思是联通
```

这两项都开启后，在使用`tsc`编译时，就会编译`js`文件了。

[sourceMap 属性](https://jspang.com/detailed?id=63#toc367)

如果把`sourceMap`的注释去掉，在打包的过程中就会给我们生成`sourceMap`文件.

> sourceMap 简单说，Source map 就是一个信息文件，里面储存着位置信息。也就是说，转换后的代码的每一个位置，所对应的转换前的位置。有了它，出错的时候，除错工具将直接显示原始代码，而不是转换后的代码。这无疑给开发者带来了很大方便。

这里我不对 Source map 文件详细讲解，如果你感兴趣，可以自行百度一下吧。

[noUnusedLocals 和 noUnusedParameters](https://jspang.com/detailed?id=63#toc368)

比如现在我们修改`demo.ts`文件的代码，改为下面的样子。

```js
const jspang: string = null;
export const name = "jspang";
```

这时候你会发现`jspang`这个变量没有任何地方使用，但是我们编译的话，它依然会被编译出来，这就是一种资源的浪费。

```js
//编译后的文件
"use strict";
exports.__esModule = true;
exports.name = void 0;
var jspang = null;
exports.name = "jspang";
```

这时候我们可以开启`noUnusedLocals：true`，开启后我们的程序会直接给我们提示不能这样编写代码，有没有使用的变量。

`noUnusedParameters`是针对于名优使用的函数的，方法和`noUnusedLocals：true`一样，小伙伴们自己尝试吧。

我们讲了几个最常用的方法，如果你需要全面的了解，可以查看这个网址：

> https://www.tslang.cn/docs/handbook/compiler-options.html (编译选项详解)

自己进行查看就可以了。

好了配置文件我们就暂时告一段落了，下节课我们讲一下 TypeScript 里的联合类型。

[18. 联合类型和类型保护](https://jspang.com/detailed?id=63#toc269)

这节视频将学习一下联合类型和相关的类型保护知识，需要注意的是，只有联合类型存在的情况下，才需要类型保护。普通的类型注解，并不需要我们这种特殊操作。那先来看一下什么是联合类型。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=237516474&amp;page=18" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[联合类型展示](https://jspang.com/detailed?id=63#toc370)

所谓联合类型，可以认为一个变量可能有两种或两种以上的类型。用代码举个例子，声明两个接口`Waiter`(服务员)接口和`Teacher`(技师)接口，然后在写一个`judgeWho`(判断是谁)的方法，里边传入一个`animal`(任意值)，这时候可以能是`Waiter`,也可能是`Teacher`。所以我们使用了联合类型，关键符号是`|`(竖线)。

```js
interface Waiter {
  anjiao: boolean;
  say: () => {};
}

interface Teacher {
  anjiao: boolean;
  skill: () => {};
}

function judgeWho(animal: Waiter | Teacher) {}
```

通过这个简单的例子，你应该知道什么是联合类型了。

```js
function judgeWho(animal: Waiter | Teacher) {
  animal.say();
}
```

但这时候问题来了，如果我直接写一个这样的方法，就会报错，因为`judgeWho`不能准确的判断联合类型具体的实例是什么。

这时候就需要再引出一个概念叫做`类型保护`，类型保护有很多种方法，这节讲几个最常使用的。

[类型保护-类型断言](https://jspang.com/detailed?id=63#toc371)

类型断言就是通过断言的方式确定传递过来的准确值，比如上面的程序，如果会`anjiao`（按脚），说明他就是技师，这时候就可以通过断言`animal as Teacher`,然后直接调用`skill`方法,程序就不再报错了。同样如果不会按脚，说明就是不同的服务员，这时候调用`say()`方法，就不会报错了。这就是通过断言的方式进行类型保护。也是最常见的一种类型保护形式。具体看代码:

```js
interface Waiter {
  anjiao: boolean;
  say: () => {};
}

interface Teacher {
  anjiao: boolean;
  skill: () => {};
}

function judgeWho(animal: Waiter | Teacher) {
  if (animal.anjiao) {
    (animal as Teacher).skill();
  }else{
    (animal as Waiter).say();
  }
}
```

[类型保护-in 语法](https://jspang.com/detailed?id=63#toc372)

我们还经常使用`in`语法来作类型保护，比如用`if`来判断`animal`里有没有`skill()`方法。

这里你可以赋值上面的`judgeWho()`方法，然后改一下名字，我这里改成了`judgeWhoTwo()`方法，具体程序如下:

```js
function judgeWhoTwo(animal: Waiter | Teacher) {
  if ("skill" in animal) {
    animal.skill();
  } else {
    animal.say();
  }
}
```

这里的`else`部分能够自动判断，得益于`TypeScript`的自动判断。

[类型保护-typeof 语法](https://jspang.com/detailed?id=63#toc373)

先来写一个新的`add`方法，方法接收两个参数，这两个参数可以是数字`number`也可以是字符串`string`,如果我们不做任何的类型保护，只是相加，这时候就会报错。代码如下:

```js
function add(first: string | number, second: string | number) {
  return first + second;
}
```

解决这个问题，就可以直接使用`typeof`来进行解决。

```js
function add(first: string | number, second: string | number) {
  if (typeof first === "string" || typeof second === "string") {
    return `${first}${second}`;
  }
  return first + second;
}
```

像上面这样写，就不报错了。这样就可以进行继续开心的编写程序了。

[类型保护-instanceof 语法](https://jspang.com/detailed?id=63#toc374)

比如现在要作类型保护的是一个对象，这时候就可以使用`instanceof`语法来作。现在先写一个`NumberObj`的类，代码如下：

```js
class NumberObj {
  count: number;
}
```

然后我们再写一个`addObj`的方法，这时候传递过来的参数，可以是任意的`object`,也可以是`NumberObj`的实例，然后我们返回相加值，当然不进行类型保护，这段代码一定是错误的。

```js
function addObj(first: object | NumberObj, second: object | NumberObj) {
  return first.count + second.count;
}
```

报错不要紧，直接使用`instanceof`语法进行判断一下，就可以解决问题。

```js
function addObj(first: object | NumberObj, second: object | NumberObj) {
  if (first instanceof NumberObj && second instanceof NumberObj) {
    return first.count + second.count;
  }
  return 0;
}
```

另外要说的是，instanceof 只能用在类上。这节课我介绍四种类型保护的方式，每种方式都在不同场景中使用(还有一些不太常用的类型保护方式，我就不讲了)，你需要自己深刻理解，多练习，在开发时才能灵活使用。

[19. Enum 枚举类型讲解](https://jspang.com/detailed?id=63#toc275)

这节主要学一下 TypeScript 中枚举(`enum`)类型的使用，你如果在程序中能灵活的使用枚举(`enum`),会让程序有更好的可读性。这里我拿每次去“大宝剑”点餐作个比喻。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=237522189&amp;page=19" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[一场大宝剑引出的思考](https://jspang.com/detailed?id=63#toc376)

比如我现在去"大宝剑"时，通过掷色子随机选择一项服务，进行程序化模拟。这里我先用 JavaScript 的写法来编写。

初级程序员写法:

```js
function getServe(status: number) {
  if (status === 0) {
    return "massage";
  } else if (status === 1) {
    return "SPA";
  } else if (status === 2) {
    return "dabaojian";
  }
}
const result = getServe(0);
console.log(`我要去${result}`);
```

中级程序员写法:

```js
const Status = {
  MASSAGE: 0,
  SPA: 1,
  DABAOJIAN: 2,
};

function getServe(status: any) {
  if (status === Status.MASSAGE) {
    return "massage";
  } else if (status === Status.SPA) {
    return "spa";
  } else if (status === Status.DABAOJIAN) {
    return "dabaojian";
  }
}

const result = getServe(Status.SPA);

console.log(`我要去${result}`);
```

高级程序员写法:

```js
enum Status {
  MASSAGE,
  SPA,
  DABAOJIAN,
}

function getServe(status: any) {
  if (status === Status.MASSAGE) {
    return "massage";
  } else if (status === Status.SPA) {
    return "spa";
  } else if (status === Status.DABAOJIAN) {
    return "dabaojian";
  }
}

const result = getServe(Status.SPA);

console.log(`我要去${result}`);
```

这时候我们就引出了今天的主角`枚举Enum`。

[枚举类型的对应值](https://jspang.com/detailed?id=63#toc377)

你调用时传一个`1`,也会输出`我要去spa`。

```js
const result = getServe(1);
```

这看起来很神奇，这是因为枚举类型是有对应的数字值的，默认是从 0 开始的。我们直接用`console.log()`就可以看出来了。

```js
console.log(Status.MASSAGE);
console.log(Status.SPA);
console.log(Status.DABAOJIAN);
```

可以看出结果就是`0,1,2`。那这时候不想默认从 0 开始，而是想从 1 开始。可以这样写。

```js
enum Status {
  MASSAGE = 1,
  SPA,
  DABAOJIAN,
}
```

[枚举通过下标反查](https://jspang.com/detailed?id=63#toc378)

我们这里能打印出枚举的值(也有叫下标的)，那如果我们知道下标后，也可以通过反差的方法，得到枚举的值。

```js
console.log(Status.MASSAGE, Status[1]);
```

这样就进行了反查。

[20. TypeScript 函数泛型-难点](https://jspang.com/detailed?id=63#toc279)

泛型我个人认为是 TypeScript 利的一个难点，我第一次学完后根本不能完全理解，所以从这节课开始，我们应该算是一个进阶教程了，难度也开始上来了，如果你一遍听不太明白，可以反复听几次，然后多做练习。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=238288811&amp;page=20" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[编写一个联合类型 Demo](https://jspang.com/detailed?id=63#toc380)

现在跟着我作一个简单的`join`方法，方法接受两个参数`first`和`second`,参数有可能是字符串类型，也有可能是数字类型。方法里为了保证都可以使用，所以我们只作了字符串的基本拼接。

```js
function join(first: string | number, second: string | number) {
  return `${first}${second}`;
}
join("jspang", ".com");
```

这个方法现在没有任何问题，但现在有这样一个需求，就是`first`参数如果传的是字符串类型，要求`second`也传字符串类型.同理，如果是`number`类型，就都是`number`类型。

那现在所学的知识就完成不了啦，所以需要学习`泛型`来解决这个问题。

[初始泛型概念-generic](https://jspang.com/detailed?id=63#toc381)

> 泛型：[generic - 通用、泛指的意思],那最简单的理解，泛型就是泛指的类型。

泛型的定义使用`<>`（尖角号）进行定义的，比如现在给`join`方法一个泛型，名字就叫做`JSPang`(起这个名字的意思，就是你可以随便起一个名字，但工作中要进行语义化。),后边的参数，这时候他也使用刚定义的泛型名称。然后在正式调用这个方法时，就需要具体指明泛型的类型啦。

```js
function join<JSPang>(first: JSPang, second: JSPang) {
  return `${first}${second}`;
}
join < string > ("jspang", ".com");
```

如果要是`number`类型，就直接在调用方法的时候进行更改就可以了。

```js
join < number > (1, 2);
```

这就是最简单的泛型理解，因为在实际开发中，有很多对象和类的情况，里边的具体类型我们没办法了解，所以提供了这种泛型的概念。

[泛型中数组的使用](https://jspang.com/detailed?id=63#toc382)

如果传递过来的值要求是数字，如何用泛型进行定义那?两种方法，第一种是直接使用`[]`，第二种是使用`Array<泛型>`。形式不一样，其他的都一样。

第一种写法:

```js
function myFun<ANY>(params: ANY[]) {
  return params;
}
myFun < string > ["123", "456"];
```

第二种写法:

```js
function myFun<ANY>(params: Array<ANY>) {
  return params;
}
myFun < string > ["123", "456"];
```

在工作中，我们经常使用`<T>`来作泛型的表示，当然这不是硬性的规定，只是大部分程序员的习惯性写法。

[多个泛型的定义](https://jspang.com/detailed?id=63#toc383)

一个函数只能定义一个泛型吗?当然不是，是可以定义多个的，这里还是拿`join`方法举例，定义多个泛型，比如第一个泛型用`T`,第二个用`P`代表。

```js
function join<T, P>(first: T, second: P) {
  return `${first}${second}`;
}
join < number, string > (1, "2");
```

会了两种，你也就会了三种以上，泛型在造轮子的时候经常使用，因为造轮子很多东西都需要灵活性。泛型给了我们很好的灵活性。需要注意的是，如果函数定义了多个泛型，使用时要对应的定义出具体的类型。

[泛型的类型推断](https://jspang.com/detailed?id=63#toc384)

泛型也是支持类型推断的，比如下面的代码并没有报错，这就是`类型推断`的功劳。

```js
function join<T, P>(first: T, second: P) {
  return `${first}${second}`;
}
join(1, "2");
```

但个人不建议大量使用类型推断，这会让你的代码易读和健壮性都会下降，所以这个知识点，大家做一个了解就可以了。

好了，这就是这节课的内容了，希望小伙伴们一定要练习一下，加深理解。

[21. TypeScript 类中泛型-难点](https://jspang.com/detailed?id=63#toc285)

上节课学习了在函数(方法)中使用泛型的基本语法，这节课在看看类中泛型的使用方法。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=238288825&amp;page=21" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[编写一个基本类](https://jspang.com/detailed?id=63#toc386)

为了下面的教学演示，所以我先编写一个基本的类`SelectGirl`,在类的构造函数中(constructor)需要传递一组女孩的名称，然后再通过下边展现女孩的名称，代码如下：

```js
class SelectGirl {
  constructor(private girls: string[]) {}
  getGirl(index: number): string {
    return this.girls[index];
  }
}

const selectGirl = new SelectGirl(["大脚", "刘英", "晓红"]);
console.log(selectGirl.getGirl(1));
```

写完后，我们可以在终端中使用`ts-node Demo.ts`进行预览，可以看到控制台中输出了`刘英`的名字。学到现在你写这样的一个类应该是非常容易的了。

现在问题来了，比如现在更好的保护小姐姐，这些小姐姐使用编号啦，那我们程序要如何修改。需要写成下面的样子，这时候我们代码看起来就没有那么优雅了,在 TypeScript 中，编写复杂代码的时候，会经常使用泛型。

```js
class SelectGirl {
  constructor(private girls: string[] | number[]) {}
  getGirl(index: number): string | number {
    return this.girls[index];
  }
}
```

[初始类的泛型](https://jspang.com/detailed?id=63#toc387)

这时候我们要用泛型重构代码，要如何作那？有了上节课的基础，应该很好理解，就是用`<>`编写，我们把代码修改成了这个样子。

```js
class SelectGirl<T> {
  constructor(private girls: T[]) {}
  getGirl(index: number): T {
    return this.girls[index];
  }
}

const selectGirl = new SelectGirl(["大脚", "刘英", "晓红"]);
console.log(selectGirl.getGirl(1));
```

这时候代码并不报错，也使用了泛型，但是在实例化对象的时候，TypeScript 是通过类型推断出来的。上节课已经介绍，这种方法并不好，所以还是需要在实例化对象的时候，对泛型的值进行确定，比如是`string`类型，就这样写。

```js
const selectGirl = new SelectGirl() < string > ["大脚", "刘英", "晓红"];
```

这就是类里边最基础的泛型使用了，如果你还不理解，请现在敲出上面的例子进行练习，不要继续学习了。

[泛型中的继承](https://jspang.com/detailed?id=63#toc388)

现在需求又变了，要求返回是一个对象中的`name`,也就是下面的代码要改成这个样子。

```js
return this.girls[index].name;
```

现在的代码一定时报错的，但是这时候还要求我们这么做，意思就是说传递过来的值必须是一个对象类型的，里边还要有`name`属性。这时候就要用到继承了，我用接口的方式来实现。写一个`Girl`的接口，每个接口里都要有 name 属性。代码如下：

```js
interface Girl {
  name: string;
}
```

有了接口后用`extends`关键字实现泛型继承，代码如下：

```js
class SelectGirl<T extends Girl> {
 ...
}
```

这句代码的意思是泛型里必须有一个`name`属性，因为它继承了`Girl`接口。

现在程序还是报错的，因为我们`getGirl`方法的返回类型还不对，这时候应该是一个`string`类型才对，所以代码应该改为下面的样子：

```js
interface Girl {
  name: string;
}

class SelectGirl<T extends Girl> {
  constructor(private girls: T[]) {}
  getGirl(index: number): string {
    return this.girls[index].name;
  }
}

const selectGirl = new SelectGirl([
  { name: "大脚" },
  { name: "刘英" },
  { name: "晓红" },
]);
console.log(selectGirl.getGirl(1));
```

我们回过头来看一下这段代码的意思，就是我们在`SelectGirl`类中使用了泛型，意思是我不知道我以后要用什么类型，但是我有一个约束条件，这个类型，必须要有一个`name`属性。这个在工作中经常使用，所以必须要好好理解这的知识。 初学泛型肯定会很难理解，我当时看书也是看的一脸懵，经过反复的实验和看别人的源代码，才对泛型有了比较深的理解。

[泛型约束](https://jspang.com/detailed?id=63#toc389)

现在的泛型可以是任意类型，可以是对象、字符串、布尔、数字都是可以的。但你现在要求这个泛型必须是`string`或者`number`类型。我们还是拿上面的例子，不过把代码改为最初的样子。

```js
class SelectGirl<T> {
  constructor(private girls: T[]) {}
  getGirl(index: number): T {
    return this.girls[index];
  }
}

const selectGirl = new SelectGirl<string>(["大脚", "刘英", "晓红"]);
console.log(selectGirl.getGirl(1));
```

然后进行约束，这时候还是可以使用关键字`extends`来进行约束，把代码改成下面的样子。

```js
class SelectGirl<T extends number | string> {
  //.....
}
```

作为教学泛型讲这些就可以了，但是在实际工作中，泛型的应用更广泛和复杂，这些需要在实际项目中不断精进和加深理解，有句话说的非常好，师傅领进门，修行在个人了。

[22. 初识命名空间-Namespace](https://jspang.com/detailed?id=63#toc290)

以前的课程都是通过`Node`来运行代码的，这节课为了有更好的演示效果，我们要在浏览器中运行代码。这就要求我们重新创建一个项目，直接在桌面上建立一个文件夹`TSWeb`。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=238399608&amp;page=22" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[搭建浏览器开发环境步骤](https://jspang.com/detailed?id=63#toc391)

已经有好几个小伙伴通过 QQ 问我如何搭建一个最基础的 TS 开发环境了。正好这节课也需要，我们就从新搭建一下。如果你已经很熟悉这部分内容可以跳过。

1. 建立好文件夹后，打开 VSCode，把文件夹拉到编辑器当中，然后打开终端，运行`npm init -y`,创建`package.json`文件。
2. 生成文件后，我们接着在终端中运行`tsc -init`,生成`tsconfig.json`文件。
3. 新建`src`和`build`文件夹，再建一个`index.html`文件。
4. 在`src`目录下，新建一个`page.ts`文件，这就是我们要编写的`ts`文件了。
5. 配置`tsconfig.json`文件，设置`outDir`和`rootDir`(在 15 行左右)，也就是设置需要编译的文件目录，和编译好的文件目录。
6. 然后编写`index.html`，引入`<script src="./build/page.js"></script>`,当让我们现在还没有`page.js`文件。
7. 编写`page.ts`文件，加入一句输出`console.log('jspang.com')`,再在控制台输入`tsc`,就会生成`page.js`文件
8. 再到浏览器中查看`index.html`文件，如果按`F12`可以看到`jspang.com`，说明我们的搭建正常了。

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="./build/page.js"></script>
    <title>Document</title>
  </head>
  <body></body>
</html>
```

这就是你开发最基础的前端项目时需要作的环境配置。我觉的学习这东西，学会了就要用，如果不用你很快就会忘记。所以以后你在做项目，请尽量使用`TypeScript`来进行编写。

[没有命名空间时的问题](https://jspang.com/detailed?id=63#toc392)

为了你更好的理解，先写一下这样代码，用类的形式在`index.html`中实现`header`,`content`和`Footer`部分，类似我们常说的模板。

在`page.ts`文件里，写出下面的代码：

```js
class Header {
  constructor() {
    const elem = document.createElement("div");
    elem.innerText = "This is Header";
    document.body.appendChild(elem);
  }
}

class Content {
  constructor() {
    const elem = document.createElement("div");
    elem.innerText = "This is Content";
    document.body.appendChild(elem);
  }
}

class Footer {
  constructor() {
    const elem = document.createElement("div");
    elem.innerText = "This is Footer";
    document.body.appendChild(elem);
  }
}

class Page {
  constructor() {
    new Header();
    new Content();
    new Footer();
  }
}
```

写完后我们用`tsc`进行编译一次，然后修改`index.html`文件，在`<body>`标签里引入`<script>`标签，并实例化`Page`，代码如下:

```js
<body>
  <script>new Page();</script>
</body>
```

这时候再到浏览器进行预览，就可以看到对应的页面被展现出来了。看起来没有什么问题，但是有经验的程序员就会发现，这样写全部都是全局变量（通过查看`./build/page.js`文件可以看出全部都是`var`声明的变量）。**过多的全局变量会让我们代码变的不可维护。**

这时候你在浏览器的控制台(`Console`)中，分别输入`Header`、`Content`、`Footer`和`Page`都时可以拿到对应的变量的,说明他们全都是全局变量。

其实你理想的是，只要有`Page`这个全局变量就足够了，剩下的可以模块化封装起来，不暴露到全局。

[命名空间的使用](https://jspang.com/detailed?id=63#toc393)

`命名空间`这个语法，很类似编程中常说的模块化思想，比如`webpack`打包时，每个模块有自己的环境，不会污染其他模块,不会有全局变量产生。命名空间就跟这个很类似，注意这里是类似，而不是相同。

命名空间声明的关键词是`namespace` 比如声明一个`namespace Home`,需要暴露出去的类，可以使用`export`关键词，这样只有暴漏出去的类是全局的，其他的不会再生成全局污染了。修改后的代码如下：

```js
namespace Home {
  class Header {
    constructor() {
      const elem = document.createElement("div");
      elem.innerText = "This is Header";
      document.body.appendChild(elem);
    }
  }

  class Content {
    constructor() {
      const elem = document.createElement("div");
      elem.innerText = "This is Content";
      document.body.appendChild(elem);
    }
  }

  class Footer {
    constructor() {
      const elem = document.createElement("div");
      elem.innerText = "This is Footer";
      document.body.appendChild(elem);
    }
  }

  export class Page {
    constructor() {
      new Header();
      new Content();
      new Footer();
    }
  }
}
```

TS 代码写完后，再到`index.html`文件中进行修改，用命名空间的形式进行调用，就可以正常了。 写完后，记得用`tsc`编译一下，当然你也可以使用`tsc -w`进行监视了，只要有改变就会进行重新编译。

```js
new Home.Page();
```

现在再到浏览器中进行查看，可以看到现在就只有`Home.Page`是在控制台可以得到的，其他的`Home.Header`...这些都是得不到的，说明只有`Home.Page`是全局的，其他的都是模块化私有的。

这就是 TypeScript 给我们提供的类似模块化开发的语法，它的好处就是让全局变量减少了很多，实现了基本的封装，减少了全局变量的污染。

[23. 深入命名空间-Namespace](https://jspang.com/detailed?id=63#toc294)

接着上节课的内容进行学习，废话不多说，直接开讲。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=238401389&amp;page=23" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[用命名空间实现组件化](https://jspang.com/detailed?id=63#toc395)

上节课的代码虽实现了模块化和全局变量的污染，但是我们工作中分的要更细致一些，会单独写一个`components`的文件，然后进行组件化。

在`src`目录下新建一个文件`components.ts`，编写代码如下：

```js
namespace Components {
  export class Header {
    constructor() {
      const elem = document.createElement("div");
      elem.innerText = "This is Header";
      document.body.appendChild(elem);
    }
  }

  export class Content {
    constructor() {
      const elem = document.createElement("div");
      elem.innerText = "This is Content";
      document.body.appendChild(elem);
    }
  }

  export class Footer {
    constructor() {
      const elem = document.createElement("div");
      elem.innerText = "This is Footer";
      document.body.appendChild(elem);
    }
  }
}
```

这里需要注意的是，我每个类(`class`)都使用了`export`导出，导出后就可以在`page.ts`中使用这些组件了。比如这样使用-代码如下。

```js
namespace Home {
  export class Page {
    constructor() {
      new Components.Header();
      new Components.Content();
      new Components.Footer();
    }
  }
}
```

这时候你可以使用`tsc`进行重新编译，但在预览时，你会发现还是会报错，找不到`Components`,想解决这个问题，我们必须要在`index.html`里进行引入`components.js`文件。

```js
<script src="./build/page.js"></script>
<script src="./build/components.js"></script>
```

这样才可以正常的出现效果。但这样引入太麻烦了，可不可以像`webpack`一样，只生成一个文件那？那答案是肯定的。

[多文件编译成一个文件](https://jspang.com/detailed?id=63#toc396)

直接打开`tsconfig.json`文件，然后找到`outFile`配置项，这个就是用来生成一个文件的设置，但是如果设置了它，就不再支持`"module":"commonjs"`设置了，我们需要把它改成`"module":"amd"`,然后在去掉对应的`outFile`注释，设置成下面的样子。

```js
{
  "outFile": "./build/page.js"
}
```

配置好后，删除掉`build`下的`js`文件，然后用`tsc`进行再次编译。

然后删掉`index.html`文件中的`component.js`,在浏览器里还是可以正常运行的。

[子命名空间](https://jspang.com/detailed?id=63#toc397)

也就是说在命名空间里，再写一个命名空间,比如在`Components.ts`文件下修改代码如下。

```js
namespace Components {
  export namespace SubComponents {
    export class Test {}
  }

  //someting ...
}
```

写完后在控制台再次编辑`tsc`，然后你在浏览器中也是可以查到这个命名空间的`Components.SubComponents.Test`(需要刷新页面后才会显示)。

通过两节课的时间，基本讲完了命名空间的内容，在工作中如果遇到，这些知识已经完全够用，所以这部分内容就先到这里了。

[24. TypeScript 如何使用 import 语法](https://jspang.com/detailed?id=63#toc298)

上节我们学习了`命名空间`的知识，有些小伙伴就有疑问了，说我看别人写的代码，都是用`import`进行引入的，你这个显得有点不专业哦。那这节我们就把上节的代码改成`import`引入。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=238608683&amp;page=24" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[修改 components.ts 文件](https://jspang.com/detailed?id=63#toc399)

现在去掉`components.ts`里的`namespace`命名空间代码，写成 `ES6` 的 `export` 导出模式。代码如下：

```js
export class Header {
  constructor() {
    const elem = document.createElement("div");
    elem.innerText = "This is Header";
    document.body.appendChild(elem);
  }
}

export class Content {
  constructor() {
    const elem = document.createElement("div");
    elem.innerText = "This is Content";
    document.body.appendChild(elem);
  }
}

export class Footer {
  constructor() {
    const elem = document.createElement("div");
    elem.innerText = "This is Footer";
    document.body.appendChild(elem);
  }
}
```

现在三个类就都已经用`export`导出了，也就是说可以实现用`import`进行引入了。

[修改 page.ts 文件](https://jspang.com/detailed?id=63#toc3100)

来到`page.ts`文件，去掉`namespace`命名空间对应的代码，然后使用 `import` 语法进行导入`Header`、`Content`和`Footer`,代码如下：

```js
import { Header, Content, Footer } from "./components";
export class Page {
  constructor() {
    new Header();
    new Content();
    new Footer();
  }
}
```

现在看起来确实和工作中写的代码非常类似了。这时候可以使用`tsc`进行编译。然后可以看到编译好的代码都是`define`开头的(这是 amd 规范的代码，不能直接在浏览器中运行，可以在 Node 中直接运行)，这种代码在浏览器中是没办法被直接运行的，需要其他库(`require.js`)的支持。

[引入 require.js](https://jspang.com/detailed?id=63#toc3101)

我这里使用了一个现成的 CDN 的`require.js`,地址你可以直接复制，然后用`<script>`标签进行引入。

> Require.js 的 CDN 地址： https://cdnjs.cloudflare.com/ajax/libs/require.js/2.3.6/require.js

复制好 URL 地址后，记得使用`<script>`标签进行引入，代码如下。

```js
<script src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.3.6/require.js"></script>
```

这时候就可以解析`define`这样的语法了。然后把`page.ts`中加入`default`关键字，如果不加是没办法直接引用到的。

```js
import { Header, Content, Footer } from "./components";

export default class Page {
  constructor() {
    new Header();
    new Content();
    new Footer();
  }
}
```

这时候再用`tsc`进行编译一下，你会发现还是又问题。因为使用`export default`这种形式的语法，需要在`html`里用`require`来进行引入。

[require 方式引入](https://jspang.com/detailed?id=63#toc3102)

因为你已经加入了`require.js`这个库，所以现在可以直接在代码中使用`require`了。具体代码如下：

```js
<body>
  <script>
    require(["page"], function (page) {
      new page.default();
    });
  </script>
</body>
```

写完这部，刷新页面，可以看到正常显示出来了，虽然用起来比较麻烦，但是我们还是实现了用`import`来进行引入，当我们又了`webpack`和`Parcel`的时候就不会这么麻烦，这些都交给打包工具来处理就好了。

[25. 用 Parcel 打包 TypeScript 代码](https://jspang.com/detailed?id=63#toc2103)

上节课代码配置起来非常麻烦，步骤也很多。工作中一定是有更好的解决方案的。其实最通用的有两种解决方案`Webpack`和`Parcel`。`webpack`不用多说，只要是前端基本都会，这几年`Parcel`也开始崛起，用的人也越来越多。所以这节课就讲一下，如何使用`Parcel`来打包`TypeScript`代码。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=238608719&amp;page=25" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[建立一个新项目](https://jspang.com/detailed?id=63#toc3104)

这里给出新建项目的步骤，如果你已经熟悉此过程，可以跳过。

1. 教学需要，这里我们重新建立一个项目`TSTest`,在桌面新建立一个文件夹，然后在`VSCode`中打开。
2. 打开终端，输入`npm init -y`,创建`package.json`文件
3. 在终端中输入`tsc --init`,创建`tsconfig.json`文件
4. 修改`tsconfig.json`配置`rootDir`和`outDir`.
5. 新建`src`文件夹，在里边建立`index.html`,`page.ts`文件
6. 编写`index.html`文件，并引入`page.ts`文件
7. 编写`page.ts`文件。

index.html 文件代码：

```js
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="./page.ts"></script>
    <title>Document</title>
  </head>
  <body></body>
</html>
```

page.ts 文件代码：

```js
const teacher: string = "jspang";
console.log(teacher);
```

这时候我们并不能正常的预览出效果，我们需要`Parcel`的帮忙。

[Parcel 的安装和使用](https://jspang.com/detailed?id=63#toc3105)

Parcel 可以通过`npm`或者`yarn`来进行安装，我这里`npm`安装很慢，会 5 分钟左右，所以我使用`yarn`来进行安装。代码如下。

```js
yarn add --dev parcel@next
```

使用 yarn 安装大概需要 1 分钟左右，这些主要看你自身的网络情况。

安装好以后，打开`package.json`文件，可以看到这样一段代码，我安装的版本是`^2.0.0-beta.1`,如果你学习时和这个版本不一样，操作可能会稍有不同。

修改`package.json`里边的代码。

```js
{

  "scripts": {
    "test": "parcel ./src/index.html"
  },
}
```

这个意思就是使用`parcel`对`index.html`进行一个编译。

然后打开终端输入`yarn test`,这时候终端会给出一个地址`http://localhost:1234`,把地址放到浏览器上，可以看到浏览器的控制台会输出`jspang`。

这说明`Parcel`会自动对`index.html`中引入的`TypeScript`文件进行编译，然后打包好后，就可以直接使用了。

使用`Parcel`大大简化了我们的配置过程，如果你想详细学习`Parcel`可以自行学习，毕竟我们这个是 TypeScript 的教程，所以更多的 Parcel 知识就不作介绍了。

[26. 在 TypeScript 中使用 JQuery](https://jspang.com/detailed?id=63#toc2106)

这个需求也经常使用，就是在 TypeScript 的代码中使用其他类库，其实这里就涉及到一个类型文件(Type file)的问题，网上有大量别人写好的类型文件，我们只要下载使用就可以了。

<iframe src="https://player.bilibili.com/player.html?aid=413767616&amp;bvid=BV1qV41167VD&amp;cid=238946993&amp;page=26" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" width="100%" style="box-sizing: border-box; height: 34rem; border: 1px solid rgb(204, 204, 204); border-radius: 8px;"></iframe>

[引入 JQuery 框架库](https://jspang.com/detailed?id=63#toc3107)

接着上节课的代码，在`TSTest`文件夹的`src`目录下，引入`JQuery`文件，这里采用`CDN`的形式进行引入。

> BootCDN 地址： https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.js

直接在`index.html`加入`<script>`标签，代码如下：

```js
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.js"></script>
```

有了 jquery 框架，就可以在`TypeScript`文件中进行使用`JQuery`的语法了。

然后在`page.ts`文件中编写如下代码。

```js
const teacher: string = "jspang";
console.log(teacher);

$(function () {
  alert("jspang");
});
```

写完后到终端中输入`yarn test`进行编译和启动服务。然后在地址栏输入了`http://localhost:1234`,可以看到程序可以正常输出，也没有任何的报错。

[安装 types/jquery(解决方法)](https://jspang.com/detailed?id=63#toc3108)

第一种：就是安装别人写好的文件

但是在`vscode`中是会报错的，这时候就需要我们安装类型文件`type file`,直接可以用 npm 进行安装。

```js
npm i @types/jquery
```

这个安装的时间还是比较长的，所以视频中我就不进行展示了。

第二种:简单粗暴

还有一种简单粗暴的方法的方式就是直接在`page.ts`文件的头部加入这句代码：

```js
declare var $: any;
```

第三种：自己写一个`.d.ts`声明文件的类库，如果你用的类库很少见，就需要自己写了。这个写起来还是很麻烦的。我只是简单的学过，但在工作中从来没自己写过，所以也不推荐给大家。比如 JQuery 就有几十个接口，如果你要写，这个文件会写很长，所以原则就是有别人写好的就直接用，实在没有就用粗暴的方法，如果实在不行，再考虑写`.d.ts`声明文件。

TypeScrip 的视频我们就暂时告一段落，紧接着会更新 Vue3 的课程，希望下伙伴们继续跟我一期学习。
# 浅拷贝和深拷贝

那么，手写深拷贝的话，要怎么实现呢？

我们尝试稍微修改下前面的浅拷贝代码：

```
const deepClone = (source) => {
  const target = {};
  for (const i in source) {
    if (source.hasOwnProperty(i)
      && target[i] === 'object') {
      target[i] = deepClone(source[i]); // 注意这里
    } else {
      target[i] = source[i];
    }
  }
  return target;
};
复制代码
```

当然，这份代码是存在问题的：

1. 没有对参数进行校验，如果传入进来的不是对象或者数组，我们直接返回即可。
2. 通过 `typeof` 判断是否对象的逻辑不够严谨。

------

**---小节 2---**

既然存在问题，那么我们就需要尝试克服：

```
// 定义检测数据类型的功能函数
const checkedType = (target) => {
  return Object.prototype.toString.call(target).slice(8, -1);
}

// 实现深度克隆对象或者数组
const deepClone = (target) => {
  // 判断拷贝的数据类型
  // 初始化变量 result 成为最终数据
  let result, targetType = checkedType(target);
  if (targetType === 'Object') {
    result = {};
  } else if (targetType === 'Array') {
    result = [];
  } else {
    return target;
  }

  // 遍历目标数据
  for (let i in target) {
    // 获取遍历数据结构的每一项值
    let value = target[i];
    // 判断目标结构里的每一项值是否存在对象或者数组
    if (checkedType(value) === 'Object' || checkedType(value) === 'Array') {
      // 如果对象或者数组中还嵌套了对象或者数组，那么继续遍历
      result[i] = deepClone(value);
    } else {
      result[i] = value;
    }
  }

  // 返回最终值
  return result;
}

const obj1 = [
  1,
  'Hello!',
  { name: 'jsliang1' },
  [
    {
      name: 'LiangJunrong1',
    }
  ],
]
const obj2 = deepClone(obj1);
obj2[0] = 2;
obj2[1] = 'Hi!';
obj2[2].name = 'jsliang2';
obj2[3][0].name = 'LiangJunrong2';

console.log(obj1);
// [
//   1,
//   'Hello!',
//   { name: 'jsliang1' },
//   [
//     { name: 'LiangJunrong1' },
//   ],
// ]

console.log(obj2);
// [
//   2,
//   'Hi!',
//   { name: 'jsliang2' },
//   [
//     { name: 'LiangJunrong2' },
//   ],
// ]
复制代码
```

下面讲解下这份深拷贝代码：

**首先**，我们先看检查类型的那行代码：`Object.prototype.toString.call(target).slice(8, -1)`。

在说这行代码之前，我们先对比下检测 JavaScript 数据类型的 4 种方式：

- **方式一：typeof**：无法判断 `null` 或者 `new String()` 等数据类型。
- **方式二：instanceof**：无法判断 `'jsliang'`、`123` 等数据类型。
- **方式三：constructor**：判断 `null` 和 `undefined` 会直接报错。
- **方式四：Object.prototype.toString.call()**：稳健地判断 JavaScript 数据类型方式，可以符合预期的判断基本数据类型 String、Undefined 等，也可以判断 Array、Object 这些引用数据类型。

详细研究可以看 **jsliang** 的学习文档：

- [《判断数据类型 - 汇总》](https://github.com/LiangJunrong/document-library/blob/master/JavaScript-library/JavaScript/表达式和运算符/判断数据类型/README.md)
- [《判断数据类型 - typeof》](https://github.com/LiangJunrong/document-library/blob/master/JavaScript-library/JavaScript/表达式和运算符/判断数据类型/判断数据类型-typeof.md)
- [《判断数据类型 - instanceof》](https://github.com/LiangJunrong/document-library/blob/master/JavaScript-library/JavaScript/表达式和运算符/判断数据类型/判断数据类型-instanceof.md)
- [《判断数据类型 - constructor》](https://github.com/LiangJunrong/document-library/blob/master/JavaScript-library/JavaScript/表达式和运算符/判断数据类型/判断数据类型-constructor.md)
- [《判断数据类型 - toString》](https://github.com/LiangJunrong/document-library/blob/master/JavaScript-library/JavaScript/表达式和运算符/判断数据类型/判断数据类型-toString.md)

**然后**，我们通过方法 `targetType()` 中的 `Object.prototype.toString.call()`，判断传入的数据类型属于那种，从而改变 `result` 的值为 `{}`、`[]` 或者直接返回传入的值（`return target`）。

**最后**，我们再通过 `for...in` 判断 `target` 的所有元素，如果属于 `{}` 或者 `[]`，那么就递归再进行 `clone()` 操作；如果是基本数据类型，则直接传递到数组中……从而在最后返回一个深拷贝的数据。

------

**---小节 3---**

以上，我们的代码看似没问题了是不是？假设我们需要拷贝的数据如下：

```
const obj1 = {};
obj1.a = obj1;
console.log(deepClone(obj1));
// RangeError: Maximum call stack size exceeded
复制代码
```

看，我们直接研制了个死循环出来！

那么我们需要怎么解决呢？有待实现！

> 乘我还没找到教好的解决方案之前，小伙伴们可以看下下面文章，思考下是否能解决这个问题：

- [什么是 js 深拷贝和浅拷贝及其实现方式](https://www.haorooms.com/post/js_copy_sq)
- [JavaScript 浅拷贝和深拷贝](https://www.kancloud.cn/ljw789478944/interview/397319)
- [面试题之如何实现一个深拷贝 - 木易杨](https://www.muyiy.cn/blog/4/4.3.html#引言)

……好的，虽然口头说着希望小伙伴们自行翻阅资料，但是为了防止被寄刀片，**jsliang** 还是在这里写下自己觉得 OK 的代码：

```
function isObject(obj) {
  return Object.prototype.toString.call(obj) === '[object Object]';
}

function deepClone(source, hash = new WeakMap()) {
  if (!isObject(source)) return source;
  // 新增代码，查哈希表
  if (hash.has(source)) return hash.get(source);

  var target = Array.isArray(source) ? [] : {};
  // 新增代码，哈希表设值
  hash.set(source, target);

  for (var key in source) {
    if (Object.prototype.hasOwnProperty.call(source, key)) {
      if (isObject(source[key])) {
        // 新增代码，传入哈希表
        target[key] = deepClone(source[key], hash);
      } else {
        target[key] = source[key];
      }
    }
  }
  return target;
}

/**
 * @name 正常深拷贝测试
 */
const a = {
  name: 'jsliang',
  book: {
    title: '深拷贝学习',
    price: 'free',
  },
  a1: undefined,
  a2: null,
  a3: 123
};
const b = deepClone(a);
b.name = 'JavaScriptLiang';
b.book.title = '教你如何泡妞';
b.a3 = 456;
console.log(a);
// { name: 'jsliang',
//   book: { title: '深拷贝学习', price: 'free' },
//   a1: undefined,
//   a2: null,
//   a3: 123 }
console.log(b);
// { name: 'JavaScriptLiang',
//   book: { title: '教你如何泡妞', price: 'free' },
//   a1: undefined,
//   a2: null,
//   a3: 456 }

/**
 * @name 解决死循环
 */
const c = {};
c.test = c;
const d = deepClone(c);
console.log(c);
// { test: [Circular] }
console.log(d);
// { test: [Circular] }
复制代码
```

------

**---小节 4---**

既然搞定完死循环，咱们再看看另一个问题：

```
const checkedType = (target) => {
  return Object.prototype.toString.call(target).slice(8, -1);
}

const deepClone = (target) => {
  let result, targetType = checkedType(target);
  if (targetType === 'Object') {
    result = {};
  } else if (targetType === 'Array') {
    result = [];
  } else {
    return target;
  }

  for (let i in target) {
    let value = target[i];
    if (checkedType(value) === 'Object' || checkedType(value) === 'Array') {
      result[i] = deepClone(value);
    } else {
      result[i] = value;
    }
  }

  return result;
}

// 检测深度和广度
const createData = (deep, breadth) => {
  const data = {};
  let temp = data;

  for (let i = 0; i < deep; i++) {
    temp = temp['data'] = {};
    for (let j = 0; j < breadth; j++) {
      temp[j] = j;
    }
  }

  return data;
};

console.log(createData(1, 3)); 
// 1 层深度，每层有 3 个数据 { data: { '0': 0, '1': 1, '2': 2 } }

console.log(createData(3, 0));
// 3 层深度，每层有 0 个数据 { data: { data: { data: {} } } }

console.log(deepClone(createData(1000)));
// 1000 层深度，无压力 { data: { data: { data: [Object] } } }

console.log(deepClone(createData(10, 100000)));
// 100000 层广度，没问题，数据遍历需要时间

console.log(deepClone(createData(10000)));
// 10000 层深度，直接爆栈：Maximum call stack size exceeded
复制代码
```

是的，你的深拷贝爆栈了！！！

虽然业务场景中可能爆栈的概率比较少，毕竟数据层级没那么多，但是还是会存在这种情况，需要怎么处理呢？

> 只想大致了解深拷贝可能出现问题的小伙伴可以跳过下面内容

举个例子，假设有数据结构：

```
const a = {
  a1: 1,
  a2: {
    b1: 1,
    b2: {
      c1: 1
    }
  }
};
复制代码
```

如果我们将其当成数来看：

```
    a
  /   \
 a1   a2        
 |    / \         
 1   b1 b2     
     |   |        
     1  c1
         |
         1
复制代码
```

那么，我们就可以采用迭代的方法，循环遍历这棵树了！

1. 首先，我们需要借助栈。当栈为空就遍历完毕，栈里面存储下一个需要拷贝的节点
2. 然后，往栈里放入种子数据，`key` 用来存储哪一个父元素的那一个子元素拷贝对象
3. 最后，遍历当前节点下的子元素，如果是对象就放到栈里，否则直接拷贝。

```
const deepClone = (x) => {
  const root = {};

  // 栈
  const loopList = [
    {
      parent: root,
      key: undefined,
      data: x
    }
  ];

  while (loopList.length) {
    // 深度优先
    const node = loopList.pop();
    const parent = node.parent;
    const key = node.key;
    const data = node.data;

    // 初始化赋值目标，key 为 undefined 则拷贝到父元素，否则拷贝到子元素
    let res = parent;
    if (typeof key !== "undefined") {
      res = parent[key] = {};
    }

    for (let k in data) {
      if (data.hasOwnProperty(k)) {
        if (typeof data[k] === "object") {
          // 下一次循环
          loopList.push({
            parent: res,
            key: k,
            data: data[k]
          });
        } else {
          res[k] = data[k];
        }
      }
    }
  }

  return root;
}
复制代码
```

这时候我们再通过 `createData` 进行广度和深度校验，会发现：

```
console.log(deepClone(createData(10, 100000)));
// 100000 层广度，没问题，数据遍历需要时间

console.log(deepClone(createData(100000)));
// 100000 层深度，也没问题了：{ data: { data: { data: [Object] } } }
复制代码
```

这样，我们就解决了爆栈的问题。

> 这里推荐下引用思路来源于大佬的文章：[深拷贝的终极探索](https://yanhaijing.com/javascript/2018/10/10/clone-deep/)，然后它附带了一个深拷贝库：[@jsmini/clone](https://github.com/jsmini/clone)，感兴趣的小伙伴可以去看看。

## 5.2 JSON

JSON.parse(JSON.stringify())

> [返回目录](#chapter-one)

其实利用工具，达到目的，是非常聪明的做法，下面我们讨论下  `JSON.parse(JSON.stringify())`。

- `JSON.stringify()`：将对象转成 JSON 字符串。
- `JSON.parse()`：将字符串解析成对象。

通过 `JSON.parse(JSON.stringify())` 将 JavaScript 对象转序列化（转换成 JSON 字符串），再将其还原成 JavaScript 对象，一去一来我们就产生了一个新的对象，而且对象会开辟新的栈，从而实现深拷贝。

> 注意，该方法的局限性：
>  1、不能存放函数或者 Undefined，否则会丢失函数或者 Undefined；
>  2、不要存放时间对象，否则会变成字符串形式；
>  3、不能存放 RegExp、Error 对象，否则会变成空对象；
>  4、不能存放 NaN、Infinity、-Infinity，否则会变成 null；
>  5、……更多请自行填坑，具体来说就是 JavaScript 和 JSON 存在差异，两者不兼容的就会出问题。

```
const arr1 = [
  1,
  {
    username: 'jsliang',
  },
];

let arr2 = JSON.parse(JSON.stringify(arr1));
arr2[0] = 2;
arr2[1].username = 'LiangJunrong';
console.log(arr1);
// [ 1, { username: 'jsliang' } ]
console.log(arr2);
// [ 2, { username: 'LiangJunrong' } ]
复制代码
```

## 5.3 函数库 Lodash

> [返回目录](#chapter-one)

Lodash 作为一个深受大家喜爱的、优秀的 JavaScript 函数库/工具库，它里面有非常好用的封装好的功能，大家可以去试试：

- [Lodash](http://lodash.net/)

这里我们查看下它的 `cloneDeep()` 方法：

- [Lodash - _.cloneDeep(value)](https://lodash.net/docs/4.15.1.html#_clonedeepvalue)

可以看到，该方法会递归拷贝 `value`。

在这里，我们体验下它的 `cloneDeep()`：

```
//  npm i -S lodash
var _ = require('lodash');

const obj1 = [
  1,
  'Hello!',
  { name: 'jsliang1' },
  [
    {
      name: 'LiangJunrong1',
    }
  ],
]
const obj2 = _.cloneDeep(obj1);
obj2[0] = 2;
obj2[1] = 'Hi!';
obj2[2].name = 'jsliang2';
obj2[3][0].name = 'LiangJunrong2';

console.log(obj1);
// [
//   1,
//   'Hello!',
//   { name: 'jsliang1' },
//   [
//     { name: 'LiangJunrong1' },
//   ],
// ]

console.log(obj2);
// [
//   2,
//   'Hi!',
//   { name: 'jsliang2' }, 
//   [
//     { name: 'LiangJunrong2' },
//   ],
// ]
复制代码
```

这里我们使用的是 Node 安装其依赖包的形式，如果需要用 MDN 等，小伙伴可以前往它官网瞅瞅。（地址在本节开头）

### 5.4 框架 jQuery

> [返回目录](#chapter-one)

当然，不可厚非你的公司还在用着 jQuery，可能还需要兼容 IE6/7/8，或者你使用 React，但是有些场景还使用了 jQuery，毕竟 jQuery 是个强大的框架。

下面我们尝试下使用 jQuery 的 `extend()` 进行深拷贝：

> index.html

```
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Document</title>
</head>
<body>
  <p>尝试 jQuery 深拷贝</p>
  <script src="https://cdn.bootcss.com/jquery/3.4.1/jquery.js"></script>
  <script>
    $(function() {
      const obj1 = [
        1,
        'Hello!',
        { name: 'jsliang1' },
        [
          {
            name: 'LiangJunrong1',
          }
        ],
      ]
      const obj2 = {};
      /**
       * @name jQuery深拷贝
       * @description $.extend(deep, target, object1, object2...)
       * @param {Boolean} deep 可选 true 或者 false，默认是 false，所以一般如果需要填写，最好是 true。
       * @param {Object} target 需要存放的位置
       * @param {Object} object 可以有 n 个原数据
       */
      $.extend(true, obj2, obj1);
      obj2[0] = 2;
      obj2[1] = 'Hi!';
      obj2[2].name = 'jsliang2';
      obj2[3][0].name = 'LiangJunrong2';

      console.log(obj1);
      // [
      //   1,
      //   'Hello!',
      //   { name: 'jsliang1' },
      //   [
      //     { name: 'LiangJunrong1'},
      //   ],
      // ];

      console.log(obj2);
      // [
      //   2,
      //   'Hi!',
      //   { name: 'jsliang2' },
      //   [
      //     { name: 'LiangJunrong2' },
      //   ],
      // ];
    });
  </script>
</body>
</html>
复制代码
```

这里由于 Node 直接引用包好像没尝试成功，所以咱通过 `index.html` 的形式，引用了 jQuery 的 CDN 包，从而尝试了它的深拷贝。

> 推荐通过 `live-server` 来实时监控 HTML 文件的变化

> 如果需要查看 `jQuery.extend()` 源码可以观看文章：
>  [《深拷贝与浅拷贝的实现（一）》](http://www.alloyteam.com/2017/08/12978/)
>  [《JavaScript 浅拷贝和深拷贝》](https://www.kancloud.cn/ljw789478944/interview/397319)

> jQuery.extend 源码

```js
jQuery.extend = jQuery.fn.extend = function() {
  var options,
    name,
    src,
    copy,
    copyIsArray,
    clone,
    target = arguments[0] || {},
    i = 1,
    length = arguments.length,
    deep = false;

  // Handle a deep copy situation
  if (typeof target === "boolean") {
    deep = target;

    // Skip the boolean and the target
    target = arguments[i] || {};
    i++;
  }

  // Handle case when target is a string or something (possible in deep copy)
  if (typeof target !== "object" && !jQuery.isFunction(target)) {
    target = {};
  }

  // Extend jQuery itself if only one argument is passed
  if (i === length) {
    target = this;
    i--;
  }

  for (; i < length; i++) {
    // Only deal with non-null/undefined values
    if ((options = arguments[i]) != null) {
      // Extend the base object
      for (name in options) {
        src = target[name];
        copy = options[name];

        // Prevent never-ending loop
        if (target === copy) {
          continue;
        }

        // Recurse if we're merging plain objects or arrays
        if (
          deep &&
          copy &&
          (jQuery.isPlainObject(copy) || (copyIsArray = Array.isArray(copy)))
        ) {
          if (copyIsArray) {
            copyIsArray = false;
            clone = src && Array.isArray(src) ? src : [];
          } else {
            clone = src && jQuery.isPlainObject(src) ? src : {};
          }

          // Never move original objects, clone them
          target[name] = jQuery.extend(deep, clone, copy);

          // Don't bring in undefined values
        } else if (copy !== undefined) {
          target[name] = copy;
        }
      }
    }
  }
  // Return the modified object
  return target;
};
复制代码
```

## 六 总结

> [返回目录](#chapter-one)

很遗憾，我们就这样暂时完成了 **浅拷贝和深拷贝** 的第一期探索啦~

在写这系列内容中，**jsliang** 犹豫过，熬夜过，想放弃过……但还是坚持下来，过了一遍。

在查资料丰富这系列知识的过程中，**jsliang** 忽略了一些知识点探索，要不然会产生更多的疑惑，最终天天通宵达旦到晚上 04:00 还在精神抖擞折腾~

我们还未深入的一些点有：

1. [Lodash 如何实现深拷贝](https://www.muyiy.cn/blog/4/4.4.html#引言)
2. [jQuery 如何实现深拷贝](https://www.kancloud.cn/ljw789478944/interview/397319)
3. [Object.assign 原理及其实现](https://www.muyiy.cn/blog/4/4.2.html#引言)
4. ……

可能有些小伙伴会觉得：

- **啊，你不先折腾完，彻彻底底搞清楚，就发表出来，你不觉得羞耻吗！**

enm...怎么说，首先在写这篇文章的时候，**jsliang** 做的是广度探索，即碰到的每一个知识点都接触了解一下，其实这样写非常累，但是进步是非常大的，因为你把一些知识点都挖掘出来了。

然后，**jsliang** 一开始的目标，只是想了解下手写深拷贝，以及一些工具快速实现深拷贝，所以个人觉得本次目标已经达到甚至超标了。

最后，还有一些知识点，例如手写一个 `Object.assign()` 或者了解 Lodash 的深拷贝源码，其实希望进一步了解的小伙伴，肯定会自行先探索，当然如果小伙伴希望有 “前人躺坑”，那么可以期待我的后续完善。

毕竟：**不折腾的前端，跟咸鱼有什么区别！**

所以，如果小伙伴们想持续跟进，可以到 **jsliang** 的 [GitHub 仓库](https://github.com/LiangJunrong/document-library) 首页找到我的公众号、微信、QQ 等联系方式。

那么，我们后期再会~

- **参考文献**：

1. [Lodash clone 系列](https://lodash.net/docs/4.16.1.html#_clonevalue)
2. [浅拷贝与深拷贝](https://juejin.im/post/6844904197595332622)
3. [深拷贝的终极探索](https://yanhaijing.com/javascript/2018/10/10/clone-deep/)
4. [深拷贝与浅拷贝的实现（一）](http://www.alloyteam.com/2017/08/12978/)
5. [深入浅出深拷贝与浅拷贝](https://juejin.im/post/6844903781549932552)
6. [什么是 js 深拷贝和浅拷贝及其实现方式](https://www.haorooms.com/post/js_copy_sq)
7. [JavaScript 浅拷贝和深拷贝](https://www.kancloud.cn/ljw789478944/interview/397319)
8. [js 深拷贝 vs 浅拷贝](https://juejin.im/post/6844903493925371917)
9. [深拷贝的终极探索（99%的人都不知道）](https://segmentfault.com/a/1190000016672263)
10. [面试题之如何实现一个深拷贝](https://www.muyiy.cn/blog/4/4.3.html#引言)


作者：jsliang
链接：https://juejin.cn/post/6844903968586334221
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

# [深拷贝的终极探索](https://segmentfault.com/a/1190000016672263)

**划重点，这是一道面试必考题，我靠这道题刷掉了多少面试者✧(≖ ◡ ≖✿)嘿嘿**

首先这是一道非常棒的面试题，可以考察面试者的很多方面，比如基本功，代码能力，逻辑能力，而且进可攻，退可守，针对不同级别的人可以考察不同难度，比如漂亮妹子就出1☆题，要是个帅哥那就得上5☆了，(*^__^*) 嘻嘻……

无论面试者多么优秀，漂亮的回答出问题，我总能够潇洒的再抛出一个问题，看着面试者露出惊异的眼神，默默一转身，深藏功与名

本文我将给大家破解深拷贝的谜题，由浅入深，环环相扣，总共涉及4种深拷贝方式，每种方式都有自己的特点和个性

## 深拷贝 VS 浅拷贝

再开始之前需要先给同学科普下什么是深拷贝，和深拷贝有关系的另个一术语是浅拷贝又是什么意思呢？如果对这部分部分内容了解的同学可以跳过

其实深拷贝和浅拷贝都是针对的引用类型，JS中的变量类型分为值类型（基本类型）和引用类型；对值类型进行复制操作会对值进行一份拷贝，而对引用类型赋值，则会进行地址的拷贝，最终两个变量指向同一份数据

```
// 基本类型
var a = 1;
var b = a;
a = 2;
console.log(a, b); // 2, 1 ，a b指向不同的数据

// 引用类型指向同一份数据
var a = {c: 1};
var b = a;
a.c = 2;
console.log(a.c, b.c); // 2, 2 全是2，a b指向同一份数据
```

对于引用类型，会导致a b指向同一份数据，此时如果对其中一个进行修改，就会影响到另外一个，有时候这可能不是我们想要的结果，如果对这种现象不清楚的话，还可能造成不必要的bug

那么如何切断a和b之间的关系呢，可以拷贝一份a的数据，根据拷贝的层级不同可以分为浅拷贝和深拷贝，浅拷贝就是只进行一层拷贝，深拷贝就是无限层级拷贝

```
var a1 = {b: {c: {}};

var a2 = shallowClone(a1); // 浅拷贝
a2.b.c === a1.b.c // true

var a3 = clone(a3); // 深拷贝
a3.b.c === a1.b.c // false
```

浅拷贝的实现非常简单，而且还有多种方法，其实就是遍历对象属性的问题，这里只给出一种，如果看不懂下面的方法，或对其他方法感兴趣，可以看我的[这篇文章](https://yanhaijing.com/javascript/2015/05/09/diff-between-keys-getOwnPropertyNames-forin/)

```
function shallowClone(source) {
    var target = {};
    for(var i in source) {
        if (source.hasOwnProperty(i)) {
            target[i] = source[i];
        }
    }

    return target;
}
```

## 最简单的深拷贝

深拷贝的问题其实可以分解成两个问题，浅拷贝+递归，什么意思呢？假设我们有如下数据

```
var a1 = {b: {c: {d: 1}};
```

只需稍加改动上面浅拷贝的代码即可，注意区别

```
function clone(source) {
    var target = {};
    for(var i in source) {
        if (source.hasOwnProperty(i)) {
            if (typeof source[i] === 'object') {
                target[i] = clone(source[i]); // 注意这里
            } else {
                target[i] = source[i];
            }
        }
    }

    return target;
}
```

大部分人都能写出上面的代码，但当我问上面的代码有什么问题吗？就很少有人答得上来了，聪明的你能找到问题吗？

其实上面的代码问题太多了，先来举几个例子吧

- 没有对参数做检验
- 判断是否对象的逻辑不够严谨
- 没有考虑数组的兼容

(⊙o⊙)，下面我们来看看各个问题的解决办法，首先我们需要抽象一个判断对象的方法，其实比较常用的判断对象的方法如下，其实下面的方法也有问题，但如果能够回答上来那就非常不错了，如果完美的解决办法感兴趣，不妨看看[这里吧](https://github.com/jsmini/type/blob/master/src/index.js)

```
function isObject(x) {
    return Object.prototype.toString.call(x) === '[object Object]';
}
```

函数需要校验参数，如果不是对象的话直接返回

```
function clone(source) {
    if (!isObject(source)) return source;

    // xxx
}
```

关于第三个问题，嗯，就留给大家自己思考吧，本文为了减轻大家的负担，就不考虑数组的情况了，其实ES6之后还要考虑set, map, weakset, weakmap，/(ㄒoㄒ)/~~

其实吧这三个都是小问题，其实递归方法最大的问题在于爆栈，当数据的层次很深是就会栈溢出

下面的代码可以生成指定深度和每层广度的代码，这段代码我们后面还会再次用到

```
function createData(deep, breadth) {
    var data = {};
    var temp = data;

    for (var i = 0; i < deep; i++) {
        temp = temp['data'] = {};
        for (var j = 0; j < breadth; j++) {
            temp[j] = j;
        }
    }

    return data;
}

createData(1, 3); // 1层深度，每层有3个数据 {data: {0: 0, 1: 1, 2: 2}}
createData(3, 0); // 3层深度，每层有0个数据 {data: {data: {data: {}}}}
```

当clone层级很深的话就会栈溢出，但数据的广度不会造成溢出

```
clone(createData(1000)); // ok
clone(createData(10000)); // Maximum call stack size exceeded

clone(createData(10, 100000)); // ok 广度不会溢出
```

其实大部分情况下不会出现这么深层级的数据，但这种方式还有一个致命的问题，就是循环引用，举个例子

```
var a = {};
a.a = a;

clone(a) // Maximum call stack size exceeded 直接死循环了有没有，/(ㄒoㄒ)/~~
```

关于循环引用的问题解决思路有两种，一直是循环检测，一种是暴力破解，关于循环检测大家可以自己思考下；关于暴力破解我们会在下面的内容中详细讲解

## 一行代码的深拷贝

有些同学可能见过用系统自带的JSON来做深拷贝的例子，下面来看下代码实现

```
function cloneJSON(source) {
    return JSON.parse(JSON.stringify(source));
}
```

其实我第一次简单这个方法的时候，由衷的表示佩服，其实利用工具，达到目的，是非常聪明的做法

下面来测试下cloneJSON有没有溢出的问题，看起来cloneJSON内部也是使用递归的方式

```
cloneJSON(createData(10000)); // Maximum call stack size exceeded
```

既然是用了递归，那循环引用呢？并没有因为死循环而导致栈溢出啊，原来是JSON.stringify内部做了循环引用的检测，正是我们上面提到破解循环引用的第一种方法：循环检测

```
var a = {};
a.a = a;

cloneJSON(a) // Uncaught TypeError: Converting circular structure to JSON
```

## 破解递归爆栈

其实破解递归爆栈的方法有两条路，第一种是消除尾递归，但在这个例子中貌似行不通，第二种方法就是干脆不用递归，改用循环，当我提出用循环来实现时，基本上90%的前端都是写不出来的代码的，这其实让我很震惊

举个例子，假设有如下的数据结构

```
var a = {
    a1: 1,
    a2: {
        b1: 1,
        b2: {
            c1: 1
        }
    }
}
```

这不就是一个树吗，其实只要把数据横过来看就非常明显了

```
    a
  /   \
 a1   a2        
 |    / \         
 1   b1 b2     
     |   |        
     1  c1
         |
         1       
```

用循环遍历一棵树，需要借助一个栈，当栈为空时就遍历完了，栈里面存储下一个需要拷贝的节点

首先我们往栈里放入种子数据，`key`用来存储放哪一个父元素的那一个子元素拷贝对象

然后遍历当前节点下的子元素，如果是对象就放到栈里，否则直接拷贝

```
function cloneLoop(x) {
    const root = {};

    // 栈
    const loopList = [
        {
            parent: root,
            key: undefined,
            data: x,
        }
    ];

    while(loopList.length) {
        // 深度优先
        const node = loopList.pop();
        const parent = node.parent;
        const key = node.key;
        const data = node.data;

        // 初始化赋值目标，key为undefined则拷贝到父元素，否则拷贝到子元素
        let res = parent;
        if (typeof key !== 'undefined') {
            res = parent[key] = {};
        }

        for(let k in data) {
            if (data.hasOwnProperty(k)) {
                if (typeof data[k] === 'object') {
                    // 下一次循环
                    loopList.push({
                        parent: res,
                        key: k,
                        data: data[k],
                    });
                } else {
                    res[k] = data[k];
                }
            }
        }
    }

    return root;
}
```

改用循环后，再也不会出现爆栈的问题了，但是对于循环引用依然无力应对

## 破解循环引用

有没有一种办法可以破解循环应用呢？别着急，我们先来看另一个问题，上面的三种方法都存在的一个问题就是引用丢失，这在某些情况下也许是不能接受的

举个例子，假如一个对象a，a下面的两个键值都引用同一个对象b，经过深拷贝后，a的两个键值会丢失引用关系，从而变成两个不同的对象，o(╯□╰)o

```
var b = 1;
var a = {a1: b, a2: b};

a.a1 === a.a2 // true

var c = clone(a);
c.a1 === c.a2 // false
```

如果我们发现个新对象就把这个对象和他的拷贝存下来，每次拷贝对象前，都先看一下这个对象是不是已经拷贝过了，如果拷贝过了，就不需要拷贝了，直接用原来的，这样我们就能够保留引用关系了，✧(≖ ◡ ≖✿)嘿嘿

但是代码怎么写呢，o(╯□╰)o，别急往下看，其实和循环的代码大体一样，不一样的地方我用`// ==========`标注出来了

引入一个数组`uniqueList`用来存储已经拷贝的数组，每次循环遍历时，先判断对象是否在`uniqueList`中了，如果在的话就不执行拷贝逻辑了

```
find`是抽象的一个函数，其实就是遍历`uniqueList
// 保持引用关系
function cloneForce(x) {
    // =============
    const uniqueList = []; // 用来去重
    // =============

    let root = {};

    // 循环数组
    const loopList = [
        {
            parent: root,
            key: undefined,
            data: x,
        }
    ];

    while(loopList.length) {
        // 深度优先
        const node = loopList.pop();
        const parent = node.parent;
        const key = node.key;
        const data = node.data;

        // 初始化赋值目标，key为undefined则拷贝到父元素，否则拷贝到子元素
        let res = parent;
        if (typeof key !== 'undefined') {
            res = parent[key] = {};
        }
        
        // =============
        // 数据已经存在
        let uniqueData = find(uniqueList, data);
        if (uniqueData) {
            parent[key] = uniqueData.target;
            break; // 中断本次循环
        }

        // 数据不存在
        // 保存源数据，在拷贝数据中对应的引用
        uniqueList.push({
            source: data,
            target: res,
        });
        // =============
    
        for(let k in data) {
            if (data.hasOwnProperty(k)) {
                if (typeof data[k] === 'object') {
                    // 下一次循环
                    loopList.push({
                        parent: res,
                        key: k,
                        data: data[k],
                    });
                } else {
                    res[k] = data[k];
                }
            }
        }
    }

    return root;
}

function find(arr, item) {
    for(let i = 0; i < arr.length; i++) {
        if (arr[i].source === item) {
            return arr[i];
        }
    }

    return null;
}
```

下面来验证一下效果，amazing

```
var b = 1;
var a = {a1: b, a2: b};

a.a1 === a.a2 // true

var c = cloneForce(a);
c.a1 === c.a2 // true
```

接下来再说一下如何破解循环引用，等一下，上面的代码好像可以破解循环引用啊，赶紧验证一下

惊不惊喜，(*^__^*) 嘻嘻……

```
var a = {};
a.a = a;

cloneForce(a)
```

看起来完美的`cloneForce`是不是就没问题呢？`cloneForce`有两个问题

第一个问题，所谓成也萧何，败也萧何，如果保持引用不是你想要的，那就不能用`cloneForce`了；

第二个问题，`cloneForce`在对象数量很多时会出现很大的问题，如果数据量很大不适合使用`cloneForce`

## 性能对比

上边的内容还是有点难度，下面我们来点更有难度的，对比一下不同方法的性能

我们先来做实验，看数据，影响性能的原因有两个，一个是深度，一个是每层的广度，我们采用固定一个变量，只让一个变量变化的方式来测试性能

测试的方法是在指定的时间内，深拷贝执行的次数，次数越多，证明性能越好

下面的`runTime`是测试代码的核心片段，下面的例子中，我们可以测试在2秒内运行`clone(createData(500, 1)`的次数

```
function runTime(fn, time) {
    var stime = Date.now();
    var count = 0;
    while(Date.now() - stime < time) {
        fn();
        count++;
    }

    return count;
}

runTime(function () { clone(createData(500, 1)) }, 2000);
```

下面来做第一个测试，将广度固定在100，深度由小到大变化，记录1秒内执行的次数

| 深度 | clone | cloneJSON | cloneLoop | cloneForce |
| ---- | ----- | --------- | --------- | ---------- |
| 500  | 351   | 212       | 338       | 372        |
| 1000 | 174   | 104       | 175       | 143        |
| 1500 | 116   | 67        | 112       | 82         |
| 2000 | 92    | 50        | 88        | 69         |

将上面的数据做成表格可以发现，一些规律

- 随着深度变小，相互之间的差异在变小
- clone和cloneLoop的差别并不大
- cloneLoop > cloneForce > cloneJSON

![img](zdeepClone.assets/1460000016672266)

我们先来分析下各个方法的时间复杂度问题，各个方法要做的相同事情，这里就不计算，比如循环对象，判断是否为对象

- clone时间 = 创建递归函数 + 每个对象处理时间
- cloneJSON时间 = 循环检测 + 每个对象处理时间 * 2 （递归转字符串 + 递归解析）
- cloneLoop时间 = 每个对象处理时间
- cloneForce时间 = 判断对象是否缓存中 + 每个对象处理时间

cloneJSON的速度只有clone的50%，很容易理解，因为其会多进行一次递归时间

cloneForce由于要判断对象是否在缓存中，而导致速度变慢，我们来计算下判断逻辑的时间复杂度，假设对象的个数是n，则其时间复杂度为O(n2)，对象的个数越多，cloneForce的速度会越慢

```
1 + 2 + 3 ... + n = n^2/2 - 1
```

关于clone和cloneLoop这里有一点问题，看起来实验结果和推理结果不一致，其中必有蹊跷

接下来做第二个测试，将深度固定在10000，广度固定为0，记录2秒内执行的次数

| 宽度 | clone | cloneJSON | cloneLoop | cloneForce |
| ---- | ----- | --------- | --------- | ---------- |
| 0    | 13400 | 3272      | 14292     | 989        |

排除宽度的干扰，来看看深度对各个方法的影响

- 随着对象的增多，cloneForce的性能低下凸显
- cloneJSON的性能也大打折扣，这是因为循环检测占用了很多时间
- cloneLoop的性能高于clone，可以看出递归新建函数的时间和循环对象比起来可以忽略不计

下面我们来测试一下cloneForce的性能极限，这次我们测试运行指定次数需要的时间

```
var data1 = createData(2000, 0);
var data2 = createData(4000, 0);
var data3 = createData(6000, 0);
var data4 = createData(8000, 0);
var data5 = createData(10000, 0);

cloneForce(data1)
cloneForce(data2)
cloneForce(data3)
cloneForce(data4)
cloneForce(data5)
```

通过测试发现，其时间成指数级增长，当对象个数大于万级别，就会有300ms以上的延迟

![img](zdeepClone.assets/1460000016672267)

## 总结

尺有所短寸有所长，无关乎好坏优劣，其实每种方法都有自己的优缺点，和适用场景，人尽其才，物尽其用，方是真理

下面对各种方法进行对比，希望给大家提供一些帮助

|          | clone        | cloneJSON    | cloneLoop | cloneForce   |
| -------- | ------------ | ------------ | --------- | ------------ |
| 难度     | ☆☆           | ☆            | ☆☆☆       | ☆☆☆☆         |
| 兼容性   | ie6          | ie8          | ie6       | ie6          |
| 循环引用 | 一层         | 不支持       | 一层      | 支持         |
| 栈溢出   | 会           | 会           | 不会      | 不会         |
| 保持引用 | 否           | 否           | 否        | 是           |
| 适合场景 | 一般数据拷贝 | 一般数据拷贝 | 层级很多  | 保持引用关系 |

本文的灵感都来自于[@jsmini/clone](https://github.com/jsmini/clone)，如果大家想使用文中的4种深拷贝方式，可以直接使用@jsmini/clone这个库

```
// npm install --save @jsmini/clone
import { clone, cloneJSON, cloneLoop, cloneForce } from '@jsmini/clone';
```

本文为了简单和易读，示例代码中忽略了一些边界情况，如果想学习生产中的代码，请阅读[@jsmini/clone](https://github.com/jsmini/clone)的源码

@jsmini/clone孵化于[jsmini](https://github.com/jsmini)，jsmini致力于为大家提供一组小而美，无依赖的高质量库

jsmini的诞生离不开[jslib-base](https://github.com/yanhaijing/jslib-base)，感谢jslib-base为jsmini提供了底层技术

感谢你阅读了本文，相信现在你能够驾驭任何深拷贝的问题了，如果有什么疑问，欢迎和我讨论

最后推荐下我的新书《React状态管理与同构实战》，深入解读前沿同构技术，感谢大家支持

京东：https://item.jd.com/12403508.html

当当：http://product.dangdang.com/25308679.html

最后最后招聘前端，后端，客户端啦！地点：北京+上海+成都，感兴趣的同学，可以把简历发到我的邮箱： yanhaijing@yeah.net

原文网址：[http://yanhaijing.com/javascr...](http://yanhaijing.com/javascript/2018/10/10/clone-deep/)
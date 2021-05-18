# 语句和声明 - 迭代器 - for...in 和 for...of 对比

> hsq

在我们工作的时候，会不会 `for...in` 和 `for...of` 傻傻分不清，这里我们讲解下这两者的区别：

无论是 `for...in` 还是 `for...of` 语句都是迭代一些东西，它们之间的主要区别在于它们的迭代方式。

`for...in` 语句以任意顺序迭代对象的可枚举属性。

`for...of` 语句遍历可迭代对象定义要迭代的数据。

上代码：

```js
/**
 * @name 区分
 * @description for...of 和 for...in 的区别
 */
Object.prototype.objCustom = function() {};
Array.prototype.arrCustom = function() {};

const iterable = [3, 5, 7];
iterable.foo = 'hello';

for (let i in iterable) {
  console.log(i);
}
// 0
// 1
// 2
// foo
// arrCustom
// objCustom

for (let i in iterable) {
  if (iterable.hasOwnProperty(i)) {
    console.log(i);
  }
}
// 0
// 1
// 2
// foo

for (let i of iterable) {
  console.log(i);
}
// 3
// 5
// 7
```

**首先**，由于继承和原型链的关系，每个对象将继承 `objCustom` 属性，并且作为 `Array` 的每个对象将继承 `arrCustom` 属性。

因此，对象 `iterable` 继承属性 `objCustom` 和 `arrCustom`。

> ```
> iterable.__proto__` 可以查找到 `arrCustom`
> `iterable.__proto__.__proto__` 可以查找到 `objCustom
> ```

**然后**，再我们通过 `for...in` 遍历 `iterable` 对象时，会遍历其所有的可枚举属性。

> 这里不是记录 3、5、7 或者 `hello`，因为这些不是枚举属性，但是会记录数组索引以及 `arrCustom` 和 `objCustom`。

```js
for (let i in iterable) {
  console.log(i);
}
// 0
// 1
// 2
// foo
// arrCustom
// objCustom
```

**接着**，如果我们使用 `hasOwnProperty()` 来检查，那么会检查属于自己的枚举属性（而不是继承的）。

```js
for (let i in iterable) {
  if (iterable.hasOwnProperty(i)) {
    console.log(i);
  }
}
// 0
// 1
// 2
// foo
```

**最后**，需要了解的是 `for...of`，该循环迭代并记录 `iterable` 作为可迭代对象定义的迭代值，即 3、5、7，而不是任何对象的属性。
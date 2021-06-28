# 鹿可

## 关于ReactHooks了解多少

functional组件的：useState，useEffect，useRef，useMemo，useCallback，memo，Suspense，Lazy

我不常用的useLayoutEffect，useReducer，useContext，useImperativeHandle，useDebugValue，useTransition

## 事件和EventLoop之间的关系



讨论了点关于浏览器的多进程多线程，于是又被问到了进程和线程的关系以及区别，聊了一下Linux的进程和线程。



## 关于nodejs

讲一讲为什么nodejs可以实现高并发

> 请你实现如何读取一个500M的大文件，然后能在100ms内响应给前端

聊了Buffer,ReadFile

最终说是用的Stream实现的



## 关于TS

> type 和interface有哪些区别

区别多了去了

### interface VS type

大家使用 typescript 总会使用到 interface 和 type，[官方规范](https://github.com/Microsoft/TypeScript/blob/master/doc/spec.md) 稍微说了下两者的区别

> - An interface can be named in an extends or implements clause, but a type alias for an object type literal cannot.
> - An interface can have multiple merged declarations, but a type alias for an object type literal cannot.
>   但是没有太具体的例子。

明人不说暗话，直接上区别。

#### 相同点

### 都可以描述一个对象或者函数

#### interface

```
interface User {
  name: string
  age: number
}

interface SetUser {
  (name: string, age: number): void;
}
```

#### type

```
type User = {
  name: string
  age: number
};

type SetUser = (name: string, age: number): void;
```

#### 拓展（extends）与 交叉类型（Intersection Types）

interface 可以 extends， 但 type 是不允许 extends 和 implement 的，**但是 type 缺可以通过交叉类型 实现 interface 的 extend 行为**，并且两者并不是相互独立的，也就是说 interface 可以 extends type, type 也可以 与 interface 类型 交叉 。

**虽然效果差不多，但是两者语法不同**。

#### interface extends interface

```
interface Name { 
  name: string; 
}
interface User extends Name { 
  age: number; 
}
```

#### type 与 type 交叉

```
type Name = { 
  name: string; 
}
type User = Name & { age: number  };
```

#### interface extends type

```
type Name = { 
  name: string; 
}
interface User extends Name { 
  age: number; 
}
```

#### type 与 interface 交叉

```
interface Name { 
  name: string; 
}
type User = Name & { 
  age: number; 
}
```

### 不同点

### type 可以而 interface 不行

- type 可以声明基本类型别名，联合类型，元组等类型

```
// 基本类型别名
type Name = string

// 联合类型
interface Dog {
    wong();
}
interface Cat {
    miao();
}

type Pet = Dog | Cat

// 具体定义数组每个位置的类型
type PetList = [Dog, Pet]
```

- type 语句中还可以使用 typeof 获取实例的 类型进行赋值

```
// 当你想获取一个变量的类型时，使用 typeof
let div = document.createElement('div');
type B = typeof div
```

- 其他骚操作

```
type StringOrNumber = string | number;  
type Text = string | { text: string };  
type NameLookup = Dictionary<string, Person>;  
type Callback<T> = (data: T) => void;  
type Pair<T> = [T, T];  
type Coordinates = Pair<number>;  
type Tree<T> = T | { left: Tree<T>, right: Tree<T> };
```

### interface 可以而 type 不行

interface 能够声明合并

```
interface User {
  name: string
  age: number
}

interface User {
  sex: string
}

/*
User 接口为 {
  name: string
  age: number
  sex: string 
}
*/
```

#### 总结

一般来说，如果不清楚什么时候用interface/type，能用 interface 实现，就用 interface , 如果不能就用 type 。其他更多详情参看 [官方规范文档](https://github.com/Microsoft/TypeScript/blob/master/doc/spec.md)

> 如果是想让一个接口继承一个基本类型

答案是使用type

```ts
type Name = string
function sayName(name:Name){
  console.log(name)
}
```


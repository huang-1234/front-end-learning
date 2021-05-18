# webpack详解

## 一种讲法

## Context

`Webpack` 在查找相对路径的时候，会以 `context` 为根目录进行查找，`context` 的默认值是 `Webpack` 启动路径，如果需要修改 `context` 的值也可以手动修改：

```js
const path = require('path');

module.exports = {
  context: path.join(__dirname, 'src');
}
复制代码
```

### Context 类型

| 类型     | 例子                          | 含义                                        |
| -------- | ----------------------------- | ------------------------------------------- |
| `string` | `path.join(__dirname, 'src')` | 设置 `Webpack` 的上下文，**必须是绝对路径** |

现在就将相对路径的根目录改成了 `src`，这个时候使用相对路径就是从 `src` 目录下进行查找。例如上面的 `entry`，就会从 `src` 目录下进行查找，也就是 `src/index.js`。

## Entry

`entry` 是 `Webpack` 配置模块的入口，`Webpack` 开始构建时会从 `entry` 的文件开始递归解析出所有依赖的模块。

举个例子：

```js
const path = require('path');

module.exports = {
  devtool: false,
  mode: 'development',
  entry: './index.js',
  output: {
    filename: 'bundle.js',
    path: path.join(__dirname, './'),
  },
};
复制代码
const module1 = require('module1');

module1();
复制代码
function module1() {
  console.log('module1');
}

module.exports = module1;
复制代码
```

那么 `Webpack` 构建的时候会从 `index.js` 开始，解析依赖到了 `module1`，于是会将 `module1` 中的代码打包进 `bundle.js`。

例如：

```js
function module1() {
  console.log('module1');
}

module1();
复制代码
```

### Entry 类型

| 类型     | 例子                                                         | 含义                                 |
| -------- | ------------------------------------------------------------ | ------------------------------------ |
| `string` | `./index.js`                                                 | 入口模块的文件路径，可以是相对路径   |
| `array`  | `['./index.js', './main.js']`                                | 入口模块的文件路径，可以是相对路径   |
| `object` | `{ index: './index.js', main: ['./main.js', './src/index.js']}` | 多入口配置，每个入口生成一个 `chunk` |

### Entry 描述

- `dependOn`：当前入口文件依赖的入口文件，即必须在入口文件被加载之前加载依赖的入口文件
- `filename`：指定当前入口文件构建后输出的文件名称
- `import`：启动构建时被夹加载的模块
- `library`：配置入口文件的选项
- `runtime`：运行时 `chunk` 的名称，如果设置了此选项将会创建一个同名的运行时 `chunk`，否则将会使用入口文件作为运行时

例如：

```js
module.exports = {
  entry: {
    index: './index.js',
    main: {
      dependOn: 'index',
      import: './main.js',
    },
  },
};
复制代码
```

构建时会等待 `index` 构建完成后再启动 `main` 的构建。

对于单个入口，`dependOn` 和 `runtime` 不能同时存在：

```js
module.exports = {
  entry: {
    index: './index.js',
    main: {
      dependOn: 'index',
      runtime: 'other',
      import: './main.js',
    },
  },
};
复制代码
```

这种情况是不符合要求的，会报错。

对于单个入口，`runtime` 不能是已经存在的入口文件名称：

```js
module.exports = {
  entry: {
    index: './index.js',
    main: {
      runtime: 'index',
      import: './main.js',
    },
  },
};
复制代码
```

这种情况也是不符合要求的，会报错。

小心循环依赖：

```js
module.exports = {
  entry: {
    index: {
      dependOn: 'main',
      import: './index.js',
    },
    main: {
      dependOn: 'index',
      import: './main.js',
    },
  },
};
复制代码
```

这种情况会产生循环依赖，同样会报错。

### 实例

下面举例几个在实际的生产环境中会用到的例子：

#### 分离代码和依赖

```js
module.exports = {
  entry: {
    main: './src/app.js',
    vendor: './src/vendor.js',
  },
};
复制代码
module.exports = {
  output: {
    filename: '[name].[contenthash].bundle.js',
  },
};
复制代码
module.exports = {
  output: {
    filename: '[name].bundle.js',
  },
};
复制代码
```

这样做是在告诉 `Webpack` 需要打包两个单独的 `chunk`。

这样做的好处在于可以将一些基本不会修改的依赖（例如 `jQuery` `Bootstrap`）放在 `vendor` 当中，这些依赖会被打包在一起生成一个 `chunk`。由于这些依赖基本不会有变化，所以这些依赖的 `contenthash` 也不会发生变化，能够更好地优化浏览器缓存。

#### 多页应用

```js
module.exports = {
  entry: {
    pageOne: './src/pageOne/index.js',
    pageTwo: './src/pageTwo/index.js',
    pageThree: './src/pageThree/index.js',
  },
};
复制代码
```

这样做是在告诉 `Webpack` 需要打包三个单独的 `chunk`。

在多页应用里，每访问一个页面就会重新获取一个新的 `HTML` 文档。当新的 `HTML` 文档被加载的时候，资源也会被重新下载。

为了解决这个问题 `Webpack` 提供了一个类似 `optimization.splitChunks` 的能力，能够创建各个页面之间公共的 `bundle`。随着多页应用的入口增多，这种代码重用机制的收益会越来越高。

### `chunk` 名称

1. 如果 `entry` 类型为 `string` 或者 `array`，就只会生成一个 `chunk`，且名称为 `main`；
2. 如果 `entry` 类型为 `object`，则会生成多个 `chunk`，名称为 `object` 的 `key`；

### 动态配置 Entry

如果需要动态配置 `entry`，可以将 `entry` 设置为一个函数，支持同步和异步：

```js
module.exports = {
  // 同步
  entry: function syncEntry() {
    return {
      index: './index.js',
      main: './main.js',
    };
  },
  // 异步
  entry: function asyncEntry() {
    return new Promise(function (resolve) {
      resolve({
        index: './index.js',
        main: './main.js',
      });
    });
  },
};
复制代码
```

### 多入口配置

如果需要创建多个 `chunk`，或者使用了 `CommonsChunkPlugin` 之类的插件，则应该使用**模板语法**来替换 `filename`，确保每个 `chunk` 都有单独的名称。

```js
module.exports = {
  entry: {
    app: './src/app.js',
    search: './src/search.js',
  },
  output: {
    filename: '[name].js',
  },
};
复制代码
```

## Output

`output` 是 `Webpack` 配置输出文件的文件名、路径等信息的选项。对于多个入口，只需要配置一个 `output`。

最基础的用法只需要配置一个 `filename` 选项即可：

```js
module.exports = {
  output: {
    filename: 'bundle.js',
  },
};
复制代码
```

这样配置将会输出一个 `bundle.js` 在 `dist` 目录下。


作者：炽翎
链接：https://juejin.cn/post/6926760819375996941
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
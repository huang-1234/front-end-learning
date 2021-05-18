# learnWebpack

## 优化css代码嵌入dom，减少对dom的操作

## 优化 Demo（使用 plugin）

这个时候就需要对 `bundle.js` 做一些优化，将 `CSS` 文件与 `bundle.js` 分离，然后可以单独引入 `CSS` 样式文件。

`Webpack` 拥有 `plugin` 机制，可以使用 `plugin` 在打包过程中的某个阶段对代码进行处理。

要分离样式文件，就需要使用到一个 `plugin`：`MiniCssExtractPlugin`。

执行以下命令：

```bash
yarn add mini-css-extract-plugin --dev
复制代码
```

安装 `MiniCssExtractPlugin`，然后再对 `webpack.config.js` 做一些修改：

```js
// webpack.config.js
const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  // 开发者工具 不需要开发调试
  devtool: false,
  // 开发模式 不进行代码压缩
  mode: 'development',
  // 入口文件
  entry: './index.js',
  output: {
    // 输出文件名称
    filename: 'bundle.js',
    // 输出文件路径
    path: path.join(__dirname, './'),
  },
  module: {
    rules: [
      {
        // 正则匹配后缀名为 .css 的文件
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader'],
      },
    ],
  },
  plugins: [new MiniCssExtractPlugin()],
};
复制代码
```

再执行 `yarn build`，会发现在当前目录下多了一个 `main.css`。

回到 `index.html` 中，将分离出来的 `main.css` 单独引入：

```html
<!-- index.html -->
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>basic webpack demo</title>
    <link rel="stylesheet" href="./main.css" />
  </head>
  <body>
    <div id="app"></div>
    <script src="./bundle.js"></script>
  </body>
</html>
复制代码
```

再回到页面中，`Hello, Webpack!` 也实现了水平居中。打开控制台，可以看到样式 `main.css` 被正确引入了。
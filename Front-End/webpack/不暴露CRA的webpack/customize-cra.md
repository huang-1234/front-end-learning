# 使用 customize-cra 修改 webpack 配置

使用 customize-cra 修改 webpack 配置
一、为什么使用 customize-cra
二、customize-cra 使用步骤
三、customize-cra 常用配置
一、为什么使用 customize-cra
说到 webpack 配置，很多人都知道在项目根目录下创建 webpck.config.js 文件，然后在该文件中配置参数即可。

但是如果使用脚手架命令，如 create-react-app myproject 创建的项目,是不需要手动配置 webpack 的。但是因项目需要单独配置或者覆盖原始 webpack 配置，该如何做昵？

比较极端的方法是可以使用 npm run eject 命令将 webpack.config.js 暴露出来。然后在该配置文件中进行修改。但其一，该命令是不可逆的。也就是一旦执行了此命令。webpack.config.js 文件就永久的暴露出来。其二，如果只是修改一个很小的配置项。是否可以不执行 npm run eject 也能够配置 webpack 昵。这就是 customize-cra 的作用。

二、customize-cra 使用步骤
1 下载 customize-cra 和 react-app-rewired。
```js
npm install customize-cra react-app-rewired --dev
```
2 更改 package.json 中的 scripts 配置，如下所示。即用 react-app-rewired命令代替 react-scripts
```js
 "scripts": {
    "start": "react-app-rewired start",
    "build": "react-app-rewired build",
    "test": "react-app-rewired test",
    "eject": "react-app-rewired eject"
  },
```
3 在项目根目录下添加 config-overrides.js 文件。在该文件中配置 webpack。

三、customize-cra 常用配置
引入 antd 样式文件，需要下载 babel-plugin-import。
npm install babel-plugin-import --dev
1
在 react 项目中，经常使用 antd 作为组件库。在引入并使用了 antd 组件后，会发现样式没有生效。所以这时候就要单独引入 antd 的 css 样式文件，配置如下。
```js
const { override, fixBabelImports} = require('customize-cra');
module.exports = override(
 // 在这里使用 customize-cra 里的一些函数来修改配置
  fixBabelImports('import', {
    libraryName: 'antd',
    libraryDirectory: 'es',
    style: 'css' //或者true, true代表运用less
  })
);
```
按照以上步骤配置好之后，重启项目，antd 样式生效。

使用 Less，需要下载 less 和 less-loader。

```js
npm install less less-loader --dev
```
如果在项目中使用到了 Less 。需要使用 customize-cra 中的 addLessLoader 模块来配置 Less。该配置当于在 webpack.config.js 里面配置 less-loader 。

以下配置不仅实现了 less-loader，还设置了 less 模块化语法，但是只能是以 .module.less 的文件才能实现模块化。
```js
const { override, addLessLoader } = require('customize-cra');
module.exports = override(
    addLessLoader({
        lessOptions: {
           javascriptEnabled: true,
           localIdentName: '[local]--[hash:base64:5]'
        }
    }),
);
```
添加别名，设置相对路径。
创建 import 或 require 的别名，来确保模块引入变得更简单。例如，一些位于 src/ 文件夹下的常用模块。使用 customize-cra 中的 addWebpackAlias 模块来实现该功能。
```js
const { override, addWebpackAlias} = require('customize-cra');
const path = require('path');
module.exports = override(    
    addWebpackAlias({      
["containers"]: path.resolve(__dirname, "src/containers"),        
["components"]: path.resolve(__dirname, "src/components""
    })
```
引入时直接
```js
import containers from 'containers';
import components from 'components';

// 等同于

import containers from '"src/containers"';
import components from 'src/components';
```
------------------------------------------------
版权声明：本文为CSDN博主「杏子_1024」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_44135121/article/details/109850564

### [深入浅出 Create React App - 凝果屋的韩亦乐 - 博客园](http://www.baidu.com/link?url=0mH-ndPNJZ0Q9A85G9vzkAC35d2M9szc8MB4uJ0wzamlDLh8fr942K9tXKU2WKUbJoN64_uKupP2pL0RL7QE-_)

[深入浅出CRA](https://www.cnblogs.com/corvoh/p/12175139.html)


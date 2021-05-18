

## url-loader

**v5 后弃用**：请考虑使用 [`asset modules`](https://webpack.docschina.org/guides/asset-modules/) 代替。

用于将文件转换为 base64 URI 的 loader。

## 快速开始

首先，你需要安装 `url-loader`：

```js
npm install url-loader --save-dev
```

`url-loader` 功能类似于 [`file-loader`](https://webpack.docschina.org/loaders/file-loader/), 但是在文件大小（单位为字节）低于指定的限制时，可以返回一个 DataURL。

**index.js**

```js
import img from './image.png';
```

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|jpg|gif)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 8192,
            },
          },
        ],
      },
    ],
  },
};
```

然后通过你的首选方法运行 `webpack`。

## 选项

| Name                                                         | Type                      | Default                                                      | Description                                  |
| :----------------------------------------------------------- | :------------------------ | :----------------------------------------------------------- | :------------------------------------------- |
| **[`limit`](https://webpack.docschina.org/loaders/url-loader/#limit)** | `{Boolean|Number|String}` | `true`                                                       | 指定文件的最大体积（以字节为单位）。         |
| **[`mimetype`](https://webpack.docschina.org/loaders/url-loader/#mimetype)** | `{Boolean|String}`        | 基于 [mime-types](https://github.com/jshttp/mime-types) 库实现转换 | 设置要转换的文件的 MIME 类型。               |
| **[`encoding`](https://webpack.docschina.org/loaders/url-loader/#encoding)** | `{Boolean|String}`        | `base64`                                                     | 指定用于内联文件的编码。                     |
| **[`generator`](https://webpack.docschina.org/loaders/url-loader/#generator)** | `{Function}`              | `() => type/subtype;encoding,base64_data`                    | 你可以创建自己的自定义实现以对数据进行编码。 |
| **[`fallback`](https://webpack.docschina.org/loaders/url-loader/#fallback)** | `{String}`                | `file-loader`                                                | 指定当目标文件大小超过限制时的替代 loader。  |
| **[`esModule`](https://webpack.docschina.org/loaders/url-loader/#esmodule)** | `{Boolean}`               | `true`                                                       | 使用 ES 模块语法。                           |

### `limit` 

类型: `Boolean|Number|String` 默认值: `true`

该值可以通过 loader 的 options 参数来指定，默认为 `undefined`。

#### `Boolean` 

开启/关闭将文件转换为 base64。

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|jpg|gif)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: false,
            },
          },
        ],
      },
    ],
  },
};
```

#### `Number|String` 

指定文件的最大体积（以字节为单位）。 <font color=red>如果文件体积**等于**或**大于**限制，默认情况下将使用 [`file-loader`](https://webpack.docschina.org/loaders/file-loader/) 并将所有参数传递给它。</font>

可以通过 `fallback` 选项设置 `file-loader` 的可选参数。

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|jpg|gif)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 8192,
            },
          },
        ],
      },
    ],
  },
};
```

### `mimetype` 

类型: `Boolean|String` 默认值: 基于第三方库 [mime-types](https://github.com/jshttp/mime-types) 来获取 mimetype。

指定用于内联文件的 `mimetype`。 如果未指定，将使用第三方库 [mime-types](https://github.com/jshttp/mime-types) 来获取 mimetype。

#### `Boolean` 

当值为 `true` 时，允许使用第三方库 [mime-types](https://github.com/jshttp/mime-types) 来获取 mimetype。 而为 `false` 时，则从数据 URL 中删除 `mediatype` 部分（如果省略，则默认为 `text/plain；charset=US-ASCII`）。

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|jpg|gif)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              mimetype: false,
            },
          },
        ],
      },
    ],
  },
};
```

#### `String` 

设置要转换的文件的 MIME 类型。

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|jpg|gif)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              mimetype: 'image/png',
            },
          },
        ],
      },
    ],
  },
};
```

### `encoding` 

类型: `Boolean|String` 默认值: `base64`

指定用于内联文件的编码格式。 如果未指定，则 `encoding` 为 `base64`。

#### `Boolean` 

如果不想使用任何编码，可以将 “encoding” 设置为 `false`，如果将其设置为 `true`，则默认使用 `base64`。

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.svg$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              encoding: false,
            },
          },
        ],
      },
    ],
  },
};
```

#### `String` 

它支持下面的编码格式（[Node.js Buffers and Character Encodings](https://nodejs.org/api/buffer.html#buffer_buffers_and_character_encodings)）：`["utf8","utf16le","latin1","base64","hex","ascii","binary","ucs2"]`。

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.svg$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              encoding: 'utf8',
            },
          },
        ],
      },
    ],
  },
};
```

### `generator` 

类型： `Function` 默认值：`(mimetype, encoding, content, resourcePath) => mimetype;encoding,base64_content`

你可以使用自定义方案来编码数据。

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|html)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              // `mimetype` 和 `encoding` 参数将从你传入的参数中中获得
              // `resourcePath` 参数是文件的路径。
              generator: (content, mimetype, encoding, resourcePath) => {
                if (/\.html$/i.test(resourcePath)) {
                  return `data:${mimetype},${content.toString()}`;
                }

                return `data:${mimetype}${
                  encoding ? `;${encoding}` : ''
                },${content.toString(encoding)}`;
              },
            },
          },
        ],
      },
    ],
  },
};
```

### `fallback` 

类型: `String` 默认值: `'file-loader'`

指定当目标文件的大小超过 `limit` 选项中设置的限制时要使用的替代加载程序。

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|jpg|gif)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              fallback: require.resolve('responsive-loader'),
            },
          },
        ],
      },
    ],
  },
};
```

当使用降级 loader 时，其配置项与 url-loader 的配置项相同。

例如为替代 loader（responsive-loader）设置 `quality` 参数：

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.(png|jpg|gif)$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              fallback: require.resolve('responsive-loader'),
              quality: 85,
            },
          },
        ],
      },
    ],
  },
};
```

### `esModule` 

类型: `Boolean` 默认值: `true`

默认情况下，`file-loader` 生成使用 ES modules 语法的JS模块。 在某些情况下，使用 ES 模块更为合适，比如在 [module concatenation](https://webpack.docschina.org/plugins/module-concatenation-plugin/) 和 [tree shaking](https://webpack.docschina.org/guides/tree-shanking/)。

你可以通过以下命令启用 CommonJS 模块语法：

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          {
            loader: 'url-loader',
            options: {
              esModule: false,
            },
          },
        ],
      },
    ],
  },
};
```

## 示例 

### SVG 

SVG 可以被压缩至体积更小，尽量避免使用 `base64`。 你可以从[这里](https://css-tricks.com/probably-dont-base64-svg/)了解更多信息。 你可以使用 [mini-svg-data-uri](https://github.com/tigt/mini-svg-data-uri) 来压缩 SVG。

**webpack.config.js**

```js
const svgToMiniDataURI = require('mini-svg-data-uri');

module.exports = {
  module: {
    rules: [
      {
        test: /\.svg$/i,
        use: [
          {
            loader: 'url-loader',
            options: {
              generator: (content) => svgToMiniDataURI(content.toString()),
            },
          },
        ],
      },
    ],
  },
};
```

## 贡献 

如果你还没有阅读我们的贡献指南，请花一点时间阅读。

[CONTRIBUTING](https://github.com/webpack-contrib/url-loader/blob/master/.github/CONTRIBUTING.md)

## License 

[MIT](https://github.com/webpack-contrib/url-loader/blob/master/LICENSE)

« Previous
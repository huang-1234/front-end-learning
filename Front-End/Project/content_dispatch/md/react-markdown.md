# [react-markdown 使用总结](https://segmentfault.com/a/1190000020294373)

## 示例和代码

[react-code-previewer](http://awbeci.xyz/react-code-previewer/)

## 前言

react-markdown 是一款非常优秀的 markdown 转 html 的 react 组件，但是官方文档是全英文而且也没有说明的太详细，我就把自己开发遇到的问题以及总结记录下来，希望帮助更多的开发人员。

## 安装和使用

### 安装

```
npm install --save react-markdown
yarn add react-markdown
```

### 基本使用

```
const React = require('react')
const ReactDOM = require('react-dom')
const ReactMarkdown = require('react-markdown')

const input = '# This is a header\n\nAnd this is a paragraph'

ReactDOM.render(<ReactMarkdown source={input} />, document.getElementById('container'))
```

这里有个问题 source 属性是直接设置成 input 字符串，当然如果你想记录的文字不多倒还好，如果你是想做成文档形式那么设置成字符串显然不好，正确的操作应该是获取.md 文件内容给source属性，下面我们就来讲如何操作。

## react-markdown source 属性从 .md 文件中获取内容

### 配置webpack

在使用之前我们要设置 webpack 支持.md 文件，要不然直接引入会报错，代码如下：

```
npm install -D raw-loader
yarn add -D raw-loader
 rules: [
      {
        test: /\.md$/,
        use: "raw-loader"
      },
      ...
```

这样设置好之后就可以了，然后我们就可以直接引入.md 文件做为 source 属性了，是不是非常方便！

api.md

```
## API

### PreviewLayout

| 参数     | 说明                       | 类型 | 默认值 | 版本  |
| :------- | :------------------------- | :--: | :----: | :---: |
| children | 传递的组件，可以是任意组件 | jsx  |  null  | 0.1.0 |

### MdPreviewer

| 参数 | 说明          |  类型  | 默认值 | 版本  |
| :--- | :------------ | :----: | :----: | :---: |
| md   | markdown 文档 | string |  null  | 0.1.0 |

### CodePreviewer

| 参数     | 说明           |  类型  | 默认值 | 版本  |
| :------- | :------------- | :----: | :----: | :---: |
| code     | 要显示的代码   | string |  null  | 0.0.1 |
| showCode | 是否要展示代码 |  bool  |  true  | 0.1.0 |
import apiMd from "../md/api.md";
<ReactMarkdown
  source={apiMd}
  escapeHtml={false}
  renderers={{
    code: CodeBlock,
    heading: HeadingBlock
  }}
/>
```

运行看看

## SyntaxHighlighter 设置语法高亮

react-markdown 默认设置代码只有个灰色背景，并没有对语法进行高亮设置，我们可以根据它提供的Node types 的 code 属性进行自定义语法高亮，这里我们要引入SyntaxHighlighter包。

```
npm install react-syntax-highlighter
yarn add react-syntax-highlighter
```

然后，新建一个CodeBlock.js 文件

```
import React, { PureComponent } from "react";
import PropTypes from "prop-types";
import { PrismLight as SyntaxHighlighter } from "react-syntax-highlighter";
// 设置高亮样式
import { coy } from "react-syntax-highlighter/dist/esm/styles/prism";
// 设置高亮的语言
import { jsx, javascript, sass, scss } from "react-syntax-highlighter/dist/esm/languages/prism";

class CodeBlock extends PureComponent {
  static propTypes = {
    value: PropTypes.string.isRequired,
    language: PropTypes.string
  };

  static defaultProps = {
    language: null
  };

  componentWillMount() {
    // 注册要高亮的语法，
    // 注意：如果不设置打包后供第三方使用是不起作用的
    SyntaxHighlighter.registerLanguage("jsx", jsx);
    SyntaxHighlighter.registerLanguage("javascript", javascript);
  }

  render() {
    const { language, value } = this.props;
    return (
      <figure className="highlight">
        <SyntaxHighlighter language={language} style={coy}>
          {value}
        </SyntaxHighlighter>
      </figure>
    );
  }
}

export default CodeBlock;
```

这里有三点要说明一下：

- 设置语法高亮的语言

```
import { jsx, javascript, sass, scss } from "react-syntax-highlighter/dist/esm/languages/prism";
```

node_modules/react-syntax-highlighter/dist/esm/languages/prism下有好多语言提供选择，你们可以自己按照自己的意思挑选要引入的语言，上面是我引入的语言。

- 注册你的语言

上面我们引入了语言包，我们还要注册一下，如果不注册的话，有可能打包后的高亮不起作用，以防万一我们把需要的语言都注册下。

```
SyntaxHighlighter.registerLanguage("jsx", jsx);
SyntaxHighlighter.registerLanguage("javascript", javascript);
```

- 设置语法高亮样式

```
import { coy } from "react-syntax-highlighter/dist/esm/styles/prism";
```

node_modules/react-syntax-highlighter/dist/esm/styles/prism下有好多样式提供选择，我选择的是 coy，你们可以自己一个个试试挑选自己喜欢的语法高亮颜色。

下面我们再看看这段代码

```
render() {
    const { language, value } = this.props;
    return (
      <figure className="highlight">
        <SyntaxHighlighter language={language} style={coy}>
          {value}
        </SyntaxHighlighter>
      </figure>
    );
  }
```

通过从 props 获取要设置的语言 language，代码 value，样式从本地设置为 coy，那么父组件里面我们这样设置：

```
import CodeBlock from "../CodeBlock";
import codePreviewMd from "../md/codePreviewer.md";

<ReactMarkdown
  source={codePreviewMd}
  escapeHtml={false}
  renderers={{
    code: CodeBlock,
    heading: HeadingBlock
  }}
/>
```

那么我们 codePreviewer.md 文件里面就可以这样设置代码

codePreviewer.md

\```html
<div>
<section></section>
</div>
\```

\```jsx
import { PreviewLayout } from "react-code-previewer";

<PreviewLayout></PreviewLayout>;
\```

上面的 html & code 和 jsx & code 就会通过 code:CodeBlock 以 language 和 value传入到CodeBlock。

## 设置 <h123456 标题anchor 锚点功能

通过发现我们知道 github 的 markdown 的 README.md 文档是有锚点功能的，我们现在使用的 react-markdown是没有这个功能的，那么我们只能自定义了，好在 react-markdown 为我们提供了重写 h 标签的属性：heading，下面我们来看看如何设置。

### 什么是锚点？

使用命名锚记可以在文档中设置标记，这些标记通常放在文档的特定主题处或顶部。然后可以创建到这些命名锚记的链接，这些链接可快速将访问者带到指定位置。

所以锚点功能包含两个部分：**id 标记(或者 name 标记)** 和 **定位锚点的链接** 两部分构成，如下是我设置 h 标签锚点的代码：

```
<h1 id='h1-anchor-id'>
  <span>{children}</span>
  <a href='#h1-anchor-id'>#</a>
</h1>
```

点击 a 标签就可以定位到 id='h1-anchor-id'的h1。这里有个问题就是我的标题可能是 h1-h6 我不可能每次都自己写 上面的代码如

```
<h2 id='h1-anchor-id'>
  <span>{children}</span>
  <a href='#h1-anchor-id'>#</a>
</h2>
<h3 id='h1-anchor-id'>
  <span>{children}</span>
  <a href='#h1-anchor-id'>#</a>
</h3>
```

这显然代码有点冗余了，我们只有自己写个公共的方法去设置 h1-h6，我们创建一个 Heading.js文件
Heading.js

```
import React from "react";

const elements = {
  h1: "h1",
  h2: "h2",
  h3: "h3",
  h4: "h4",
  h5: "h5",
  h6: "h6"
};

function Heading({ level, children, ...props }) {
  return React.createElement(elements[level] || elements.h1, props, children);
}

Heading.defaultProps = {
  type: "h1"
};

export default Heading;
```

这样我通过你传递进来的 level属性决定使用 h1-h6 中的某个标题了。
接下来我们创建HeadingBlock.js 文件

HeadingBlock.js

```
import React, { PureComponent } from "react";
import PropTypes from "prop-types";
import cls from "classnames";
import Heading from "./Heading";

class HeadingBlock extends PureComponent {
  renderHtml = () => {
    const { level, children } = this.props;

    if (children && children.length > 0) {
      const nodeValue = children[0].props.value;
      return (
        <Heading level={`h${level}`} id={nodeValue}>
          <span className="title">{children}</span>
          <a href={`#${nodeValue}`} className="link">
            #
          </a>
        </Heading>
      );
    } else {
      return <>{children}</>;
    }
  };
  render() {
    return <>{this.renderHtml()}</>;
  }
}

export default HeadingBlock;
```

如上面代码所示，我们通过父组件传递进来的 level：就是 1-6 数值, children：标题内容，如 level:2，children:'这是标题内容'，其实就是 markdown 里的：## 这是标题内容。这样就把 level 传递到 Heading组件就可选用你设置的 h 了，这样锚点功能就设置完毕，我们再来看看父组件代码如何设置

```
import CodeBlock from "CodeBlock";
import HeadingBlock from "HeadingBlock";
import codePreviewMd from "../md/codePreviewer.md";

<ReactMarkdown
  source={codePreviewMd}
  escapeHtml={false}
  renderers={{
    code: CodeBlock,
    heading: HeadingBlock
  }}
/>
```

## 总结

1、react-markdown 解决了我们渲染 markdown文件样式和语法高亮问题
2、react-syntax-highlighter 解决我们渲染 markdown 语法高亮问题，其实它可以单独使用的，具体的请查看官方文档
3、react-syntax-highlighter设置的语言要注册一下，如：`SyntaxHighlighter.registerLanguage("jsx", jsx);`否则可能不起作用
4、react-markdown 提供了好多替代方案都包含在 [Node Types](https://github.com/rexxars/react-markdown#node-types) 里面

## 引用

> [react-markdown](https://github.com/rexxars/react-markdown)
> [react-syntax-highlighter](https://github.com/conorhastings/react-syntax-highlighter)
> [cross-reference-named-anchor-in-markdown](https://stackoverflow.com/questions/5319754/cross-reference-named-anchor-in-markdown)
> [为 Markdown 文档指定标题 id](https://blog.tankery.me/development/spesific-header-id-for-markdown)
> [markdown 语法教程](https://www.axihe.com/markdown-deu/markdown-hello/markdown-tutorial.html)
> [markdown 语法](http://www.markdown.cn/)
> [react-markdown-code-and-syntax-highlighting](https://medium.com/young-developer/react-markdown-code-and-syntax-highlighting-632d2f9b4ada)


# nextjs渲染分析

## 入口

这是一个基础demo，由开发者自己提供server，用于渲染

```
const Koa = require('koa')
const Router = require('koa-router')
const next = require('next')
// 创建实例
const app = next({ dev, conf, dir: './src' })
app.prepare().then(() => {
  const server = new Koa()
  const router = new Router()
  router.get('/', async ctx => {
    // 渲染
    await app.render(ctx.req, ctx.res)
    ctx.respond = false
  })
  server.listen(port)
})
```

在自定义服务端中通过`const app = next()`创建实例并使用`app.render(req, res)`方法进行渲染

所以直接从app.render这个渲染入口开始着手

> 了解框架逻辑唯一的方式就是看源码，由于源码过于细节，下面我会简化涉及到的代码，仅保留主要逻辑，附带具体地址，有兴趣深入的同学可以看看

## app.render

```
next-server/server/next-server.ts
import { renderToHTML } from './render.tsx'

// app.render入口函数
this.render(req, res){
    const html = await this.renderToHTML(req, res)
    return this.sendHTML(req, res, html)
}
this.renderToHTML(req, res){
    const html = await this.renderToHTMLWithComponents(req, res)
    return html
}
this.renderToHTMLWithComponents(req, res) {
    // render内的renderToHTML
    return renderToHTML(req, res)
}
```

可以看到上面都是简单的调用关系，虽然删除了大部分代码，但我们只需要知道，最终它调用了`render.tsx`内的`renderToHTML`

这是一个相当长的函数，也就是本篇文章的主要内容，通过`renderToHTML`能够了解到大部分内容，和上面相同，删除了大部分逻辑，仅保留核心代码

## renderToHTML

```
// next-server/server/render.tsx
function renderToHTML(req, res) {
// 参考下文#补充 loadGetInitialProps，非常简单的函数，就是调用了_app.getInitialProps
// _app.getInitialProps函数内部会先调用pages.Component的getInitialProps
// 也就是在这里，我们编写的组件内的getInitialProps同样会被调用，获取部分初始数据
  let props = await loadGetInitialProps(App, { Component, router, ctx });
  
  // 定义渲染函数，返回html和head
  const renderPage = () => {
    // 参考下文#补充 render
    return render(
      renderToStaticMarkup,
      //渲染_app,以及其内部的pages.Component也就是我们编写的代码，详情参考next/pages/_app.tsx
      <App
        Component={EnhancedComponent}
        router={router}
        {...props}
      />
    );
  };
  
// _document.getInitialProps会调用renderPage，渲染_app也就是我们的正常开发时编写的组件代码，详情参考next/pages/_app.tsx
  const docProps = await loadGetInitialProps(Document, { ...ctx, renderPage });
  
// 参考下文#补充 renderDocument
  let html = renderDocument(Document, {
    props,
    docProps,
  });
  return html;
}
```

## 小结

```
req=>
render(req, res)
    renderToHTML(req, res)
        renderToHTMLWithComponents(req, res)
            renderToHTML(req,res)
                _app.initialProps = loadGetInitialProps(App, { Component, router, ctx })
                _document.initialProps = loadGetInitialProps(Document, { ...ctx, renderPage })
                renderDocument(Document, _app.initialProps, _document.initialProps)
<=res
```

对应

```
req=>
    _app.getInitialProps()
        Component.getInitialProps()
    _document.getInitialProps()
        _app.render()
            Component.render()
    _document.render()
<=res
```

这篇文章简要描述next服务端的渲染过程，从中我们也能清楚_document、_app、以及pages内自己编写的组件之间的关系...

要是还没明白，请重新阅读一遍renderToHTML函数内的注释内容

需要注意的一些点，随缘补充

- _document只在服务端被执行，浏览器端是不会执行的
- react提供的renderToString函数只产出html，也就是纯粹的string，所有数据必须在调用renderToString之前注入
- 在浏览器端渲染时，存在isInitialRender用于标示是否第一次渲染，如果是第一次渲染，会调用ReactDOM.hydrate(reactEl, domEl)来执行绑定事件，所以部分生命周期（componentWillMount之后）以及事件会在浏览器端执行。

## 补充

上文中出现的部分函数，直接截取自源码，都相对简单，可以作为参考

#### render

```
function render(
    renderElementToString: (element: React.ReactElement<any>) => string,
    element: React.ReactElement<any>,
    ampMode: any,
  ): { html: string; head: React.ReactElement[] } {
    let html
    let head
  
    try {
      html = renderElementToString(element)
    } finally {
      head = Head.rewind() || defaultHead(undefined, isAmp(ampMode))
    }
  
    return { html, head }
  }
```

#### loadGetInitialProps

```
export async function loadGetInitialProps<C extends BaseContext, IP = {}, P = {}>(Component: NextComponentType<C, IP, P>, ctx: C): Promise<IP | null> {
    if (process.env.NODE_ENV !== 'production') {
      if (Component.prototype && Component.prototype.getInitialProps) {
        const message = `"${getDisplayName(Component)}.getInitialProps()" is defined as an instance method - visit https://err.sh/zeit/next.js/get-initial-props-as-an-instance-method for more information.`
        throw new Error(message)
      }
    }
    // when called from _app `ctx` is nested in `ctx`
    const res = ctx.res || (ctx.ctx && ctx.ctx.res)
  
    if (!Component.getInitialProps) {
      return null
    }
  
    const props = await Component.getInitialProps(ctx)
  
    if (res && isResSent(res)) {
      return props
    }
```

#### renderDocument

```
function renderDocument(
    Document: DocumentType,
    {...很多参数，太长省略}
  ): string {
    return (
      '<!DOCTYPE html>' +
      renderToStaticMarkup(
        <AmpModeContext.Provider value={ampMode}>
          <Document
            __NEXT_DATA__={{
              dataManager: dataManagerData,
              props, // The result of getInitialProps
              page: pathname, // The rendered page
              query, // querystring parsed / passed by the user
              buildId, // buildId is used to facilitate caching of page bundles, we send it to the client so that pageloader knows where to load bundles
              dynamicBuildId, // Specifies if the buildId should by dynamically fetched
              assetPrefix: assetPrefix === '' ? undefined : assetPrefix, // send assetPrefix to the client side when configured, otherwise don't sent in the resulting HTML
              runtimeConfig, // runtimeConfig if provided, otherwise don't sent in the resulting HTML
              nextExport, // If this is a page exported by `next export`
              dynamicIds: dynamicImportsIds.length === 0 ? undefined : dynamicImportsIds,
              err: err ? serializeError(dev, err) : undefined, // Error if one happened, otherwise don't sent in the resulting HTML
            }}
            dangerousAsPath={dangerousAsPath}
            ampPath={ampPath}
            amphtml={amphtml}
            hasAmp={hasAmp}
            staticMarkup={staticMarkup}
            devFiles={devFiles}
            files={files}
            dynamicImports={dynamicImports}
            assetPrefix={assetPrefix}
            {...docProps}
          />
        </AmpModeContext.Provider>,
      )
    )
  }
```

[javascript](https://segmentfault.com/t/javascript)[node.js](https://segmentfault.com/t/node.js)[react.js](https://segmentfault.com/t/react.js)[next.js](https://segmentfault.com/t/next.js)[ssr](https://segmentfault.com/t/ssr)
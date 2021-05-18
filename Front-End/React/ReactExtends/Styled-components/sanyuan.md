# styled-components:前端组件拆分新思路

一直在思考React组件如何拆分的问题，直到接触到styled-components，让我有一种如鱼得水的感觉，今天我就给大家分享一下这个库如何让我们的前端组件开发的更优雅，如何保持更合适的组件拆分粒度从而更容易维护。

### 一、使用方法

styled-components是给React量身定制的一个库，奉行React中all in js的设计理念，并将这个理念进一步发挥到极致，让CSS也能够成为一个个的JS模块。

使用起来也相当方便，首先安装这个库

```
npm install styled-components --save
复制代码
```

然后在style.js中使用(注意这里不是style.css，样式文件全部是JS文件)

```
import styled from 'styled-components';
//styled.xxx表示创建xxx这个h5标签,
//后面紧接的字符串里面写的是CSS代码
export const HeaderWrapper = styled.div`
  z-index: 1;
  position: relative;
  height: 56px;
  border-bottom: 1px solid #f0f0f0;
`;
复制代码
```

之后再React中使用它:

```
import React, {Component} from 'react';
import { HeaderWrapper } from './style.js';

class App extend Component{
    render() {
        return (
            <HeaderWrapper></HeaderWrapper>
        )
    }
}
export default App;
复制代码
```

Ok!这就是它的日常使用方式。如果有兴趣可以去github的相应仓库打开更多使用姿势:)

### 二、使用styled-component解决了哪些痛点

可能你还会有疑惑：这么做有什么好处呢？

#### 1.CSS模块化

尽量降低模块之间的耦合度，利于项目的进一步维护。比起用原生的CSS，这是它首当其冲的优势。

#### 2.支持预处理器嵌套语法

如:

```
export const SearchWrapper = styled.div`
  position: relative;
  float: left;
  .zoom {
    right: 5px;
    &.focused {
      background: #777;
      color: #fff;
    }
  }
`;
复制代码
```

可以采用sass,less的嵌套语法，开发更加流畅。

#### 3.让CSS代码能够处理逻辑

不仅仅是因为里面的模板字符串可以写JS表达式，更重要的是能够拿到组件的上下文信息(state、props)

比如,在React组件中的JSX代码中写了这样一段：

```
<RecommendItem imgUrl={'xxx'}/>
复制代码
```

在相应的style.js中就能够接受相应的参数:

```
export const RecommendItem = styled.div`
  width: 280px;
  height: 50px;
  background: url(${(props) => props.imgUrl});
  background-size: contain;
`;
复制代码
```

CSS能够拿到props中的内容，进行相应的渲染，是不是非常酷炫？

#### 4.语义化

如果以上几点还不能体现它的优势，那这一点就是对于前端开发者的毒药。

现在很多人对标签语义化的概念趋之若鹜，但其实大多数开发者都还是div+class一把撸的模式。难道是因为语义化不好吗？能够让标签更容易理解当然是件好事情，但是对于html5规范推出的标签来说，一方面对于开发者来说略显繁琐，还是div、span、h1之类更加简洁和亲切，另一方面标准毕竟是标准，它并不能代表业务，因此并不具有足够的表达力来描述纷繁的业务，甚至这种语义化有时候是可有可无的。我觉得这两点是开发者更喜欢div+class一把撸的根本原因。

那好，照着这个思路，拿React组件开发而言，如果要想获得更好的表达力，尽可能的语义化，那怎么办？可能你会暗笑：这还用说，拆组件啊！但组件真的是拆的越细越好吗？

有人曾经说过:当你组件拆的越来越细的时候，你会发现每一个组件就是一个标签。但是这会造成一些更加严重的问题。假设我们拆的都是UI组件，当我们为了语义化连一个button都要封装成一个组件的时候，代码会臃肿不堪，因为会出现数量过于庞大的组件，非常不利于维护。

那，有没有一个折中的方案呢？既能提高标签语义化，又能控制JS文件的数量。 没错，这个方案就是styled-components。

以首页的导航为例, 取出逻辑后JSX是这样：

```
<HeaderWrapper>
    <Logo/>
    <Nav>
        <NavItem className='left active'>首页</NavItem>
        <NavItem className='left'>下载App</NavItem>
        <NavItem className='right'>
            <i className="iconfont">&#xe636;</i>
    	</NavItem>
        <SearchWrapper>
            <NavSearch></NavSearch>
            <i className='iconfont'>&#xe614;</i>
        </SearchWrapper>
    </Nav>
    <Addition>
        <Button className='writting'>
    	  <i className="iconfont">&#xe615;</i>
    	  来参加
    	</Button>
    	<Button className='reg'>注册</Button>
    </Addition>
</HeaderWrapper>
复制代码
//style.js
import styled from 'styled-components';

export const HeaderWrapper = styled.div`
    z-index: 1;
    position: relative;
    height: 56px;
    border-bottom: 1px solid #f0f0f0;
`;

export const Logo = styled.div`
    position: absolute;
    top: 0;
    left: 0;
    display: block;
    width: 100px;
    height: 56px;
    background: url(${logoPic});
    background-size: contain;
`;

export const Nav = styled.div`
    width: 960px;
    height: 100%;
    padding-right: 70px;
    box-sizing: border-box;
    margin: 0 auto;
`;
//......
复制代码
```

拆分后的标签基本是在style.js里面导出的变量名，完全自定义，这个时候CSS都成为了一个个JS模块，每一个模块相当于一个标签(如：styled.div已经帮我们创建好了标签)，在模块下面完全可以再写h5标签。这样的开发方式其实是非常灵活的。

### 三、开发过程中遇到的坑以及目前缺点

坑: 以前的injectGlobal已经被弃用，因此对于全局的样式文件需要使用createGlobalStyle来进行引入。

```
//iconfont.js
//全局样式同理
import {createGlobalStyle} from 'styled-components'

export const IconStyle = createGlobalStyle`
@font-face {
  font-family: "iconfont";
  src: url('./iconfont.eot?t=1561883078042'); /* IE9 */
  src: url('./iconfont.eot?t=1561883078042#iefix') format('embedded-opentype'), /* IE6-IE8 
  //...
}

.iconfont {
  font-family: "iconfont" !important;
  font-size: 16px;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
`
复制代码
```

然后在全局的根组件App.js里面:

```
import { IconStyle } from './statics/iconfont/iconfont'
import { GlobalStyle } from  './style'
//import ...

function App() {
  return (
    <Provider store={store}>
      <div>
        {/* 通过标签形式引入这些样式 */}
        <GlobalStyle></GlobalStyle>
        <IconStyle></IconStyle>
        <Header />
        <BrowserRouter>
        <div>
          <Route path='/' exact component={Home}></Route>
          <Route path='/detail' exact component={Detail}></Route>
        </div>
        </BrowserRouter>
      </div>
    </Provider>
  );
}

export default App;
复制代码
```

对于styled-components缺点而言，我认为目前唯一的不足在于模板字符串里面没有CSS语法，写起来没有自动提示，对于用惯IDE提示的人来说还是有美中不足的。不过也并不是什么太大的问题，如果有相应的插件或工具欢迎在评论区分享。

对于styled-components以及组件化一点小小的思考，记录一下，希望能对各位有启发。
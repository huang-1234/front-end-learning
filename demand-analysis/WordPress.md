# 关于专利的问题

## 第一篇

前面刚说到由于FaceBooks对开源项目React的专利问题，而vue就只是采用了 MIT开源协议

上周，[WordPress 团队因专利问题而决定停止使用 React 的消息](https://wpchina.org/wordpress-stop-using-react-5487/)，引发了社区关于新技术框架的讨论。在美中国开发者[尤雨溪](https://baike.baidu.com/item/尤雨溪/2281470)（英文名：Evan You）的 Vue.js 框架，成为呼声最高的竞争者。

由于 Facebook 在其开源项目 React （以及其他项目）中夹带专利条款，出于对全球 WordPress 用户的负责，为了让用户免收 Facebook 专利困扰，WordPress 团队决定在所有项目中停止使用 React ，包括目前开发过程中的[古腾堡](https://wpchina.org/wordperss-new-core-editor-gutenberg-is-under-development-5450/)项目。

作为全球最受欢迎的开源的建站系统，[WordPress 目前在全球网站中的使用率已经达到了 28.7%](https://w3techs.com/technologies/history_overview/content_management/all)（数据截至2017年9月20日）。弃用 React 之后，继任框架的选择，成为的 WordPress 社区最受关注的热点问题。尤雨溪称，在 WordPress 宣布弃用 React 之前，他和 Matt 进行了讨论，但并没有得出明确的结论。

除了 [Vue.js](https://cn.vuejs.org/) 之外，[Preact.js](https://github.com/developit/preact) 也是 WordPress 核心开发者考虑的备选框架。最近，尤雨溪一直积极参与 WordPress 核心开发团队博客的讨论，并澄清了关于项目财务稳定性的误解。

对于 WordPress 应该采用哪种框架这个问题，作为 Vue.js 项目的创建者，尤雨溪有三个理由，认为 Vue 更适合 WordPress。他说：

- 作为一个独立而非大公司内部的开源项目，Vue 与 WordPress 项目的开源软件价值观一致。完全基于 MIT 许可，Vue 的发展有公开的捐助渠道（可通过 [Patreon ](https://www.patreon.com/evanyou)和 [OpenCollective](https://opencollective.com/vuejs) 进行长期捐助，或者通过 [PayPal](https://www.paypal.me/evanyou) 进行一次性捐助）来维护。WordPress 可以成为 Vue 的主要赞助商，轻松确保 Vue 的可持续发展。
- Vue 是最方便的框架之一，拥有稳定而积极的社区，和越来越多的学习资源。采用 Vue ，将会为刚刚接触 WordPress 开发的开发者提供低而平滑的学习曲线。这也是 WordPress 获得成功的原因。
- 作为一个可增量选用的框架，Vue 非常灵活，它可以应用在小到嵌入式小工具，插件开发，大到完整的单页应用程序的开发之中。在简单的用例中，它无需任何编译步骤；在复杂的用例中（比如古腾堡），它成熟而强大。Vue 提供了从 vdom+ 到使用原始渲染函数，服务器端渲染，路由，状态管理，构建工具，浏览器开发扩展，到编辑工具支持等全栈支持。

几个小时之前，Vue 项目核心团队的尤雨溪和其他 6 名成员还参与了 [AMA ](https://hashnode.com/ama/with-vuejs-team-cj7itlrki03ae62wuv2r2005s)会议，讨论了关于该项目的一般性问题，如何使用和贡献，以及一般的编程建议。相关的讨论可以在这里参考。

古腾堡项目团队一直致力于确保 WordPress 开发者可以使用它们喜欢的任何 JS 库来创建 “古腾堡块”（Gutenblocks），并对与框架无关的块呈现进行了探索。这些探索将减少创建插件和主题对核心库的依赖。

然而，WordPress 社区的其他成员都强调，所选框架对于 WordPress 产品生态系统将会产生深远的影响，远远超出其在古腾堡项目的使用，因此，不应该急于根据单一项目作为技术决策的标准。

关于 WordPress 团队的技术选型，WordPress 中文网将会继续跟进，请保持关注。

## 第二篇

这边很快啊！！！很快FaceBooks就说要放弃专利，将以 MIT 开源协议重新授权 React，[原文](https://wpchina.org/facebook-will-relicense-react-via-react-next-week-5502/)

昨天早上，Facebook 发表声明，下周将以 MIT 开源协议许可重新发布 React, Jest, Flow, Immutable.js 等 4 个前端工具，放弃专利权利。但尚无替代品的 React Native 以及其他项目仍在评估之中。

Facebook 在官方声明中说（[英文](https://code.facebook.com/posts/300798627056246/relicensing-react-jest-flow-and-immutable-js/)原文在这里，请自备梯子）：

 下周，我们将根据 MIT 开源协议重新授权 React, Jest, Flow, Immutable.js 开源项目。我们使用开源许可重新授权这些项目，是因为 React 是在 Web 开源项目生态系统中应用广泛的基石，我们不希望以非技术原因阻止技术进步。

 在社区几周的失望和不确定之后，我们做出了这个决定。尽管我们认为我们的 BSD + 专利许可的形式为我们项目的用户提供了好处；但是我们承认，我们没能够说服社区。

在了解到我们使用许可的不确定性之后，我们知道许多团队开始了寻找 React 替代品的进程。我们对这些用户的流失感到抱歉。尽管我们不期望通过改变授权协议能够留住这些用户，但是我们确实不希望关闭这扇大门。友好的合作和竞争推动着我们共同进步，我们希望全面参与。

这一转变自然也会引起人们对 Facebook 其他开源项目的担心。我们其他的开源项目现在仍保留 BSD + 专利许可的授权方式。我们正在对这些项目进行评估；但是每个项目都是不同的，期待的许可选项所考虑的因素也是不一样的。

下周，Facebook 将以 MIT 协议发布 React 16 版本；对于 React 而言，这也是一次重要的版本，不仅是指其改变授权许可，还包括其本身的功能。

毫无疑问，Facebook 放弃专利条款，改用 MIT 许可协议，是开源社区的一次胜利。这说明，面对大公司的专利胁迫，开源社区有自我净化的能力。同时，我们相信，[WordPress 决定放弃使用 React](https://wpchina.org/wordpress-stop-using-react-5487/) 是促成 Facebook 改变使用许可的重要因素。

但是接下来会怎样你？像百度、腾讯这样的公司，会因为 React 改回 MIT 许可协议，而停止其原来的迁移计划吗？Apache 基金会会继续禁止使用 React 吗？WordPress 还会按原计划放弃使用 React 吗？

这些都还不确定，因为要考虑的因素有很多。除了短期的迁移成本，还有未来 Facebook 重新改变授权许可的潜在可能。这些我们都将拭目以待。你觉得呢？

## 第三篇

昨天，WordPress #core-js Slack 频道进行了一场活跃的技术讨论会议，讨论的重点不再是具体框架之间的比较；而是在未来 WordPress 的基于 Javascript 的界面构建中，框架所能扮演的角色，发挥的作用。

参加会议讨论的包括有 WordPress 核心开发人员，React 社区、Vue 社区的核心开发人员和领导人，Chrome 工程师，以及 WordPress 社区之外其他感兴趣的人员。

在 [WordPress 决定放弃 React](https://wpchina.org/wordpress-stop-using-react-5487/) 事件之后，[Facebook 宣布重新授权 React 并放弃专利](https://wpchina.org/facebook-will-relicense-react-via-react-next-week-5502/)。之后，Matt 在其博客上发表文章称，[React 仍然是 WordPress 团队的选项之一](https://ma.tt/2017/09/facebook-dropping-patent-clause/)。

这次会议由 Andrew Duthie 主持。他首先询问了框架在 WordPress 开发者的工作流程中所发挥的作用，并要求框架贡献者提供关于可扩展接口的建议。

古腾堡（Gutenberg）项目负责工程师 Matías Ventura 说，他不认为 WordPress 核心选取的 js 框架会成为插件开发的实际标准。插件开发人员的实际标准是 WordPress 公开的 API 接口。

通过框架无关的构建古腾堡块（Gutenblocks）方法，核心框架不必成为开发人员的事实标准。但是外部的 Gutenberg 团队认为，这样的结局是不可避免的。有的团队正在等待 WordPress 团队的最终决定，将会采用 WordPress 团队选中的框架库。

波士顿大学的开发人员 Adam Pieniazek 说，“我们的计划是关注 WordPress 所决定的那个框架，即使古腾堡项目有一个完全未知 API 。”“尽管我个人喜欢 Vue 超过 React，但是如果 WordPress 决定选择 React，那么我们将会专注于构建 React 的专业知识。这并不意味着我们不会使用 Vue，但是不会成为我们的主要关注对象。”

Gravity Forms 项目（一个著名的 WordPress 表单插件）的创始人 Carl Hancock 也称，他的团队准备采用 WordPress 选择的前端库。

WordPress 社区之外参与者在对与框架无关的方法上，观点是一致的。没有人急切地强迫所有使用 WordPress 开发人员使用同一个框架。他们关注的剩余问题是，它是如何工作的，以及是否会让开发者出于混乱的处境。

工程师 Paul Bakus 表示，“古腾堡的目标是时建立一个平台，因此最好做到与框架分离，不向古腾堡块（Guntenblocks）开发者暴露。这样在必要的时候，可以更换底层的框架。”

Vue.js 项目的创始人尤雨溪（Even You）说，如果 WordPress 所有的用户界面，都可以通过标准界面进行扩展，最好明确分清这两个问题：核心使用的框架和扩展使用的框架。将用于核心的框架和用于扩展的框架分开，是十分钟要的，同时在技术上也是可行的。

React 项目的维护者 Dan Abromov 强调，对于古腾堡的扩展和未来 WordPres 项目，都应该采用框架无关的方法。

总的来说，这次会议的参与者从各自角度提出了各自的观点，彼此互相尊重、合作，帮助 WordPresss 贡献者在框架选择过程中找到最好的方法。会议并没有做出最后的结论，下周同一时间将会继续进行。
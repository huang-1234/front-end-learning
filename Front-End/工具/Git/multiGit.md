# [Git 多人协作开发的过程](https://www.cnblogs.com/onelikeone/p/6857910.html)

## 本文以master和dev举例，可视化git工具为sourceTree

1. 在 `dev` 开发完成后提交到本地，不推送到远程
2. 切换到 `master` 拉去远程分支代码
3. `show in finder` 打开项目运行，没有问题后切换到 `dev` 分支
4. 将 `master` 分支合并到 `dev` ，运行代码
5. 没有冲突：运行step5
6. 有冲突

- 两人操作同一份类文件冲突：
- 定位到冲突文件，调整类文件代码顺序，清除冲突标记
- 在 sourceTree 中右键选择冲突文件，选择 **解决冲突**
- 提交后确认代码确认没有问题
- 工程文件冲突：
- 直接在 sourceTree 中选择冲突文件，选择 **采用他人版本**
- `show in finder` 找回因采用他人版本自己本地被移除的本地文件
- 提价后运行代码，确保自己后面修改的文件都在，运行没有问题
- 解决完冲突提交后，跳回 `master` 分支，合并 `dev` 到 `master`
- 再次在 `master` 分支中运行项目，确保没有问题
- 提交并推送到远程 `master` 分支
- 跳转到 `dev` 分支继续开发

## Git可以完成两件事情：

1. 版本控制

2. 多人协作开发

如今的项目，规模越来越大，功能越来越多，需要有一个团队进行开发。

如果有多个开发人员共同开发一个项目，如何进行协作的呢。

Git提供了一个非常好的解决方案 ---- 多人协作开发。

### 1.**多人协作原理**

典型的做法是，首先创建一个git服务器，被多个人所操作。

3## 1.**多人协助实现**

分为如下几个步骤：

1.创建一个git裸服务器 （git init --bare）

2.从裸服务器将版本库克隆至本地（git clone ）

3.本地常规操作

4.推送版本至服务器 （git remote +  git push origin master）

5.从远程服务器拉取版本（git pull）

一般而言，我们需要在Linux服务器上来搭建我们的git版本服务器，每个公司都会有。

由项目负责人开始。

我们现在是windows系统上模拟这个操作过程。

### (1).**创建一个git裸服务器 （git init --bare）**

由负责人来完成的。服务器新建一个项目目录，如git-server

创建完毕，我们发现git-server内容和上次的不太一样。

上次使用git init 创建之后，会有一个隐藏的.git目录。目录中的才是现在看到的内容。

也就是说，现在根本就没有.git目录了。

这就意味着在这个目录中，不能做常规的开发。

### (2).**从裸服务器将版本库克隆至本地（git clone ）**

在git版本服务器，一般是不做任何开发工作的。如果要开发项目，就需要将版本库从服务器克隆到本地。

假设有一个程序员甲，开始自己的工作了。

使用命令 **git clone git版本服务器地址**

在windows下面，就是使用绝对路径，如下：
# Git 分支管理

## Git branch 中蕴含的哲学

- Production-ready code 与 developing code 的分离
- Do one thing, do it well. 每个分支的目的性明确，只做一件事。
- 多功能可以并行开发，且新功能与 hot fix 可以同步进行。

## 简化 branch new-branch & checkout new-branch 操作

```bash
$ git checkout -b <new-branch> 
```

## 应用场景：加入一个临时功能，并在活动结束后去掉

git merge 默认是 fast-forward, 即合并分支后，从 log 中去掉了分支历史。

所以，要满足这个需求，就需要禁用这个功能。

```bash
$ git merge <new-feature> --no-ff
```

同时，git 会创建一个 merge commit.

## 之前整理的笔记

Unlike many other VCSs, Git encourages a workflow that branches and merges often, even multiple times in a day. Understanding and mastering this feature gives you a powerful and unique tool and can literally change the way that you develop.

无论是添加新功能，还是修改bug。都应先建立一个对应的分支，完成后，合并到主分 支。这样就能保证，在开发新功能的同时，如果有一个紧急的bug需要修改，我就可以 切回主分支进行修改(先提交修改), 其实是回到 master 分支，再开一个分支，而不会 造成因当前修改过大，短时间无法发布 bug fix 版本。

> 注意：`每次建立分支，或者切换分支前，都需要把当前的修改提交，否则切换到其他分支也能 看到这些未提交的修改，working directory 下的文件不会恢复到指定文档的版本.`

建立分支

```bash
$ git branch <branch_name>
```

切换到指定分支

```bash
$ git checkout <branch_name>
```

Merge

先切换到需要合并到的分支，例如 master, 然后 merge

```bash
$ git checkout master
$ git merge <branch_name>
```

如果有冲突，使用 mergetool

```bash
$ git mergetool
```

再手动提交修改

删除无用分支

```bash
$ git branch -d <branch_name>
```

列出所有分支，并显示当前所处分支

```bash
$ git branch
$ git branch -v
```

列出所有分支的关系

```bash
$ git log --graph --all --decorate --oneline
$ git log --graph --all --decorate --simplify-by-decoration
```

列出指定分支的关系

```bash
$ git log --graph --all --decorate --simplify-by-decoration <b1> <b2>
```

## 参考

- [Git工作流指南：Gitflow工作流](http://blog.jobbole.com/76867/)
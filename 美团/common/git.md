#GIT简介
###什么是GIT

* 分布式版本控制软件
* GIT vs CVS && SVN   

[参考文献](http://wiki.sankuai.com/display/DEV/GitWorkflow) 

***需要注意的地方***

 1. 不要提交与项目无关的东西，如.project，mt.oa.dev.data.properties，log4j.properties等本地文件
 2. 每次提交的内容尽量小且独立
 3. 只要没有push到远程，一切都可以修改
 
###主要特点

* [小而快](http://git-scm.com/about/small-and-fast)
  * 为[Linux](https://git.kernel.org)而生
  * [Android](https://android.googlesource.com)使用
  * [github](https://github.com)专业git托管，公共项目免费
  * [bitbucket](https://bitbucket.org)同样著名，而且提供免费私人项目

* [分布式](http://git-scm.com/about/distributed)
  * 不需要中心服务器(停电？宕机？没影响)

* [GPL v2](http://git-scm.com/about/free-and-open-source)
  * 自由开源，可商业使用
 
##基本概念

###工作区域

使用git时,文件在三个工作区域中流转：git的本地数据目录，工作目录以及暂存区。			

* 工作区

  人称`working directory`，从git项目数据库中checkout出的一个单独的(默认情况下是最新的)项目版本，通过Add将文件加入缓存区

* 暂存区

  人称`staging area`, 亦称`index`，是介于工作区和版本库的一种中间状态。暂存区一般都放在.git目录中。

* 仓库

  人称`repository`，亦称`HEAD`，存放项目中所有元数据以及对象的地方(.git/)，通过clone将项目导出


		+-----------+
		|  working  |  --------------+
		+-----------+                |
		      |                      |
		      |  git add             |
		      |  git diff            |
		      v                      |
		+-----------+                |  git commit -a
		|  staging  |                |
		+-----------+                |  git diff HEAD
		      |                      |
		      |  git commit          |
		      |  git diff --cached   |
		      v                      |
		+-----------+                |
		|  repos..  |  <-------------+
		+-----------+

### 文件状态	
在git的世界里，有两类文件，分别是未追踪(untracked)和已追踪(tracked)，已追踪的文件是指已经放入了最新的git镜像(snapshot)里，已追踪的文件又分为三个状态，分别是:

	Unmodified: 文件没有做过任何修改
	Modified: 文件已被修改更新
	Staged: 文件已经修改更新，准备commit的状态

### GIT对象
Git对象分为四类，可通过git cat-file -t {hash}查看：

* commit
* tree
* blob

**如何访问GIT对象**

* 采用部分Hash值，ID为一个40位的Hash值，一般只用前6位就够区分。
* master
* HEAD
* ^代表父提交，如HEAD^，HEAD^^
* 当一个提交有多个父提交时，^后面加数字代表第几个父提交，如HEAD^1，HEAD^^2
* ~n代表祖先提交，例如a92329~5，相当于a92329^^^^^

###数据结构

git不同于svn和cvs（在每个目录下都保存一个.svn或CVS目录）的地方是，git只在根目录下保存一个名为.git的目录，当在其子目录中执行git命令时，默认递归地向上找名为.git目录，直到找到第一个.git目录为准。

* .git/index：包含文件索引的目录树

* .git/objects：包含文件修改内容，目录结构由文件ID的hash值组成，ID的前2位作为目录名，后38位作为文件名。例如:.git/objects/e6/92ac8d2496838392910c8291910d98b82910d9

* .git/refs：引用目录，其中.git/refs/heads/master保存最新提交的ID，.git/refs/tags/xxx保存标签。

* .git/HEAD：HEAD是master的一个游标，其文件内容为ref: refs/heads/master，即指向.git/refs/heads/master文件的引用

* .git/logs：记录分支变更。

###关键概念

	要将一个文件加入到版本管理中，首先要将文件加入stage，只有更新到stage中的内容才会在commit的时候被提交。需要注意的是文件本身的改动并不会自动更新到stage中，每次的任何修改都必须重新更新到stage中去才会被提交。对于工作区直接删除的文件，需要用 git rm 命令进行标记，在下次提交时，在版本库中删除.
	
	分离头指针：.git/HEAD头指针执行一个具体提交ID，而不是一个引用
###提交流程

	git add是将工作区的变更通知到index即更新目录树 同时对于工作区修改或者新增的内容写到对象库的一个新的对象中，该对象的ID是存在目录树上中的。 然后执行 git commit时将目录树写到对象库中，master分支做相应的更新，即master最新指向的目录树就是原暂存区提交的目录树。
	记录文件变更的时间戳，在扫描的时候先比较时间戳在时间戳变化的情况下看看文件内容是否发生改变

## 常用命令


### git config 配置  

**配置文件**

* /etc/gitconfig：通过git config --system配置，系统级配置文件，对所有git用户产生影响

* ~/.gitconfig: 通过git config --global配置，用户配置文件，对当前用户产生影响，并且会覆盖掉系统级配置文件的配置
	
* GIT_DIR/.git/config: 通过git config配置，版本库级配置文件，对当前版本库产生影响，并会覆盖掉用户配置文件中的配置


**问题: git config如何设置不同等级的配置？**

* 如果是系统级配置，则在git config后加--system
* 如果是用户级配置，则在git config后加--global
* 如果是版本库级配置，则在git config后什么都不加

配置优先级：版本库级配置文件>用户配置文件>系统级配置文件，即版本库级配置会覆盖掉用户和系统级配置    
影响范围：版本库级配置文件<用户配置文件<系统级配置文件

	git config --list		//显示版本库级配置的内容
    git config user.name   //检查单个值

    $ git init				              //创建git仓库
	$ git config --global user.email ""  //设置用户email
	$ git config --global user.name ""   //设置用户名
	$ git config --global color.ui true  //开启颜色显示
	

    sudo git config --system alias.st status
	sudo git config --system alias.ci commit
	sudo git config --system alias.co checkout
	
	global选项时不需要管理员权限
	git config --global alias.cmts "commit -s"
	
### git clone 克隆项目

    git clone /path/to/repository   	克隆本地
		
	git clone git://github.com:schacon/simplegit.git simple    
	将simplegit项目克隆到当前目录，格式为git协议+github.com网站+账号+项目.git,输出项目名称为simple

### git status 查看状态
	
	git status		
	git status -s   简单输出
	输出分两列，如:MM README
	?:未加入缓存; A：加入缓存; M：修改；D:删除
	第一列是暂存区与仓库对比
	第二列是工作区与暂存区对比

### git diff 查看差异
			
	git diff          工作区和暂存区比较
	git diff --cache  暂存区和HEAD比较 
	git diff HEAD     工作区和HEAD比较 
		
### git add 添加到暂存区		

	git add 文件1 文件2 … 
	git add .    递归添加当前目录下的所有文件，不建议使用此命令
	git add *    当前目录的所有文件，不建议使用此命令
	
### git rm 从暂存区删除	
	
	git rm README   删除暂存区中的README文件
	git rm --cached 会直接删除暂存区的文件 工作区不改变

### git mv 重命名文件

	git mv README READYOU    将README重命名为READYOU

### git commit 提交到仓库
	
	git commit -m "message"
	git commit -a  提交所有工作区和暂存区的修改文件，不包括未被版本库跟踪的文本，不建议使用此命令	git commit --amend 修补式提交
	
### git reset 重置（慎用）

	git reset HEAD README      将README重新标记为untracked状态
	git reset HEAD^            回滚到上一次提交的状态，暂存区回滚，工作区不变 
	git reset --soft HEAD^     回滚到上一次提交的状态，暂存区和工作区不变
	git reset --soft HEAD~2    回滚到倒数第二次提交，暂存区和工作区不变
	git reset --hard HEAD^		回滚到上一次提交的状态，暂存区和工作区重置，强烈不建议使用
    git reset --hard {hash}    回滚到某个特性的commit，暂存区和工作区重置，强烈不建议使用
    
    其实质是让refs/heads/master中的游标指向某次commit的hash值
    
**问题：--hard，--soft，--mixed的区别？**    
--hard：使refs/heads/master指向新的commit ID，重置暂存区和工作区内容
--soft：使refs/heads/master指向新的commit ID，不重置暂存区和工作区内容
--mixed（默认值）：使refs/heads/master指向新的commit ID，重置暂存区内容，但不重置工作区内容

### git checkout 检出（慎用）
	
	git checkout HEAD README  从仓库将README文件检出，暂存区和工作区内容将被覆盖
	git checkout -- README  从暂存区将README文件检出，工作区内容将被覆盖，慎用
	git checkout HEAD^1 -- README 从仓库中
	git checkout HEAD .     将所有文件恢复为最后一次commit的版本，强烈不建议使用
	git checkout {hash} .   按某次提交将所有文件检出，强烈不建议使用

	git checkout 	         显示工作区、暂存区和HEAD的差异
	git checkout dev        切换到dev分支
	git checkout -b dev master  从master建立新的dev分支, 并同时切换到dev

### git fetch 从远程获取文件

	git fetch 

### git merge 合并分支
	
	git merge dev  
		
### git pull  从远程获取文件

	git pull

   此命令等同为`git fetch`加上`git merge`，并且会试图解决依赖。  
  		
### git push 推送到远程

	git push 将最近一次提交推送到远程	
	git push -u origin master   推送本地master分支到远程origin上面，-u保持分支合并的图形完整性


### git log  查看日志
		
	git log     查看所有日志
	git log -p 3   查看最近3次提交的日志
	git	log -p {hash}  查看某次提交的详情
	git log --author icyleaf --since="one week ago"  查看icyleaf用户最近一个星期提交信息
	git log --graph --oneline    	用简单图形查看分支
	git log -1 --pretty=raw      查看最近1次提交的树形图
**问题**: 如何查找本月/上月代码提交行数？


### git branch 查看分支
	
	git branch    查看所有分支
	git branch dev 新建名为dev的分支
	git branch -m dev dev2  dev分支改名为dev2
	git branch -d dev   删除分支
	git branch -D dev	删除分支
	-d和-D区别？？？
	
##高级命令		

### gitk 图形界面
	
	gitk --all 显示所有分支
	gitk --since="2 weeks ago"
	

### git stash 保存当前进度
	 
	git stash 保存当前进度
	git stash list 查看保存的所有进度的列表
	git stash pop 恢复最新保存的进度，最新进度在list列表中删除
	git stash apply 恢复最新保存的进度，最新进度在list列表中不删除
	git stash drop 删除最新进度
	git stash clear 删除所有进度
	
### git cat-file  查看文件类型

	git cat-file -t {hash}  查看ID类型
	git cat-file -p {hash}  查看ID内容

### git rev-parse
	
	git rev-parse --git-dir       查看.git目录所在位置
	git rev-parse --show-toplevel 显示根目录位置
	git rev-parse --show-prefix   显示当前位置到根目录的相对路径
	git rev-parse --show-cdup     显示当前位置回退到根目录的路径
	查看最新提交的ID，以下三个命令输出相同
	git rev-parse master  
	git rev-parse refs/heads/master
	git rev-parse HEAD

### git blame 文件追溯

	git blame -- README   查看日志

**提示**: `git log -p`侧重文件演化过程，而`git blame`则注重目前文件中的每一行是谁写的。

		
### git tag 标签

	git tag -a v1.0	  给最后一次commit打上v1.0的标志  
	git tag -d v1.0   删除标签

### git describe  查看提交

	git describe   将最新提交显示为一个易记的名称，由基础版本号-SHA1缩写组成			
	
### git remote 分享与更新项目

	git remote add upstream http://github.com/dongwenting/luies.git  添加本地远程仓库
	git remote -v     查看本地远程仓库
	git remote rename upstream github     改名本地远程仓库
	git remote rm github        删除本地远程仓库
	git remote prune upstream   清除远程分支

### git reflog 查看日志
	
	git reflog show master      显示refs/heads/master内容的变更日志
	git reflog show refs/stash  显示refs/stash内容的变更日志

### git ls-files 查看文件	
	
	git ls-files 查看暂存区中的所有文件

### .gitignore 忽略文件
	
	可以放在任何目录中，作用范围是当前目录及其子目录
	通过将.gitignore加入文件中，可忽略自身
	只对未跟踪文件有效，对已加入版本库的文件无效

	.git/info/exclude 本地忽略
	git config --global core.excludesfile /path/to/.gitignore  设置.gitignore文件忽略
	git config core.excludesfile    查看忽略文件

### git archive 打包
	
	git archive -o latest.zip HEAD  将最新提交打包
	git archive -o partial.tar HEAD src doc   将src和doc打包
	git archive --format=tar --prefix=1.0/ v1.0 | gzip > foo-1.0.tar.gz 

		
###解决冲突

  如果无法自动合并，会有如下代码:

		<<<<<<< 自己的
		+++++
		=======
		+
		>>>>>>> 别人的

  这种方式不太友好，我们使用一种新的方式来表示，先改变`merge.conflictstyle`:

		shell> git config merge.conflictstyle diff3

  将会显示为以下形式:

		<<<<<<< 自己的
		+++++
		||||||| 共同的
		+++
		=======
		+
		>>>>>>> 别人的

  由于我们的代码是有一个共同的祖先，在diff3模式下，表示相同祖先不同改变情况。

##Tips
 
git ci = git commit   
git st = git status   
git co = git checkout   
 
**如何切换分支而不用提交已修改的文件？**   
git stash 切换分支前保存进度   
git stash pop 回到之前保存的进度 
 
 
**错误执行git reset后，该如何挽救？**    
.git/logs中保存了分支修改历史    
git reflog show master | head -5    
git reset --hard master@{2}   

**git checkout和git reset有什么区别**   
git checkout：检出，默认值是暂存区，一般用于覆盖工作区，本质是控制头指针指向，即.git/HEAD的文件内容    
git reset：重置，默认值是HEAD，一般用于重置暂存区（除非使用--hard，否则不重置工作区）本质是控制引用内容，例如.git/refs/heads/master的内容   

   
   
  





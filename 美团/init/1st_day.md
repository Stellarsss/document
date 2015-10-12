# 新人指路

### 领用设备(电脑，人体工学椅，柜子,工牌)

### 文档说明

此文档使用Mardkdown编写，如果你看的是html版本，建议先下载 mou <http://mouapp.com> ，阅读原始版本。

### 公司导航
* 生活：<http://wiki.sankuai.com/pages/viewpage.action?pageId=52332220>
	* 早饭,午饭自理
	* 订木桶饭，网址：http://192.168.2.110/ 群号：262693484
	* 大厦6层餐厅
	* 对面商场3层的美食城
	* 公司提供晚餐：每天要到[这](http://meal.meituan.it/)订餐（需要到前台开通权限，发邮件申请也可）

* 11F,12F,13F导引牌阅读
* 通过[内部办公导航](http://123.sankuai.com/)可以
	* [订餐](http://meal.meituan.it/)
	* [借书](http://book.meituan.it/)
	* [会议预定](http://mrbs.sankuai.info)
	* [task/工单系统](http://task.sankuai.com)
	* [wiki/知识库系统](http://wiki.sankuai.com)
	* [查看考勤](http://hr.sankuai.com/kaoqin/as/employee_employee)

###其他
每周还有羽毛球，篮球活动

* 美团嗨歌群： 208868170
* MT桌游协会： 300082104
* MBA篮球大联盟： 241570160
* 北辰游泳CLUB： 331264617

	
### 环境搭建
####Windows背景的同志请看这里
* 文档记录和阅读[Markdown](http://zh.wikipedia.org/wiki/Markdown)和[Vim](http://wiki.sankuai.com/pages/viewpage.action?pageId=72161931)
* linux常用命令
* shell
* Mac快捷键  
	* window的control键相当于command键
	* ctrl键 ＝ control键
	* Alt 键 ＝ Option
	* shift 键 ＝ shift
	* shift+cmd+3|4：截屏|截图到桌面
	* shift+control+cmd+3|4：截屏|截图到内存
	* cmd+n：新建当前窗口
	* cmd+c：复制 
	* opt+cmd+v：移动
	* cmd+v:复制
	* cmd+delete：删除文件
* Mac安装软件
	* 安装软件，双击dmg，将图标拖到Application就行
	* 卸载软件，将图标拖到废纸篓

####办公环境
* RTX(公司内部交流软件) 和 QQ
	* 安装常见问题：<http://wiki.sankuai.com/pages/viewpage.action?pageId=52332309>
	* 下载：官网 <http://rtxapp.com/mac/>
	* 设置：服务器地址：rtx.sankuai.info；端口号：8000
	* task.sankuai.com,选择IT项目，问题类型选权限，申请开通rtx上联系其他RD部门的权限
* 软件仓库：
	* http://files.sankuai.info/
	* [mac repo](http://horse.sankuai.com/Soft.For.Mac/)
* libre office(必须安装，后面会用到)
	* 官网 <https://www.libreoffice.org>
* mail client
	* 网页版：[https://mail.meituan.com](https://mail.meituan.com)
	* 配置方式：http://wiki.sankuai.com/pages/viewpage.action?pageId=22577175
* mou
	* 官网 <http://mouapp.com>
* evernote
	* 工作日志，学习笔记等
* 其他：sogou拼音，google chrome等

#### 开发环境
* git
	* 获得方式：官网 <http://git-scm.com>
	* Mac独有方式：`终端`执行命令`xcode-select --install`
	  * 打开`Finder` (默认底栏最左边)
	  * 左侧打开`应用程序`，进入`实用工具`目录
	  * 打开`终端`
	  * 运行以下命令

			xcode-select --install

* jdk
	* 获得方式：官网 <http://java.oracle.com>
	* version >= 1.6
	* **注意1**：java 1.6由苹果发布，如果需要开发Android程序，可直接命令行下运行java，会安装java 1.6
	* **注意2**：eclipse最新版在10.8上，即使安装1.7，也会要求安装1.6，为安全起见，安装1.6吧
	* 环境检查验证: 
		* cat > charsetTest.java
		* 复制以下代码
		* ctrl + d 退出
		* javac charsetTest.java
		* java charsetTest
		* 查看结果输出，是否均为UTF-8
		
		```			  		  		  
			import java.nio.charset.Charset;
			import java.io.OutputStreamWriter;
			import java.io.ByteArrayOutputStream;

			public class CharsetTest {
				public static void main(String[] args) throws Exception {
					System.out.println("charset: " + Charset.defaultCharset());
					System.out.println("encoding: " + System.getProperty("file.encoding"));
					System.out.println("used: " + new OutputStreamWriter(new ByteArrayOutputStream()).getEncoding());
				}
			}
		```

	* 如果上一步骤，输出不均为utf-8，则需要额外设置以使用UTF-8编码，可写入`~/.bash_profile` 

			shell> export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"

* eclipse (后端工程师)
	* 获得方式：官网 <http://www.eclipse.org/downloads>
	* 注意不要使用myeclipse，统一使用classic/standard版本，尽量确保是洁净版，无其他插件
	* 修改编码(统一使用utf-8编码)
	
			Preferences->General->Workspace->Text file Encoding->UTF-8
* mysql (后端工程师, 可选)
	* 获得方式：[官网](http://dev.mysql.com/downloads/mysql/)
	* 配置：注意字符集；my.cnf；安全配置
		* 从192.168.2.165上导入一份原始数据
		
				//TODO 将来会提供一键构建功能，敬请期待
	* 新建数据库
	
			shell> mysql -uroot  
			mysql> create database mtoa;  
			mysql> use mtoa
	* 恢复数据
		
			shell> source path/dumpsql_lwp.sql
		
* maven
	* 获得方式：[官网](http://maven.apache.org/)
	* 基本安装
	  * 下载apache-maven-X.Y.Z-bin.tar.gz (X.Y.Z指版本号)
	  * 双击解压，更名(选中，按回车或者单击文件名)为`maven`，拖放到`应用程序`
	  * 把以下内容加入到~/.bash_profile

			export PATH=$PATH:/Applications/maven/bin

	    * 可直接在`终端`中执行以下命令：(不需要复制`shell>`)

				shell> cat >> ~/.bash_profile
				export PATH=$PATH:/Applications/maven/bin
				<输入ctrl-d>
				shell> source ~/.bash_profile

	* 常规使用：docs/java/common/maven.md

* git账号使用:[参考](http://wiki.sankuai.com/pages/viewpage.action?pageId=74931420)
  * 生成自己的私钥与公钥（如果同一个人换了不同的电脑，要重新生成）
    * `终端`执行命令`ssh-keygen`
      * 打开`Finder` (默认底栏最左边)
      * 左侧打开`应用程序`，进入`实用工具`目录
      * 打开`终端`，执行以下命令:

			ssh-keygen
	  * 一路回车即可

    * `终端`查看公钥，查看`~/.ssh/id_rsa.pub`内容

			cat ~/.ssh/id_rsa.pub

  * 根据文档，提交公钥到[Stash](http://git.sankuai.com/projects),提交过程可以参考http://wiki.sankuai.com/pages/viewpage.action?pageId=74931420#
	
* 本地开发环境构建 (默认不需要任何更改)
	* 建议分两个目录，一个工作目录(mt_ws),一个部署目录(mt_repo);开发在前者目录，如果要部署测试环境，使用后者目录
	* 工作/部署目录执行（也就是说要先进入工作/部署目录之后）：
	git clone git@git.sankuai.com:it/mtoa.git
	* 在开发目录下，确认`src/main/resources/mt.oa.dev.data.properties`文件中
		
			jdbc.url=jdbc:mysql://192.168.2.165/mtoa?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull
				...			
			mongodb.host=192.168.2.165

	**注意**: 当mysql配置为192.168.2.165时，不要运行activiti单元测试。
		
	* 确认`src/main/resources/mt.oa.dev.service.properties`中 (可选)
		
			office.home=/Applications/LibreOffice.app/Contents

		**注意**: 在新版中，没有/Applications/LibreOffice.app/Contents/program/soffice.bin文件，需要自行做软链接：

			shell> ln -s /Applications/LibreOffice.app/Contents/program/soffice soffice.bin

		**验证**: 下载[jodconverter](https://code.google.com/p/jodconverter/downloads/list)，运行

			shell> java -Doffice.home=/Applications/LibreOffice.app/Contents -jar lib/jodconverter-core-3.0-beta-4.jar /path/to/docx /path/to/pdf 
		
	* 确认`src/test/resources/log4j.properties`和`src/main/webapp/WEB-INF/classes/log4j.properties`中 (可选，或者本地搭建mongodb)
		
				logj4.appender.mlog.host=192.168.2.165
				
	* 常见问题
		* 问题：git pull报错，Please check that your locale settings  
			
				vi ~/.bash_profile

				export LC_CTYPE=en_US.UTF-8
				export LC_ALL=en_US.UTF-8
				source ~/.bash_profile

* TestNG (后端工程师, 可选)
	* 安装
	
			Help->Install New Software->Add  
			name:TestNG  
			url:http://beust.com/eclipse  
	* 入门教程：http://dingtao.iteye.com/blog/207973
		
* Jetty (后端工程师, 可选)
	* 在maven下启动：执行mtoa项目中的jettyrun.sh
			
			./jettyrun.sh
			可能需要执行：chmod +X jettyrun.sh
	* 在eclipse中安装，启动jetty
	
			Help->Install New Software->Add  
			name:run-jetty  
			url:http://run-jetty-run.googlecode.com/svn/trunk/updatesite  
	* 相关配置
		* Jetty -> Context: 默认是/mtoa或类似，请确保为/
		* Arguments -> VM argumetns: -Dspring.profiles.active=dev
	* 在eclipse中启动jetty
	
			项目右键->Run Jetty，通过http://127.0.0.1:8080/#/account/login登录系统
	* 常见问题
		* 问题：jetty启动报错java.lang.ClassNotFoundException: org.eclipse.jetty.webapp.WebAppContext
		原因jetty6版本中没有WebAppContext，采用版本7.Run Configuration中选jetty7。
			
				run configuration中用jetty7运行。
* MongoDB (后端工程师, 可选)
	* 获得方式：www.mongodb.org
	* 解压文件
	* 启动mongodb  
	
			shell mongodb/bin > mkdir data  
			shell mongodb/bin >./mongod --dbpath=data	

* Apache (前端工程师，可选)

  参见[Mac OS X下启动Apache](mac.os.x.apache.md)

* 启动项目

  * 普通方式，项目下运行`jettyrun.sh`即可

		shell> ./jettyrun.sh

### 项目公用环境
* [线上系统](http://pig.sankuai.info/#/)
* [测试系统](http://192.168.2.165:8080/#/account/login)
	
		用户名:<自己的mis账号，无@后面内容>  
		密码:随意

#### 基础技能	
* 工作日志
	* 没有可信，抗抵赖输出的任务都是耍流氓
	* 昨天做了什么，今天要做什么
	* 有没有完成任务；完成的质量如何
	* 初期，最好留下执行过程的记录，方便分析定位问题所在(这一点对于工作经验还不是很丰富的同学来说，非常重要，请重视)
	* 工作期间至少保证RTX或QQ一个在线，并且浏览器一直打开美团邮箱
* 周/月/季报格式
	* 周报格式
	
		-[V] xxx任务
		
		预期输出:yyyy
		
		实际输出:zzzz
		
		-[x] xxx任务
		
		预期输出:yyyy
		
		实际输出:zzzz
		
	  
	  总结：xxxxx
	  
		  //TODO 月报和季报待补充*
	  	
* 时间管理

   推荐一本书：暗时间
 
###基础技能列表
可以先过一下 是否每一项都是掌握的，找出自己的短板，然后安排到学习任务中去

* git
* shell
* maven
* eclipse
* spring(含mvc)
* activiti
* yui
	* 官网
	* fe.sankuai.com
* testng & junit
* mt.itdev.pf（系统概念）
	* metadata service
	* dataset service
	* bill service
	* bpm service
	* eai service
	* log service
	* ui-factory

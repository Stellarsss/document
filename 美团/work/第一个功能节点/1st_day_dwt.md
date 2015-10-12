# 新人指路

##生活导航
###领用设备
到前台领取工牌，电脑，椅子，柜子，办公用品等  
无线：sankuai  
密码：87654312  
###吃饭

* 中餐自己解决：
	* 订木桶饭，网址：http://192.168.2.110/ 群号：262693484
	* 6层餐厅
	* 对面商场3层的美食城
	
* 晚餐公司解决：记得每天要到[这](http://meal.meituan.it/)订餐

###内网导航

通过[导航](http://123.sankuai.com/)网址可以
[预定会议](http://mrbs.sankuai.info/mrbs/day.php?year=2013&month=09&day=27&area=2&room=71), 
[查看考勤](http://hr.sankuai.com/kaoqin/as/employee_employee)，
[提交问题](http://task.sankuai.com/secure/Dashboard.jspa), 
[wiki知识库](http://wiki.sankuai.com/dashboard.action)

###借书

http://book.meituan.it/mt/login.html

###其他

* 每周还有羽毛球，篮球活动
	* 美团嗨歌群： 208868170
	* MT桌游协会： 300082104
	* MBA篮球大联盟： 241570160
	* 北辰游泳CLUB： 331264617

#环境搭建
##mac使用

* Mac快捷键  
	* command键相当于window的control键
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

* chrome调试
	* 隐身登陆:shift+cmd+n 
	* F10 = cmd+'
	* F11 = cmd+;

##办公环境


* RTX(公司内部交流软件)   
	服务器地址：rtx.sankuai.info  
	端口号：8000
* QQ
* libre office
* mail client  
	网页版：https://mail.meituan.com  
	配置方式：http://wiki.sankuai.com/pages/viewpage.action?pageId=22577175
* mou  
	官网：mouapp.com  
	学习[Markdown](http://zh.wikipedia.org/wiki/Markdown)
* evernote  
	用于记录工作日志，学习笔记等
* 其他：sogou拼音，googlechrome等
	
##开发环境

###git
* 申请账号  
	参考[这篇文章](http://wiki.sankuai.com/pages/viewpage.action?pageId=46341961)  
	登陆http://task.sankuai.com/browse/SYS  
* 安装git  
	账号申请完成后，选择工作目录执行，下载mtoa源码  
	git clone yourname@git.sankuai.com:mtoa
	
* eclipse安装git插件  
	Help->Install New Software->Add  
	name:git  
	url:http://download.eclipse.org/egit/updates
	
###JDK

建议使用不低于1.6的版本，即mac自带的jdk1.6  
貌似如果安装1.7，eclipse容易混乱???  
注意：由于jdk 1.6的一个bug，需要额外设置使用UTF-8编码，将   

	export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8   
写入~/.bash_profile (jdk 1.7不受影响) 
  
** 验证**  
在shell中运行以下代码，并确保输出均为UTF-8:


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

shell> javac CharsetTest.java  
shell> java CharsetTest

###eclipse
* 版本选择  
	注意不要用myeclipse  
	别人推荐用classic/standard版本，尽量确保是洁净版，无其他插件  
	个人推荐用J2EE版本，自带maven和junit，也没啥问题  

###MySQL
* 新建mtoa数据库  
		
		shell> mysql -uroot  
		mysql> create database mtoa;  
		mysql> use mtoa

* 配置编码  
Mac OS X 上安装 MySQL 默认是没有 my.cnf 配置文件的，MySQL 使用默认配置运行。

		cd /usr/local/mysql/support-files/
		sudo cp my-medium.cnf /etc/my.cnf
		vi /etc/my.cnf
		[client]
		default-character-set=utf8

		[mysql]
		default-character-set=utf8

		[mysqld]
		character-set-server = utf8

		重启mysql
		sudo /Library/StartupItems/MySQLCOM/MySQLCOM restart


###Maven

到[官网](http://maven.apache.org/download.html)下载maven 
将apache-maven-3.0.4-bin.tar.gz解压到/usr/share/java 
	
	shell> ln -s /usr/share/java/apache-maven-3.0.4 /usr/share/maven 
	修改~/.bash_profile 
	MAVEN_HOME=/usr/share/maven
	export MAVEN_HOME

###Jetty

* 解压jetty安装包，在系统program目录下制作软链接soffice.bin  
	
		shell /Applications/LibreOffice.app/Contents/program> ln -s soffice soffice.bin 
* 在mtoa项目中，启动jetty
	./jettyrun.sh
* http://127.0.0.1:8080/#/account/login登录系统  
	输入账号:liuwenping  
	密码：随意  
* eclipse安装jetty插件  
	
		Help->Install New Software->Add  
		name:run-jetty  
		url:http://run-jetty-run.googlecode.com/svn/trunk/updatesite  

###TestNG

* 安装TestNG  
	Help->Install New Software->Add  
	name:TestNG  
	url:http://beust.com/eclipse  
* 入门教程  
	Java测试新技术TestNG和高级概念

###MongoDB

* 解压文件
* 启动mongodb  
	
		shell mongodb/bin > mkdir data  
		shell mongodb/bin >./mongod --dbpath=data

###环境配置

* eclipse导入mtoa
* 修改编码  
	
		Preferences->General->Workspace->Text file Encoding->UTF-8	
* 编译项目

		pom.xml->Run As->Maven Build-> Goals： clean compile
* 去除pdf报错
	
		Preferences->Java->Compiler->Errors/Warnings
		搜索框中输入access找到Deprecated and restricted API
		将Forbidden reference(access rules)的error改为warning
* mysql配置在src/main/resources/mt.oa.dev.data.properties，使用线上数据库
	
		mysql database setting
		jdbc.driver=com.mysql.jdbc.Driver
		jdbc.url=jdbc:mysql://192.168.2.165/mtoa?		useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull
		jdbc.username=dev
		jdbc.password=1qazxsw2

* mongodb配置在src/main/webapp/WEB-INF/classes/log4j-dev.properties

	log4j.appender.mlog.host=192.168.2.165
			
* 项目右键->Run Jetty 肯定会报错
* 项目右键->Run Configuration
	
		Web	Application
		Context的/mtoa改为/
		
**问题**：启动报错java.lang.ClassNotFoundException: org.eclipse.jetty.webapp.WebAppContext
原因jetty6版本中没有WebAppContext，采用版本7.Run Configuration中选jetty7。
		
		Run Configuration->Select a Jetty Version->jetty7

**问题**:启动报错Could not resolve placeholder 'spring.profiles.active' 

		Run Configuration->arguments->VM arguments中增加：
		-Dspring.profiles.active=dev


* 通过http://127.0.0.1:8080/#/account/login登录系统



**问题**：git pull报错，Please check that your locale settings  
vi ~/.bash_profile

	export LC_CTYPE=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
source ~/.bash_profile



###OA(办公自动化系统)  	
	
	[线上系统](http://pig.sankuai.info/#/)
	[测试系统](http://192.168.2.165:8080/#/account/login)
	用户名:liuwenping  
	密码:随意

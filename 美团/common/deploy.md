#环境配置

##安装前准备  
### 安装原则

* 无特殊要求，使用centos/debian/ubuntu等Linux发行版本(公司默认使用)
* 所有不需要root的操作，使用sankuai帐号(技术规范)
* 软件尽可能使用发行版自带版本(避免编译)
  * centos: yum installl ...
  * debian/ubuntu: apt-get install ...
* 自行安装软件放到/opt下，编译软件(不建议编译)放到/usr/local下  rpmforge.org###系统还原
web登陆cloud.sankuai.com，用老胡的账号密码登陆，控制面板中选择mid，单击"管理-重置系统"
### 登陆系统
	
	ssh root@192.168.4.123 
	用户名：root
	密码：为登陆信息的初始密码
	
### 环境检查
		[root@mid ~]# cat /etc/issue
	CentOS release 6.4 (Final)   //系统是CentOS 6.4版本
		[root@mid ~]# uname -r
	2.6.32-358.2.1.el6.x86_64  //系统是64位x86
	
完整的系统需要安装以下应用：

* JDK
* maven：项目管理及自动构建工具
* MySQL：关系型数据库，保存表
* MongoDB：非关系型数据库，保存单据和日志等其他信息
* nginx：反向代理服务器
* memcached：高速缓存
* tomcat：web容器
* mtoa根据系统版本和位数下载相应安装包。
##安装步骤
### 添加用户		
	//增加sankuai用户
	[root@mid ~]# useradd sankuai
	//修改sankuai密码
	[root@mid ~]# passwd sankuai
	[root@mid ~]# su - sankuai
	###安装JDK1.7
	
* 安装openJDK（任选其一）

		[root@mid software]# yum install -y java-1.7.0-openjdk
		[root@mid software]# java -version
			* 安装Sun JDK（任选其一）
[JDK下载地址](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

	//将下载的安装包拷贝到测试环境	~ $ scp jdk-7u45-linux-x64_0.rpm sankuai@192.168.4.123:~
	//root执行安装	[root@mid software]# rpm -ivh jdk-7u45-linux-x64_0.rpm --prefix /opt
	
	[root@mid software]$ java --version	###安装maven
	[root@mid ~]# wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo	[root@mid ~]# yum install -y apache-maven

###第一次验证
用最简单的方式运行mtoa，连接2.165的数据库

	//生成公钥
	[sankuai@mid ~]$ ssh-keygen
	在http://git.sankuai.com/plugins/servlet/ssh/keys 中添加公钥
	
	//下载代码
	[sankuai@mid ~]$ git clone git@git.sankuai.com:it/mtoa.git	//打包运行	[sankuai@mid ~]$ cd mtoa/mtoa
	[sankuai@mid mtoa]$ mvn clean package
	[sankuai@mid mtoa]$ ./jettyrun.sh 	

通过192.168.4.123:8080访问mtoa		###安装mysql  
	
	//检查是否已安装mysql，系统自带mysql的lib库	[root@mid ~]# rpm -qa | grep mysql
	mysql-libs-5.1.67-1.el6_3.x86_64  
	
	//安装mysql的服务器包和开发包
	[root@mid ~]# yum install -y mysql-server mysql mysql-devel	
	//启动mysql	[root@mid ~]# service mysqld start
	//查看mysql是否开机启动，	[root@mid ~]# chkconfig --list | grep mysqld
	 mysqld  0:off 1:off 2:off	3:off 4:off 5:off 6:off
	
	0：关机 
	1：单用户模式，系统出问题时维护 
	2：无网络连接的多用户命令行模式 
	3：有网络连接的多用户命令行模式 
	4：系统保留 
	5：带图形界面的多用户模式 
	6：重启 
	
	//一般设345等级开机启动
	[root@mid ~]# chkconfig --level 345 mysqld on	
	//mysql初始化安装好后，root用户默认是没有密码的，注意新密码不要加''引号
	//命令格式： mysqladmin -uroot -poldpasswd password newpassword	[root@mid ~]# mysqladmin -uroot password 1qazxsw2
	//创建mtoa数据库，增加dev用户
	[root@mid ~]# mysql -u root -p
	mysql> create database mtoa;
	mysql> grant all privileges on mtoa.* to 'dev'@'localhost' identified by '1qazxsw2' with grant option;
	mysql> grant all privileges on mtoa.* to 'dev'@'127.0.0.1' identified by '1qazxsw2' with grant option;
	mysql> grant all privileges on mtoa.* to 'dev'@'192.168.4.123' identified by '1qazxsw2' with grant option;
	mysql> exit;
	
	//测试dev用户
	[root@mid ~]# mysql -udev -p1qazxsw2 mtoa	
	//设置mysql字符集，默认的数据库编码方式基本都设置成latin1的编码方式，需要将其修改成utf8的编码格式	mysql> show variables like 'character%';
	
	//修改字符编码，
	[root@mid ~]# vi /etc/my.cnf
	[mysqld]				        #服务器配置
	datadir=/var/lib/mysql
	socket=/var/lib/mysql/mysql.sock
	user=mysql
	lower_case_table_names=1        #表名不区分大小写，mysql创建和查找表时自动将表名转为小写
	init_connect='SET NAMES utf8'   #连接初始化时调用SET NAMES utf8
	default_character_set=utf8      #设客户端的默认字符集为utf-8
	default_collation=utf8_general_ci
	character_set_server=utf8        #数据库服务器的编码方式
	collation_server=utf8_general_ci
	default-storage-engine=innodb    #默认引擎类型

	[client]					      #客户端配置
	default-character-set=utf8       #设服务器端的默认字符集为utf-8
	# Disabling symbolic-links is recommended to prevent assorted security risks 	symbolic-links=0

	[mysqld_safe]
	log-error=/var/log/mysqld.log
	pid-file=/var/run/mysqld/mysqld.pid	
	//记得修改配置文件后，要重启mysql服务
	[root@mid ~]# service mysqld restart		//导入表	[root@mid ~]# mysqldump --host=192.168.2.165 -udev -p1qazxsw2 -C -R mtoa|mysql -uroot -p mtoa##mongodb
	
	[root@mid ~]# cd /etc/yum.repos.d/	[root@mid yum.repos.d]# vi /etc/yum.repos.d/mongodb.repo  	[mongodb]  
	name=MongoDB Repository  
	baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64  
	gpgcheck=0

	[root@mid yum.repos.d]# yum install mongo-10gen-server 
	[root@mid yum.repos.d]# /etc/init.d/mongod start	//查看mongodb是否正常启动
	[sankuai@mid bin]$ ps aux | grep mongo	[sankuai@mid bin]$ netstat -utlp | grep 27017	
	//mongodb停止服务	[sankuai@mid bin]./mongo   
	mongo> use  admin  
	mongo> db.shutdownServer();  

	 [MongoDB下载地址](http://www.mongodb.org/downloads)
	
	//将下载的安装包拷贝到测试环境	 ~ $ scp mongodb-linux-x86_64-2.4.8.tgz sankuai@192.168.4.123:~	[sankuai@mid ~]# mkdir software
	[sankuai@mid ~]# mv mongodb-linux-x86_64-2.4.8.tgz software/
	
	//创建日志和数据目录
	[sankuai@mid ~]$ mkdir logs
	[sankuai@mid ~]$ mkdir -p data/mongo
	
	//解压并改名
	[sankuai@mid ~]# cd software
	[sankuai@mid software]# tar zxvf mongodb-linux-x86_64-2.4.8.tgz 
	[sankuai@mid software]# mv mongodb-linux-x86_64-2.4.8 mongodb
	
	//后台启动
	[sankuai@mid software]$ cd mongodb/bin
	[sankuai@mid bin]$ ./mongod --dbpath /home/sankuai/data/mongo --logpath=/home/sankuai/logs/mongo --fork 
		### 第二次验证
连接本地数据的方式运行mtoa，用eclipse搜索一下192.168.2.165，将其都改为192.168.4.123
	[sankuai@mid mtoa]$ ./jettyrun.sh 	###安装nginx

	//添加nginx源
	[root@mid ~]# cd /etc/yum.repos.d/	[root@mid yum.repos.d]# vi nginx.repo
	[nginx] 
	name=nginx repo 
	baseurl=http://nginx.org/packages/centos/$releasever/$basearch/ 
	gpgcheck=0 
	enabled=1
	
	//安装nginx	[root@mid yum.repos.d]# yum install -y nginx
	//启动nginx	[root@mid yum.repos.d]# /etc/init.d/nginx start 
	在浏览器中输入http://192.168.4.123/，如果出现Welcome to nginx!，则安装成功
	
	//配置nginx，实现tomcat的负载均衡	[root@mid ~]# vi /etc/nginx/nginx.conf 

	http{		…    	upstream mid.sankuai.info{  #server地址
        	server 192.168.4.123:18080; #tomcat地址:端口
        	server 192.168.4.123:28080;
    	}
    
   	 	server{
        	server_name mid.sankuai.info;
        	listen 8080;
        	charset utf-8;
        	location /{
                root html;
                index index.html index.htm;
                proxy_pass http://mid.sankuai.info;
                proxy_set_header X-Real-IP $remote_addr;
                client_max_body_size 100m;
        	}
        	location ~^/(WEB-INF)/{
                deny all;
        	}
    	}
	}	[root@mid yum.repos.d]# /etc/init.d/nginx restart ###安装memcached
	[root@mid ~]# yum install -y memcached php-pecl-memcache
	[root@mid ~]# service memcached start
	[root@mid ~]# chkconfig --list | grep memcached

	[root@mid yum.repos.d]# chkconfig --level 345 memcached on
	###安装tomcat 7	//解压为tomcat-node1和tomcat-node2（单机模拟集群，2个节点）	~ $ scp apache-tomcat-7.0.37.tar sankuai@192.168.4.123:~/software
	[sankuai@mid software]# tar xvf apache-tomcat-7.0.37.tar
	[sankuai@mid software]# mv apache-tomcat-7.0.37 tomcat-node1
	[sankuai@mid software]$ cp -r tomcat-node1/ tomcat-node2

	//由于两个tomcat运行在一台服务器上，所以要分别修改tomcat的端口，修改tomcat/conf目录下server.xml	[sankuai@mid conf]$ vi server.xml
	tomcat-node1的配置：	<Server port="18005" shutdown="SHUTDOWN">	<Connector port="18080" protocol="HTTP/1.1"
		connectionTimeout="20000"  
		redirectPort="8443" /> 			<Connector port="18009" protocol="AJP/1.3" redirectPort="8443" />	tomcat-node2的配置：		<Server port="28005" shutdown="SHUTDOWN">	<Connector port="28080" protocol="HTTP/1.1"			connectionTimeout="20000"  
		redirectPort="8443" />  	<Connector port="28009" protocol="AJP/1.3" redirectPort="8443" />	//修改两个tomcat中bin/catalina.sh，增加如下内容	[sankuai@mid bin]$ vi catalina.sh 
	JAVA_OPTS="$JAVA_OPTS -Dspring.profiles.active=dev"
	###配置memcached session manager[msm下载地址](https://code.google.com/p/memcached-session-manager/downloads/list)    
	//分别进入tomcat/lib目录，下载所需jar包	[root@mid ~]# cd tomcat-node1/lib	[root@mid lib]# wget http://memcached-session-manager.googlecode.com/files/memcached-	session-manager-1.6.5.jar   	[root@mid lib]# wget http://memcached-session-manager.googlecode.com/files/memcached-session-manager-tc7-1.6.5.jar    	[root@mid lib]# wget http://files.couchbase.com/maven2/spy/spymemcached/2.8.12/spymemcached-2.8.12.jar   	[root@mid lib]# wget http://files.couchbase.com/maven2/couchbase/couchbase-client/1.1.4/couchbase-client-1.1.4.jar    
到tomcat/conf下修改context.xml，增加如下内容，node1和node2都要增加
	
	//配置memcached	<Manager className="de.javakaffee.web.msm.MemcachedBackupSessionManager"      memcachedNodes="192.168.4.123:11211"      sticky="false"      sessionBackupAsync="false"	  requestUriIgnorePattern=".*\.(ico|png|gif|jpg|css|js)$"  	  transcoderFactoryClass="de.javakaffee.web.msm.JavaSerializationTranscoderFactory"/>###第三次验证验证Ngnix是否实现tomcat的负载均衡，且采用memcached保存session。
新建一个web工程，新增test.jsp，打成war包发布到tomcat/webapps下	
	// node1的内容	SessionID:<%=session.getId()%>	<BR>	SessionIP:<%=request.getServerName()%>	<BR>	SessionPort:<%=request.getServerPort()%>	<%	out.println("This is Tomcat Server Node1！");	%>
	// node2的内容	SessionID:<%=session.getId()%>	<BR>	SessionIP:<%=request.getServerName()%>	<BR>	SessionPort:<%=request.getServerPort()%>	<%	out.println("This is Tomcat Server Node2！");	%>
	http://192.168.4.123:8080/test/test.jsp访问，反复刷新，sessionid不改变，但最后的提示信息不一样则说明配置成功。

###第四次验证
	
	//mtoa项目中打包
	[sankuai@mid mtoa]$ mvn clean package
	[sankuai@mid mtoa]$ mv target/mt.oa-0.0.1-SNAPSHOT.war target/ROOT.war
	
	将tomcat/webapps下的内容删除，将ROOT.war拷贝到webapps中	先启动两个tomcat，再启动memcached，最后启动nginx
	可通过http://192.168.4.123:8080 或http://192.168.4.123:18080 或http://192.168.4.123:28080 访问主页

###问题列表
**问题：tomcat启动报错**
/home/sankuai/tomcat/webapps/ROOT/common.zipNov 19, 2013 10:33:23 AM org.apache.catalina.core.StandardContext startInternal
SEVERE: Error listenerStart
Nov 19, 2013 10:33:23 AM org.apache.catalina.core.StandardContext startInternal
SEVERE: Context [] startup failed due to previous errors
原因：没有设置JAVA_OPTS="$JAVA_OPTS -Dspring.profiles.active=dev"

#姚磊版


###搞清系统是哪个,准备对应版本的安装程序    

```
// FIXME: 发行版提供了mongodb, mysql等，建议使用发行版自带版本
// FIXME: 说明一下使用tomcat对比jetty好处，目前线上使用jetty
// FIXME: 如无特殊要求，一律切换到sankuai帐号操作
```

通过uname –a查看
将mongodb-linux-x86_64-2.2.3.tgz，apache-tomcat-7.0.35.tar.gz ，MySQL-5.6.14-1.linux_glibc2.5.x86_64.rpm-bundle.tar，jdk-7u45-linux-x64_0.rpm

```
// FIXME: linux下自行安装可执行文件，一般是安装到/opt下，编译的话，一般是/usr/local
```

复制到root@192.168.4.123:/root/soft/

###安装mysql    
解压文件后执行
yum install libaio
rpm -i MySQL-server-5.6.14-1.linux_glibc2.5.x86_64.rpm
rpm -i MySQL-client-5.6.14-1.linux_glibc2.5.x86_64.rpm 

如果server安装遇到如下冲突的话执行
“file xxx from install of MySQL-server-5.6.14-1.linux_glibc2.5.x86_64 conflicts with file from package mysql-libs-5.1.67-1.el6_3.x86_64”

yum -y remove mysql-libs-5.1.67*
安装完成注意提示信息

启动mysql在/usr/bin目录下
./mysqld_safe --user=mysql &

使用初始随机密码登陆，并修改

mysql –uroot –p随机密码
set password for 'root'@'localhost' = password('yaolei313');
set password for 'root'@'127.0.0.1' = password('yaolei313');
set password for 'root'@'::1' = password('yaolei313');
set password for 'root'@'huzhiyong.corp.sankuai.com'= password('yaolei313');

剩余操作为创建用户dev/1qazxsw2及数据库mtoa，并导入数据。

```
// FIXME: 加入mysql基本配置，默认编码，忽略表名大小写等。
```

###安装mongodb
```
// FIXME: 无特殊要求，从发行版安装或编译。不要使用ROOT帐号
```

解压文件后在其目录下创建data目录
[root@huzhiyong mongodb-linux-x86_64-2.2.3]# mkdir data
后台运行mongod
nohup ./mongod --dbpath=/root/soft/mongodb-linux
-x86_64-2.2.3/data &

###安装JDK1.7

```
// FIXME: 为使生效，写入~/.bash_profile
```

使用rpm -ivh jdk-7u45-linux-x64_0.rpm执行安装，安装完成后配置环境变量。
JAVA_HOME=/usr/java/jdk1.7.0_45
CLASSPATH=.:$JAVA_HOME/lib.tools.jar
PATH=$JAVA_HOME/bin:$PATH

export JAVA_HOME
export CLASSPATH
export PATH

###安装nginx
模块依赖性Nginx需要依赖下面3个包    
1. gzip 模块需要[zlib库](http://www.zlib.net/)    
2. rewrite 模块需要[pcre库](http://www.pcre.org/)    
3. ssl 功能需要[openssl库](http://www.openssl.org/)    
分别下载
openssl-fips-2.0.5.tar.gz
zlib-1.2.8.tar.gz
pcre-8.21.tar.gz
nginx-1.5.6.tar.gz
到任意目录。

前3个按照正常的configure,make,make install来完成安装，配置nginx时指定
./configure --with-pcre=../pcre-8.21 --with-zlib=../zlib-1.2.8 
--with-openssl=../openssl-fips-2.0.5（参数指定的都是安装目录），然后在make，make install

通过到./nginx –t检查是否安装成功。若碰到如下问题：
could not build the server_names_hash, you should increase …

需要在nginx配置文件中加入
http{
   …
   types_hash_max_size 2048;
   server_names_hash_bucket_size 64;

###安装memcached
Memcache用到了libevent这个库用于Socket的处理，所以还需要安装libevent
下载memcached-1.4.15.tar.gz，libevent-2.0.21-stable.tar.gz
安装libevent：
tar 解压并cd进入
./configure 默认安装目录/usr/local
make
make install

安装memcached，同时需要安装中指定libevent的安装位置：
tar解压并cd进入
./configure --with-libevent=/usr/local
make
make install
安装完成后会把memcached放到 /usr/local/bin/memcached ，
测试是否成功安装memcached：
ls -al /usr/local/bin/mem*

```
FIXME: 开机自启动策略，或者相关文档
```

启动
/usr/local/bin/memcached -d -m 10 -u root -l 192.168.4.123 -p 12000 -c 256 -P /tmp/memcached.pid

配置说明

* d选项是启动一个守护进程
* m是分配给Memcache使用的内存数量，单位是MB，我这里是10MB，
* u是运行Memcache的用户，我这里是root，
* l是监听的服务器IP地址，如果有多个地址的话，我这里指定了服务器的IP地址192.168.4.123，
* p是设置Memcache监听的端口，我这里设置了12000，最好是1024以上的端口，
* c选项是最大运行的并发连接数，默认是1024，我这里设置了256，按照你服务器的负载量来设定，
* P是设置保存Memcache的pid文件，我这里是保存在 /tmp/memcached.pid

###安装tomcat 7
解压为tomcat-7-node1和tomcat-7-node2即可（单机模拟集群，2个节点）


分别修改tomcat/conf目录下server.xml:

	<Server port="18005" shutdown="SHUTDOWN">
	<Connector port="18080" protocol="HTTP/1.1"
	<Connector port="18009" protocol="AJP/1.3" redirectPort="8443" />

	<Server port="28005" shutdown="SHUTDOWN">
	<Connector port="28080" protocol="HTTP/1.1"
	<Connector port="28009" protocol="AJP/1.3" redirectPort="8443" />


###配置memcached session manager
[msm官网](https://code.google.com/p/memcached-session-manager/) 
到tomcat/lib目录下，执行如下命令：   
wget http://memcached-session-manager.googlecode.com/files/memcached-session-manager-1.6.5.jar   
wget http://memcached-session-manager.googlecode.com/files/memcached-session-manager-tc7-1.6.5.jar    
wget http://files.couchbase.com/maven2/spy/spymemcached/2.8.12/spymemcached-2.8.12.jar   
wget http://files.couchbase.com/maven2/couchbase/couchbase-client/1.1.4/couchbase-client-1.1.4.jar    
session序列化配置使用java序列化则不需要下载额外jar包，否则请参考官网。

到tomcat/conf下修改context.xml，增加如下内容

	<Manager className="de.javakaffee.web.msm.MemcachedBackupSessionManager"
      memcachedNodes="192.168.4.123:12000"
      sticky="false"
      sessionBackupAsync="false"
	  requestUriIgnorePattern=".*\.(ico|png|gif|jpg|css|js)$"  	  transcoderFactoryClass="de.javakaffee.web.msm.JavaSerializationTranscoderFactory"/>

以上配置node1和node2都要修改，可以先改完一个复制到另一个。

###配置nginx

修改nginx.cnf文件


http{
  …
  upstream test.yao.com{  #server主机名
      server 192.168.4.123:18080; #tomcat地址:端口
      server 192.168.4.123:28080;
  }
  …
  gzip on;
  gzip_min_length 1k;
  gzip_types       text/plain application/x-javascript text/css application/xml;
  …
  server{
    server_name  test.yao.com;
    …
    location / {
            root   html;
            index  index.html index.htm;
            proxy_pass http://test.yao.com;
            proxy_set_header X-Real-IP $remote_addr;
    }
  }
}


###验证配置是否成功
随便新建一个web工程，我的叫spring，发布到tomcat/webapps下
分别在tomcat node1和node2的发布工程中添加test.jsp,内容如下

	
	// node1
	SessionID:<%=session.getId()%>
	<BR>
	SessionIP:<%=request.getServerName()%>
	<BR>
	SessionPort:<%=request.getServerPort()%>
	<%
	out.println("This is Tomcat Server Node1！");
	%>

	// node2
	SessionID:<%=session.getId()%>
	<BR>
	SessionIP:<%=request.getServerName()%>
	<BR>
	SessionPort:<%=request.getServerPort()%>
	<%
	out.println("This is Tomcat Server Node2！");
	%>
启动nginx，访问http://192.168.4.123/spring/test.jsp，反复刷新，sessionid不改变，但最后的提示信息不一样则说明配置成功。



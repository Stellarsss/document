#MAVEN 

主要记录了maven重要的几个概念描述和ant等传统构建工具的一个区别。

###Maven相较于Ant的优势以及二者之间的区别


**区别一览表 **
  <table>
  <tr ><td colspan="2">设计理念</td><td colspan="2">集成</td></tr>
  <tr><td>Maven</td><td>Ant</td><td>Maven</td><td>Ant</td></tr>
  <tr><td>声明式（pom.xml）简单容易记忆</td><td>过程式(build.xml)繁琐</td><td>简单的集成所有测试</td><td>集成所有的测试复杂</td></tr>
  <tr><td>约定优于配置</td><td>木有约定，自力更生</td><td>站点管理（site）很简单</td><td>站点管理很复杂</td></tr>
  <tr><td>面对项目进行管理（处理构建外，还有依赖管理，信息管理）</td><td>专注于构建</td><td></td><td></td></tr>
   <tr><td>定义了生命周期，内置插件</td><td>没有生命周期，手动配置每一个task</td><td></td><td></td></tr>
   <tr><td>jar包只需声明（maven从仓库下载）</td><td>jar包都需要手动下载和管理</td><td></td><td></td></tr>
</table>

  
  

**说明**

  首先POM的定义是基于声明的，这一点和ant的build.xml完全不一样。一个是定义依赖，一个是定义过程。但maven要想修改默认设定比较麻烦，ant全都在build.xml里，创建的时候虽然工作量大，但修改起来就比较方便。
  
  Maven 是遵循约定优于配置的思想。maven的约定除了目录位置外，Maven的核心插件也使用了一组通用的约定，以用来编译源代码，打包可分发的构件，生成 web 站点，还有许多其他的过程。Maven它有一个定义好的生命周期和一组知道如何构建和装配软件的通用插件。如果循这些约定，我们只需要将代码放到正确的目录，Maven就会帮你处理剩下的事情。Ant则全是手工进行。
  
  Ant 将提供了很多可以重用的task，例如 copy, move, delete 以及junit 单元测试。Maven 则提供了很多可以重用的过程。可以通过写shell一样一个Java项目的build过程来进行描述。写好一个build.xml 文件，来解决Java程序运行编译过程中需要解决的classpath，以及相关参数的配置问题，只要是项目中的主要结构以及依赖的库不变，很少去修改build.xml。但是如果我们要开发一个新的项目即使原有项目的build.xml能够复用得模块还是比较少的。因为Ant 所提供的可重用的task粒度太小，虽然灵活性很强，但是我们需要纠缠很多细节的东西。
    
  


----
#Maven 

###一.基础
Maven是一个采用纯Java编写的开 源项目管理工具。Maven采用了一种被称之为project object model (POM)概念来管理项目，所有的项目配置信息都被定义在一个叫做POM.xml的文件中，通过该文件，Maven可以管理项目的整个声明周期，包括编译，构建，测试，发布，报告等等。


官方定义：
Maven是一个项目管理工具，它包含了一个项目对象模型 (Project Object Model)，一组标准集合，一个项目生命周期(Project Lifecycle)，一个依赖管理系统(Dependency Management System)，和用来运行定义在生命周期阶段(phase)中插件(plugin)目标(goal)的逻辑。
####核心概念
#####1.项目对象模型POM
POM回答类似这样的问题：这个项目是什么类型。项目的名称是什么。项目的构建自定义。
#####2.坐标
Maven坐标的元素包括groupId、artifactId、version、packaging、classifier。
groupId：定义当前Maven项目隶属的实际项目。groupId的表示方式与java包名的表示方式类似，通常与域名反向一一对应。 
artifactId：该元素定义实际项目中的一个Maven项目/模块。
version：版本。
packaging：打包方式。如：jar、war。 
classifier：不能直接定义，用来表示构件到底用于何种jdk版本

#####3.项目生命周期
#####4.插件和目标
#####5.依赖管理
#####6.仓库管理

###二.常见操作

####1.创建项目
 mvn archetype:create -DgroupId=com.meituan.app -DartifactId=meituan-app
 注意：groupId即是一般代码路径中上层目录
 	   artifactId就是项目名称
 然后用eclipse导入
 目录结构（约定）：
 	src/main/java:源码目录 
 	src/main/resources:资源目录(如存放log4j.properties)
 	src/main/webapp:web目录
 	src/test/java:测试源码目录 
 	src/test/resources:测试资源目录
 	target:编译结果目录
 	
####2.pom.xml 文件
pom.xml是maven对一个项目的核心配置，这个文件将包含如何构建项目的大多数配置信息.

pom定义了最小的maven元素groupId,artifactId,version。

groupId:项目或者组织的唯一标志，并且配置时生成的路径也是由此生成。

artifactId: 项目的通用名称.


version:项目的版本


packaging: 打包的机制，如pom, jar, maven-plugin, ejb, war, ear, rar, par


classifier: 分类
####基础配置：

\<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">

   \<modelVersion>4.0.0\</modelVersion>  
   	 
  \<groupId>com.meituan\</groupId> 
   
\<artifactId>mdemo\</artifactId> 
  
\<version>0.0.1\</version> 

\</project>

POM关系
Java工程一般会依赖其它的包。在Maven中，这些被依赖的包就被称为dependency。
#####a.依赖
  依赖关系列表（dependency list）是POM的重要部分。
  
   \<dependencies> 
   
   \<dependency> 
    
   \<groupId>junit\</groupId> 
   
   \<artifactId>junit\</artifactId> 
    
   \<version>4.0\</version> 
    
   \<scope>test\</scope> 
    
  \</dependency> 
  
  \</dependencies>
  
#####b.继承
  \<parent> 标签
#####c.合成
 \<project> 标签
####3.常见命令和用法

mvn clean test

mvn clean package

mvn clean install

clean说明要清空所有的配置文件

test说明要运行单元测试

package说明要打包

install安装到本地仓库

####4.生命周期和phase
 Maven拥有三套相互独立的生命周期，分别为clean、default和site。
 
 clean生命周期的目的是清理项目，default生命周期的目的是构建项目，而site生命周期的目的是建立项目站点。
 
 
 在上述的3个生命周期下会有相应的阶段
 
* clean生命周期包含三个阶段：pre-clean、clean、post-clean
* default 包括很阶段
* site生命包含4个阶段：pre-site、site、post-site、site-	deploy

####5.仓库
   Maven中的任何一个依赖、插件或者项目的构建输出，都可以称为构件。任何一个构件都有一组坐标唯一标识。Maven项目中构件的坐标都是完全相同的。在此基础上，Maven可以在某个位置统一存储所有Maven项目共享的构件，这个统一的位置就是仓库。 对于Maven来说，仓库只分为两大类：本地仓库和远程仓库。当Maven根据坐标寻找构件的时候，它首先会查看本地仓库，如果本地仓库存在此构件，则直接使用；如果本地仓库部存在此构件，Maven就会去远程仓库查找，发现需要的构件之后，下载到本地仓库再使用。即本地>远程。
 
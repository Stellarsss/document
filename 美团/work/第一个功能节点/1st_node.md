
#第一个功能节点
##1.到底是要做什么?
   一句话描述：通过平台提供的服务和功能实现一个包括前端部分在内的简单(增删改查)功能.（麻雀虽小，却能包括我们平台中大部分常用的功能和服务）
   
  **选题**:第一个功能节点的功能选择 没有特别的限制，可以做一个熟悉的领域或者感兴趣的题目。比如 考勤功能，借书功能，订餐等。
   
  **建议**:
  
  功能不要整的太复杂，在这个阶段关注点是熟悉整个开发的流程，不要耗太多时间在业务上。
   
   [ ]TODO

## 2.需要达到的目标 
通过系统的平台实现一个简单功能，在此过程中: 

1. 初步了解系统设计思路，功能实现流程和注意事项。  
 
2. 记录问题(重要)，找出自身不足。  
 
3. 熟悉团队工作流程和一般代码规范。

4. 培养在学习技能时，整理输出的习惯（代码和文档）


[ ]TODO

## 环境配置
   参见1st_day.md
   
## 开发过程分解
开发总体来说分为两个阶段，前端部分和后端部分。其中后端开发又分为2个阶段：即基于元数据和单据模版。开发过程从后端开始，后端开发完毕后在开发前端。

**下面分别介绍其开发流程和注意事项**
 
## 基于元数据的后端开发步骤


   
### 元数据 table meta

1. 元数据是什么？

   参见metadata.md
   
2. 实现meta
    * 参考已有的实现 比如：AssetMeta，简单了解每一种Field的含义，以及如何定义。
    	TAB_CODE（表码）  
		TAB_NAME(表名)  
		PKField：主键字段  
		CodeField：字符串字段  
		RefField：引用字段  
		MoneyField：钱字段  
		MemoField：备注字段  
		…………
	* 需要继承AbstractTableMeta,熟悉下相关的接口。
	
	* 按照需求定义字段    		 
    
    **思考：**

	1.属性放哪合适，设计的合理性（质量评估）
 
	2.设计自检。（testcase作为判断标准之一，已有实现是什么样的，以前是什么样子的）
	
	
### controller 测试用例

 * 设计用例。（目的是要想好输入和输出到底是什么）
 
 明确输入输出。考虑好如何验证自己的功能.可以参考AssetControllerTestCase
	
	//输入：URL：Controller方法的访问路径；GenericVO：必须包含Controller方法所需参数；ClientEnv：用户信息
	GenericVO book = new GenericVO().set("BOOK_CODE", "13042500131").set("BOOK_NAME","c++ primer").set("ISTAT", "1");
	GenericVO send = new GenericVO().set("data", book);
	String ret = handleReturn("/oa/am/book/oa/am/book/save", send, client);

* 编写用例  

	* 须继承自AbstractTestNGControllerTests，利用其handle或handleReturn方法。  
	
				AbstractTestNGControllerTests：利用spring提供的MockHttpServletRequest和MockHttpServletResponse发起Http请求和获得响应，返回String或ModelAndView。
	
			//url：请求地址；param：请求参数；client：用户信息  
			protected String handleReturn(String url,GenericVO param,ClientEnv client)throws Exception;
			ModelAndView handle(String url,GenericVO param,ClientEnv client)
	* 新建表采用DbStructAnalysisBizService服务(数据结构分析服务)，利用其syncEntity方法。  
	
			@Autowired
			@Qualifier("pf.mds.service.dbstructanalysis")
			private DbStructAnalysisBizService dsaService;
			//同步表，class为表名  
			public void syncEntity(Class<? extends TableMeta> clazz) throws BuzException;
			//业务加工(开发，运维工具)中提供了元数据管理的界面，可以提供在线的实体元数据与表结构的同步
	* 获得用户信息采用:注入AuthenticateBizService服务(授权服务)，利用其loginEnv方法。  

			@Autowired
			@Qualifier("pf.sa.service.authentication")
			AuthenticateBizService authService;
			//登录用户，accountCode：账户码；accountPwd：密码；是否采用sso  
			ClientEnv login(String accountCode,String accountPwd,Boolean sso) throws BuzException;

### controller 定义

根据测试用例，实现自己的Controller，须继承自BaseController，否则需要自己实现异常处理。

		BaseController：实现Controller的异常处理，截获所有Throwable，将其转换为BuzException，然后截获BuzException异常。因此建议Controller方法都抛出BuzException异常。  

在Controller中实现持久化，可以有以下两种方法:
	
#### 利用CommonBizService来实现
* 注入服务
	
		@Autowired
		@Qualifier("pf.service.common")
		CommonBizService commonService;
				     
* 注意事项
	* 如果以服务的方式对外提供（接口中定义）否则建议在controller中直接编写。
	* controller中只要一次service调用（数据库连接）。更好的是减少数据库查询次数。
	* SQL单独定义要有具体含义和注释，并且要使用别名（单表也要有）
	* SQL复用要放在dao里
	* insert 和 update均叫save
	* action映射规范（rest）
	* controller异常处理需要继承BaseController，否则需要自己实现异常处理
	* LOG需要统一使用
	* 持久化不能用commonDao，因为没有事务保证，需用CommonBizService

#### 自定义业务服务(service)
为controller提供服务，实现一些业务接口

* 定义服务接口
	
		包名约束：接口定义在com.meituan.oa.xxx.service，实现在com.meituan.oa.xxx.service.impl
		命名约束：名称包含*BizService*
		参数规则：SQL语句StringBuilder，实体GenericVO，用户信息ClientEnv
* 实现

		//必须继承AbstractBusinessService,实现前面定义的服务接口类
		AbstractBusinessService：所有Service都必须继承自它。它主要包括3个用途：		1、	提供CommonDao用于CRUD；		2、	提供oplog，用于在Mongodb中存储操作日志；		3、	提供错误处理
* 标注

		//规则约定
		@Service("xxx.xxx.xx")

* 在controller中的调用

		注入服务，以billService为例
		@Autowired
		@Qualifier("pf.bs.service")
		BillBizService billService;
		调用接口

	
***思考：***
    	为什么controller里使用CommonDao没有事务保证，而在service中确能有事务保证？
	
* 注意事项
  
	* service方法统一方式进行异常处理
	* 数据变更一定要有校验
	* 注释要足够清晰和完整
	* 用户行为要记录,特别是数据变更（oplog）
	* service方法最好要有ClientEnv
	
### dao层(可选)
    
 如果有较为复杂的数据存取 可以写一个dao，一般情况下commonDao（service里）和CommonBizService（controller）已经能满足需要。
 
### 运行测试用例调试

	//TODO 补充调用方式
	
## 基于单据模板的后端开发步骤

当基于元数据的后端开发完成后，就可以着手单据模版方式的开发

### 定义单据模板
* 文件位置
	src/main/resources的action/oa/pf/bs/model/ 目录下配置单据模板

* 命名规范
   以bill_code命名文件夹,文件名叫oa.pf.bs.model.find.action
   
* 基本属性介绍
	
	
		bill_code：单据码  
		layout：布局方式，list：列表; grid:网格
		ext: 扩展，service的名称，单据提交后做额外处理 
		main：
			metaCode：表码  
			metaName：表名  
			field：字段， 
				code：字段编码，必须与TableMeta对应   
				name：字段名称  
				type：字段类型
				showtype：展示类型，可选值：head，tail，暂不支持
				showlist：是否列表展示,可选值：true，false
				listpos：列表位置
				showcard：是否卡片展示，可选值：true，false
				cardpos：卡片位置
				ispk：是否主键
				required：是否必须，true：名称前加*号
				iscate：是否分类，true：重新请求数据
				config：  
					DS_CODE:数据集码   
					param:{"show_type":"tree"}弹出界面的表格以树形显示内容 


### controller testcase
   
   重新审视下测试用例，修改为适应单据模版方式。   
### controller实现

修改元数据的Controller为单据模板的。（增删改已经有成熟的接口，但查询需要自己实现）  

使用的service和元数据不一样：

	元数据用CommonBizService实现CRUD，单据模板利用BillBizService实现CRUD。 
	 
	元数据利用TableMeta.class指明哪个元数据，单据模板用bill_code指明哪个单据模板。

### service定义&实现&测试

BillBizService:封装了对单据模板的CRUD操作。

	//查找一批记录，bill_code：单据码，param：参数，client：用户信息  
	public List<GenericVO> fetch(@RequestParam("bill_code") String bill_code, @RequestParam("param") GenericVO param, ClientEnv client) throws Exception 
	//保存单据，bill_code：单据码；billdata：单据数据；env：用户信息
	public String saveBillData(String bill_code, GenericVO billdata, ClientEnv env) throws BuzException;
###	参考文档
	docs/java/pf/cookbook/bill.md
	
## 前端开发
完成后端开发后 就可以进行前端开发了。

### 功能节点注册
首先要考虑下访问的url
比如 http://localhost:8080/#/xxx/yyy表示功能节点的访问路径 那么将会有如下定义过程.

在相应目录下定义src/main/webapp/static/xxx/yyy.js（**注意路径和命名**）
这样功能节点就注册好了，当访问上述url时会去解析所定义的文件.

### 代码框架
前端的代码基本上是一个模式的（现有模式已经在整改中）
可以参见asset-model.js的内容来进行开发

### 添加控制和对接后端

	M.add('oa-xxx/yyy'…)
	oa-后面的xxx/yyy表示namespace 
	Y.namespace("mt.oa.xxx.yyy")  
	billCode=单据模板定义的单据码  
	searchBox： 
	 	data：必须与单据模板定义一致 
		searchUrl：与Controller定义一致
	byTable:
		toolbar：默认实现的有addNew，modifyNew，del，view，其他按钮须自定义实现
	
	详见前端参数文档 TODO
### 测试
	数据库相关操作 参见 mysql_mongodb_operation.md
	在eclipse中Run Jetty或终端中./jettyrun.sh(记得先启动mongodb)  
	浏览器输入http://127.0.0.1:8080/#/account/login登录系统  
	以http://127.0.0.1:8080/#/xxx/yyy访问功能节点，测试各功能是否正确。
		
## 常见问题列表FAQ

**1.RefField的含义?DS_CODE是什么意思？**  

RefField是数据集的引用，DS_CODE是数据集码，它指向一个SQL查询或者其它方式得到的集合，参考系统->业务加工->数据集服务。
 
**2.TestNG运行报错：NullPointerException** 

注意url路径是否与Controller的一致。  

**3.TestCase中，handle和handleReturn分别怎么用？**
	
		handle：将Controller的返回值包装在String的data字段中；
		
		handleReturn：将Controller的返回值包装在ModelAndView中。
		

**4.为什么sql参数不能为String，必须为StringBuilder？** 
 
性能考虑，频繁字符串操作  

**5.sql语句中  $[],${}是什么意思？**  

$[]可选，GenericVO中如果包含该字段，则填上，如果没有，则跳过。 
 
${}必填，GenericVO中必须包含该字段。
具体内容参考docs/java/pf/cookbook/dao.md

**6.根据MVC，Controller使用Service,Service使用Dao。为何Controller都直接用CommonBizService？** 
 
按理应该封装Service，供Controller调用，对超过一次使用到的SQL，需设计接口和实现。只一次的就直接写在Controller中。

**7.元数据和单据模板分别什么时候用？为什么有两套东西？**
  
元数据是定义数据库的表结构。单据模板是元数据和界面之间的桥梁。   
(pf.bs,platform.bill.service)是为了人们不再关注基本的CRUD及相关的界面实现，而封装出来的一个业务组件。  
只需要简单地配置，完成复杂的CRUD和界面。

**8.为何要这样设置单据模版的位置和命名？**  
前端按照以下路径发起请求：
http://ip:8080/oa/pf/bs/model/{bill_code}/oa.pf.bs.model.find.action  
因此按以上设计才能正确找到相应的单据模板。 
 
**9.showlist和showcard有什么区别？如何设置?**   
showlist是指当数据以列表方式展示时，该字段是否显示（当列数过多时需省略显示某些字段），showcard是指当数据以卡片方式显示时，该字段是否显示（在新增时一般以卡片方式显示）。

**10.数据库表是在什么时候建立的？**

测试用例中看到单个表的建立采用DbStructAnalysisBizService。  
系统通过前端统一管理表。  
在业务加工->元数据服务中，单击查询，将搜索classpath下所有AbstractTableMeta的子类，生成SQL建表语句，然后单击同步后，根据数据库中是否有该表，选择是建表还是修改表结构。

**11.请求从前台到后台，再到数据库时怎么一个具体过程，经过了哪些类（类似系统结构图）**





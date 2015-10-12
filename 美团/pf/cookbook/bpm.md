# 流程服务
## 场景
* 支持`主流的`[21种流程模式](http://zh.wikipedia.org/wiki/%E5%B7%A5%E4%BD%9C%E6%B5%81%E6%A8%A1%E5%BC%8F "逗你玩不行啊")
* 基于bpmn v2标准

## 选型

#### jbpm vs activiti
jBPM是目前市场上主流开源工作引擎之一，在创建者Tom Baeyens离开JBoss后，jBPM的下一个版本jBPM5完全放弃了jBPM4的基础代码，基于Drools Flow重头来过，目前官网已经推出了jBPM6的beta版本；Tom Baeyens加入Alfresco后很快推出了新的基于jBPM4的开源工作流系统Activiti。由此可以推测JBoss内部对jBPM未来版本的架构实现产生了严重的意见分歧。

技术组成|Activiti|jBPM5
---:|:---:|:---
数据库持久层ORM|MyBatis3|Hibernate3
持久化标准|无|JPA规范
事务管理|MyBatis机制/Spring事务控制|Bitronix，基于JTA事务管理
数据库连接方式|Jdbc/DataSource|Jdbc/DataSource
支持数据库|Oracle、SQL Server、MySQL等多数数据库|Oracle、SQL Server、MySQL等多数数据库
设计模式|Command模式、观察者模式等	
内部服务通讯|Service间通过API调用|基于Apache Mina异步通讯
集成接口|SOAP、Mule、RESTful|消息通讯
支持的流程格式|BPMN2、xPDL、jPDL等|目前仅只支持BPMN2 xml
引擎核心|PVM（流程虚拟机）|Drools
技术前身|jBPM3、jBPM4|Drools Flow
所属公司|Alfresco|jBoss.org

#### 为何选择activiti
* jbpm夹带了太多的私货，jboss家能沾边的都用上了

## 二次封装
### BpmBizService常用方法

	/** 启动流程
	  * @param pd_key：流程定义ID（必填）
	  * @param work_item：实体主键（必填）
	  * @param message：任务消息（可选）
	  * @param env：用户信息（必填）
	  * @return 流程实例ID
	  */	
	public String start(String pd_key, GenericVO work_item, String message, ClientEnv env) 
	
	/**
	 * 通过任务
	 * @param task_id：任务id（必填）
	 * @param message：任务消息（可选）
	 * @param env：用户信息（必填）
	 * @return：void
	 */
	public void commit(String task_id, String message, ClientEnv env) throws BuzException

	/**
	 * 获取任务列表(尚未完成的)
	 * @param pd_key：流程定义ID（可为null，查询所有流程定义的任务）
	 * @param 查询参数（可为null，查询所有条件的任务）可设以下参数：
		task_id：任务ID
		start_ts：起始时间
		end_ts：结束时间
		TASK_DESC：任务描述	
	  * @param env：用户信息（必填）
	  * @return：void
	 */
	public List<Task> fetchTaskList(String pd_key, GenericVO param, ClientEnv env)


**注意：对一个实体主键，只能启动一个流程实例，否则会报错**

### BpmManagementBizService常用接口
	/**
	 * 根据流程定义文件部署流程
	 * @param resources：资源列表（必填）
	 * @return 流程定义ID
	 */
	public String deploy(List<String> resources) throws BuzException
	
	/**
	 * 删除流程定义
	 * @ param：deploy_id：流程定义ID（必填）
	 * @ return：void
	 */
	public void unDeploy(String deploy_id) throws BuzException

	/**
	 * 删除流程实例,如果该流程定义有关联的流程实例，必须先调用cleanProcInstByID，删除所有关联的流程实体
	 * @param：proc_inst_id：流程实例ID（必填）
	 * @param client：用户信息（必填）
	 * @return：void
	 */	
	void cleanProcInstByID(String proc_inst_id, ClientEnv client) throws Exception


## 测试用例
不推荐采用activiti自带的测试用例基类，否则每次执行测试都会清除数据库(如果连接自己的数据库，则无所谓)
### 单元测试
TODO
### 集成测试
TODO
## 流程部署
* 如果只是控制条件的变化，不建议重新部署流程(使用业务加工->流程部署预览，将pd_key符合要求的都查出来，挨个修改)
* 部署前务必检查一下bpmn文件中的process tag的id，name是否与流程定义(mt_oa_pd)保持一致
* 如果流程定义中的流转关系发生了变化，比如usertask等都发生了变化，推荐重新部署(http//:<ip>:<port>/#/bpm-tool，点击流程部署按钮，在弹出的窗口中点击加载按钮，选择待部署的流程，点击部署按钮)

## 已知缺陷/短板
* act_hi_varinst && act_ru_variable是动态结构纵向延展存储的典型反面教材，其数据量与流程实例的数量比例基本上是`20:1`(如果简单的利用复杂类型存lob的机制将workitem整体存进去，则需要自行将过程控制的属性确保其能与sql组合查询，符合业务条件的结果集；如果采用mongo or neo4j切换其workitem存储，也将导致大幅度的调整)
* 目前尚无法将其完全的变成一个独立的流转服务
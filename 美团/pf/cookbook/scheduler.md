# 任务调度
## 应用场景
* 可以部署为独立的服务(单纯的调度服务？把context作为参数传过去，直接restful，这样大家都消停了)
* 可以自行配置，监控，调整job的执行
* 


## 选型
### timer@jdk
	典型使用
	public static void main(String[] args) throws InterruptedException {
		TimerTask task = new TimerTask() {
			@Override
			public void run() {
				// TODO Auto-generated method stub
				System.out.println(" I am running");
			}
		};
		Timer timer = new Timer();
		Calendar calendar = Calendar.getInstance();
		calendar.setTimeInMillis(new Date().getTime() + 3000);
		// timer.schedule(task, calendar.getTime());// 3秒后执行
		//timer.scheduleAtFixedRate(task, calendar.getTime(), 1000);//特定时间开始，每隔1秒执行一次
		timer.scheduleAtFixedRate(task, 1000, 1000);//1秒后，每隔一秒执行一次
		//timer.schedule(task, 1000);// 延时多少秒
		Thread.sleep(10000);
		timer.cancel();	
	}
### scheduledexecutor@jdk
	public static void main(String[] args) throws InterruptedException, ExecutionException{
		
		
		  ScheduledExecutorService scheduleService = Executors.newScheduledThreadPool(3);
		  Runnable task = new Runnable(){
			  public void run(){
				  
				  System.out.println("I am running~");
			  }
		  };
		  scheduleService.schedule(task, 1000, TimeUnit.MILLISECONDS);
		  scheduleService.execute(task);
		  //scheduleService.scheduleAtFixedRate(command, initialDelay, period, unit)
		  ScheduledFuture<String> future =  scheduleService.schedule(new Callable<String>(){
			@Override
			public String call() throws Exception {
				return " callable";
			}		  
		  }, 1000, TimeUnit.MILLISECONDS);
		  	 System.out.println(future.get());
		  Thread.sleep(5000);
		  scheduleService.shutdown();
	}
### schedule@spring
	//TODO 代码待补
### scheduler@guava
	//TODO 代码待补
### quartz

#### 关键概念
* scheduler:调度器，负责调度任务的执行
* job:
* jobdetail:`job instance`
* trigger:可以简单的理解为job执行的触发规则。a component that defines the schedule upon which a given Job will be executed.

#### 技术储备
##### 配置方法
* maven配置

		<dependency>
    		<groupId>org.quartz-scheduler</groupId>
    		<artifactId>quartz</artifactId>
    		<version>2.2.0</version>
		</dependency>
* classpath下添加一个quartz.properties的文件。

		
		
		#mtoa/src/test/resources/quartz.properties
		org.quartz.scheduler.instanceName = mt.oa.scheduler
		org.quartz.threadPool.threadCount = 3
		org.quartz.jobStore.class = org.quartz.simpl.RAMJobStore
		
		StdSchedulerFactory 读取该配置文件来实例化一个调度器(scheduler)
		默认会读取quartz.properties否则，org/quartz 包下的文件将会被读取。
		如果要自定义配置文件的名字的话需要设置System属性org.quartz.properties去指定相应的文件。
		解释：
		1. org.quartz.scheduler.instanceName

		调度器的实例名称，对于调度器实例本身来说，没有实际意义。但当同一程序中存在多个实例时这个用来区分不同的实例，如果在集群（cluster）环境中，则必须使用同一个名称来表示逻辑上是一个调度器。

		2. org.quartz.scheduler.instanceId和org.quartz.scheduler.instanceIdGenerator.class

		instanceId能够是任何字符串，但是必须要唯一，如果设置为AUTO则instanceIdGenerator专门用来设置生成规则。
		除了ATUO还有SYS_PROP属性（读取系统属性org.quartz.scheduler.instanceId）

		3. org.quartz.scheduler.threadsInheritContextClassLoaderOfInitializer

		A boolean value ('true' or 'false') that specifies whether the threads spawned by Quartz will inherit the context ClassLoader of the initializing thread (thread that initializes the Quartz instance). This will affect Quartz main scheduling thread, JDBCJobStore's misfire handling thread (if JDBCJobStore is used), cluster recovery thread (if clustering is used), and threads in SimpleThreadPool (if SimpleThreadPool is used). Setting this value to 'true' may help with class loading, JNDI look-ups, and other issues related to using Quartz within an application serve.
		
* 详细的配置
	1. [Main Configration](http://quartz-scheduler.org/documentation/quartz-2.1.x/configuration/ConfigMain)

	2. [ThreadPool Settings](http://quartz-scheduler.org/documentation/quartz-2.1.x/configuration/ConfigThreadPool)
	
	3. [Global Listeners Settings](http://quartz-scheduler.org/documentation/quartz-2.1.x/configuration/ConfigListeners)

		
		
* 编写一个测试类，进行简单测试，验证是否配置好

		Scheduler s = StdSchedulerFactory.getDefaultScheduler();
		s.start();//启动
		s.shutdown();//结束
* cluster config
	
		//TODO 目前似乎难以验证
* db store
	
		执行一下mtoa/srcmain/resources/sql/mt.oa.pf.sched.mysql.innodb.sql
		构建quartz执行需要的数据环境


* integration spring
	* 定义一个单独的mt.oa.schedule.xml文件,需要注意以下内容

			<bean id="spring.scheduler" class="org.springframework.scheduling.quartz.SchedulerFactoryBean"
			lazy-init="false" destroy-method="destroy">
				<property name="autoStartup" value="true"/>
				<property name="waitForJobsToCompleteOnShutdown" value="false"/>
				<property name="dataSource" ref="dataSource"/>
				<property name="overwriteExistingJobs" value="true"/>
				<property name="applicationContextSchedulerContextKey" value="appctx"/>
				<property name="configLocation" value="classpath:quartz.properties"/>
				<property name="startupDelay" value="30"/><!-- 延时启动 -->
				<!-- <property name="overwriteExistingJobs" value="true"/> -->
				<!-- 启动时更新己存在的Job，这样就不用每次修改targetObject后删除qrtz_job_details表对应记录了 -->		
			</bean>

	* 调整mt.oa.test.xmp以及mt.oa.app.xml的profile，确保`mt.oa.schedule.xml`能import进去
* 从下载包中docs/dbTables中找到适用于`mysql innodb`引擎的脚本(为了保持命名空间的一致性，qrtz_改为mt_oa_qrtz_为了简单起见，你也可以不修改)，执行建表
* 跑一遍测试用例，简单测试一下(添加一个普通的job，配置一个cron trigger)


## 二次封装
### 服务定义
* start(ClientEnv client)
	* 作为容器启动的入口
* shutdown(ClientEnv client)
	* 作为停止容器的入口
* saveJob(genericvo job_detail,ClientEnv client)
	* 保存任务(并不启动)
* saveTrigger(genericvo trigger,ClientEnv client)
	* 保存触发器(关联cron trigger,)
* removeJob(String job_name,String job_group,Client env)
	* 需要注意的是removeJob，会级联删除trigger
* removeTrigger(String trigger_name,String trigger_group,Client env)
* [?] restart(ClientEnv client)
	* ***规划中，尚未决定是否提供该功能***
* fetchLog(GenericVO param,ClientEnv client)
* execute(Genericvo trigger,clientenv client)
	立即执行当前选中的trigger
	
		//TODO 从这个角度出发，任务调度管理其实可以将job与trigger分开，有job没trigger一样不能启动

### 对外暴露的rest api
	//TODO 待补充

### 存储的数据结构
#### quartz自身的数据结构

* [prefix]_QRTZ_LOCKS

编码|类型|可否为空|备注
:---|:---:|---|---:
SCHED_NAME | varchar(120) |no
LOCK_NAME  | varchar(40)  |no

* [prefix]_BLOB_TRIGGERS
* [prefix]_CALENDARS
* [prefix]_PAUSED_TRIGGER_GRPS
* [prefix]_SCHEDULER_STATE
* [prefix]_SIMPLE_TRIGGERS
* [prefix]_SIMPROP_TRIGGERS
* [prefix]_CRON_TRIGGERS
* [prefix]_JOB_DETAILS
* [prefix]_FIRED_TRIGGERS
* [prefix]_TRIGGERS

		//TODO 待补充

#### pf维护的数据结构
* MT_OA_JOB

编码|名称|类型|备注
:---|:---:|:---:|---:
PK_JOB|主键|T_PK
JOB_NAME|任务编码|T_CODE
JOB_GROUP|任务分组|T_CODE
JOB_CLAZZ|任务资源|T_CODE
MEMO|备注|T_MEMO
MOD_CODE|模块编码|T_CODE
PK_ACCOUNT_CRT|创建者|T_REF
CRT_TS|创建时间|T_TIMESTAMP
LM_TS|最后修改时间|T_TIMESTAMP
ISTAT|状态|T_STAT

* MT_OA_TRIGGER

编码|名称|类型|备注
:---|:---:|:---:|---:
PK_TRIGGER|主键|T_PK
PK_JOB|主键|T_REF
PK_CRON|cron主键|T_REF|常用的时段，注册成参照
CRON_EXP|cron表达式|T_CODE|当此字段有值时，优先
ISTAT|状态|T_STAT|
CRT_TS|创建时间|T_TIMESTAMP
LM_TS|最后修改时间|T_TIMESTAMP
		
## 使用步骤（业务程序员）
### job impl
定义一个Job的实现类(实现AbstractJob)

	public class AbstractJob implements Job{
		protected ApplicationContext getAppCtx(JobExecutionContext context){
		//appctx在bean的文件中定义
			ApplicationContext appctx = (ApplicationContext)context.getScheduler().getContext().get("appctx");
			return appctx;
		}
		protected void oplog(JobExecutionContext context){
			//。。。
			//用于记录操作日志，方便查询
		}
	}
在execute方法中实现需求

	推荐在job中直接调用spring注册的bean，而不是将逻辑堆砌在job的impl中，一来保障事务，二来，确保job的impl仅仅是服务调用，便于移植

### 部署
提交代码后，重新部署war
### 注册、配置
* 通过业务加工-任务调度管理功能节点增加job，并配置cron trigger；(执行间隔根据自己需要来)

		cron expression，将来会有一个可视化的傻瓜配置界面；现在只能6/7段
		有不明觉厉的观众，请自行放狗，并补充该文档
* 点击`[立即执行]`按钮，点击`[执行日志]`按钮，查看输出日志，验证其是否成功
# 业务服务
## 基本思路
	面向接口编程；如果不是必要的，公用的，需要对外部提供的查询方法，无需定义接口方法，直接放controller中，就行
## 事务保障
* 利用aop实现，请阅读mt.oa.repository.spring.xml中关于aop的相关配置
* 利用类，方法的命名规则进行配置

		//如果对事务隔离级别，嵌套等不太清楚的，请自行脑补
		//如果对悲观，乐观；排他，共享，意向锁还不太清楚的。。。请自行脑补
	
## 命名规则
### 包的命名规则
	//mod_code:业务模块编码，可以从keyword.md中获取
	com.meituan.oa.<mod_code>.service
### 类的命名规则
	//只所以叫这个名字。。。请看mt.oa.repository.spring.xml中关于aop的相关配置，如果没整明白，自补或者咨询同事
	XXXBizService
### spring bean别名的命名规则
	<mod_code>.service.<some_thing>
## 基类申明
	//如果没有特殊情况，请继承AbstractBizService
	public class XxxBizServiceImpl extends AbstractBusinessService implement XxxBizService{...}

## 方法命名规则
* 查询一个具体的业务对象：findXxx
* 查询一组具体的业务对象：fetchXxx
* 保存一个业务对象：saveXxx
* 删除一个或一组对象：deleteXxx

## 异常处理
	try{
		…
	}catch(Exception e){
		processError(e);//之所以没直接aop，是想让代码更加直观易懂
	}
## 代码范式
### 查询
	...
	try{
		StringBuilder sql = new StringBuilder(…);
		…
		GenericVO param = …;
		List<GenericVO> list = _commondao.query(sql,param);//_commondao在AbstractBusinessService中定义
		return list;
	}catch(Exception e){
		processError(e);//如果需要自行定义反馈到前端的异常
	}
### 数据变更	(新增，修改，删除)
	//
## 测试用例
### spring context xml引入
	//在类的头部定义context配置，以便注入
	@ContextConfiguration(locations={"classpath:/spring/mt.oa.test.xml"})
	
### 测试基类
	org.springframework.test.context.testng.AbstractTestNGSpringContextTests
### 事务保障	
	不要在测试用例的class中使用commondao，这样做，无法获得事务保障，请替代以commonbizservice
	
### 典型代码
	try {
		//bill,bill_meta,bill_field
		dsaService.syncEntity(BillMeta.class);
	} catch (Exception e) {
		TestCaseHelper.processError(e);
	}
## 常见问题

#缓存服务

## 应用场景
* 相对稳定的,高频使用的(可能需要有evict的相应处理)，数据，配置
* bs.data.find;bs.model.find

## 选型

### memcached
### redis
### ehcache
#### 关键概念
* 命中率

#### 配置方法
* maven config

		  <dependency>
		    <groupId>net.sf.ehcache</groupId>
		    <artifactId>ehcache</artifactId>
		    <version>2.3.1</version>
		    <type>pom</type>
		  </dependency>
* 编辑一个ehcache.xml放到classpath目录下

		//TODO 代码待补

* 编辑mt.oa.cache.xml写入mt.oa.test.xml以及mt.oa.app.xml中

		//TODO 代码待补

* 
#### 基本用法
* 编写一个测试类
* 模拟一个bs.data.find的处理
* 模拟bs.model.find的处理，存在嵌套的问题

	* 代码修改如下：
	
			//在billbizserviceimpl中找到以下方法，加上@Cacheable
			@Cacheable(value="bs_model_cache",key="#bill_code+#catePK")
			@Override
			public GenericVO find(String bill_code, String catePK) throws BuzException {
	* 测试代码如下：
	
			@Test
			public void testLoadBillModel(){
				try {
					ClientEnv client = authService.loginEnv("admin");
					String bill_code = "gl_ro_bill";//bill code
					int len = 1000;
					long[] start = ProfLogHelper.begin();
					for(int i=0;i<len;i++){
						handleReturn("/oa/pf/bs/model/"+bill_code+"/oa.pf.bs.model.find.action",p,client);	
					}
					String msg = ProfLogHelper.end(start, "test");
					System.out.println(msg);
				} catch (Exception e) {
					TestCaseHelper.processError(e);
				}
			}
	* 性能对比如下：
	

	场景|循环次数|原代码执行(ms)|缓存后执行(ms)
	:---|:---:|:---:|:---
	bs.model.find|1000|6362|3700


	* 由于单据模板本身进行了mongo缓存，所以性能不是很显著
* 测试获取单据明细数据的性能对比(此时未进行datapod的缓存)
	* 代码修改如下：
	
			//在billbizserviceimpl中找到以下方法，加上@Cacheable
			@Cacheable(value="bs_data_cache",key="#bill_code+#pk_cate+#pk_value_main")
			@Override
			public GenericVO findBillData(String bill_code,String pk_cate,String pk_value_main, ClientEnv client) throws BuzException {
	* 测试代码如下：
	
			@Test
			public void testLoadBillData(){//测试加载数据
				try {
					ClientEnv client = authService.loginEnv("zuojiaoyun");
					String bill_code = "gl_ro_bill";//bill code
					//mock bill_data
					GenericVO p = new GenericVO().set("bill_code",bill_code);
					p.set("pk_value_main","4028822541684cbe0141685557100003");
					p.set("pk_cate","RANGE_CODE8497496200000000000000");
					int len = 50;
					long[] start = ProfLogHelper.begin();
					for(int i=0;i<len;i++){
					handleReturn("/oa/pf/bs/data/"+bill_code+"/oa.pf.bs.data.find.action",p,client);	
				}
				String msg = ProfLogHelper.end(start, "test");
				System.out.println(msg);
				} catch (Exception e) {
					TestCaseHelper.processError(e);
				}
			}
	
	* 性能对比如下：
	
	
	场景|循环次数|原代码执行(ms)|缓存后执行(ms)
	:---|:---:|:---:|:---
	bs.data.find|10|5464|1297
	bs.data.find|50|25234|1521
 
* 获取dataset模型(不带数据)
	* 代码修改
		
			//
			@Cacheable(value="ds_model_cache",key="#ds_code")
			@Override
			public GenericVO findModel(String ds_code, ClientEnv client) throws BuzException {
	* 测试代码
		
			//
	* 性能对比
* 获得dataset模型(带数据，无数据权限)
	* 代码修改
	* 测试代码
	* 性能对比
* 通过datapod方式获取
* 数据权限缓存


		由于存在现实的级联调用关系，比如：datapod-->bill,如果构成单据的一个属性(值域是T_REF),该属性的值域：ds_code=enum_fi_item的编码，名称(即)发生了变化，此时应该能清除所有引用到该参照的bs_data_cache的key
		数据集的新增，修改，删除都需要级联更新

## 二次封装
### 服务定义
* cache 监控

### rest api
### 存储结构
## 使用方式	
	一定要涉及到cache的监控，在线清理，控制开关之类的细节
	重点在于单据模板，datapod引用；单据明细数据；数据权限映射(rm-->datapod-->bill model-->bill data)
	//TODO级联如何删除，此事有待研究
* 提供cache 清除的工具方法或者controller	

### 单据

#### 单据模板
* 修改代码，不再进行mongo db的存储，直接使用ehcache，简化代码
* 由于目前没有删除单据模板的操作，所以无需考虑evict的问题
* 在billbizserviceimpl的相关方法头部加入@Cacheable即可

#### 单据明细
* 在billbizserviceimpl的相关方法头部加入@Cacheable即可
	* find,需要加@Cacheable
	* save(主，子)都需要加@CachePut
	* delete(主，子)都需要加@CacheEvict
	
			//XXX 如果find需要pk_value_main+bill_code+pk_cate,save,delete的方法好像有点够呛
			//XXX 如果上缓存，可以直接使用pk_value_main+bill_code为key，如果是deleteBillData假定每次只删除一个数据为宜?也许有批量删除的批量更新cache的功能，不用annotation，应该也可以直接上cacheManager处理
* 服务方法嵌套调用的验证

		//TODO 有待验证,理论上因为是aop设定的动态代理类，应该没问题

		
### 数据集
#### 数据集模型获取
	为了保证嵌套调用也能生效，可能方法内还得再来一次显性的调用
* 修改findModel的算法，不再使用mongo 缓存，简化算法，因应调整ext的实现

#### 数据集数据获取

* 封装一个buildCacheKey(ds_code,param,client,paging)的方法
* 封装一个buildCacheValue(key,ds_code,param,client,paging)的方法
* 分页
	* 采用直接调用cacheManager的方式进行处理，key需要包含主要参数(去空，排序)
* 不分页

#### 通过datapod获取

### 数据权限

### cache monitor
* 可以查询指定的cache中key的情况
* 支持在线清除指定的key，或者直接清空整个cache
* 可以查阅内占用的情况
* 单独使用cache monitor bizservice实现，提供配套的ui

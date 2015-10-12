# 关系管理(Relation)
用于取代数据库物理外键的关系描述管理
##应用场景
    
* 单据设计：在配置单据时，根据选择的主体实体，得到与之相关的实体
* 级联更新：当一个基础信息实体被其他业务模块实体引用时，依据关系的描述，可以得到具体的引用情况说明。
* cache的级联更新：当一个cache的key失效时，确保与之相关联的key一并失效

**举例说明：**  

* 比如，由于种种原因(比如误建无效用户，需要删除)，需要删除一条员工数据，我们期望能检验一下，有无业务模块的实体引用这个记录，如果有，则不能删除。

##基本原理

	通过MT_OA_RELATION表，定义实体关系描述。

##结构设计

###MT_OA_RELATION
MT_OA_RELATION用于描述实体关系。具体实体定义请参看entity.md。  


字段|名称|含义---:|:---:|:---PK_RELATION|主键|
PK_ENTITY_MAIN|主元主键|用于关联MT_PF_ENTITY表的PK_ENTITY
PK_ENTITY_SLAVE|从元主键|用于关联MT_PF_ENTITY表的PK_ENTITY
PK_FIELD_MAIN|主元字段主键|用于关联MT_PF_FIELD的PK_FIELD
PK_FIELD_SLAVE|从元字段主键|用于关联MT_PF_FIELD的PK_FIELD
PK_ENTITY_BRIDGE|桥接表主键|用于关联MT_PF_ENTITY表的PK_ENTITY
PK_FIELD_BRIDGE_MAIN|桥接表主属性|用于关联MT_OA_RELATION表的PK_FIELD_MAIN
PK_FIELD_BRIDGE_SLAVE|桥接表属性|用于关联MT_OA_RELATION表的PK_FIELD_SLAVE
RLT_TYPE|关系类型|0：一对多；3：多对多
IFORCE|引用方式|0：弱引用；3：强引用
MSG_TPL|消息模板|
PK_ACCOUNT_CRT|创建人|
CRT_TS|创建时间|
LM_TS|最后修改时间|
ISTAT|状态|0:编辑；3:发布
MEMO|备注|

**注：Main为被引用(主表)，Slave为引用（子表）**

**问题：为什么要有MT_OA_RELATION表？**  
不知道你有没有注意到，数据库中的表只有主键，没有外键，那么如何实现表间的关系映射呢？就需要MT_OA_RELATION，来存储两张表的字段间的映射关系。目前是通过数据集服务实现。
###名词解释
####什么是直连（RLT_TYPE=0） 
一张表中的某个外键T_REF直接引用了另一张表的主键T_PK，适用于一对多的关系。例如mt_oa_sub_demand中的外键PK_DEMAND直接引用mt_oa_demand的主键PK_DEMAND。

	例如：根据mt_oa_tm_demand的某个主键，获取关联实体
	select b.* from mt_oa_tm_demand a left join mt_oa_tm_sub_demand b on (a.pk_demand=b.pk_demand) where a.pk_demand="xxxxx"
	
	从SQL语句逆推，mt_oa_relation中需要存储的内容如下：
	main：mt_oa_tm_demand，pk_demand
	slave：mt_oa_sub_demand，pk_demand
	bridge：NULL
	rlt_type：0
####什么是桥接(RLT_TYPE=3)  
一张表与另一张表的映射关系通过一个中间表来提供，适用于多对多的关系。例如教师负责某个课程，学生选课，教师--课程--学生，如果教师需要知道自己负责课程的学生，就需要桥接表（课程）查询。   

又如mt_oa_tm_task有个附件表mt_oa_att，但是需要通过rlt_biz_att关联。

	例如：根据mt_oa_tm_task的某个主键，获取关联附件
	select b.* from rlt_biz_att b left join mt_oa_tm_task a on (a.pk_task=b.pk_biz) left join mt_oa_att c on (b.pk_att=c.pk_att) where a.pk_demand="xxxxx"
	
	从SQL语句逆推，mt_oa_relation中需要存储的内容如下：
	main：mt_oa_tm_task，pk_task
	slave：mt_oa_att，pk_att
	bridge：rlt_biz_att，pk_biz，pk_att	
	rlt_type：3

####什么是弱连接（IFORCE=0）
例如一个供应商提供多种产品，一种产品由多个供应商提供，当删除一个供应商时，其关联的产品不能删除（因为还有其他供应商提供）。
####什么是强连接（IFORCE=3）
例如一个要求对应多个要求条款，当删除要求时，其关联的所有要求条款都要删除。
###实体约束
在单据模板中，利用ext属性配置约束条件。   

1. 引用关系必须唯一，{PK_ENTITY_MAIN，PK_ENTITY_SLAVE，PK_FIELD_MAIN，PK_FIELD_SLAVE}组成的属性必须唯一。


##服务接口设计
**实体：MT_PF_ENTITY中保存的每个表的元数据被称为一个实体**  
**实例：表中的每条记录被称为一个实例**

###RelationBizService
RelationBizService为基本关系服务类，提供底层关系服务接口。


	/**
	  * 根据实体的编码或者主键，返回关系列表
	  * @param  meta_unique：可以是实体的编码或者主键（必填）
	  * @return 关系列表
	  */	
	public List<GenericVO> fetch(String meta_unique)
	
	/**
	  * 根据实体的编码或者主键，返回关联实体
	  * @param  meta_unique 可以是实体的编码或者主键（必填）
	  * @return 关联实体列表
	  */	
	public List<GenericVO> fetchEntity(String metaCode) 

###RelationExtBizService
RelationExtBizService对RelationBizService进行封装，提供高级关系服务接口。
	
	/**
	  * 根据实体的编码或者主键，再加上实例主键，返回关联实例
	  * @param meta_unique 可以是实体的编码或者主键（必填）
	  *        pk_value 实例主键（必填）
	  * @return 实例列表
	  */
	public List<GenericVO> fetchInstance(String meta_unique,String pk_value)
	
	/**
	  * 根据实体的编码或者主键，再加上实例主键，删除关联实例
	  * @param meta_unique 可以是实体的编码或者主键（必填）
	  *        pk_value 实例主键（必填）
	  * @return 是否成功
	  */
	public boolean deleteInstance(String meta_unique,String pk_value)
	
##使用示范
###界面初始化

* 首先必须要导入并同步表元数据
		
		单击业务加工->元数据服务，进入元数据服务界面，导入并同步表

* 然后配置引用关系
		
		单击业务加工->关系管理服务，进入关系管理界面   
		单击"新增"，进入新增界面
		
		如果是直连，则选择"关系类型"为"一对多"，不用选择桥接表各字段
		单击"主表"按钮，在弹出对话框中选择主表，单击"主表字段"，在弹出对话框中选择主表的被引用字段
		单击"子表"按钮，在弹出对话框中选择子表，单击"子表字段"，在弹出对话框中选择子表的引用字段
		
		如果是桥接，则选择"关系类型"为"多对多"
		单击"主表"按钮，在弹出对话框中选择主表，单击"主表字段"，在弹出对话框中选择主表的主字段
		单击"子表"按钮，在弹出对话框中选择子表，单击"子表字段"，在弹出对话框中选择子表的主字段
		单击"桥接表"，在弹出对话框中选择桥接表
		单击"桥接表主属性"，在弹出对话框中选择桥接表是通过哪个字段关联主表主键
		单击"桥接表子属性"，在弹出对话框中选择桥接表是通过哪个字段关联子表主键
		
		根据是否为强引用，选择引用方式
				
* 最后单击"确定"按钮，保存引用关系。   

###编程实现
####注入服务

	@Autowired
	@Qualifier("pf.mds.service.relation")
	RelationBizService relationService;
	
	@Autowired
	@Qualifier("pf.mds.service.ext.relation")
	RelationExtBizService relationExtService;
	
####使用场景举例
	
1. 根据实体的编码或者主键，得到关系列表，例如，如何知道MT_BD_ACCOUNT的引用关系？   
	
		List<GenericVO> ret = relationService.fetch("MT_BD_ACCOUNT");


2. 在单据设计时   
根据实体的编码或者主键，返回关联实体，例如，如何知道MT_BD_ACCOUNT的关联实体？
	
		List<GenericVO> ret = relationService.fetchEntity("MT_BD_ACCOUNT");
	
3. 在级联更新时    
根据实体的编码或者主键，再加上实例主键，返回关联实例，例如，获得MT_BD_ACCOUNT表中，主键为"8ac08d163ec9a0aa013ec9a8540e0e91"的实例，被哪些实例引用？    
		
		List<GenericVO> ret = relationExtService.fetchInstance("MT_BD_ACCOUNT","8ac08d163ec9a0aa013ec9a8540e0e91");

4. 在级联删除时   
根据实体的编码或者主键，再加上实例主键，删除与实例关联的其他实例，例如，删除MT_BD_ACCOUNT表中主键为"8ac08d163ec9a0aa013ec9a8540e0e91"关联的实例？ 

		boolean ret = relationExtService.deleteInstance("MT_BD_ACCOUNT","8ac08d163ec9a0aa013ec9a8540e0e91");


##部署上线
####建表
可通过dsaService同步表

	dsaService.syncEntity(RelationMeta.class);

或者通过业务加工-元数据服务，导入同步表

####配置数据集	
需要配置db_metadata和db_field两个数据集   
业务加工-数据集服务-新建   

	以db_metadata为例：
	数据集编码：db_metadata
	数据集名称：元数据列表
	类型：sql
	类型：json
	策略：select PK_ENTITY, ENTITY_CODE, ENTITY_NAME from mt_pf_entity where 1=1 $[ and (ENTITY_CODE like ${FILTER} or ENTITY_NAME like ${FILTER} or PK_ENTITY = ${PK_ENTITY})]
	
	数据集结构明细：
	显示顺序：0
	属性编码：PK_ENTITY
	属性名称：主键
	类型：T_PK
	是否为参数：属性
	是否主键：是
	
	显示顺序：1
	属性编码：ENTITY_CODE
	属性名称：表码
	类型：T_CODE
	是否为参数：属性
	是否主键：否
	
	显示顺序：2
	属性编码：ENTITY_NAME
	属性名称：表名
	类型：T_CODE
	是否为参数：属性
	是否主键：否
	
	以db_field为例：
	数据集编码：db_field
	数据集名称：字段列表
	类型：sql
	类型：json
	策略：select PK_FIELD, FIELDCODE, FIELDNAME from mt_pf_field where 1=1 $[ and (FIELD_CODE like ${FILTER} or FIELD_NAME like ${FILTER}) ] $[and PK_ENTITY = ${PK_ENTITY}]
	
	数据集结构明细：
	显示顺序：0
	属性编码：PK_FIELD
	属性名称：主键
	类型：T_PK
	是否为参数：属性
	是否主键：是
	
	显示顺序：1
	属性编码：FIELDCODE
	属性名称：字段码
	类型：T_CODE
	是否为参数：属性
	是否主键：否
	
	显示顺序：2
	属性编码：FIELDNAME
	属性名称：字段名
	类型：T_CODE
	是否为参数：属性
	是否主键：否

###配置datapod
业务加工-datapod-新增
	
	POD编码：grid_db_metadata
	POD名称：元数据表
	显示类型：表格
	数据集：元数据列表
	是否默认：一定要选是
	
	POD结构明细：
	数据集属性：主键   //一定要把主键选上，否则会报错
	属性类型：主键
	显示顺序：0
		
	数据集属性：表名
	属性类型：显示列
	显示顺序：1
	
	数据集属性：表码
	属性类型：显示列
	显示顺序：2

##常见问题

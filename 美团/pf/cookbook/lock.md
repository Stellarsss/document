# [事务](http://zh.wikipedia.org/wiki/%E6%95%B0%E6%8D%AE%E5%BA%93%E4%BA%8B%E5%8A%A1)
数据库管理系统执行过程中的一个逻辑单位，由一个有限的数据库操作序列构成。
## 应用场景
* 你借笔钱给我，你的户头上减少了10000，我的户头增加10000，后者操作成功，前者操作失败，是不是大家都很开心啊

## 基本概念
* mysql的事务支持(取决于存储引擎)
	* MyISAM:不支持事务
		
			//TODO (是否支持lock，需要验证)
	* InnoDB：支持ACID，行锁(Row Lock),并发
	* BDB:支持事务
* ACID
	* Atomicity：事务必须是原子(不可分割)，要么执行成功进入下一个状态，要么失败rollback到最初状态。
	* Consistency：事务开始之前和结束之后，数据库的完整性约束没有被破坏(一般通过外键来约束)
	* Isolation：一个事务不能知道另外一个实物的执行情况
	* Durablility：事务完成以后，该事务所对数据库做的变更便持久的保存在数据库中，并不会被回滚
* 隔离级别：
	* READ UNCOMMITTED：不commit也能读取变更的数据，俗称dirty read，优点就是性能高，
	
			想想事务A导致了数据变更，事务B读取到了该数据变更，并引用了该数据，然后事务A被rollback。。。是不是很悲剧啊
	* READ COMMITTED:已经commit的记录可见
	
			如果一个事务正在select查询中，另外一个事务此时insert一个记录，则新添加的数据不可见
	* REPEATABLE READ:mysql的默认事务隔离级别，一个事务开始后，其他事务对数据的修改在本事务中不可见，直到本事务commit/rollback。
	* SERIALIZABLE：最高级隔离，事务串行，会导致读取数据被锁，其他事务不能修改，直到该事务commit/rollback
* 事务的传递性
	
		//TODO 等着有时间补，结合spring的aop设置
## 使用
### jdbc
		//TODO 显性调用
### aop(spring)
* aspectj

		//TODO

* method interceptor

		//TODO

### annotation
* 配置(@ context xml)

		//TODO 需要示范spring的配置，尤其是annotation-driven，component-scan的部分

* 标注方式

		//TODO 待补


---
# 锁
## 应用场景
* 两个业务员同时修改一个业务对象，其中一个将金额从1000修改为1200，先保存，另外一个将1000修改为1500，后保存，如何告之后者，数据已经变更，重新查询再试？
* 由于网络慢，用户疯狂点击，一个保存操作被发来了若干次(业务常说的重复提交)
## 类型
### db lock
* 注意事项
	* 对mysql而言，innodb引擎才可以行锁，myisam只能表锁(有待验证)
	* 需要设置autocommit=false；
* 锁表(Table Lock):如果不是用`索引列/主键`进行指定，则你丫就是在锁表
* 行锁(Row Lock)
* 页锁

#### 悲观锁(Pessimistic Locking)
先取锁再访问的保守策略，一个事务一旦对某行数据加锁，其他事务无法执行与该锁冲突的操作，适用于数据争用激烈的环境，以及发生冲突时使用锁保护数据成本低于回滚事务的成本的环境

mysql的InnoDB引擎提供了两种行锁(Row Lock);

为了允许行锁和表锁共存，内部还有意向锁(Intention Lock,意向锁都是表锁),在叫低级别锁前可获得，通知意向将锁放置在较低级别上，一来防止其他事务以会使较低级别的锁无效的方式修改较高级别的资源，二来，提高数据库在较高的粒度级别检测锁冲突的效率。

对于InnoDB而言，意向锁是自动加的；update,delete,insert语句自动给涉及数据集加排他锁；普通select不加任何锁


##### 共享锁(S)
允许事务去读一行数据，阻止其他事务获得相同数据集的排他锁

		select * from table_1 where id=x lock in share mode
##### 排他锁(X)
允许获得排他锁的事务更新数据，阻止其他事务获得`相同数据集`的`共享读锁`和`排他写锁`
对于`mysql`而言，有两种常见的设计策略

* 针对每个需要加锁的业务对象存储的表，来锁
	
		//行锁模式
		select * from table_1 where id=x for update
		//表锁模式
		select * from table_1 where name='xx' for update
需要注意的是：如果预期的应用效果是一旦被lock就立即抛出异常，而不是等待解锁，可以有以下两种做法
	* for update nowait	* 修改innodb_lock_wait_timeout

* 提供一个统一的lock表(quartz v2的策略)
	* lock表结构
	
	字段编码|字段名称|类型|备注
	:---|:---:|:---:|---:
	sched_name|调度器名称|varchar(120)|
	lock_name|锁名称|varchar(40)|
	* 使用方法
		
		//给每个业务对象插一条记录，变相的利用数据库特性起到分布锁的作用	
		select 1 from qrtz_locks where lock_name='triiger_access' for update
		//TODO 待补

##### 意向共享锁(IS)
在表上的页或者行上请求共享锁之前，在表级请求共享意向锁。在表级设置意向锁，可以防止另外一个事务随后在包含那一页的表上获得排他锁。既然无法获得排他锁了，就不需要检查表中的每行或每页上的锁以确定事务可以锁定整个表(简单的说行共享了之后，就不能锁表)
##### 意向排他锁(IX)
IS的超集，保护针对层次结构中某些(并非全部)低层次资源请求或获得排他锁.
##### 其他
	//你不会想知道的，其他的数据库还有意向排它共享(SIX),意向更新(IU)，共享意向更新(SIU)，更新意向排他(UIX)
	//总之，事务是个很大的坑
##### 关系矩阵
当前锁模式/是否兼容/请求锁模式|X|IX|S|IS
:---|:---|:---:|---:
X(当前锁模式)|冲突|冲突|冲突|冲突
IX|冲突|兼容|冲突|兼容
S|冲突|冲突|兼容|兼容
IS|冲突|兼容|兼容|兼容
#### 乐观锁(Optimistic Locking)
多用户并发的事务在处理时不会彼此互相影响，各事务能够在不产生锁的情况下处理各自影响的那一部分数据。在提交数据更新之前，每个事务会先检查钙食物读取数据后，有没有其他事务又修改了该数据。适用于数据争用不打，冲突较少的环境中，偶尔回滚事务的成本会低于读取数据时锁定数据的成本，并发性能更好。

	//对业务数据加version属性的方式来解决，修改之前核对一下version有无变化，在我们的业务系统中通过每个业务对象中的lm_ts的字段(T_TIMESTAMP)的方式来实现



### mem lock
	//TODO java.util.concurrent包可重入锁
	//需要指出的是一旦jvm cluster，就悲剧了
---	
	
	//TODO 忘记sync关键字吧，可重入锁完全可以替代丫，并且效率更高
### 分布锁
		//TODO 利用zookeeper待补
		//克服mem lock在cluster领域的问题
---
		
		当下我们采用的是mongo来做分布锁，由于其本身原子性的保障，这个方法是不靠谱的，只能暂时应急
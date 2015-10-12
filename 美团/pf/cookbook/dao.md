# 数据访问对象(DAO)
## 流行风尚
### jdbc 裸奔
	//FIXME 待补充
### jdbc template
	//FIXME 待补充
### hibernate
	//FIXME 待补充
### jpa
	//FIXME 待补充
### ibatis/mybatis
	//FIXME 待补充
## 我们的写法
### 为啥要自己轮？
### 有啥利好？
* 有几分像jpa，有几分想ibatis
* basedao提供了各类型常用的sql操作，您只需专注于sql的拼写就好
### 怎么用？
一切尽在BaseDao中，以下为常用方法：

* 保存单个业务对象

		save(TableMeta t,GenericVO vo)
	
* 根据条件执行sql，查询符合条件的结果
		
		query(StringBuilder sql,GenericVO param)

* 根据条件分页查询，避免大量的I/O
	
		paging(StringBuilder sql,GenericVO param,int pageNo,int pageSize)

* 执行变更数据的sql(update,delete,insert均可，一般是前两者)
	
		executeChange(String sql,GenericVO vo)

* 删除指定主键的业务对象
	
		delete(TableMeta t,List<V> pk_list)

* 检测是否有符合条件的数据(如果找到了，就是false;找不到就是true)
		
		checkUnique(StringBuilder,GenericVO vo)

* 批量执行一组相同的sql
		
		batch(StringBuilder sql,List<GenericVO> data)

### sql怎么写？
* 一定要用stringbuilder(为了避免直接使用string，basedao的方法参数都改为stringbuilder了)
* 变量：${key}
	
		--按照mis账号过滤
		select a.* from mt_bd_account a where account_code =${ACCOUNT_CODE}
		--如果basedao.query(sql,param)中的param，包含key:ACCOUNT_CODE，则该sql就能正确执行
* 可选$[…]

		--如果是可选条件。。。
		select a.* from mt_bd_account a where 1=1 and $[account_code=${ACCOUNT_CODE}]
		-- 如果basedao.query(sql,param)的param中没有包含key:ACCOUNT_CODE,则sql为：
		select a.* from mt_bd_account a where 1=1
		-- 如果包含key:ACCOUNT_CODE,则sql为
		select a.* from mt_bd_account a where account_code =${ACCOUNT_CODE}
		
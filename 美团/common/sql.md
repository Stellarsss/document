#SQL
##分类
SQL语言分为四大类：

- 数据查询语言DQL
	- select 
- 数据操纵语言DML
	- insert
	- update
	- delete
- 数据定义语言DDL
	- create table|view|index|syn|cluster
- 数据控制语言DCL
	- grant
	- rollback
	- commit
	 	  
##基本语法
###show
- show databases
- show tables
- show columns from tablename;  = describe tablename
- show status
- show grants
- `show create database xxx`
- `show create table xxx`
- show errors
- show warnings
- show character set
- show collation：显示校对

###select

	select <字段名列表> from <表名|视图名> where <查询条件>

- distinct
- limit
- order by：多个列以逗号分隔，前面的列优先级高；指定排序方向：asc（升序），desc（降序）
- group by
- where
 	- between and
 	- in `大于2个值时推荐使用in，而不是or，更整齐`
 	- or
 	- and`and和or混合使用时，AND优先级高`
	- like：%任意个字符，_一个字符`不要过度使用通配符，确实要使用时，将其放在搜索SQL语句末尾，以提高效率`
	- REGEXP：正则表达式
		- .：任意一个字符
		- |：or
		- []：任选其一
		- \\：转义
		- ^：开始
		- $：结尾
		- *：任意个
		- +：至少一个
		- ?：0或1个
- concat：连接，select concat(RTrim(name), '(', age, ')') from person;
- as：别名

顺序：  
`select from where group by having order by limit`

**where和having的区别？**   

1. where过滤行，having过滤分组
2. where在分组前进行过滤，having在分组后进行过滤

###insert

	insert into <表名>(<列名列表>)  value(<列值>)

- 插入多条记录 insert into customers(cust_name) values("sss"),("xxx"); 每组由括号括起，逗号分隔
- 数据迁移 insert into customers(cust_id,cust_name) select cust_id,cust_name from custnew;

###update|delete

	update <表名> set <列名> = <新值> where <列名> = <旧值>  `不要轻易省略where`   
	delete from <表名> where <列名> = <值>   `不要轻易省略where`

`在执行update或delete之前，先执行select语句，确保where子句正确`

###create

	create table <表名>
	(
	<列名1> <数据类型>,
	<列名2> <数据类型>,
	<列名3> <数据类型>,
	....
	)

- NOT NULL
- AUTO_INCREMENT
- DEFAULT

###alter

	alter table <表名> add <列名> <数据类型>
	alter table <表名> drop column <列名>
	
###drop

	drop table <表名>

###rename
	
	rename table <旧表名> to <新表名>

###grant
	
	grant <权限> ON <数据库名>.<表名> to <用户名>@<IP>

###revoke
	
	revoke <权限> ON <数据库名>.<表名> to <用户名>@<IP>		
###联结

- where on：等值联接
- inner join：内部联接
- left outer join：左联接 
- right outer join：右联接

**全联接 vs 左联接 vs 右联接？**

- union：组合查询

##函数
###文本处理函数
- Left()
- Length()
- Locate()
- Lower()
- LTrim()
- RTrim()：去掉右边所有空格
- Right()
- Soundex()
- SubString()
- Upper()

###日期处理函数
- AddDate()
- AddTime()
- CurData()
- CurTime()
- Date(): 对timestamp类型的值，需要用Date()将其转为Date类型，再比较`select * from xxx where Date(time) = '2012-01-10'`
- DateDiff()
- Date_Format()
- Day()
- DayOfWeek()
- Hour()
- Minute()
- Month()
- Now()
- Second()
- Time()
- Year()

###数值处理函数
- Abs()
- Cos()
- Exp()
- Mod()
- Pi()
- Rand()
- Sin()
- Sqrt()
- Tan()

###聚集函数
- AVG()
- COUNT():`*不忽略空值，列名则忽略空值` 
- MAX()
- MIN()
- SUM()

##引擎
- MyISAM：支持全文本搜索，不支持事务处理
	- `select note_text from product where Match(note_text) Against('rabbit');` Match
	指定搜索列，Against指定搜索内容
	- `select node_text,Match(note_text) Against('rabbit') from product;`搜索全部行，但结果顺序根据行中词的匹配程度排序
	- match与like的区别，match的返回结果会根据匹配程度排序；like的返回结果随机排序
- InnoDB：不支持全文本搜索，支持事务处理
- MEMORY：数据存在内存中，速度很快

##存储过程
	
	定义存储过程，()中是参数列表，支持in，out，inout三种类型
	create procedure product(in p1 int, out p2 date) 
	begin
		存储过程体
	end
	
	调用存储过程，p1是in型，调用时用输入数值，p2是out型，用@返回
	call product(1000,@p2);
	
	查看返回结果
	select @p2
	
	删除存储过程
	drop procedure product;

##游标
	
	create procedure product()
	begin
		声明游标
		declare ordernumber cursor for select order_num from orders;
		打开游标
		open ordernumber;
		repeat
			获取游标各值赋给局部变量
			fetch ordernumber into o;
		until done end repeat;
		关闭游标
		close ordernumber;
	end
	 

##触发器
	
	触发器名称必须唯一，仅支持表，不支持视图，一张表最多6个触发器
	何时执行（before，after）
	响应活动（delete，update，insert）
	for each row：每一行都执行
	create trigger <触发器名称> after insert on <表名> for each row select 
	
	drop trigger <触发器名称>

##事务
一组SQL语句，要么完全执行，要么完全不执行
	
	开始事务
	start transaction
	回滚
	rollback
	提交
	commit
	
	savepoint <保留点名称>
	rollback to <保留点名称>
	






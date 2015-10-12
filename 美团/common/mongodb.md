# MongoDB
当前比较热门的NoSql数据库之一  
[官网](www.mongodb.org)
## 基本概念

- nosql：非关系型的数据库，主要特点：非关系型的、分布式的、开源的、水平可扩展的。
- 文档：由键值对组成，类似于关系数据库中的行
- 集合：由一组文档组成，类似于关系数据库中的表
- BSON：类似JSON的key-value对

##前期准备
```
下载安装包后解压，第一次运行需要建立存放数据的目录，mongod默认写入/data/db/
sudo mkdir -p /data/db sudo chown ‘id –u’ /data/db

启动MongoDB，--dbpath指明数据目录
./mongod --port 27017 --logpath /var/log/mongo --dbpath /app/mongo/data/mongo &
mongo：MongoDB自带的shell，shell命令操作语法和JavaScript很类似，其实底层是用JavaScript脚本实现。确保在使用shell之前启动mongod
用./bin/mongo脚本链接Mongo，默认链接localhost的27017端口，默认使用test数据库
./mongo
启动后连接到默认的test数据库，切换数据库到foobar
> use foobar
switched to db foobar
全局变量db指向foobar
> db
foobar
```

###ObjectId
	由12字节组成
	
	0|1|2|3|4|5|6|7|8|9|10|11
	时间戳  | 机器 |PID|	计数器

###show
	
	如果没有插入数据，MongoDB不会新建数据库
	show dbs
	
	MongoDB将在第一次使用集合时显式生成集合，不需要用户创建集合
	MongoDB采用动态策略，不需要指明集合结构。
	show collections
	
##CRUD	
###insert 
如果插入文档中没有_id，则MongoDB自动创建一个_id键，作为唯一标示 

	
	db.collection.insert({"name":"xxx"});
 
###remove 
不会删除集合本身和索引，remove接收一个查询文档作为可选参数，只有符合条件的文档才被删除，remove为空时，删除所有文档
 	
 	db.collection.remove();
 	db.collection.remove({"name":"xxx"})

###update

	db.collection.update( criteria, objNew, upsert, multi )

	criteria : update的查询条件，类似sql中where后面的内容
	objNew   : 修改器（如$set,$inc...）+ update的对象，类似sql update中set后面的内容
	upsert   : 如果不存在update的记录，是否插入objNew，true为插入，默认是false，不插入。
	multi    : 默认为false，只更新找到的第一条记录，如果为true，则把按条件查出的多条记录全部更新。

	获得更新文档数目
	db.runCommand({getLastError : 1})
	{
		"err" : null,
		"updateExisting" : true,
		"n" : 5,
		"ok" : true
	}
	
###修改器	 

####键值修改器

- $inc：对一个数字字段field增加value，只支持数字
	- { $inc : { field : value } } 
- $set：相当于sql的set field = value，全部数据类型都支持
	- { $set : { field : value } }
- $unset：删除字段
	- { $unset : { field : 1} }

####数组修改器

- $push：把value追加到field数组中
	- { $push : { field : value } } 
- $addToSet：把value追加到field数组中，而且只有当value值不在数组内才增加
	- { $addToSet : { field : value } }
- $pop：根据位置，删除数组内的一个值
	- { $pop : { field : 1 } }：删除最后一个值
	- { $pop : { field : -1 } }：删除第一个值
- $pull：删除数组内所有field等于value值
	- { $pull : { field : value } }
- $pullAll：同$pull,可以一次删除数组内多个值
	- { $pullAll : { field : value_array } }	
 
###find
 
 	db.collection.find(criteria, projection)
 	
 	criteria：查询条件，相当于sql中where后面的条件
 	projection：投影，相当于sql中select和from间的列，0：不返回；1：返回
 	db.collection.findOne();
 	
####条件句
条件句是内层文档的键，修改器是外层文档的键
 
 	$lt：<
 	$lte：<=
 	$gt：>
 	$gte：>=
 	$ne：!=
 	$in
 	$nin
 	$or	
 	$not
 	$all
	$size
	$slice
	$elemMatch
	$where

####cursor

	当查询mongo时会返回一个cursor，其包含查询结果。Mongo通过遍历它显示所有结果。首先迭代20次cursor显示20条记录，等待shell输入it再迭代下20个结果。
		通过while遍历cursor，打印所有结果，如果cursor包含下一个文本，则hasNext返回true
	var cursor = db.collection.find()
	while (cursor.hasNext()){
		obj = cursor.next();
		…..
	}
	
	cursor.forEach(function(x){
		print(x.name);
		….
	});	

####查询选项

- limit：限制返回结果数量的上限
- skip：跳过返回结果的数量
- sort：排序，参数为一组键值对，键对应field，值代表排序方向(1:升序；-1：降序)
	- db.collection.find().sort({field1: 1, field2:-1})


###ensureIndex

创建索引
	db.collection.ensureIndex(keys, options)
 	
 	keys：创建索引字段和方向
 	options：可选，创建索引


###聚合
* count：返回集合文档数量，db.collection.count()
* distinct：返回与给定值不同的值，db.runCommand({"distinct": "collection", "key":"value"})
****


### 导出数据
```
 ./mongodump -h 127.0.0.1:27017 -d mt_oa_pf -o /home/sankuai/mongodump/
```

### 导入
```
 mongorestore -h dbhost -d dbname --directoryperdb dbdirectory
``` 


###0 数据库

 
#### 获得帮助

```
>help
>db.help();
>db.foo.help();
>db.foo.find().help();
后面不加括号，则显示JS代码
>db.foo.update
```

2、切换/创建数据库

```
use yourDB;
//当创建一个集合(table)的时候会自动创建当前数据库
```
 
3、查询所有数据库

```
mongo>show dbs;
```
 
4、删除当前使用数据库

```
mongo>db.dropDatabase();
``` 

5、从指定主机上克隆数据库

```
//将指定机器上的数据库的数据克隆到当前数据库
mongo>db.cloneDatabase(“127.0.0.1”);
``` 
6、从指定的机器上复制指定数据库数据到某个数据库

```
//将本机的mydb的数据复制到temp数据库中
db.copyDatabase("mydb", "temp", "127.0.0.1");
```
7、修复当前数据库

```
db.repairDatabase();
```
 
8、查看当前使用的数据库

```
mongo>db.getName();
//或者
mongo>db;
```
db和getName方法是一样的效果，都可以查询当前使用的数据库
 
9、显示当前db状态

```
db.stats();
``` 

10、当前db版本

```
db.version();
```
 
11、查看当前db的链接机器地址

```
db.getMongo();
```

#### Collection聚集集合

 
1、显性创建一个聚集集合（table）

```
db.createCollection(“collName”, {size: 20, capped: 5, max: 100});
``` 
2、得到指定名称的聚集集合（table）

```
db.getCollection("account");
```
 
3、得到当前db的所有聚集集合

```
db.getCollectionNames();
//或者
show collections
``` 
4、显示当前db所有聚集索引的状态

```
db.printCollectionStats();
```

#### 用户相关

1、添加一个用户

```
db.addUser("name");
db.addUser("userName", "pwd123", true);
添加用户、设置密码、是否只读
```

2、数据库认证、安全模式

```
db.auth("userName", "123123");
```
3、显示当前所有用户

```
show users;
``` 
4、删除用户

```
db.removeUser("userName");
```

#### 其他

1、查询之前的错误信息

```
mongo>db.getPrevError();
``` 
2、清除错误记录

```
mongo>db.resetError();
``` 

###Collection聚集集合操作

#### 查看聚集集合基本信息

 
1、查看帮助

```
db.yourColl.help();
```
 
2、查询当前集合的数据条数

```
db.yourColl.count();
```
 
3、查看数据空间大小

```
db.userInfo.dataSize();
```
 
4、得到当前聚集集合所在的db

```
db.userInfo.getDB();
```

5、得到当前聚集的状态

```
db.userInfo.stats();
```
 
6、得到聚集集合总大小

```
db.userInfo.totalSize();
```
 
7、聚集集合储存空间大小

```
db.userInfo.storageSize();
```
 
8、Shard版本信息

```
db.userInfo.getShardVersion()
```
 
9、聚集集合重命名

```
db.userInfo.renameCollection("users");
将userInfo重命名为users
```
 
10、删除当前聚集集合

```
db.userInfo.drop();
```

### sql mapp

mongo|sql
--|--
db.userInfo.find()|select * from userInfo|
db.userInfo.distinct("name");|select distict name from userInfo;
db.userInfo.find({"age": 22});|select * from userInfo where age = 22;
db.userInfo.find({age: {$gt: 22}});|select * from userInfo where age > 22;
db.userInfo.find({age: {$lt: 22}});|select * from userInfo where age < 22;
db.userInfo.find({age: {$gte: 25}});|select * from userInfo where age >= 25;
db.userInfo.find({age: {$lte: 25}});|select * from userInfo where age <= 25;
db.userInfo.find({age: {$gte: 23, $lte: 26}});|select * from userInfo where age >= 23 and age<=26;
db.userInfo.find({name: /mongo/});|select * from userInfo where name like ‘%mongo%’;
db.userInfo.find({name: /^mongo/});|select * from userInfo where name like ‘mongo%’;
db.userInfo.find({}, {name: 1, age: 1});|select name, age from userInfo;
db.userInfo.find({age: {$gt: 25}}, {name: 1, age: 1});|select name, age from userInfo where age > 25;
db.userInfo.find().sort({age: 1});|select * from userInfo desc(升序)
db.userInfo.find().sort({age: -1});|select * from userInfo asc(降序)
db.userInfo.find({name: 'zhangsan', age: 22});|select * from userInfo where name = ‘zhangsan’ and age = ‘22’;
db.userInfo.find().limit(5);|select top 5 * from userInfo;
db.userInfo.find().skip(10);|select * from userInfo where id not in (select top 10 * from userInfo
db.userInfo.find().limit(10).skip(5);|查询在5-10之间的数据(可用于分页，limit是pageSize，skip是第几页*pageSize)
db.userInfo.find({$or: [{age: 22}, {age: 25}]});|select * from userInfo where age = 22 or age = 25;
db.userInfo.findOne();|select top 1 * from userInfo;
db.userInfo.find({age: {$gte: 25}}).count();|select count(1) from userInfo where age >= 20;
db.userInfo.find({sex: {$exists: true}}).count();|select count(sex) from userInfo;

```
默认每页显示20条记录，当显示不下的情况下，可以用it迭代命令查询下一页数据。注意：键入it命令不能带“；”但是你可以设置每页显示数据的大小，用DBQuery.shellBatchSize = 50;这样每页就显示50条记录了。
```

### 索引

1、创建索引

```
mongo>db.userInfo.ensureIndex({name: 1});
//以下索引相当于组合索引
mongo>db.userInfo.ensureIndex({name: 1, ts: -1});
```
 
2、查询当前聚集集合所有索引

```
db.userInfo.getIndexes();
//查询所有索引
db.system.indexes.find();
``` 

3、查看总索引记录大小

```
db.userInfo.totalIndexSize();
```
 
4、读取当前集合的所有index信息

```
db.users.reIndex();
```
 
5、删除指定索引

```
db.users.dropIndex("name_1");
```
 
6、删除所有索引索引

```
db.users.dropIndexes();
```

7、 性能调优

```
//得到执行计划
db.mt_oa_mlog.find().limit(1000).explain();
//根据经验，不到千万级，加index没啥意义，尽量少用模糊匹配，性能会低到你想哭
```
#### 修改、添加、删除集合数据

1、添加

```
db.users.save({name: ‘zhangsan’, age: 25, sex: true});
添加的数据的数据列，没有固定，根据添加的数据为准
```
 
2、修改

```
//相当于：update users set name = ‘changeName’ where age = 25;
db.users.update({age: 25}, {$set: {name: 'changeName'}}, false, true);
//相当于：update users set age = age + 50 where name = ‘Lisi’; 
db.users.update({name: 'Lisi'}, {$inc: {age: 50}}, false, true);
相当于：update users set age = age + 50, name = ‘hoho’ where name = ‘Lisi’; 
db.users.update({name: 'Lisi'}, {$inc: {age: 50}, $set: {name: 'hoho'}}, false, true);
```
 
3、删除

```
db.users.remove({age: 132});
```
 
4、查询修改删除
db.users.findAndModify({
    query: {age: {$gte: 25}}, 
    sort: {age: -1}, 
    update: {$set: {name: 'a2'}, $inc: {age: 2}},
    remove: true
});
 
db.runCommand({ findandmodify : "users", 
    query: {age: {$gte: 25}}, 
    sort: {age: -1}, 
    update: {$set: {name: 'a2'}, $inc: {age: 2}},
    remove: true
});
update 或 remove 其中一个是必须的参数; 其他参数可选。

参数

详解

默认值

query

查询过滤条件

{}

sort

如果多个文档符合查询过滤条件，将以该参数指定的排列方式选择出排在首位的对象，该对象将被操作

{}

remove

若为true，被选中对象将在返回前被删除

N/A

update

一个 修改器对象

N/A

new

若为true，将返回修改后的对象而不是原始对象。在删除操作中，该参数被忽略。

false

fields

参见Retrieving a Subset of Fields (1.5.0+)

All fields

upsert

创建新对象若查询结果为空。 示例 (1.5.4+)

false

Ø 语句块操作

1、简单Hello World
print("Hello World!");
这种写法调用了print函数，和直接写入"Hello World!"的效果是一样的；
 
2、将一个对象转换成json
tojson(new Object());
tojson(new Object('a'));
 
3、循环添加数据
> for (var i = 0; i < 30; i++) {
... db.users.save({name: "u_" + i, age: 22 + i, sex: i % 2});
... };
这样就循环添加了30条数据，同样也可以省略括号的写法
> for (var i = 0; i < 30; i++) db.users.save({name: "u_" + i, age: 22 + i, sex: i % 2});
也是可以的，当你用db.users.find()查询的时候，显示多条数据而无法一页显示的情况下，可以用it查看下一页的信息；
 
4、find 游标查询
>var cursor = db.users.find();
> while (cursor.hasNext()) { 
    printjson(cursor.next()); 
}
这样就查询所有的users信息，同样可以这样写
var cursor = db.users.find();
while (cursor.hasNext()) { printjson(cursor.next); }
同样可以省略{}号
 
5、forEach迭代循环
db.users.find().forEach(printjson);
forEach中必须传递一个函数来处理每条迭代的数据信息
 
6、将find游标当数组处理
var cursor = db.users.find();
cursor[4];
取得下标索引为4的那条数据
既然可以当做数组处理，那么就可以获得它的长度：cursor.length();或者cursor.count();
那样我们也可以用循环显示数据
for (var i = 0, len = c.length(); i < len; i++) printjson(c[i]);
 
7、将find游标转换成数组
> var arr = db.users.find().toArray();
> printjson(arr[2]);
用toArray方法将其转换为数组
 
8、定制我们自己的查询结果
只显示age <= 28的并且只显示age这列数据
db.users.find({age: {$lte: 28}}, {age: 1}).forEach(printjson);
db.users.find({age: {$lte: 28}}, {age: true}).forEach(printjson);
排除age的列
db.users.find({age: {$lte: 28}}, {age: false}).forEach(printjson);
 
9、forEach传递函数显示信息
db.things.find({x:4}).forEach(function(x) {print(tojson(x));});
上面介绍过forEach需要传递一个函数，函数会接受一个参数，就是当前循环的对象，然后在函数体重处理传入的参数信息。
 
 
		
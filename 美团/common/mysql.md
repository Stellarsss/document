#linux常用命令

从服务器段拷贝文件到本地或者另外一个服务器上
scp sankuai@192.168.2.165:/home/sankuai/dumpsql_lwp.sql dumpsql_lwp.sql

##MYSQL 常用操作

ssh sankuai@192.168.2.165

登陆 mysql -udev -p1qazxsw2 mtoa


导出数据：mysqldump -udev -p1qazxsw2 mtoa_p >/home/sankuai/dumpsql_lwp.sql
	
导入 进到mysql命令行source /opt/dumpsql_lwp.sql
		
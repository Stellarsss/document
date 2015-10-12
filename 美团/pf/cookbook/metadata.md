#什么是元数据
## 问题(Problem)
什么是**元数据**？
## 解决方案(Solution)
描述数据的数据
当下，方案有很多，假定你要定义一个用户的实体

*  xml scheme:约定xml的结构，其自身也是一个xml
	
	...略
	
  xml：比如hibernate的hbm文件
	
	<xml>
		<entity id="mt_bd_account"...
	</xml>
	
  annotation：比如jpa中用于描述entity的那一坨
	
	@Entity("mt_bd_account")
	
	public class Account{
		@Column("pk_account")
		public String pk_account;
		
	}
	
  dcl：比如create table xx(…)
	
	create table mt_bd_account(
		pk_account char(32)
	)
	
  table meta class:比如我们，用一个对象来描述一个实体结构
	
	public class AccountMeta extends AbstractTableMeta{//现实中这个类的全名是com.meituan.oa.pf.rbac.meta.AccountMeta,为了示意简便，只保留了一个属性
		public static final String TAB_CODE = "mt_oa_account";
		public static final String TAB_NAME = "用户表";
		public PKField PK_ACCOUNT = new PKField("PK_ACCOUNT","用户主键");
		@Override
		public void init(){
			setCode(TAB_CODE);
			setName(TAB_NAME);
			put(PK_ACCOUNT);
		}
	}

没有包治万病的人血馒头，每种方案都有特定的适用场景

在mtoa.pf的体系中，需要重点强调的是实体元数据，表单元数据
	
	public class HelloWorld(){
		public String hello(){
			return "hello";
		}
	}



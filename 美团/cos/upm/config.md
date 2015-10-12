# cos.upm闲人指路

## 权限对象初始化

### 方法1：人肉注册(适用于验证阶段)

* 打开http://upm.sankuai.com，用自己的mis账号登陆

### 方法2：导入(适用于正式启用阶段)


## 权限主体初始化

* 账号

  [v] 目前支持公司所有人员帐号

* 组织机构(是否支持虚拟组织)
  
  [x] 不支持组织机构

* 角色

  [v] 支持自定义角色

* 是否支持角色运算(角色a=角色b+角色c；角色构成一棵树，角色x给子节点角色授权时授权范围为自己的权限集)？

  [x] 不支持角色运算，但支持岗位


## 授权

### 使用方法

需要有资源，权限，角色，角色赋权，用户赋角色等5步。

1. 资源管理

   * [v]添加资源

     一个资源对应简单url  
     资源分为两种，数据与菜单

   * [v]修改资源

   * [v]删除资源

1. 权限管理
   
   * [v]添加权限

        一个权限可选绑定一个资源

   * [v]数据权限

       * [v]增加
       * [v]修改
       * [v]删除

   * [x]菜单权限
  
     支持两级菜单，但仅支持二级菜单权限

       * [v] 增加
       * [v] 修改
       * [x] 删除

1. 角色管理

   [v] 创建角色：http://upm.sankuai.com/role/create

   [v] 修改角色：http://upm.sankuai.com/role/list，选择角色，然后修改

   [v] 删除角色：无法删除，但可停用

1. 角色赋权：http://upm.sankuai.com/role/permission

   [v] 添加权限：选择角色(目前仅能通过搜索)，添加角色权限

   [x] 修改权限：目前无法做到

   [x] 删除权限：目前无法处理

1. 用户赋权(用户赋角色) http://upm.sankuai.com/userRole/singleConf

   [v] 增加角色

   [v] 修改角色

   [v] 删除角色

### 验证方法

1. 数据权限

   http://api.upm-in.sankuai.com/api/auth?appkey=mtoa&userId=7075&resource=/oa/pf/bpm/oa.pf.bpm.deploy.action

   返回结果：{"data": true|false}


1. 菜单权限

   http://api.upm-in.sankuai.com/api/menus?appkey=mtoa&userId=7508

   返回结果：{"data": [...]}


## 鉴权

### 配置方法

#### 	pom.xml新增依赖关系
	
        <dependency>
            <groupId>com.sankuai.meituan</groupId>
            <artifactId>mt-filter</artifactId>
            <version>1.0.0-SNAPSHOT</version>
        </dependency>

#### web.xml新增
	
	<filter>
		<filter-name>mtFilter</filter-name>
		<filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
		<init-param>
			<param-name>targetFilterLifecycle</param-name>
			<param-value>true</param-value>
		</init-param>
	</filter>
	<filter-mapping>
		<filter-name>mtFilter</filter-name>
		<url-pattern>/*</url-pattern>
	</filter-mapping>
	
#### spring配置新增(mt.oa.app.xml)

	<!-- mtFilter -->
	<bean id="mtFilter" class="com.sankuai.meituan.filter.spring.FilterFactoryBean">
		<property name="appkey" value="mtoa"/>
        <property name="loginUrl" value="http://sso.sankuai.com"/>
        <property name="authUrl" value="http://api.upm-in.sankuai.com"/>
		<property name="successUrl" value="/"/>
		<property name="filterChainDefinitions">
			<value>
				/static/** = anon
				/api/** = anon
				/oa/pf/mds/dbconsole/** = auth
				/** = user
				<!--/** = auth-->
			</value>
		</property>
	</bean>


### 验证场景

* 前置条件：

  * 执行./jettyrun.sh启动

  * 打开浏览器 输入localhost:8080，使用mis账号密码进行登录

  * 如果成功了，请往下，如果没成功，请联系张曦(zhangxi@meituan.com)  

- 有权限+已经登录

- 有权限+未登录

- 无权限+已经登录

- 无权限+未登录

- fake

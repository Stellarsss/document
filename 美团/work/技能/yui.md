#YUI
推荐教程：YUI3 Cookbook 中文版，主要看第1，2，4，7章  

简述JQuery,Extjs,YUI,Prototype,Dojo 等JS框架的区别和应用场景

***YUI({参数列表}).use('依赖模块列表', 回调函数)***  
根据参数列表创建YUI实例，分析并建立依赖模块列表，下载所有依赖模块，执行回调函数，并传入YUI实例（Y），Loader响应(loaderResponse)。  

	例如：YUI().use('node', 'widget', … ,function(Y, loaderResponse){});   

参数列表  

* skin: CSS皮肤。 例如： skin: {default: 'night'}  
* gallery：第三方库
* base：获取YUI路径 
* modules： 设置依赖模块的信息
 
 		例如: modules:{ 
 				'moduleName':{ 
 						path: 'js/moduleName.js',
 						requires: ['node'],
 						skinnable: true
 						} 
 			}
		
		注意：模块名加引号 
		YUI模块名经常包含分隔符，所以一般约定模块名加引号，例如: my-stack包含-，如果没加引号则报错，如果加引号，则认为是字符串。

* groups：定义模块组

		例如: groups:{
				'groupsName':{
					base: '',
					async: false, //确保第三方代码正确加载
					modules:{
						'moduleName':{
							path: '',
							requires: [],
							skinnable: true,
							condition: {
								trigger: '',
								test: function(){}
							}
						}
					}
				}
			}   

* YUI_config：页面引入的js中如果包含YUI_config对象，YUI自动将其配置应用到页面的所有YUI实例中。Y.applyConfig()合并配置。   
* win：指向YUI的原生DOM窗口。  
* doc：指向YUI的原生DOM文档。

依赖模块列表   

* *：代表所有必要的模块已经静态加载，并通知YUI简单地将模块注册到Y上。  

***YUI.add('模块名称', 回调函数, '模块版本号'，{参数列表})***   
	回调函数中，任何附加到Y上的函数或对象，以后都可在use中调用。没有附加到Y上的保持私有。   
	Y上定义的是YUI的核心模块，因此最好用Y.namespace()定义命名空间，在命名空间上附加函数或对象。Y.namespace()接受一个及多个字符串以同时定义多个命名空间，并返回最后一个命名空间。
	
	例如：
	YUI.add('moduleName', function(Y){  
		Y.namespace('ModuleName');  
		Y.ModuleName.fun = function(){};   
	},'0.0.1', {requires: ['node']});

	YUI.add()是使用YUI全局对象注册模块的静态方法，因此YUI后没有()。
	YUI().use()是用给定配置创建YUI实例的工厂方法，因此YUI后有()。

参数列表：  

* requires：依赖模块列表   
* optional：可选依赖模块列表
* skinnable：是否有CSS皮肤，如果为true，则YUI将试图加载base/module-name/assets/skins/skin-name/module-name.css。

***on('', function(ev))***   
on第一个参数指定监听的事件，第二个参数指定当事件发生时的处理函数。
	
	ev.target：引起事件的节点
	ev.charCode：键盘事件产生的字符
	ev.keyCode：键盘事件按下的键
	ev.pageX，ev.pageY：鼠标坐标
	ev.currentTarget：事件处理函数被设置的节点
	ev.relatedTarget：相关目标，例如：mouseover指离开点，mouseout指进入点
	ev.stopPropagation()：阻止向上冒泡事件
	ev.preventDefault()：阻止默认事件发生
	ev.prevVal：旧值
	ev.newVal：新值

Y.Node.on()：给节点分配事件监听器。  
Y.on()：提供统一的事件监听器。  
	
	available：当节点存在时触发
	contentready：检测到一个元素和它的nextSibling时触发
	domready：DOM加载完成时触发

***目录结构***   
每个模块在基准路径(base)下都有一个以模块名命名的目录，该目录下至少包含一个module.js文件，可能还有*-min.js或*-debug.js。如果模块的skinnable为true，还要包含一个assets/skins目录，默认皮肤为sam。

	base/
		moduleName/
			moduleName.js
			assets/
				skins/
					sam/
						moduleName.css
						sprite.png
					
node包：包含node-base,node-style,node-event-delegate和nodelist。   
json包：包含json-parse和json-stringify。   

	 
##创建类
***Y.extend(类, 父类, {新增prototype方法}, {新增属性})***  
类需定义构造函数，NAME，ATTRS   

***Y.Base.create('类名NAME', 父类, [依赖模块列表], {新增方法}, {新增属性} )***

例如：
	
	// 创建一个 Y.CustomRouter 继承自Y.Router.
	Y.CustomRouter = Y.Base.create('customRouter', Y.Router, [], {
  	// 在此处添加或覆盖prototype的属性或方法.
	}, {
  		// 在此处添加静态properties或方法.
  		ATTRS: {
    		// 覆盖默认attributes.
  		}
	});
	
***Y.Base***
继承自Y.Base的类获得以下方法：

1. 状态管理（Attribute）
2. 事件处理（EventTarget）
3. 扩展和增强（plug）
4. 标准构造和析构函数

构造过程： Y发出init自定义事件，然后从顶向下调用继承链上的每个对象的initializer方法（如果有的话），如果initializer需要config对象，则搜索属性中是否包含config并传入。  
析构过程：Y发出destroy自定义事件，然后从低向上调用继承链上的每个对象的destructor方法（如果有的话）。

***Y.Widget***   
Widget继承自Base，有5个核心方法：

1. initializer()
2. destructor()
3. renderUI()：创建组件结构
4. bindUI()：根据组件状态变化，绑定事件监听器，以改变组件外观
5. syncUI()：根据状态更新组件外观

render()方法会根据传入CSS选择器，获取parentNode，创建boudingBox和contentBox的节点，并附加到parentNode上，然后依次调用renderUI()，bindUI()，syncUI()。

	boundingBox：指定组件大小和位置，拥有yui3-name和yui3-widget的类名（name为组件的NAME属性）
	contentBox：boudingBox的子节点，包含组件内容，拥有yui3-name-content的类名
	CONTENT_TEMPLATE，BOUDING_TEMPLATE：contentBox，boudingBox的标签，默认为<div>。

***Attribute***  
Attribute接口负责管理状态。

	value：属性值
	lazyAdd：true,延迟初始化直到调用get()或set()
	valueFn：返回默认属性值
	validator：判断设置是否有效
	getter，setter：设置器
	broadcase：是否广播自定义事件，0默认，1广播到顶层Y，2广播到Y.Global。 
	
##基本方法

***Node***

* 获取节点  
	
		Y.one('')：接收CSS选择器并返回第一个匹配的节点。
		
* 方法
	
		addClass：添加类名
		removeClass：删除类名
		hasClass：判断是否包含类名
		hide：隐藏节点
		show：显示节点
		remove：从父节点删除该节点
		destroy：销毁该节点和其子节点，移除所有事件监听器
		set：设置DOM属性
		get：获取DOM属性
		setXY：设置位置，统一的YUI坐标系统
		ancestor，ancestors：获得祖先节点
		next，previous：返回第一个兄弟节点
		on：添加事件监听器
		getHTML，setHTML：获取和设置HTML
		all：在节点后代中搜索，返回NodeList
		append：增加子节点，等价于Y.Node.create().appendTo()
		getDOMNode：返回原生DOM对象
		plug：使用插件
		delegate：委托事件

* 创建节点
	
		Y.Node.create
		cloneNode
		setHTML
		
* 添加自定义方法
		
		Y.Node.addMethod:方法名，回调函数，根据返回值类型进行封装

***NodeList***  

* 获取节点列表		
		
		Y.all('')：返回匹配CSS选择器的所有节点。

* 方法
		
		Node中的方法都可在NodeList调用，区别是NodeList在所有节点上都调用该方法
		push，pop：加入或弹出节点
		shift：交换节点
		indexOf：获得第几个节点
		slice：分隔节点
		each：每个节点执行一个函数

#系统架构  
###yui-config-mtoa.js###
核心配置文件，配置了M，重新组合了Yui模块，定义了诸如mt-base，w-base，mt-log等模块。
window.M=global.M
	
	var M = window.M || {};
	M.DELTA_TIME: 0
	M.cosGroups: Object, 
	[{
    	name: 'mtoa',
    	prefix: 'oa-',
    	path: 'http://' + location.host + '/static/',
    	combine: false
	}];
	M.TimeTracker: 记录页面载入时间等时间跟踪信息，Object
	M.baseUri: "http://s0.cos.dev.sankuai.com/"
	M.combine: true
	M.comboBase: "http://c.cos.dev.sankuai.com/?f="
	M.cosGroups: Array[1]
	M.debug: true
	M.logFirstScreenTime: function (el, isReadyState) {
	M.site: "oa"
	M.yuiVersion: "3.10.3"
	__proto__: Object

###page.js
oa-page，配置mt.oa，AO_config

###router.js
oa-router，继承自Y.Router，Router提供基于URL的同个页面的路由
定义route为/

###account.js
makeMenuLoadFn:加载菜单栏

oa-account/tpl，TPL模板

###oa.pf.sa.auth.layout.action
 定义了菜单栏内容
 
###notify.js
oa-notify，消息提示框  
dialogInfoObj：以键值对保存的对话框显示内容，会加入oa.errStack，与
TplContent的内容对应
	
	  msg: 错误消息，response.data.buz_error_msg
      detail: 错误详情，response.data.tech_error_msg + '\n' + response.data.ste_list
      url: src属性的URL
      query: 请求参数，oa.req.query
      title: 对话框标题
      ref: 请求路径，oa.req.path
      ip: ip地址

**调用方式**  
		
	text为传入字符串   
	Y.mt.oa.notify.notify(text);  
	error为传入键值对数组  
	Y.mt.oa.notify.error.block(error);

###base.js
oa-base，系统通用方法，以Y.mt.oa.util.fun调用
    对数据进行格式化, 用于searchBox和添加修改等的动态表单
    formatData: function(data, nameKey) 
---    
    将数字转换为日期字符串
    data：数字，以毫秒为单位
    type：为T_DATE或date，则字符串格式为Y-m-d，为month，则字符串格式为Y-m
    isShort：为true，则字符串格式为Y-m-d H:i；false，则字符串格式为Y-m-d H:i:s
    type和isShort都设置时，以type为准，type为null时，以isShort为准
    返回值：日期字符串
    formatDate: function(data, type, isShort) 
---       
      
    从列的范围中找出value对应的值
    例如：value:1 thParams.rangeset:'1:通过@0:驳回@-1:撤回'，返回值为'1:通过'
   	formatTableRangeset: function(value, thParams) 
---          
    格式化列值
    value：列值
    thParams：列属性，例如：{ code:'ISCOMMIT', name:'是否通过', type: 'T_STAT',rangeset:'1:通过@0:驳回@-1:撤回'}
	name：
	data：数组，当name和data都不为null时，value=data[name+'_NAME']	formatColData: function(value, thParams, name, data) 
---
	设置contentBox中id为section-title的节点的text属性为title
	setSectionTitle: function(title, contentBox)
---
	为section-view加入‘收起’、‘展开’效果
	btn：收起展开按钮
	contentBox：其中id为section-content节点被显示或隐藏
	foldStatus：收起或展开状态，如果为null，则由btn的view-status属性决定
	addSectionToggleView: function(btn, contentBox, foldStatus) 
---	
	由datalist和slave调用，构造SectionView
	container：父容器节点
	title：标题
	foldStatus：收起或展开状态，可选值：unfold或fold
	className：SectionView的新增类名，用于添加css样式
	buildSectionView: function(container, title, foldStatus, className)

	
###control.js
oa-control，从来没有用过

###url.js
oa-url，以键值对方式定义方法名和对应的url。

调用方式：
	
	var DataUrl = Y.mt.oa.URLS;
	//获得单据查询的url
	DataUrl.bill_model_query_enter
	//获得新的申请单号url
	DataUrl.new_idgen

###search.js
oa-searchBox，页面中的搜索框控件
searchBoxConfig：搜索框参数

	node：Y_Node，父节点，ndSearchBoxForm，即<form class='search-form'>	
	searchUrl：字符串，搜索url，同步获取数据
	url：字符串，搜索url，异步获取数据
	title：表名
	beforeBuildItem: function (o) {
	billCode: 字符串，表单码
	data: 数组，Array[]，对应单据模板的数据
	dataRelation: Object，
		config: "config"
		desc: 字符串，描述
		isShow: "showcard"
		name: "code"


	
###Y.mt.widget.CommonDialog 
config包含id号，title：对话框标题，width：宽度，content：内容
	
	var config = {
          id: 'oaNotify',
          title: Y.Lang.sub(TplTitle, { title: '出错了' }),
          width: 400,
          content：‘’
    };
	Y.mt.widget.CommonDialog(config);

###Y.mt.widget.DynamicForm
 
 	var formtable = new Y.mt.widget.DynamicForm(searchBoxConfig);
###Y.mt.lang.date

	以'Y-m-d H:i:s'格式返回当前时间	
	Y.mt.lang.date('Y-m-d H:i:s')
	以'Y-m-d'格式返回data时间，data以秒为单位
	Y.mt.lang.date('Y-m-d', data)
	
#Q&A
**为何在YUI.add()时已经设置了requires，而在YUI配置时还需再设一次requires？**  
书上解释得不清。

**path和fullpath的区别**  
path：会以base/path为路径搜索js。
fullpath：如果定义该值，则会忽略base，以fullpath搜索js。


**Dom属性和HTML属性的区别**  

书上解释得不清。

**Dom事件和自定义事件的区别**  

Dom事件是指YUI事件，如click，mouseover等。  
自定义事件是指用户自定义的事件，必须用Y.fire('事件名称',{参数列表})调用该事件。   
区别是对after的执行时刻不同。Dom事件是目标上的on和after按顺序执行，再冒泡执行父类的on和after。自定义事件是执行目标的on，冒泡执行父类的on，再执行目标的after，冒泡执行父类的after。

***superclass.constructor.apply(this, arguments)***   

superclass.constructor访问父类的构造函数
子类中初始化父类并且带同样的参数
Programmer.superclass.constructor.apply(this, arguments);

***M.add()怎么来的，不是应该是Y吗?***

在yui-config-mtoa.js中设置的，同时还定义了w-base，oa-base等模块

***property和attribute区别***

property：var root = this.root;
attribute：var root = this.get('root');


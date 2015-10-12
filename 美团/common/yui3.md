#YUI 内容提要

1.和jQuery的使用方式的一些区别


2.YUI最明显的特点介绍


3.YUI的架构


4.YUI最常用的一些全局对象

5.YUI实例

##零、YUI3同jQuery的比较

#####0、jQuery和YUI的定位和应用场景有很大的不同，比较是为了更好的理解YUI的

 

#####1、jQuery一步到位、YUI需要自己召唤。

jQuery只需一个核心文件就能搞定大多数问题.YUI则是按需加载文件。个人感觉这是最大的一个区别。jQuery适合一些中小型网站，YUI适合复杂web应用。
jQuery按照传统的JS文件加载方式，在加载时需要注意模块和顺序。YUI则是动态加载，不仅性能上会有所提升，此外可以将模块语义话，无需关心如何去获得文件，在项目庞大臃肿的时候尤其好使。但如果管理不好就是个灾难。


#####3、学习曲线jQuery平滑很容易上手。YUI需要一定的基础。
个人感觉 J只需懂点js基础即可上手，门槛比较低,但功能很强大也很贴合web特点。Y的重点除了js基础外还必须理解YUI的代码的组织和结构。理解了代码组织和结构后学习YUI就是一个很nice的事情。前期比较麻烦一点。但可持续性很强。

#####4、jQuery以dom为核心，YUI以组件为核心
jQuery关心的核心是DOM，一切均是DOM为核心。YUI则是更面向widget，高度模块化和独立。从这点上来看YUI更适合大型团队开发。

#####5、jQuery中不会有出错（例如dom不存在的情况），YUI则需要手动判断
jQuery中操作一个不存在的DOM时浏览器不会报错（不影响页面的其它的跟本逻辑无关的地方），但在调试的时候可能需要更有经验或者更多的时间。YUI的选择器遇到不存在的情况是返回null的这要求必须手动处理。

#####6、语义上相同的代码在jQuery和YUI中有何区别
参考一篇文章 著名的罗塞达石碑系列 对于基础语法有很简单明了的比较,very nice！~:）[jQuery - YUI 3 Rosetta Stone](http://www.jsrosettastone.com/)

--------
## 一、YUI特点详解
####1. 动态按需加载

YUI3种子中的Get、Loader模块是动态按需加载的基础,YUI3框架通过良好的结构组织，可以根据程序引入的所需模块名称自动计算依赖模块，实现按需加载；YUI3动态加载的优势：

1. 将js文件写入script标签，每一个标签都会占用一个http请求(即使是304.)，而动态加载的文件缓存后则不必发起真实的http请求。提高了框架的性能。

2. 动态加载可以避免开发人员额外关注js文件之间的依赖和排序及重复问题。  引入的时候只需要引入需要模块的名称即可，依赖关系不需要花费精力处理。

3. 动态加载利于页面代码语义化，只需要关心 ‘需要什么’。

 
####2.细粒度化设计

YUI3对每个模块都进行了更细粒度的划分。比如，dom模块，划分为了 base,screen,style,selector-css2,selector-css3,selector-native等几个小模块，对于我们控制页面的载入的数据量有很大帮助。


####3.闭包特性（安全沙箱）
 页面的每一个YUI实例能够被自包含、保护和限制(YUI().use())。这种和其他YUI实例的分离，能够配合你的特殊函数需求，并且能让不同的YUI 版本更好的运行在一起。在很大程度上方便了不同开发者对同一页面的并行开发。
这里YUI().use(”,function(Y){…})就是一个安全沙箱，可以确保这里面的Y是纯天然无污染的，Y实例里有什么功能完全取决于use里传进的模块名称，function(Y){}里面的程序跟外界是隔离的，在里面创建的变量（除了全局变量）以及对YUI的添加修改都不会影响到同个页面上其他人写的程序。


## 二、架构
  <IMG SRC="http://dl.iteye.com/upload/attachment/509168/56652789-85a3-3d66-bf32-c95256633cb9.png"/>
  
  
**YUI3从结构上来看分为4个类别**


**种子亦或引导：** 该模块是YUI3的单一核心，页面都必须包含该模块，该模块提供加载功能，所以可以堪称是YUI的一个种子或者引擎。在YUI3中扮演引导层的作用，通过在页面引入种子相关文件，调用YUI().use()方法可以安全快速的加载YUI3核心类和组件类。包含YUI Base、Get和Loader模块。

**核心：** 核心模块为YUI3下游组件提供通用依赖。该模块包括OOP模块（提供对象继承机制，DOM等绝大多数模块直接或间接依赖OOP）、Dom模块（提供基础的DOM操作与选择类）、Node模块（基于Dom模块，提供文档节点的创建、选择和操作等方法，相比YUI2有了很大的精简）、Event模块（提供屏蔽浏览器差异的事件注册和响应机制，同时提供高级自定义事件的功能）

**组件框架：**组件框架基于YUI核心框架。从下到上依次基于Attribute、Base、Widget模块组成；同时提供Plugin模块实现灵活扩展。组件框架是建立和扩展组件的基础。

**组件：** YUI3提供的高度模块化可复用的组件，根据程序按需引入相关模块即可。YUI3目前提供了Animation、Drag and Drop、IO、Cookies、JSON 等基础组件模块。

## 三、全局对象
###a、全局对象

YUI模块是YUI3.x实现的单个核心依赖。在使用YUI的页面中都必须包括YUI，这是唯一的依赖文件。YUI模块包含模块加载功能和模块依赖计算功能，YUI模块作为具体实现的一个种子，你只需要提供需要的模块列表及基于这些模块实现的代码；通过配置YUI的加载方式，YUI3可以在加载时通过一个优化的HTTP请求获取所有所需的模块文件；此外，YUI模块在自定义组件加载script和css时作为组件的核心种子。通过YUI模块可创建一个全局的实例化YUI对象。 而且通过该对象创建YUI其他模块实例对象。一个页面可以共享同一个YUI实例，或者也可以为页面中每块功能使用不同的封闭的实例（安全沙箱）。
 
 
查看API yui模块，该模块包含以下对象：


1. Array           提供一些静态的数组操作方法，通过YUI实例调用。如 Y.Array.each()


2. config          实例化YUI时可传入的参数，根据参数生成可配置的YUI实例


3. Get
           提供动态加载script和css的功能。Y.Get(..)
           
           
4. Intl              提供本地化资源管理支持 。Y.Intl


5. Lang           提供对JavaScript的一些工具方法和扩展方法。如对象类型检测等 .如 Y.Lang.isString()


6. Object        提供针对object的静态操作方法 .如 Y.Object.hasKey()


7. Queue        提供一个简单的队列实现 new Y.Queue() 


8. UA              提供针对浏览器、引擎、操作系统的属性信息 .如 Y.UA.ie


9. YUI             YUI 全局命名空间对象。创建Global Object:  Y = YUI(config)


 
 
 使用Global Object
需要加载脚本\<script src="build/yui/yui-min.js">\</script> ,然后通过调用方法YUI() 即可创建一个YUI对象。
在只调用YUI()的情况下，所有以下功能在YUI核心都可用：array,core,lang,later,log,object,ua,yui,get,loader 
 
###b.YUI.use()
YUI对象最基本的就是use方法的使用。通过use方法，允许你加载所需的模块到yui实例中，如下
YUI().use('node','dd',function(Y){  
    //Y.Node and  Y.DD  is ready  
});
如果需要加载所有模块 只需要使用 YUI().use('*',function(Y){});即可
###c. config  配置参数
通过配置config，可以控制YUI实例的加载策略；记录下比较常用的几个配置及作用
YUI({
combine:false/true ,//  use the Yahoo! CDN combo service for YUI resources。
filter:raw/debug,//默认加载模块的 *-min.js压缩文件，通过配置raw或debug，可以加载模块对应的 *.js或 *-debug.js。
modules:{
//设定加载的YUI开发包之外的模块。 配置模块名及对应的文件地址和依赖模块
'moduleName':{
fullpath:'',
requires:[]
}
},
groups:{
//设定加载一组YUI开发包之外的模块集合，
'groupName':{
base:'',
modules:{
'module1':{path:'',requires:[],skinnable:true}//注：设定skinnable=true可以依据YUI定义的模块组织目录结构自动加载该模块依赖的css文件
}
}
}
});
 
d、YUI核心实例对象 常用方法与静态对象介绍（非全部）
 
Y.guid(pre)
创建unique序列字符串
 
Y.instanceOf(obj,type)
判断引用对象的类型；返回true/false；
例：Y.instanceOf(new String('str'),String) //true

Y.Lang
数据类型判断相关：
Y.Lang.isArray(arr)
Y.Lang.isBoolean(o)
Y.Lang.isNull(o)
Y.Lang.isFunction(o)
Y.Lang.isNumber(o)
Y.Lang.isObject(o)
Y.Lang.isString(o)
Y.Lang.isUndefined(o)
Y.Lang.isDate(o)
Y.Lang.isValue(o)  null/undefined/NaN->false ;others ->true
Y.Lang.type(o)  //typeof 
时间相关
Y.Lang.now() //  Returns the current time in milliseconds.
//字符串操作
Y.Lang.sub(str,o)  //简单的字符替换。更高级的字符替换在‘substitute’模块
Y.Lang.trim(o)/trimLeft(o)/trimRight(o)
 
Y.UA
检测当前浏览器引擎、浏览器及操作系统信息
if(Y.UA.ie>0){}
if(Y.UA.chrome>0){}
if(Y.UA.os=='windows'){}
 
Y.Array
注：在加载其他模块后，可以直接使用Y调用Y.Array的方法。
Y.Array.test(arr)// 非数组->0;数组->1;类数组(array like object,例如arguments、HTMLElement collections)->2
Y.Array.each(arr,function(item,index){},context)
Y.Array.hash(arrA,arrB)  //返回 将数组arrA中的值作为key，arrB中的值作为value 的hash对象。如果arrB没有对应值，则value=true
Y.Array.some(arr,function(value,index,arr){},context); //函数返回true，则Y.Array.some返回true；否则 返回false
 
 
Y.Object
Object相关静态方法 注：在加载其他模块后，可以直接使用Y调用Y.Object的方法。
var child = Y.Object(parent);//以parent对象做原型，创建基于原型继承的对象child。
实现原理：
Y.Object = function(o) {  
    var F = function() {},  
    F.prototype = o;  
    return new F();  
}
方法：
 
Y.Object.each(o,function(v,k){},context,proto)  迭代object的键值
Y.Object.hasKey(o,key)/Y.Object.owns(o,key) // ===hasOwnProperty() 
Y.Object.hasValue(o,value) //
Y.Object.isEmpty(o)
Y.Object.keys(o) //string[]
Y.Object.values(o) //array
Y.Object.size(o) //int
Y.Object.some(o,function(v,i,o){},context);  ////函数返回true，则Y.Object.some返回true；否则 返回false
 
 
Y.Queue
简单队列
var queue = new Y.Queue('a','b','c');//新建简单队列
方法：
queue.add('d','e','f'); //添加到队列尾
queue.next() ;//FIFO, array.shift();移除队头
queue.last(); //LIFO, array.pop();  移除队尾
queue.size(); //队列大小
此外，引入queue-promote模块，队列将扩展增加以下方法
queue.indexOf(ele);//
queue.promote(ele);//
queue.remove(ele);//
 
 
Y.mix(receiver,source,over,list,mode,merge) 
非常重要的方法；提供对象合并功能。
 
用第二参数的属性覆盖(追加到)第一个参数对象 ；是augment方法和mix方法的基础。
参数可以是prototype或者object(默认是object，如果是prototype，可以根据mix方法第四个参数mode设置)。

 
api说明如下：
 
  object mix ( r , s , ov , wl , mode , merge )
Applies the supplier's properties to the receiver.
By default all prototype and static propertes on the supplier are applied to the corresponding spot on the receiver.
By default all properties are applied, and a property that is already on the reciever will not be overwritten. The default behavior can be modified by supplying the appropriate parameters.
Parameters:
r <Function> the object to receive the augmentation.
s <Function> the object that supplies the properties to augment.
ov <boolean> if true, properties already on the receiver will be overwritten if found on the supplier.
wl <string[]> a whitelist. If supplied, only properties in this list will be applied to the receiver.
mode <int> what should be copies, and to where default(0): object to object 1: prototype to prototype (old augment) 2: prototype to prototype and object props (new augment) 3: prototype to object 4: object to prototype.
merge <boolean/int> merge objects instead of overwriting/ignoring. A value of 2 will skip array merge Used by Y.aggregate.
Returns: object
the augmented object.
 
Y.merge(obj1,obj2,obj3,....)
基于mix，只提供简单的对象合并功能，也就是mix的object合并。遇到相同的属性会覆盖原来的值。
源码如下：
Y.merge = function() {  
    var a = arguments, o = {}, i, l = a.length;  
    for (i = 0; i < l; i = i + 1) {  
        Y.mix(o, a[i], true);  
    }  
    return o;  
};
示例：
var set1 = { foo : "foo" };  
var set2 = { foo : "BAR", bar : "bar" };  
var set3 = { foo : "FOO", baz : "BAZ" };  
   
var merged = Y.merge(set1, set2, set3);  
//{foo => FOO, bar => bar, baz => BAZ}
这里需要注意的是，如果复制的属性是引用类型，那么merge操作相当于java里的浅拷贝功能。
 
 
接下来的两个方法来源于oop模块，不知道YUI官方Global Object例子中为什么包含这两个方法？
可能是因为augment同merge一样依赖于mix方法；
而面向对象的继承实现也是框架的基础方法吧。
 
Y.extend(..)
（该方法定义在oop模块，所以使用需要引入oop模块 ）
基于原型继承模拟面向对象继承的方法。是YUI3继承机制的核心方法。
API说明如下：
  
 object extend ( r , s , px , sx )
Utility to set up the prototype, constructor and superclass properties to support an inheritance strategy that can chain constructors and methods. Static members will not be inherited.
Parameters:
r <function> the object to modify.
s <function> the object to inherit.
px <object> prototype properties to add/override.
sx <object> static properties to add/override.
Returns: object
the extended object.
 示例：
function Bird(name) {  
    this.name = name;  
}   
Bird.prototype.flighted   = true;  // Default for all Birds  
Bird.prototype.isFlighted = function () { return this.flighted };  
Bird.prototype.getName    = function () { return this.name };  
   
function Chicken(name) {  
    // Chain the constructors  
    Chicken.superclass.constructor.call(this, name);  
}  
// Chickens are birds  
Y.extend(Chicken, Bird);  
   
// Define the Chicken prototype methods/members  
Chicken.prototype.flighted = false; // Override default for all Chickens  
 测试：
var chicken = new Chicken('小鸡'),  
chicken instanceof Object // true  
chicken instanceof Bird    //true  
chicken instanceof Chicken //true  
  
chicken.isFlighted()  //false  
chicken.getName()   //小鸡  
Y.augment(..)
（该方法定义在oop模块，所以使用需要引入oop模块 ）
同样也依赖于mix方法。与merge相似，提供对象合并功能，不同的是不止合并object实例，主要用处还是合并构造器对象。
API说明如下：
  
 object augment ( r , s , ov , wl , args )
Applies prototype properties from the supplier to the receiver. The receiver can be a constructor or an instance.
Parameters:
r <function> the object to receive the augmentation.
s <function> the object that supplies the properties to augment.
ov <boolean> if true, properties already on the receiver will be overwritten if found on the supplier.
wl <string[]> a whitelist. If supplied, only properties in this list will be applied to the receiver.
args <Array | Any> arg or arguments to apply to the supplier constructor when initializing.
Returns: object
the augmented object.
 
 在这里需要注意  augment与extend方法的区别：如下图。
通过extend方法不仅继承了父类的方法，而且也构造了完整的原型继承链。
而通过augment合并方法，仅仅继承了源对象的属性，而没有构造继承链。

代码示例:
function Foo() {}  
Foo.prototype.doSomething = function () {  };  
  
function Bar() {}  
  
Y.augment(Bar, Foo);  
  
var b = new Bar();  
if (b instanceof Bar) {} // true   
if (b instanceof Foo) {} // FALSE  

##四、YUI实例
[参考链接 淘宝UED](http://ued.taobao.com/blog/2011/04/a-recipe-for-a-yui-3-application/)
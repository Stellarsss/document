### 大概结构
* Spring MVC和Struts2的比较：
	- spring mvc的入口是servlet，而struts2是filter（servlet和filter的区别）。

	- spring mvc是基于方法的设计，而struts是基于类。
	spring3 mvc是方法级别的拦截，拦截到方法后根据参数上的注解，把request数据注入进去，在spring3 mvc中，一个方法对应一个request上下文。而struts2框架是类级别的拦截，每次来了请求就创建一个Action，然后调用setter getter方法把request中的数据注入，一个Action对象对应一个request上下文。

	- 参数传递：struts是在接受参数的时候，可以用属性来接受参数，这就说明参数是让多个方法共享的。

	- intercepter的实现机制：struts有以自己的interceptor机制，spring mvc用的是独立的AOP方式。

![image](./img-resources/1.png)

DispatcherServlet处理请求的过程：1. WebApplicationContext被查找并且作为一个attribute绑定到request，绑定时的key为DispatcherServlet.WEB_APPLICATION_CONTEXT_ATTRIBUTE
2. locale resolver被绑定到request中，用来解决request中的国际化，包含rendering the view, preparing data, and so on。不需要的话可以忽略。3. theme resolver被绑定到request中，views通过它来决定使用哪个theme。不需要的话可以忽略。
4. If you specify a multipart file resolver, the request is inspected for multiparts; if multiparts are found, the request is wrapped in a MultipartHttpServletRequest for further processing by other elementsSpring Framework3.2.4.RELEASE Reference Documentation 446￼￼￼
Spring Framework￼￼￼in the process. See Section 17.10, “Spring's multipart (file upload) support” for further information about multipart handling.
5. An appropriate handler is searched for. If a handler is found, the execution chain associated with the handler (preprocessors, postprocessors, and controllers) is executed in order to prepare a model or rendering.
6. If a model is returned, the view is rendered. If no model is returned, (may be due to a preprocessor or postprocessor intercepting the request, perhaps for security reasons), no view is rendered, because the request could already have been fulfilled.

web.xml中每个DispatcherServlet都对应自己的一个WebApplicationContext

![image](./img-resources/2.png)

### sample下载地址
https://anonsvn.springframework.org/svn/spring-samples/

### hello world

####知识点
* 核心类与接口

		DispatcherServlet -- 前置控制器
		HandlerMapping接口 -- 处理请求的映射		HandlerMapping接口的实现类：		SimpleUrlHandlerMapping  通过配置文件，把一个URL映射到Controller;DefaultAnnotationHandlerMapping  通过注解，把一个URL映射到Controller类上
		HandlerInterceptor接口 -- 拦截器
		ViewResolver接口的实现类		UrlBasedViewResolver类 通过配置文件，把一个视图名交给到一个View来处理		InternalResourceViewResolver类，比上面的类，加入了JSTL的支持
		View接口		JstlView				LocaleResolver
		HandlerExceptionResolver接口 --异常处理		SimpleMappingExceptionResolver实现类		
		
* RequestMapping中的URI templates

* with any type and method-level annotations class需要创建代理对象时，proxy-target-class="true"将使用CGLIB而不是jdk reflect，否则需要将注解移到interface上

* RequestMappingHandlerMapping和RequestMappingHandlerAdapter

* 异常处理   
一种是使用HandlerExceptionResolver接口；一种是在Controller类内部使用@ExceptionHandler注解。使用第一种方式可以实现全局异常控制，并且Spring已经提供了一个默认的实现类SimpleMappingExceptionResolver；使用第二种方式可以在Controller内部实现更个性化点异常处理方式，灵活性更高。
    SimpleMappingExceptionResolver配置：    
如果warnLogCategory不为空，spring就会使用apache的org.apache.commons.logging.Log日志工具，记录这个异常，级别是warn。值：“org.springframework.web.servlet.handler.SimpleMappingExceptionResolver”，在log4j的配置文件中还要加入log4j.logger.org.springframework.web.servlet.handler.SimpleMappingExceptionResolver=WARN，保证这个级别是warn的日志一定会被记录，即使log4j的根日志级别是ERROR。
* 转发和重定向    
return "forward:/order/add";return "redirect:/index.jsp";* 处理ajax返回json请求
	- 添加相关com.fasterxml.jackson.core的jar包
	- spring配置文件修改,MappingJackson2HttpMessageConverter不需要手动添加，spring通过自动检测class文件是否存在来完成添加。以下是为了修改方法返回string类型时的乱码。

            <mvc:annotation-driven >
		      <mvc:message-converters register-defaults="true">
			    <bean class="org.springframework.http.converter.StringHttpMessageConverter">
				<property name="supportedMediaTypes">
					<list>  
	                    <value>text/plain;charset=UTF-8</value>  
	                    <value>text/html;charset=UTF-8</value>  
	                </list> 
				</property>
			</bean>
		      </mvc:message-converters>
	        </mvc:annotation-driven> 
 

### 相关注解

* <context:component-scan/>   
扫描指定的包中的类上的注解，扫描注解包含 @Component, @Repository, @Service, and @Controller,另外也回扫描<annotation-config/>相关的注解，包含 @Required, @Autowired, @PostConstruct, @PreDestroy, @Resource, @PersistenceContext and @PersistenceUnit 

* 常用的注解有：
	- @Controller 声明Action组件	- @Service    声明Service组件   
	- @Repository 声明Dao组件	- @Component   泛指组件, 当不好归类时
	- @Resource  用于注入，( j2ee提供的 ) 默认按名称装配，	- @Resource(name="beanName") 	- @Autowired 用于注入，(srping提供的) 默认按类型装配 	- @Transactional( rollbackFor={Exception.class}) 事务管理	- @Scope("prototype")   设定bean的作用域* MVC相关注解：	- @RequestMapping("/menu")  请求映射
	- @PathVariable URI template
	- @RequestParam 
	- @RequestBody	- @ResponseBody	- @ModelAttribute 加到方法上，返回值加到model中或方法入参包含model直接操作model；加到方法参数上，表示此参数从model中获取，可以在session中，在之前的modelattribute方法中，在webdatabinder中，或默认构造函数	- @SessionAttributes 
	* 哪些对象何时加入session    
    spring 在处理完modelAndView 之后，会调用	HandlerMethodInvoker.updateModelAttributes，其会遍历	model中的key，如果 key在 SessionAttributes中，则加入sessionAttributeStore。   

    * 如何获取 session中的对象    
    在spring 处理modelAndView之前，先检查是否有SessionAttributes 注释，有则获取了sessionAttributeStore中 对应的属性，然后加入了 model中。    
    因此如果是在AController里使用 @sessionAttributes("xx"), 并成功设置了该属性 , 而在BController 里没有使用 @sessionAttributes("xx")， 那么BController 的方法参数里，使用 @ModelAttribute("xx") String xx, 是取不到sessionAttributeStore 中的值的。如果你想在其它的Controller获取session的值就要在Bcontroller前面加@sessionAttributes("xx"),因为要初始化 xx后才能在方法参数中通过@ModelAttribute("xx")去获取session里面的值

    * 何时销毁

    需要手动调用 sessionStatus.setComplete, 才会销毁 @SessionAttributes 中对应的session属性 。这里需要留意，要记得销毁用不着的session对象。
    
	- @RedirectAttributes
	- @CookieValue 加到方法参数上
	- @RequestHeader 
  RequestParam,PathVariable,RequestHeader,CookieValue属于同类型的注解。
  
	- @ExceptionHandler### ViewResolver和View
* SpringMVC用于处理视图最重要的两个接口是ViewResolver和View。ViewResolver的主要作用是把一个逻辑上的视图名称解析为一个真正的视图，SpringMVC中用于把View对象呈现给客户端的是View对象本身，而ViewResolver只是把逻辑视图名称解析为对象的View对象。View接口的主要作用是用于处理视图，然后返回给客户端。
Spring为我们提供了非常多的视图解析器，下面将列举一些视图解析器。

* `AbstractCachingViewResolver`： 
   
这是一个抽象类，这种视图解析器会把它曾经解析过的视图保存起来，然后每次要解析视图的时候先从缓存里面找，如果找到了对应的视图就直接返回，如果没有就创建一个新的视图对象，然后把它放到一个用于缓存的map中，接着再把新建的视图返回。使用这种视图缓存的方式可以把解析视图的性能问题降到最低。

* `UrlBasedViewResolver`： 
   
它是对ViewResolver的一种简单实现，而且继承了AbstractCachingViewResolver，主要就是提供的一种拼接URL的方式来解析视图，它可以让我们通过prefix属性指定一个指定的前缀，通过suffix属性指定一个指定的后缀，然后把返回的逻辑视图名称加上指定的前缀和后缀就是指定的视图URL了。如prefix=/WEB-INF/jsps/，suffix=.jsp，返回的视图名称viewName=test/index，则UrlBasedViewResolver解析出来的视图URL就是/WEB-INF/jsps/test/index.jsp。默认的prefix和suffix都是空串。

URLBasedViewResolver支持返回的视图名称中包含redirect:前缀，这样就可以支持URL在客户端的跳转，如当返回的视图名称是”redirect:test.do”的时候，URLBasedViewResolver发现返回的视图名称包含”redirect:”前缀，于是把返回的视图名称前缀”redirect:”去掉，取后面的test.do组成一个RedirectView，RedirectView中将把请求返回的模型属性组合成查询参数的形式组合到redirect的URL后面，然后调用HttpServletResponse对象的sendRedirect方法进行重定向。
  
同样URLBasedViewResolver还支持forword:前缀，对于视图名称中包含forword:前缀的视图名称将会被封装成一个InternalResourceView对象，然后在服务器端利用RequestDispatcher的forword方式跳转到指定的地址。    
`使用UrlBasedViewResolver的时候必须指定属性viewClass，表示解析成哪种视图`，一般使用较多的就是InternalResourceView，利用它来展现jsp，但是当我们使用JSTL的时候我们必须使用JstlView。

下面是一段UrlBasedViewResolver的定义，根据该定义，当返回的逻辑视图名称是test的时候，UrlBasedViewResolver将把逻辑视图名称加上定义好的前缀和后缀，即“/WEB-INF/test.jsp”，然后新建一个viewClass属性指定的视图类型予以返回，即返回一个url为“/WEB-INF/test.jsp”的InternalResourceView对象。

	<bean class="org.springframework.web.servlet.view.UrlBasedViewResolver">  
   		<property name="prefix" value="/WEB-INF/" />  
   		<property name="suffix" value=".jsp" />  
   		<property name="viewClass" 						  value="org.springframework.web.servlet.view.InternalResourceView"/>  
	</bean>  
 
* `InternalResourceViewResolver`：  
  
是URLBasedViewResolver的子类，所以URLBasedViewResolver支持的特性它都支持。在实际应用中InternalResourceViewResolver也是使用的最广泛的一个视图解析器。那么InternalResourceViewResolver有什么自己独有的特性呢？单从字面意思来看，我们可以把InternalResourceViewResolver解释为内部资源视图解析器，这就是InternalResourceViewResolver的一个特性。
`相当于指定了viewClass为InternalResourceView、JSTLView的UrlBasedViewResolver`
`根据jstlPresent来判定实际为InternalResourceView或JSTLView`
InternalResourceViewResolver会把返回的视图名称都解析为InternalResourceView对象，InternalResourceView会把Controller处理器方法返回的模型属性都存放到对应的request属性中，然后通过RequestDispatcher在服务器端把请求forword重定向到目标URL。

比如在InternalResourceViewResolver中定义了prefix=/WEB-INF/，suffix=.jsp，然后请求的Controller处理器方法返回的视图名称为test，那么这个时候InternalResourceViewResolver就会把test解析为一个InternalResourceView对象，先把返回的模型属性都存放到对应的HttpServletRequest属性中，然后利用RequestDispatcher在服务器端把请求forword到/WEB-INF/test.jsp。这就是InternalResourceViewResolver一个非常重要的特性，我们都知道存放在/WEB-INF/下面的内容是不能直接通过request请求的方式请求到的，为了安全性考虑，我们通常会把jsp文件放在WEB-INF目录下，而InternalResourceView在服务器端跳转的方式可以很好的解决这个问题。

下面是一个InternalResourceViewResolver的定义，根据该定义当返回的逻辑视图名称是test的时候，InternalResourceViewResolver会给它加上定义好的前缀和后缀，组成“/WEB-INF/test.jsp”的形式，然后把它当做一个InternalResourceView的url新建一个InternalResourceView对象返回。

	<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
   		<property name="prefix" value="/WEB-INF/"/>
   		<property name="suffix" value=".jsp"></property>
	</bean>
 
* XmlViewResolver：   

它继承自AbstractCachingViewResolver抽象类，所以它也是支持视图缓存的。XmlViewResolver需要给定一个xml配置文件，该文件将使用和Spring的bean工厂配置文件一样的DTD定义，所以其实该文件就是用来定义视图的bean对象的。在该文件中定义的每一个视图的bean对象都给定一个名字，然后XmlViewResolver将根据Controller处理器方法返回的逻辑视图名称到XmlViewResolver指定的配置文件中寻找对应名称的视图bean用于处理视图。该配置文件默认是/WEB-INF/views.xml文件，如果不使用默认值的时候可以在XmlViewResolver的location属性中指定它的位置。XmlViewResolver还实现了Ordered接口，因此我们可以通过其order属性来指定在ViewResolver链中它所处的位置，order的值越小优先级越高。以下是使用XmlViewResolver的一个示例：

（1）在SpringMVC的配置文件中加入XmlViewResolver的bean定义。使用location属性指定其配置文件所在的位置，order属性指定当有多个ViewResolver的时候其处理视图的优先级。关于ViewResolver链的问题将在后续内容中讲到。

	<bean class="org.springframework.web.servlet.view.XmlViewResolver">  
   		<property name="location" value="/WEB-INF/views.xml"/>  
   		<property name="order" value="1"/>  
	</bean>  
 
（2）在XmlViewResolver对应的配置文件中配置好所需要的视图定义。在下面的代码中我们就配置了一个名为internalResource的InternalResourceView，其url属性为“/index.jsp”。

	<?xml version="1.0" encoding="UTF-8"?>  
		<beans xmlns="http://www.springframework.org/schema/beans"  
    	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
    	xsi:schemaLocation="http://www.springframework.org/schema/beans  
     	http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">  
    	<bean id="internalResource" 
    	  class="org.springframework.web.servlet.view.InternalResourceView">  
       <property name="url" value="/index.jsp"/>  
    </bean>  
	</beans>  
 
（3）定义一个返回的逻辑视图名称为在XmlViewResolver配置文件中定义的视图名称——internalResource。

	@RequestMapping("/xmlViewResolver")  
	public String testXmlViewResolver() {  
   		return "internalResource";  
	}  
 
（4）这样当我们访问到上面定义好的testXmlViewResolver处理器方法的时候返回的逻辑视图名称为“internalResource”，这时候Spring就会到定义好的views.xml中寻找id或name为“internalResource”的bean对象予以返回，这里Spring找到的是一个url为“/index.jsp”的InternalResourceView对象。

* BeanNameViewResolver：   

这个视图解析器跟XmlViewResolver有点类似，也是通过把返回的逻辑视图名称去匹配定义好的视图bean对象。
不同点有二，
一是BeanNameViewResolver要求视图bean对象都定义在Spring的application context中，而XmlViewResolver是在指定的配置文件中寻找视图bean对象，
二是BeanNameViewResolver不会进行视图缓存。

看一个例子，在SpringMVC的配置文件中定义了一个BeanNameViewResolver视图解析器和一个id为test的InternalResourceview bean对象。

	<bean class="org.springframework.web.servlet.view.BeanNameViewResolver">
   		<property name="order" value="1"/>
	</bean>
	<bean id="test" class="org.springframework.web.servlet.view.InternalResourceView">
   		<property name="url" value="/index.jsp"/>
	</bean>
 
这样当返回的逻辑视图名称是 test的时候，就会解析为上面定义好id为test的InternalResourceView。

* ResourceBundleViewResolver：   

它和XmlViewResolver一样，也是继承自AbstractCachingViewResolver，但是它缓存的不是视图，这个会在后面有说到。和XmlViewResolver一样它也需要有一个配置文件来定义逻辑视图名称和真正的View对象的对应关系，不同的是ResourceBundleViewResolver的`配置文件是一个属性文件，而且必须是放在classpath路径下面的，默认情况下这个配置文件是在classpath根目录下的views.properties文件，如果不使用默认值的话，则可以通过属性baseName或baseNames来指定`。baseName只是指定一个基名称，Spring会在指定的classpath根目录下寻找以指定的baseName开始的属性文件进行View解析，如指定的baseName是base，那么base.properties、baseabc.properties等等以base开始的属性文件都会被Spring当做ResourceBundleViewResolver解析视图的资源文件。

当我们把basename指定为包的形式，如“com.xxx.views”，的时候Spring会按照点“.”划分为目录的形式，到classpath相应目录下去寻找basename开始的配置文件。

ResourceBundleViewResolver使用的属性配置文件的内容类似于这样：

	resourceBundle.(class)=org.springframework.web.servlet.view.InternalResourceView  
	resourceBundle.url=/index.jsp  
	test.(class)=org.springframework.web.servlet.view.InternalResourceView  
	test.url=/test.jsp  
 
在这个配置文件中我们定义了两个InternalResourceView对象，一个的名称是resourceBundle，对应URL是/index.jsp，另一个名称是test，对应的URL是/test.jsp。从这个定义来看我们可以知道resourceBundle是对应的视图名称，使用resourceBundle.(class)来指定它对应的视图类型，resourceBundle.url指定这个视图的url属性。

会思考的读者看到这里可能会有这样一个问题：为什么resourceBundle的class属性要用小括号包起来，而它的url属性就不需要呢？这就需要从ResourceBundleViewResolver进行视图解析的方法来说了。ResourceBundleViewResolver还是通过bean工厂来获得对应视图名称的视图bean对象来解析视图的。那么这些bean从哪里来呢？
就是从我们定义的properties属性文件中来。在ResourceBundleViewResolver第一次进行视图解析的时候会先new一个BeanFactory对象，然后把properties文件中定义好的属性按照它自身的规则生成一个个的bean对象注册到该BeanFactory中，之后会把该BeanFactory对象保存起来，所以ResourceBundleViewResolver缓存的是BeanFactory，而不是直接的缓存从BeanFactory中取出的视图bean。然后会从bean工厂中取出名称为逻辑视图名称的视图bean进行返回。

接下来就讲讲Spring通过properties文件生成bean的规则。它会把properties文件中定义的属性名称按最后一个点“.”进行分割，把点前面的内容当做是bean名称，点后面的内容当做是bean的属性。这其中有几个特别的属性，`Spring把它们用小括号包起来了，这些特殊的属性一般是对应的attribute，但不是bean对象所有的attribute都可以这样用。其中(class)是一个，除了(class)之外，还有(scope)、(parent)、(abstract)、(lazy-init)`。而除了这些特殊的属性之外的其他属性，Spring会把它们当做bean对象的一般属性进行处理，就是bean对象对应的property。所以根据上面的属性配置文件将生成如下两个bean对象：

	<bean id="resourceBundle"
		class="org.springframework.web.servlet.view.InternalResourceView">  
   		<property name="url" value="/index.jsp"/>  
	</bean>
	<bean id="test" class="org.springframework.web.servlet.view.InternalResourceView">  
   		<property name="url" value="/test.jsp"/>  
	</bean>  
 
`从ResourceBundleViewResolver使用的配置文件我们可以看出，它和XmlViewResolver一样可以解析多种不同类型的View`，因为它们的View是通过配置的方式指定的，这也就意味着我们可以指定A视图是InternalResourceView，B视图是JstlView。

* FreeMarkerViewResolver、VolocityViewResolver：

这两个视图解析器都是UrlBasedViewResolver的子类。FreeMarkerViewResolver会把Controller处理方法返回的逻辑视图解析为FreeMarkerView，而VolocityViewResolver会把返回的逻辑视图解析为VolocityView。因为这两个视图解析器类似，所以这里我就只挑FreeMarkerViewResolver来做一个简单的讲解。FreeMarkerViewResolver和VilocityViewResolver都继承了UrlBasedViewResolver。
对于FreeMarkerViewResolver而言，它会按照UrlBasedViewResolver拼接URL的方式进行视图路径的解析。但是使用FreeMarkerViewResolver的时候不需要我们指定其viewClass，因为FreeMarkerViewResolver中已经把viewClass定死为FreeMarkerView了。
我们先在SpringMVC的配置文件里面定义一个FreeMarkerViewResolver视图解析器，并定义其解析视图的order顺序为1。

	<bean class="org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver">  
   		<property name="prefix" value="fm_"/>  
   		<property name="suffix" value=".ftl"/>  
   		<property name="order" value="1"/>  
	</bean>  
 
那么当我们请求的处理器方法返回一个逻辑视图名称viewName的时候，就会被该视图处理器加上前后缀解析为一个url为“fm_viewName.ftl”的FreeMarkerView对象。对于FreeMarkerView我们需要给定一个FreeMarkerConfig的bean对象来定义FreeMarker的配置信息。FreeMarkerConfig是一个接口，Spring已经为我们提供了一个实现，它就是FreeMarkerConfigurer。我们可以通过在SpringMVC的配置文件里面定义该bean对象来定义FreeMarker的配置信息，该配置信息将会在FreeMarkerView进行渲染的时候使用到。对于FreeMarkerConfigurer而言，我们最简单的配置就是配置一个templateLoaderPath，告诉Spring应该到哪里寻找FreeMarker的模板文件。这个templateLoaderPath也支持使用“classpath:”和“file:”前缀。当FreeMarker的模板文件放在多个不同的路径下面的时候，我们可以使用templateLoaderPaths属性来指定多个路径。在这里我们指定模板文件是放在“/WEB-INF/freemarker/template”下面的。

	<bean class="org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer">  
   		<property name="templateLoaderPath" value="/WEB-INF/freemarker/template"/>  
	</bean>  
 
接下来我们定义如下一个Controller：

	@Controller  
	@RequestMapping("/mytest")  
	public class MyController {  
    	@RequestMapping("freemarker")  
    	public ModelAndView freemarker() {  
       		ModelAndView mav = new ModelAndView();  
       		mav.addObject("hello", "andy");  
       		mav.setViewName("freemarker");  
       		return mav;  
    	}  
	}  
 
由上面的定义我们可以看到这个Controller的处理器方法freemarker返回的逻辑视图名称是“freemarker”。那么如果我们需要把该freemarker视图交给FreeMarkerViewResolver来解析的话，我们就需要根据上面的定义，在模板路径下定义视图对应的模板，即在“/WEB-INF/freemarker/template”目录下建立fm_freemarker.ftl模板文件。这里我们定义其内容如下：

	<html>  
    	<head>  
       	<title>FreeMarker</title>  
    	</head>  
   	 	<body>  
       		<b>Hello World</b>  
       		<font color="red">Hello World!</font>  
       		${hello}  
    	</body>  
	</html>  
 
经过上面的定义当我们访问/mytest/freemarker.do的时候就会返回一个逻辑视图名称为“freemarker”的ModelAndView对象，根据定义好的视图解析的顺序，首先进行视图解析的是FreeMarkerViewResolver，这个时候FreeMarkerViewResolver会试着解析该视图，根据它自身的定义，它会先解析到该视图的URL为fm_freemarker.ftl，然后检查在定义好的模板路径/WEB-INF/freemarker/template下是否有该模板存在fm_freemarker.ftl，如果有则返回该模板对应的FreeMarkerView。
接着FreeMarkerView就可以利用该模板文件进行视图的渲染了。所以访问结果应该如下所示：

* 视图解析器链

       在SpringMVC中可以同时定义多个ViewResolver视图解析器，然后它们会组成一个ViewResolver链。当Controller处理器方法返回一个逻辑视图名称后，ViewResolver链将根据其中ViewResolver的优先级来进行处理。所有的ViewResolver都实现了Ordered接口，在Spring中实现了这个接口的类都是可以排序的。在ViewResolver中是通过order属性来指定顺序的，默认都是最大值。所以我们可以通过指定ViewResolver的order属性来实现ViewResolver的优先级，order属性是Integer类型，order越小，对应的ViewResolver将有越高的解析视图的权利，所以第一个进行解析的将是ViewResolver链中order值最小的那个。当一个ViewResolver在进行视图解析后返回的View对象是null的话就表示该ViewResolver不能解析该视图，这个时候如果还存在其他order值比它大的ViewResolver就会调用剩余的ViewResolver中的order值最小的那个来解析该视图，依此类推。当ViewResolver在进行视图解析后返回的是一个非空的View对象的时候，就表示该ViewResolver能够解析该视图，那么视图解析这一步就完成了，后续的ViewResolver将不会再用来解析该视图。当定义的所有ViewResolver都不能解析该视图的时候，Spring就会抛出一个异常。
       基于Spring支持的这种ViewResolver链模式，我们就可以在SpringMVC应用中同时定义多个ViewResolver，给定不同的order值，这样我们就可以对特定的视图特定处理，以此来支持同一应用中有多种视图类型。

`注意：像InternalResourceViewResolver这种能解析所有的视图，即永远能返回一个非空View对象的ViewResolver一定要把它放在ViewResolver链的最后面`。
 

	<bean class="org.springframework.web.servlet.view.XmlViewResolver">  
   		<property name="location" value="/WEB-INF/views.xml"/>  
   		<property name="order" value="1"/>  
	</bean>  
  
	<bean class="org.springframework.web.servlet.view.UrlBasedViewResolver">  
   		<property name="prefix" value="/WEB-INF/" />  
   		<property name="suffix" value=".jsp" />  
   		<property name="viewClass" 	value="org.springframework.web.servlet.view.InternalResourceView"/>  
	</bean>  
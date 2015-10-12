####Spring quick review  note

-----

TIP1:ApplicationContext和BeanFactory区别和联系

1.两者都是载入Bean定义信息，装配Bean。根据需要分发Bean
2.ApplicationContext提供了更多的功能：
  a. 文本信息解析工具，包括国际化的支持
  b. 载人文件资源的通用方法，如载入图片。
  c. 向监听器的bean发送事件。
  
  
 ---
###什么是AOP
 
1. 面向切面编程Aspect-Oriented-Programming，是对面向对象的思维方式的有力补充。
	
2. 好处：可以动态的添加和删除在切面上的逻辑而不影响原来的执行代码。

3. 关键概念：
a) JoinPoint  :切面与原方法交接点 即 切入点
b) PointCut  :切入点集合
c) Aspect（切面）释意:可理解为代理类前说明
d) Advice :可理解为代理方法前说明 例如@Before
e) Target  :被代理对象 被织入对象
f) Weave  :织入

###Spring AOP配置与应用
两种方式：Annotation，xml配置
####1. Annotation

a) 加上对应的xsd文件spring-aop.xsd

b) beans.xml <aop:aspectj-autoproxy />

c) 建立拦截类

d) 用@Aspect注解这个类

e) 建立处理方法

f) 用@Before来注解方法

g) 写明白切入点（execution）

h) 让spring对我们的拦截器类进行管理@Component

常见的Annotation:
a) @Pointcut  切入点声明 以供其他方法使用 , 例子如下:


@Aspect

@Component

public class AspectInterceptor {

@Pointcut("execution(public * com.meituan.dao..*.*(..))")

public void myMethod(){}

@Around("myMethod()")

public void before(ProceedingJoinPoint pjp) throws Throwable{

System.out.println("method before");

pjp.proceed();
		
}

@AfterReturning("myMethod()")

public void afterReturning() throws Throwable{

System.out.println("method afterReturning");
		
}
	
@After("myMethod()")
	
public void afterFinily() throws Throwable{

System.out.println("method end");


}
}

b) @Before 执行之前

c) @AfterReturning 方法正常执行完返回之后

d) @AfterThrowing 方法抛出异常后

e) @After 类似异常的finally 

f) @Around 环绕 类似filter , 如需继续往下执行则需要像filter中执行FilterChain.doFilter(..)对象一样 执行 ProceedingJoinPoint.proceed()方可,例子如下:

@Around("execution(* com.meituan.dao..*.*(..))")

public void before(ProceedingJoinPoint pjp) throws Throwable{

System.out.println("method start");

pjp.proceed();//类似FilterChain.doFilter(..)告诉jvm继续向下执行

}

###2. xml配置AOP
 把interceptor对象初始化

 <aop:config

 <aop:aspect 

 <aop:pointcut

 <aop:before

例子：

\<bean id="logInterceptor" class="com.bjsxt.aop.LogInterceptor">\</bean>

\<aop:config>

<!– 配置一个切面 –>

<aop:aspect id="point" ref="logInterceptor">

<!– 配置切入点，指定切入点表达式 –>

<!– 此句也可放到 aop:aspect标签外 依然有效–>

<aop:pointcut
expression=
"execution(public * com.meituan.service..*.*(..))"
id="myMethod" />

<!– 应用前置通知 –>

<aop:before method="before" pointcut-ref="myMethod" />

<!– 应用环绕通知 需指定向下进行 –>

<aop:around method="around" pointcut-ref="myMethod" />

<!– 应用后通知 –>

<aop:after-returning method="afterReturning"
pointcut-ref="myMethod" />

<!– 应用抛出异常后通知 –>

<aop:after-throwing method="afterThrowing"
pointcut-ref="myMethod" />

<!– 应用最终通知  –>

<aop:after method="afterFinily"
pointcut="execution(public * om.bjsxt.service..*.*(..))" />

</aop:aspect>

</aop:config>
 

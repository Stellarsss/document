#TestNG[官网](http://testng.org/doc/documentation-main.html#test-results)  TestNG是一个测试框架，以简化单元测试和集成测试。  
***基本概念***  单元测试：对系统中的一个单元进行独立的测试，执行速度快，没有什么启动开销或外部依赖。  功能测试：关注一项功能，通常涉及不同组件之间的交互。  集成测试：一种端到端的测试，会执行整个流程，包括所有的外部依赖。  回归测试：修改了旧代码后，重新进行测试以确认修改没有引入新的错误或导致其他代码产生错误。  ###TestNG vs JUNITJUnit是单元测试框架，TestNG则提供更高级别的测试。1.	依赖测试。在JUnit中，如果测试不成功，则所有后续的依赖测试也会失败，这会使大型测试套件报告出许多不必要的错误。TestNG利用Test注释的 dependsOnMethods或dependsOnGroups 属性来解决测试的依赖性问题，如果依赖测试不成功则跳过，而不是标为失败。2.	参数化测试。在JUnit中，如果您想改变某个测试方法的参数，就只能给每个不同的参数组编写一个测试用例。TestNG通过testgn.xml或DataProvider提供参数化数据，就可以对不同的数据集重用同一个测试用例。接下来将着重介绍以上两点。##测试配置文件###testng.xml
testng.xml用于配置测试。	<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd" >	//suite：套件，由一个或多个测试组成	<suite name="">
		//设置suite级参数		<parameter name="" value=""/>		//test：测试，由一个或多个类组成		<test name="">			//设置test级参数，如果与suite中的name相同，则test会覆盖suite中的参数			<parameter name="" value=""/>			//class：类，由一个或多个方法组成			<classes>				<class name="">					<methods>
						//包含或排除的方法名，可用正则表达式匹配						<include name=""/>						<exclude name=""/>					</methods>				</class>			</classes>		</test>		<test>
			//对包下的所有类扫描测试			<packages>				<package name=""/>			</packages>		</test>	</suite>命令行运行测试
	java org.testng.TestNG testng1.xml [testng2.xml testng3.xml ...]
###testing-failed.xml执行失败时，TestNG会在输出目录（默认是test-output/）下自动生成名为testng-failed.xml文件。运行该文件，则TestNG只运行失败的测试。
	<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd" >	<suite thread-count="5" verbose="2" name="" parallel="none" annotations="JDK">
		<test name="T2(failed) junit="false" parallel="none" annotation="JDK">			<classes>				<class name="org.testngbook.FailedTest">					<methods>						<include name="f"/>						<include name="depend"/>					</methods>				</class>			</classes>		</test>	</suite>
命令行运行失败的测试
	java org.testng.TestNG test-output/testng-failed.xml
	##依赖测试
TestNG有两种依赖：
* Hard dependencies：所有依赖方法都必须运行，任何一个失败，则跳过当前方法。* Soft dependencies：尽管一些依赖方法失败，当前方法仍运行。通过@Test的alwaysRun=true设置。

dependsOnMethods：违反DRY(Don't repeat yourself)原则，导致重构问题，不推荐。  
	
	@Test
	public void serverStartedOk() {}
 
	@Test(dependsOnMethods = { "serverStartedOk" })
	public void method1() {}
method1依赖于serverStartedOk，保证serverStartedOk先执行，当serverStartedOk失败时，将跳过method1.

	@Test(groups = { "init" })
	public void serverStartedOk() {}
 
	@Test(groups = { "init" })
	public void initEnvironment() {}
 
	@Test(dependsOnGroups = { "init.* })
	public void method1() {}

method1依赖于组
dependsOnGroups：新方法只要放到适当的组中，可伸缩性好，推荐。  ###配置方法
依赖方法和配置方法的区别：测试方法显示依赖于依赖方法，隐式依赖于配置方法。

配置方法|失败后---:|:---@BeforeSuite|套件中所有测试方法都跳过@BeforeGroups|同一组内所有测试方法都跳过@BeforeTest|<test>标签内所有类都跳过
@BeforeClass|测试类中的所有测试方法都跳过@BeforeMethod|测试类中的所有测试方法都跳过
###Test注释范围
@Test annotaion定义
	@Target({METHOD, TYPE, CONSTRUCTOR})
	public @interface Test{}可知Test注释能用在方法，构造函数和类上。
	@Test(groups="web")
	public class CardTest{
		public void test1(){};
		public void tese2(){};
	}

在类上定义Test注释，它将自动应用到该类的所有公有方法，包括属性，即所有公有方法都自动为测试方法且属于groups="web"组。
###捕获异常
exceptedException用于捕获测试方法抛出的异常，shouldThrowIfPlaneIsFull必须抛出ReservationException异常，否则测试失败。
	
	@Test(exceptedException = ReservationException.class)
	public void shouldThrowIfPlaneIsFull(){
		Plane plane = createPlane();
		plane.bookAllSeats();
		plane.bookPlane(createValidItinerary(), null);
	}###Test继承
	@Test(groups="web")
	class BaseWebTest{}
	public class WebTest extends BaseWebTest{
		public void test1(){}
		public void test2(){}
	}
继承自BaseWebTest的子类的所有**公有方法**自动成为web组，WebTest成为一个简单的POJO，不需要添加注释。  

***注意：不要将测试基类列在testng.xml中，正则表达式可能导致包含基类，如`*Test.class`***
###Test返回值
注释了@Test的方法的返回值会忽略除非allow-return-values为true。
	<suite allow-return-values="true"> 
	<test allow-return-values="true">##参数化测试
TestNG通过两种方式向测试方法传递参数：  

* 利用testng.xml
* 利用DataProvider
方式|优点|缺点|场景  
---:|:---:|:---:|:---  testng.xml|值在testng.xml中指定，易于修改，TestNG自动传给测试方法|值不能动态获取。只能表示基本类型，而不能是Java对象|设置JDBC或主机名等  DataProvider|可传递任何Java对象，可动态获取	|需自己实现获取逻辑###注入基本类型参数只支持基本类型	
	<!-- testng.xml -->
	<suite name="param">
		<parameter name="xml-file" value="accounts.xml"/>
		<parameter name="hostname" value="192.168.2.165"/>
	
	public class Test{
		@Parameters({"xml-file","hostname"})		@Test
		public void test(String file, @Optional("localhost") String host){
			….
		}	}
	Optional：当testng.xml找不到名为host的参数时，用host采用默认值localhost。	###注入复杂类型参数接收两个参数：
- Method：当前测试方法的信息  	- method.getName(): 获得测试方法的方法名  - ITestContext：当前测试的上下文	- context.getIncludedGroups(): 获得测试方法属于哪些组

举例：
	//使用	@Test(dataProvider="account")
	public void test(Account account){
	}
		//定义一个名为account的dataprovider，返回值为Object[][]，行为测试次数(每一行对应一次测试方法的调用)，列为参数列表；若属性name为空，则name默认为方法名（不推荐）。	@DataProvider(name="account")	public Object[][] generateAccount(Method method, ITestContext context){
		int n=0;		return new Object[][]{
			new Object[] {new Account(n++)},
			new Object[] {new Account(n++)},
			new Object[] {new Account(n++)}		}	}通常dataProvider与测试方法在同一个类中，如果在不同类，则用dataProviderClass指明。
	
	public class StaticProvider {
  		@DataProvider(name = "create")
  		public static Object[][] createData() {
   			return new Object[][] {
      			new Object[] { new Integer(42) }
    		}
  		}
	}
 
	public class MyTest {
  		@Test(dataProvider = "create", dataProviderClass = StaticProvider.class)
  		public void test(Integer n) {
    		...
  		}
	}###延迟数据提供除了返回值为Object[][]外，DataProvider还接受Iterator。不同之处在于，TestNG需要取得下一组参数时，才会调用Iterator的next()方法，优点是不用一次性将数据读入内存。	public interface Iterator{		public boolean hasNext();		public Object next();		public void remove();	}###工厂@Factory，方法必须返回Object[]对象，Object[]为测试对象实例数组。  
TestNG在所有测试执行前，调用一次所有标注为@Factory的方法。
	
	<!-- testng.xml -->
	<class name="WebTestFactory" />

	public class WebTestFactory {
  		@Factory
  		public Object[] createInstances() {
   			Object[] result = new Object[10]; 
   			for (int i = 0; i < 10; i++) {
     			 result[i] = new WebTest(i * 10);
   			 }
    	return result;
  		}
	}

	public class WebTest {
 		private int m_numberOfTimes;
  		public WebTest(int numberOfTimes) {
    		m_numberOfTimes = numberOfTimes;
  		}
 
  		@Test
  		public void testServer() {
   			for (int i = 0; i < m_numberOfTimes; i++) {
    		 // access the web page
    		}
  		}
	}

###DataProvider vs Factory
方式|类似点|场景  
---:|:---:|:---  DataProvider|向测试方法传递参数|对不同参数的测试方法由DataProvider提供 Factory|向构造函数传递参数|构造函数的属性由工厂提供###分组Test注释的groups属性，执行时包含或排除分组  	
	@Test(groups="fast")
	public class B{
		@Test
		public void test1(){}  //test1属于fast组
		@Test(groups="unit")
		public void test2(){}  //test2属于fast和unit组
	}命令行运行分组：
		java org.testng.TestNG –groups fast -excludegroups unit com.example.B 
	
testng.xml配置分组：执行com.example.B中所有属于fast组的测试方法
	<suite name="">		<test name="">
			<groups>
				<run>
					<include name="fast"/> //可用正则表达式
				</run>
			</groups>
			<classes>
				<class name="com.example.B"/>
			</classes>
		</test>
	</suite>		1. 没有include也没有exclude时，执行所有测试方法。2. 只要指定了include或exclude，则严格按配置执行。
3. 排除优先：一个方法即属于include又属于exclude，以exclude为准##其他###捕获异常当执行测试方法时，须抛出异常列表中的某个异常，否则为失败。 
	@Test(expectedExceptions = {PlanFullException.class,FlightCanceledException.class})###ITest接口测试类继承该接口，则生成报告会包含getTestName()方法返回的信息，有助于快速定位问题。	
	public interface ITest{		public String getTestName();	}

举例：
	public class PictureTest implements ITest{
		public String getTestName(){
			return "[Picture:"+ name +"]";
		}	}	
###异步测试
该注释的含义为测试方法调用100次，其中98次成功，则认为测试通过，1000毫秒内返回则成功，否则失败	@Test(timeOut=1000, invocationCount=100, successPercentage=98)需要考虑：忙等(timeOut)、丢包(successPercentage)等情况###多线程测试threadPoolSize：线程数  invocationCount：测试次数，可用于压力测试
	@Test(threadPoolSize = 3, invocationCount = 10,  timeOut = 10000)
	public void testServer() {
###并发执行	
testng.xml配置多线程：
	<suite name="TestNG" verbose="1" parallel="methods" thread-count="2">
		…
	</suite>

- thread-count指定线程数目
- parallel指定并行模式		- parallel="methods"：所有测试方法都运行于独立的线程。	- parallel="tests"：同一<test>标签内的测试方法运行在独立的线程中。
	- parallel="classes"：同一<classes>标签内的测试方法运行在独立的线程中。
	- parallel="instances"：同一实例中的测试方法运行在独立的线程中。	#TestNG Java API

	TestNG tng = new TestNG();
	tng.setTestClasses(new Class[] {MyTest.class});
	TestListenerAdapter listener = new TestListenerAdapter();
	tng.addListener(listener);
	tng.run();
	listener.getPassedTests().size();创建TestNG对象，执行MyTest测试，添加TestListener。你可使用org.testng.TestListenerAdapter或实现org.testng.ITestListener接口。
###获取报告
TestListenerAdapter实现ITestListener接口，记录所有通过、失败、跳过的测试。

	public interface ITestListener{
		public void onStart(ITestContext context);
		public void onFinish(ITestContext context);
		public void onTestStart(ITestContext context); 
		public void onTestSuccess(ITestContext context);
		public void onTestSkipped(ITestContext context);
	}
	
	public class MyTestListener extends TestListenerAdapter{
		public void onTestSuccess(ITestResult result){
			super.onTestSuccess(result);
			// TODO
		}
	}
	
ITestResult.getResult返回ITestNGMethod，获取测试方法的原始Method
	ITestNGMethod method = result.getMethod();	method.getMethodName();	method.getInvocationCount();
	method.getGroups().length;
	method.getTimeout();
	###构造testng.xml配置文件
	
	<!--例如testng.xml内容如下 -->
	<suite name="TmpSuite" >
  		<test name="TmpTest" >
    		<classes>
      			<class name="test.failures.Child"  />
    		<classes>
    	</test>
	</suite>
	XmlSuite suite = new XmlSuite();
	suite.setName("TmpSuite");
 
	XmlTest test = new XmlTest(suite);
	test.setName("TmpTest");
	List<XmlClass> classes = new ArrayList<XmlClass>();
	classes.add(new XmlClass("test.failures.Child"));
	test.setXmlClasses(classes) ;

	List<XmlSuite> suites = new ArrayList<XmlSuite>();
	suites.add(suite);
	TestNG tng = new TestNG();
	tng.setXmlSuites(suites);
	tng.run();

标签|类名---:|:---	
< suite>|XmlSuite
< test>|XmlTest
< package>|XmlPackage
< class>|XmlClass
<method-selector>|XmlMethodSelector	

###指定testng.xml文件

	TestNG tng = new TestNG();
	tng.setTestSuites(Arrays.asList(new String[]{
		"testng.xml",
		"test-15/testng.xml"
	}));

###Annotaion转换器
执行时覆盖所有测试方法的超时注释，可通过testClass，testMethod覆盖特定类特定方法的注释。
	
	public class TimeoutTransformer implements IAnnotationTransformer{
		public void transform(ITest annotation, Class testClass, Constructor testConstructor, Method testMethod){
			annotation.setTimeOut(5000);
		}
	}	
	
	TestNG tng = new TestNG();
	tng.setAnnotationTransformer(new TimeoutTransformer());


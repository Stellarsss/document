#Google Java Style
[参考文献](http://google-styleguide.googlecode.com/svn/trunk/javaguide.html)
##源文件
文件名为它所包含的大小写敏感的顶级类名，后缀为.java，采用UTF-8编码。

- 空格：除了行结束符，空格字符只用0x20代表，这意味着：
 	1. 所有字符串中的空格符需要转义。
 	2. 制表符不用于缩进。
 	
- 对特殊字符，采用转义字符（如\b, \t, \n, \f, \r, \", \' and \\），而不是相应的八进制（\012）或Unicode（\u000a）编码。
- 对非ASCII字符，是采用Unicode字符还是Unicode转义字符（适当的注释非常有用），取决于代码的可读性能否更好。

Example | Discussion 
----|------
String unitAbbrev = "μs";|非常好: 非常清晰不需要注释
String unitAbbrev = "\u03bcs"; // "μs"|允许，但没必要这么做
String unitAbbrev = "\u03bcs"; // Greek letter mu, "s"|允许，但很奇怪且易错
String unitAbbrev = "\u03bcs";|差，读者不知道什么意思
return '\ufeff' + content; // byte order mark|好，为不可打印的字符使用转义，必要的注释

##源文件结构

- 组成顺序：（块间空一行）
	- 许可或版权信息（如果有的话）
	- 包名
		- 同一语句不能换行
	- import语句
		- 不能使用通配符或静态导入
		- 同一语句不能换行
		- **分组规则：**
		- 所有静态导入作为单独一组
		- com.google导入
		- 第三方导入，相同顶级包名的作为一组，按ASCII顺序排序，例如android, com, junit, org, sun
		- java导入
		- javax导入
		- 组与组之间不空行
	- 顶级类名

- 类声明
	- 顶级类用单独一个文件保存
	- 类成员的声明顺序对可读性有很大影响，在这里并没有一个唯一正确的方法，不同类的成员声明顺序可不同，但必须存在一定逻辑。例如新增加的方法未必要添加到类尾部，这会导致按照新增时间顺序声明的逻辑，而这种逻辑并没有意义。
	- 多个构造函数或覆盖方法应该写在一起

##格式化

- 大括号
	- 在if, else, for, do, while语句后必须加括号，即使括号中为空或只包含一条语句
	- 遵循K & R风格
		- {前不换行
		- {后换行
		- }前换行
		- }后换行，但else或逗号后不换行
	- 除了`if/else-if/else或try/catch/finally`等多区块语句，如果{}中为空则直接闭合，例如void doNothing() {} 
	
Example：		
	
	return new MyClass() {
  		@Override public void method() {
		    if (condition()) {
      			try {
			        something();
			      } catch (ProblemException e) {
			        recover();
      			}
    		}
  		}
	};	
	
- 块缩进
	- 新块开始都有两个空格的缩进。块结束时恢复到之前缩进等级。同一块内的代码和注释的缩进等级相同。
- 每句语句后面一个换行
- 列宽为160，超过的行将自动换行，除了以下情况：
	- URL或JSNI方法等无法遵循该原则的行；
	- package包名或import语句；
	- 注释中的命令行将被拷贝到shell中执行的语句
- 换行规则
	- 方法或构造函数与后面的(在一起，不换行
	- 逗号，与前面的内容一起，不换行 
	- 如果换行，下一行比上一行缩进4空格
	- 如果多个连续换行，行间缩进递增4空格。只有在每行都描述同一系列的元素时，才不递增缩进。
- 变量声明	
	- enum类型：如果不包含方法，则像声明数组一样声明enum。例如private enum Suit { CLUBS, HEARTS, SPADES, DIAMONDS }
	- 每个变量声明一次，而不是一起声明，如int a, b
	- 全局变量在类开始时声明。局部变量需要时才声明，而且尽快初始化。
	- 数组初始化方式如下：

example：

	new int[] {           new int[] {
 	 0, 1, 2, 3             0,
	}                       1,
                       		 2,
	new int[] {             3,
	  0, 1,               }
 	  2, 3
	}                     new int[]
                          {0, 1, 2, 3}
	- 方括号在类型后面，而不是变量后面。例如String[] args, 而不是 String args[]
- switch

example：
	
	switch (input) {  //switch中的内容缩进2格
  	  case 1: 			
  	  case 2:		  //case中的内容缩进2格
    	prepareOneOrTwo();
    	// fall through   //语句以break,continue,return或throw结束
  	  case 3:				//或者通过注释说明继续执行下一分支的原因
   		handleOneTwoOrThree();
    	break;
  	  default:			//switch中必须包含default分支，即使没有内容
   		handleLargeNumber(input);   //最后分支的后面不需要注释
	}	

##命名	
- 变量使用ASCII字符或数字，有效的命名必须符合\w+正则表达式。不使用像name_, mName, s_name, kName的前缀或后缀。
- 包名全部小写
- 类名采用`CamelCase`写法，由名词或名词短语组成；接口名由形容词或形容词短语组成；注释没有统一规则。测试类以测试类名开头，以Test结尾，例如`HashTest或HashIntegrationTest`.
- 方法名采用`lowerCamelCase`，由动词或动词短语组成。JUnit测试中方法名会采用下划线以区分不同逻辑，典型例子为`test<MethodUnderTest>_<state>`, 例如`testPop_emptyStack`，测试方法名没有统一规则。
- 常量成员变量名采用`CONSTANT_CASE`，全部大写，以下划线分割。常量是static final字段，但不是所有static final字段都是常量，

Example：

	// Constants
	static final int NUMBER = 5;
	static final ImmutableList<String> NAMES = ImmutableList.of("Ed", "Ann");
	static final Joiner COMMA_JOINER = Joiner.on(',');  // because Joiner is immutable
	static final SomeMutableType[] EMPTY_ARRAY = {};
	enum SomeEnum { ENUM_CONSTANT }

	// Not constants
	static String nonFinal = "non-final";
	final String nonStatic = "non-static";
	static final Set<String> mutableCollection = new HashSet<String>();
	static final ImmutableSet<SomeMutableType> mutableElements = ImmutableSet.of(mutable);
	static final Logger logger = Logger.getLogger(MyClass.getName());
	static final String[] nonEmptyArray = {"these", "can", "change"};

- 非常量成员变量名采用`lowerCamelCase`
- 参数名词采用`lowerCamelCase`，避免单个字符
- 局部变量采用`lowerCamelCase`，可尽量简短，避免单个字符，除非循环变量或临时变量。即使为final可不可变的，局部变量也不认为是常量，不要加final static修饰。
- 泛型可采用两种方式命名：
	- 单一大写字母，后面可跟一数字（例如E,T,X,T2）
	- 类名后跟一大写T（例如RequestT，FooBarT）
- Camel case
	- 第一步：将短语转成ASCII字符，去掉多余符号，例如Müller's algorithm转为Muellers algorithm
	- 第二步：将结果按空格拆分成单词，例如AdWords变为ad words，但iOS不是在此列。
	- 第三步：将每个单词的第一个字母大写，或除了第一个单词的其他单词的第一个字母大写
	- 第四步：将得到的单词连接起来

Example：

Prose form|Correct|Incorrect  
----|-----|-----
"XML HTTP request"|	XmlHttpRequest|	XMLHTTPRequest
"new customer ID"|	newCustomerId| newCustomerID
"inner stopwatch"| innerStopwatch| innerStopWatch
"supports IPv6 on iOS?"	| supportsIpv6OnIos| supportsIPv6OnIOS
"YouTube importer"| YouTubeImporter,YoutubeImporter*

##编程
- @Override不可忽略	
- 总是捕获异常catch exception

确实没有必要在catch中执行操作时，需要写注释说明原因

	try {
 		 int i = Integer.parseInt(response);
		  return handleNumericResponse(i);
	} catch (NumberFormatException ok) {
	  // it's not numeric; that's fine, just continue
	}
	return handleTextResponse(response);

catch中命名为expected时，不需要写注释	

	try {
 		 emptyStack.pop();
	     fail();
	} catch (NoSuchElementException expected) {
	}

- 静态成员

通过类名访问，而不是通过引用
	
	Foo aFoo = ...;
	Foo.aStaticMethod(); // good
	aFoo.aStaticMethod(); // bad
	somethingThatYieldsAFoo().aStaticMethod(); // very bad
- Finalizers不要使用，很少需要覆盖Object.finalize方法，如果你有一定要这样做的理由，请先读并认真理解`Effective Java Item 7, "Avoid Finalizers," `，然后别这么做

##Javadoc

注释格式一般如下：
	
	/**
	 * Multiple lines of Javadoc text are written here,
	 * wrapped normally...
	 */
	public int method(String p1) { ... }

简短格式如下：

	/** An especially short bit of Javadoc. */
- 每个类或方法前有一段简短说明，由名词或动词组成，并未非完整句子。该说明非常重要，常作为搜索关键字。 Tip：Javadoc格式易写成`/** @return the customer ID */`，应该为`/** Returns the customer ID. */`。
- 注释的参数顺序为@param,@return,@throws,@deprecated，其值不能为空。一行无法写下时，换行起点为@后空四格。
- 公共类和公共或保护方法前加注释，除了以下情况
	- 对简单方法例如getFoo，或单元测试方法前，方法名就能充分说明方法含义时。但对getCanonicalName方法，读者不知道cannonical name什么意思时，需要加注释
	- 重载方法时不需要注释
	- 包外部不可见的类或方法仍需要注释，当需要注释说明类或方法的目的或行为时，都需要注释。
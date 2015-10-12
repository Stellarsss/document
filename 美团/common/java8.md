# java 8
## 函式接口 functional interface
只有一个方法的接口，比如runnable,comparator;提供@FunctionalInterface,但是非必须
### Lambda语法(JSR 335)
```
(parameters) -> expression  || (parameters) -> {statements;}
```
* 小括号内，以逗号分隔
* 一个箭头符号： ->
* 方法体，可以是表达式和代码块

### 方法引用

* 静态方法： ClassName::methodName
* 非静态方法：Instance::methodName
* 构造函数：ClassName::new

### Iterator
```
//java 5写法
List<Emp> list = Arrays.asList(new Emp("code1"),new Emp("code2"),new Emp("code3"))
for(Emp e:list){
	p.code = "new_value";
}
//java 8写法
List<Emp> list = Arrays.asList(new Emp("code1"),new Emp("code2"),new Emp("code3"))
list.forEach( p -> p.code="new_value" )
```

### Stream API
```
long start = System.nanoTime();
int[] a = IntStream.range(0,1_000_000).filter(p -> p%2 == 0).toArray();
long end = System.nanoTime();
System.out.prontln(end-start);
start = System.nanoTime();
int[] b = IntStream.range(0,1_000_000).parallel().filter(p -> p %2==0).toArray();
end = System.nanoTime();
System.out.prontln(end-start);//并行更快
```

## 默认方法
对于面向接口开发而言，一般都是先设计一个接口，实现一个abstract，然后再基于abstract类实现，现在可以利用默认方法，去掉抽象类实现了
```
public interface ISome{
	default void method(){
		//do something
	}
}
...
public class SomeImpl implements ISome{
	public static void main(String[] args){
		ISome inst = new SomeImpl();
		inst.method();//虽然SomeImpl没有实现method()，但是因为有默认方法，所以就可以直接用了
	}
}
```

### 抽象类 vs 接口

* 相同点
	* 抽象类型(不能直接new)
	* 都可以有实现方法(之前接口是不可以的)
	* 都不需要实现类或子类去实现所有方法
* 不同点
	* 抽象类不能多重继承
	* 抽象类是is-a；接口是like-a
	* 接口中的变量是public static final,必须初始化；抽象类的变量默认是friendly，子类可重新定义也可以重新赋值

## 类型注解
之前，注解(annotation)只能用于类，方法，属性，现在其他地方也能用
* 创建类实例：new @Interned MyObject();
* 类型映射：myString = (@NonNull String)str;
* implements: class UnmodifiableList<T> implements @Readonly List<@Readonly T>{...}
* throw exception:void xxx()throws @Critical XException

```
类型注解只是语法，不是语义，编译成class后，不包含类型注解
```
check framework(http://types.cs.washington.edu/checker-framework/)利用类型注解，提供检查

```
@NonNull Object inst = new Object();
/*@NonNull*/ Object inst = null;//向下兼容模式
```
## 重复注解

```
//java5 写法
public @interface Authority{
	String role();
}
public @interface Authorities{
	Authority[] value;
}
@Authorities({@authority(role="admin"),@Authority(role="manager")})
public void something(){...}

//java 8写法
@Repeatable
public @interface Authority{
	String role();
}
public @interface Authorities{
	Authority[] value;
}
@Authority(role="admin")
@Authority(role="manage")
public void something(){...}
```

## IDE support
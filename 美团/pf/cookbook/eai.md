EAI分为import与export，在设计时，有考虑自动与手动导入与导出，但目前尚未有先例。

# EAI展示

前端展示分为导入与导出，相关实现在`src/main/webapp/static/pf/eai/`的`import.js`与`export.js`。  
EAI利用目前的`SearchBox`与`DyTable`来显示整个表单。`SearchBox`部分为参数，`DyTable`为具体值。  

### 导出 (手动)

提供预览与下载。下载时，将把预览结果保存为`xlsx`文件，可以直接使用相关软件打开，或者上传至其它接受系统。  
首个应用目标是财务的[半自动化支付](http://task.sankuai.com/browse/MTOA-374)，此导出文件可以直接上传至招行系统。

### 导入 (手动)

提供预览与导入。先选择文件，点击`预览`上传后，会显示预览结果。如果有指定转换状态，转换后的状态，有`转换`字样。  
首估应用目标也是财务的[半自动化支付](http://task.sankuai.com/browse/MTOA-374)，招行结果导出后可直接导入至本系统。

# EAI配置

EAI配置是与导入与导出一起使用的。实际上应该分开，目前的配置比较复杂，可能需要重够。

### 配置界面

使用`/pf/eai`进入配置，可以对目前的配置实行增删改查。相关文件是`src/main/webapp/static/pf/eai.js`及`src/main/webapp/static/pf/eai/update.js`。

相关字段介绍如下：

* 我方规则

  数据发生交换时，我方可以应用的规则，可以为`spring://`bean或者`sql://`语句。

* 他方规则

  数据发生交换时，他方可以应用的规则。目前暂未使用。

* 扩展Bean

  当使用我方规则或他方规则生成数据时，对数据进行再次处理的扩展Bean。  
  将把扩展Bean废弃，使用我方规则或他方规则即可。  
  引入扩展Bean主要是想在使用sql生成数据后，再次处理。

### 参数说明

* 参数类型

  同普通类型，如`T_STAT`, `T_REF`, `T_DATE`。

* 参数默认值

  参数显示的默认值

* 参数其它配置

  同`bill_model`中的其它配置。如`T_STAT`中的`rangeset`，`T_REF`中的`config`。  
  `T_STAT`还支持`rangeset_dst`，用法同`rangeset`，表示把目标转为我方的规则。  
  `T_DATE`还支持`datetype`，表示时间格式。如类型为`T_DATE`，并且指定了`datetype`，则默认值动态生成。

# EAI使用

* 通过界面配置一个EAI

* 如果不需要`bean`，纯`sql`就可以完成，直接填好`sql`即可。

  可以参考`IT_CM_EXPORT`, `LO_PROC_EXPORT`, `LO_PROC_IMPORT`。  
  可以直接使用的用户环境变量有`login_acc_code`, `login_pk_acc`, `login_acc_name`.

* 如果需要对数据进行额外处理，需要实现`ImportBizService`或`ExportBizService`.

# TODO

1. 完善目前代码注释

2. 合并`我方规则/他方规则`与`扩展Bean`。

3. 与新型`DataSet`集成。

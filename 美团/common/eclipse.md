#eclipse

##常规设置
- 设置文件打开方式：Eclipse->Preferences，在type filter text中输出file associations界面中配置不同后缀的文件的编辑器
- 配置Java模板：Eclipse->Preferences->Java->Editor->Templates
- 显示行号：Eclipse->Preferences->General->Editors->Text Editors->勾选show line numbers
- 设置列宽：Eclipse->Preferences->Java->Code Style->Formatter->Edit->Maximum line width
- 加强自动提示：Eclipse->Preferences->Java->Editor->Content Assist
	- Auto activation delay默认值为200（单位是毫秒）也就是说在打“.”之后停留200毫秒才能出现智能感知的提示。改为20
	- Auto activation triggers for Java的.改为.abcdefghigklmnopqrstuvwxyz

##调试
- F3：打开声明，open declaration  
- F4：打开type hierarchy对话框    
- F5：单步进入  
- F6：单步跳过  
- F7：单步跳出  
- F8：继续 
- 条件断点：断点上右击选择Breakpoint properties，设置Conditional中的条件
- 异常断点：在Debug透视图中，选择Breakpoints编辑器，工具栏上J!图标，增加异常类型

##常用快捷键 For MAC

- command=control
- option=alt

###cmd

- cmd+a：全选  
- cmd+c：拷贝  
- **cmd+d：删除该行**  
- **cmd+e：快速转换编辑器，在所有已打开文件中查找文件**  
- cmd+f：打开查找窗口  
- **cmd+g：选中方法，搜索该方法的所有声明**  
- cmd+h：最小化当前窗口  
- **cmd+l：打开go to line窗口**  
- cmd+n：打开新建窗口  
- **cmd+o：快速outline，显示类的所有方法**  
- cmd+p：打印  
- cmd+q：退出当前应用  
- cmd+s：保存  
- **cmd+t：打开实现**  
- cmd+v：粘贴  
- **cmd+w：关闭当前窗口**  
- cmd+x：剪切  
- cmd+z：撤销
- **cmd+/：注释或取消**  
- **cmd+左：跳到该行最后**  
- **cmd+右：跳到该行最前**  
- **cmd+上：跳到第一行**  
- **cmd+下：跳到最后一行**  
- **cmd+F11：快速执行程序**

###shift+cmd

- shift+cmd+a：open plug-in artifact  
- **shift+cmd+f：代码排版** 
- shift+cmd+g：选中方法，搜索所有用到该方法的地方   
- shift+cmd+h：打开Type in Hierarchy对话框，以类名搜索文件  
- shift+cmd+l：打开快捷键帮助
- **shift+cmd+o：自动import**  
- **shift+cmd+r：打开资源**  
- **shift+cmd+t：打开Type对话框，以类名搜索文件**  
- shift+cmd+u：选中方法，搜索该类中所有用到该方法的地方  
- shift+cmd+w：关闭所有打开文件  
- shift+cmd+enter：当前行上插入一行

###option

- **opt+/：自动补齐** 
- **opt+cmd+r：重命名**   
- **opt+上|下：当前行与上|下面一行交换位置**  
- **opn+cmd+上|下：将当前行复制到上一行|下一行**  

 


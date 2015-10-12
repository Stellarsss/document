## Mac OS X下启动Apache

0. 打开`终端`
   * 底栏`Finder`
   * 左侧`应用程序`
   * 进入`实用工具`目录
   * 打开`终端`

1. 生成配置文件，可以使用如下命令，在终端运行即可

       cat > `whoami`.conf <<EOF
       <Directory "/Users/`whoami`/Sites/">
           Options Indexes FollowSymLinks MultiViews
           AllowOverride All
           Order allow,deny
           Allow from all
       </Directory>
       EOF

   可能的屏幕显示：

       liudongmiao:~ thom$ cat > `whoami`.conf <<EOF
       > <Directory "/Users/`whoami`/Sites/">
       >     Options Indexes FollowSymLinks MultiViews
       >     AllowOverride All
       >     Order allow,deny
       >     Allow from all
       > </Directory>
       > EOF
 
1. 把\`whoami\`.conf，复制到apache配置目录，运行以下命令即可

   **提示**：会要求输入密码，但是不会回显

       sudo cp `whoami`.conf /etc/apache2/users/

1. 启用Apache，执行以下命令(实际上，这并不是立即启动apache)

       sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist 

1. 在家目录下创建一个`站点`，运行以下命令

       mkdir -p ~/Sites
       touch ~/Sites/.localized

1. 任何在`站点`下的文件，都可以通过<http://localhost/~yourname>访问

   **注意**：yourname是你机器的名称，可运行`whoami`得到

       whoami

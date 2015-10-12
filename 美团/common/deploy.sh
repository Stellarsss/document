#!/bin/sh
###### 安装mtoa脚本 ######
###### 以root用户执行./deploy.sh即可完成配置 ######
###### 增加sankuai用户，密码1qazxsw2 ######
USER=sankuai
PASSWD=1qazxsw2
#if [ $(id -u) -eq "0" ]; then
#       useradd $USER
#       echo $PASSWD | passwd --stdin $USER
#       exit 0
#else
#       USER_NAME=$(whoami)
#       echo "You are running this script as $USER_NAME, please run as root."
#       exit -1
#fi
###### 安装openjdk ######
#yum install -y java-1.6.0-openjdk
###### 安装maven ######
#wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
#if [ $? -ne 0 ]; then
#       echo "download maven repo error, please check the url or network."
#       exit -1
#fi
#yum install -y apache-maven
##### 安装mysql ######
#yum install -y mysql-server mysql mysql-devel
#service mysqld start
#mysqladmin -uroot password $PASSWD
#mysql -uroot -p$PASSWD -e"create database mtoa;"
#mysql -uroot -p$PASSWD -e"grant all privileges on mtoa.* to 'dev'@'localhost' identified by '1qazxsw2' with grant option;"
#mysql -uroot -p$PASSWD -e"grant all privileges on mtoa.* to 'dev'@'127.0.0.1' identified by '1qazxsw2' with grant option;"
mysql -uroot -p$PASSWD -e"grant all privileges on mtoa.* to 'dev'@'192.168.4.123' identified by '1qazxsw2' with grant option;"

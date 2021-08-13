MySQL数据库设置
（1）首先启动MySQL
[root@localhost ~]# systemctl start  mysqld.service
（2）查看MySQL运行状态，运行状态如图：
[root@localhost ~]# systemctl status mysqld.service
（3）此时MySQL已经开始正常运行，不过要想进入MySQL还得先找出此时root用户的密码，通过如下命令可以在日志文件中找出密码：
[root@localhost ~]# grep "password" /var/log/mysqld.log
（4）如下命令登录数据库：
[root@localhost ~]# mysql -uroot -p
（5）此时不能做任何事情，因为MySQL默认必须修改密码之后才能操作数据库，如下命令修改密码：
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'new password';
其中‘new password’替换成你要设置的密码，注意:密码设置必须要大小写字母数字和特殊符号（,/';:等）,不然不能配置成功。
如果出现如下错误：
是以为密码的复杂度不符合默认规定，如下命令查看mysql默认密码复杂度：
SHOW VARIABLES LIKE 'validate_password%';
如需修改密码复杂度参考如下命令：
set global validate_password_policy=LOW;

set global validate_password_length=6;
3 开启mysql的远程访问
执行以下命令开启远程访问限制（注意：下面命令开启的IP是 192.168.19.128，如要开启所有的，用%代替IP）：

grant all privileges on *.* to 'root'@'192.168.0.1' identified by 'password' with grant option;
注：password--是你设置你的mysql远程登录密码。

然后再输入下面两行命令
mysql> flush privileges;

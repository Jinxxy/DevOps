# CentOS 7 安装LNMP环境

## 系统要求

```shell
# 查看CentOS版本
[root@bogon source]# cat /etc/redhat-release 
CentOS Linux release 7.9.2009 (Core)
[root@bogon source]# cat /proc/version
Linux version 3.10.0-693.el7.x86_64 (builder@kbuilder.dev.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC) ) #1 SMP Tue Aug 22 21:09:27 UTC 2017
```

## 所需安装软件列表

```shell
mysql-8.0.17.tar.gz
nginx-1.16.1.tar.gz
php-7.3.9.tar.gz
redis-5.0.5.tar.gz
swoole-4.4.4.tgz
```

> 系统内置 [CURL](https://ec.haxx.se/) 命令,所以我们选择`CURL`下载软件`curl -O xxx`，如果软件包出现解压问题，不是因为`tar -zxf` 解压不了这个包。而是说明这个包下载的不完整，或者说因为网络原因只是一个空包，解决办法是删除后重新下载。另外防止资源网站迁移，请使用`curl -OL`参数.
> `-L`：跟踪重定向
> 国外资源下载太慢，请使用迅雷下载，然后通过`scp`上传到服务器，常用参数：
>
> - `-r` 传输的对象是目录
> - `-p` 指定端口，默认 22
>
> 使用场景：
>
> - `scp -p <server port> <server user>@<server ip>:<server path>/<server file> <local path>` 这是下载服务器资源，资源将被保存到 `<local path>`。
> - `scp -p <server port> <local path>/<local file> <server user>@<server ip>:<server path>` 这是上传本地文件到服务器指定路径。

## 运行权限

```shell
# 创建dywww用户和组
groupadd dywww
useradd -r -g dywww -s /bin/false dywww
# 添加到nginx组
# usermod -a -G 新的组 用户名
usermod -a -G nginx dywww
# php运行权限
etc\php-fpm.d\下，添加两行：
user = dywww
group = dywww
# nginx运行权限
nginx.conf
user dywww:dywww
```

## 安装软件

### PHP7

```shell
# 添加yum源
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
# 查看php7
yum search php71w
# yum安装
yum  -y install php71w php71w-cli php71w-common php71w-devel php71w-embedded  php71w-fpm php71w-gd php71w-mbstring php71w-mysqlnd php71w-opcache  php71w-pdo php71w-xml
//开启服务
# 启动php-fpm
systemctl start php-fpm
# 开机启动设置
systemctl enable php-fpm
systemctl daemon-reload

域名/admin.php
```

#### 安装 swoole-不需要

```shell
# PHP7.2以上
	[root@localhost /]# pecl install swoole
# PHP7.1
	#下载swoole的源码包并解压
	[root@localhost soft]# wget -c http://pecl.php.net/get/swoole-4.2.1.tgz
	[root@localhost soft]# tar xzvf swoole-4.2.1.tgz
	# 编
	译&&安装
    # 使用phpize来生成php编译配置
	[root@localhost soft]# cd swoole-4.2.1
	[root@localhost swoole-4.2.1]# phpize
    # 使用./configure 来做编译配置检测
	[root@localhost swoole-4.2.1]# ./configure --with-php-config=/usr/local/php/bin/php-config
	# make进行编译，make install进行安装
	[root@localhost swoole-4.2.1]# make && make install
	Installing shared extensions:     /usr/local/php/lib/php/extensions/no-debug-non-zts-20160303/
	Installing header files:          /usr/local/php/include/php/
	# 修改php.ini，加入
	默认：extension="swoole.so"
	项目：extension="/home/wwwroot/longli.diyibox.com/conf/swoole-loader/swoole_loader71.so"
	# 重启php-fpm
	service php-fpm restart
```

### Nginx

```shell
yum install nginx
# 查看nginx版本
[root@localhost soft]# nginx -v
nginx version: nginx/1.16.1
```

### MySQL

```shell
# 安装wget
yum install wget -y
# 添加yum repository
wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
# 安装mysql服务
yum -y install mysql57-community-release-el7-10.noarch.rpm
# 安装MySQL服务器
yum -y install mysql-community-server
# 启动MySQL
systemctl start  mysqld.service
# 查看MySQL运行状态，运行状态如下：
[root@localhost nginx]# systemctl status  mysqld.service
● mysqld.service - MySQL Server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2021-01-20 14:12:25 CST; 19s ago
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
  Process: 49154 ExecStart=/usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid $MYSQLD_OPTS (code=exited, status=0/SUCCESS)
  Process: 49105 ExecStartPre=/usr/bin/mysqld_pre_systemd (code=exited, status=0/SUCCESS)
 Main PID: 49157 (mysqld)
   CGroup: /system.slice/mysqld.service
           └─49157 /usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid

Jan 20 14:12:21 localhost.localdomain systemd[1]: Starting MySQL Server...
Jan 20 14:12:25 localhost.localdomain systemd[1]: Started MySQL Server.
```

#### 修改mysql密码

```shell
# 进入MySQL还得先找出此时root用户的密码，通过如下命令可以在日志文件中找出密码：
[root@localhost nginx]# grep "password" /var/log/mysqld.log
2021-01-20T06:12:22.675466Z 1 [Note] A temporary password is generated for root@localhost: /uj:,sjqi6jP
# 命令进入数据库：
mysql -uroot -p
# 输入初始密码（是上面图片最后面的 no;e!5>>alfg），此时不能做任何事情，因为MySQL默认必须修改密码之后才能操作数据库：
ALTER USER 'root'@'localhost' IDENTIFIED BY 'v492p4!cK@CN';
# 其中‘new password’替换成你要设置的密码，注意:密码设置必须要大小写字母数字和特殊符号（,/';:等）,不然不能配置成功
# 如果要修改为root这样的弱密码，需要进行以下配置：
    # 查看密码策略
    show variables like '%password%';
    # 修改密码策略
    vi /etc/my.cnf
    # 添加validate_password_policy配置
    # 选择0（LOW），1（MEDIUM），2（STRONG）其中一种，选择2需要提供密码字典文件
    #添加validate_password_policy配置
    validate_password_policy=0
    #关闭密码策略
    validate_password = off
# 重启mysql服务使配置生效
systemctl restart mysqld
# 执行以下命令开启远程访问限制（注意：下面命令开启的IP是 192.168.0.1，如要开启所有的，用%代替IP）：
grant all privileges on *.* to 'root'@'%' identified by 'v492p4!cK@CN' with grant option;
```

#### Redis

```shell
下载源码并解压
yum install gcc gcc-c++
wget http://download.redis.io/releases/redis-5.0.8.tar.gz
tar -zxvf redis-5.0.8.tar.gz
cd redis-5.0.8
编译
make
make PREFIX=/usr/local/redis install
安装
cp redis.conf /usr/local/redis/
cd /usr/local/redis
更改配置
vim redis.conf
	通过:/daemonize 找到指定位置，将no改为yes 
	daemonize no 改为 daemonize yes
启动reids
./bin/redis-server ./redis.conf
查看是否启动成功
ps -ef|grep -i redis
关闭redis
./bin/redis-cli shutdown
执行redis
./bin/redis-cli
127.0.0.1:6379>ping
PONG
```

##### 更改配置

```shell
vim /usr/local/redis/etc/redis.conf

# 修改一下配置
# redis以守护进程的方式运行
# no表示不以守护进程的方式运行(会占用一个终端)  
daemonize yes

# 客户端闲置多长时间后断开连接，默认为0关闭此功能                                      
timeout 300

# 设置redis日志级别，默认级别：notice                    
loglevel verbose

# 设置日志文件的输出方式,如果以守护进程的方式运行redis 默认:"" 
# 并且日志输出设置为stdout,那么日志信息就输出到/dev/null里面去了 
logfile stdout
# 设置密码授权
requirepass <设置密码>
# 监听ip
bind 127.0.0.1 
```

##### 配置环境变量

```shell
vim /etc/profile
export PATH="$PATH:/usr/local/redis/bin"
# 保存退出
# 让环境变量立即生效
source /etc/profile
# 配置用户权限

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;

修改权限。%表示针对所有IP，password表示将用这个密码登录root用户，如果想只让某个IP段的主机连接，可以修改为

GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.100.%' IDENTIFIED BY 'my-new-password' WITH GRANT OPTION;
```

### 防火墙

```
systemctl status firewalld.service
systemctl stop firewalld.service  
```




# CentOS7安装PHP7

### Centos安装PHP7

#### 查看yum源中有没有php7.x

yum search php7

#### 由于linux的yum源不存在php7.x，所以我们要更改yum源：

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

#### yum 安装php72w和各种拓展，选自己需要的即可:

yum  -y install php72w php72w-cli php72w-common php72w-devel php72w-embedded  php72w-fpm php72w-gd php72w-mbstring php72w-mysqlnd php72w-opcache  php72w-pdo php72w-xml

#### 查看php版本

php -v

#### 配置php.ini

vi /etc/php.ini 按下esc进入命令模式



### CentOS7升级PHP7 完全详细教程

1. CentOS7的默认PHP版本是PHP5，但是如果我们要安装PHP7，不需要将现有的PHP5删除，只要将PHP升级到PHP7即可。

使用 yum provides php 命令可以获取CentOS7的PHP包安装情况。显示的是在现有的安装源中能够安装的最新版本为：php-5.4.16-46.el7.x86_64

2. 在安装PHP7之前，建议先升级更新一下CentOS7的安装包：

yum -y update ：升级所有软件包的同时也升级软件和系统内核；

yum -y upgrade ：只是升级所有软件包，但是不升级软件和系统内核。

我们这里使用第二条：yum -y upgrade 进行升级。

完成后，重启httpd： systemctl restart httpd.service ：重启httpd。

使用： index.php + phpinfo() : 测试，没有php信息页面展示，说明还需要进行php配置。

3. 使用： yum remove php-common -y ：移除CentOS7 已安装的php-common，以便安装新的php-common。此步删除了CentOS原有的php5。

4. 因为linux的yum源不存在php7.x，所以我们首先要更改yum源：

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

执行上述命令后，使用： php -v ：显示

-bash: php: command not found ： 说明还需要继续配置php7。

5. 使用： sudo yum list php* ： 查看目前能够安装的PHP版本（最新版）。

可以看到可安装的PHP最新版为：php72w。

6. 安装php72w: sudo yum -y install php72w : 。

执行上述命令后，使用： php -v ：显示

-bash: php: command not found ：

虽然没有显示PHP7安装成功后的版本信息，但是此时已经成功安装了php72w，需要重启httpd服务器，以使得新安装的php72w生效运作。

7. 完成后，使用： systemctl restart httpd.service ：重启httpd。

使用浏览器： index.php + phpinfo() : 测试，出现php信息页面展示，说明httpd已经初步完好配置了 php72w。

8. 然后，为了解决使用： php -v : 命令不显示php72w版本的问题，以及使得php72w更加强健，我们建议安装 php72 拓展：

拓展安装1：

yum install php72w-common php72w-fpm php72w-opcache php72w-gd  php72w-mysqlnd php72w-mbstring php72w-pecl-redis php72w-pecl-memcached  php72w-devel

```shell
上述命令一共会安装30个拓展包，安装过程较慢，请耐心等待。。。
安装的拓展包如下：
php-api, php-bz2, php-calendar, php-ctype, php-curl, php-date, php-exif, php-fileinfo, php-filter, php-ftp, php-gettext, php-gmp, php-hash, php-iconv, php-json, php-libxml, php-openssl, php-pcre, php-pecl-Fileinfo, php-pecl-phar, php-pecl-zip, php-reflection, php-session, php-shmop, php-simplexml, php-sockets, php-spl, php-tokenizer, php-zend-abi, php-zip, php-zlib

执行上述命令后，使用：   php -v   ：显示：   PHP 7.2.16 (cli)   ： 说明php72w开发环境基本安装完成。
```

9. 为了进一步强大php72w的开发环境，建议输入以下命令, 以安装php72w更加全面的拓展包：

```shell
安装包			                                提供的拓展
php72w			                           mod_php	, php72w-zts
php72w-bcmath		
php72w-cli		                           php-cgi, php-pcntl, php-readline
php72w-dba		
php72w-devel		
php72w-embedded		                   php-embedded-devel
php72w-enchant		
php72w-fpm		
php72w-gd		
php72w-imap		
php72w-interbase		                     php_database, php-firebird
php72w-intl		
php72w-ldap		
php72w-mbstring		
php72w-mcrypt		
php72w-mysql		                         php-mysqli, php_database
php72w-mysqlnd		                     php-mysqli, php_database
php72w-odbc		                         php-pdo_odbc, php_database
php72w-opcache		                     php72w-pecl-zendopcache
php72w-pdo		                        php72w-pdo_sqlite, php72w-sqlite3
php72w-pdo_dblib		                     php72w-mssql
php72w-pear		
php72w-pecl-apcu	
php72w-pecl-imagick	
php72w-pecl-memcached	
php72w-pecl-mongodb	
php72w-pecl-redis	
php72w-pecl-xdebug	
php72w-pgsql		                      php-pdo_pgsql, php_database
php72w-phpdbg		
php72w-process		        php-posix, php-sysvmsg, php-sysvsem, php-sysvshm
php72w-pspell		
php72w-recode		
php72w-snmp		
php72w-soap		
php72w-tidy		
php72w-xml		                    php-dom, php-domxml, php-wddx, php-xsl
php72w-xmlrpc
```

以上各个拓展包都是类似地使用： yum install php72w-xml ： 命令进行安装。
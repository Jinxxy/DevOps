# 配置文件

```shell
# nginx配置文件主要分为六个区域:核心区域
main(全局设置)作用域是全局
events(nginx工作模式)
http(http设置)
	upstream(负载均衡服务器设置)
		server(主机设置)
   			location(URL匹配)
```

![nginx.conf配置](Nginx模块.assets/image-20210514151819823.png)

> nginx.conf

```shell
# 指定用户
user root;
# 指定线程数(核心数2倍)
worker_processes 8;
# 日志记录
error_log logs/error.log;
# 进程id
pid logs/nginx.pid;




```



# 核心模块

## HTTP 模块

http模块负责HTTP服务器相关属性的配置，有server和upstream两个子模块

http {
include:来用设定文件的mime类型,类型在配置文件目录下的mime.type文件定义，来告诉nginx来识别文件类型。

default .tyvpe:设定了默认的类型为二进制流，也就是当文件类型未定义时使用这种方式，例如在没有配置asp的locate环境时，Nginx是不予解析的，此时，用浏览器访问asp文件就会出现下载了。
log_format:用于设置日志的格式，和记录哪些参数，这里设置为main，刚好用于access_log来纪录这种类型。

## EVENT 模块



## MAIL 模块



# 基础模块

HTTP Access 模块、HTTP FastCGI 模块、HTTP Proxy 模块和 HTTP Rewrite 模块



# 第三方模块

HTTP Upstream Request Hash 模块、Notice 模块和 HTTP Access Key 模块及用户自己开发的模块
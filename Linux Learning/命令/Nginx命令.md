# Nginx Web
### 使用重定向、管道和 sed 来处理一下输出。
    $ nginx -V 2>&1 | sed 's/ /\n/g'
> 2>&1 的作用是把标准错误的输出重定向到标准输出（其文件描述符为 1），管道 | 将上一步命令 nginx -V 2>&1 传递给 sed 进行处理。处理的方式为 s/ /\n/g，它是一个正则表达式，其含义为将空白替换为换行输出。使输出变得易读。
### 查看默认配置文件。
    $ cat /etc/nginx/nginx.conf ---常规
    $ cat /etc/nginx/nginx.conf | grep -vE "#|^$"
> grep 去除了带 # 的行和 ^$ （即空白行）。使输出变得易读。
***
### server配置块
    $ cd /etc/nginx/sites-enabled/
    $ cat ./default | grep -vE "#|^$"
配置含义

    # 虚拟主机的配置
    server {
        # 侦听 80 端口，分别配置了 IPv4 和 IPv6
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;

        # 定义服务器的默认网站根目录位置
        root /usr/share/nginx/html;

        # 定义主页的文件名
        index index.html index.htm;

        # 定义虚拟服务器的名称
        server_name localhost;

        # location 块
        location / {
            try_files $uri $uri/ =404;
        }
    }
> 在配置文件中可以看到，如果我们想修改 Server 的端口为 8080，那么就可以修改 listen 80 为 listen 8080。访问网站的时候应该是 网站:8080，其中 :8080 表示访问 8080 端口。如果是 80 端口，可以省略不写。如果我们想更改网站文件存放的位置，修改 root 就可以了。
***
### location配置块
> location 用于匹配请求的 URI。
URI 表示的是访问路径，除域名和协议以外的内容，比如说我访问了 https://www.shiyanlou.com/louplus/linux，https:// 是协议，www.shiyanlou.com 是域名，/louplus/linux 是 URI。
>> location 匹配的方式有多种：1.精准匹配
2.忽略大小写的正则匹配
3.大小写敏感的正则匹配
4.前半部分匹配

    location [ = | ~ | ~* | ^~ ] pattern {
    #    ......
    #    ......
    }
#### location实例
    location = / {
        # [ 配置 A ]
    }   
    // 当访问 www.shiyanlou.com 时，请求访问的是 /，所以将与配置 A 匹配；
    location / {
        # [ 配置 B ]
    }
    // 当访问 www.shiyanlou.com/test.html 时，请求将与配置 B 匹配；
    location /documents/ {
        # [ 配置 C ]
    }
    // 当访问 www.shiyanlou.com/documents/document.html 时，请求将匹配配置 C;
    location ^~ /images/ {
        # [ 配置 D ]
    }
    // 当访问 www.shiyanlou.com/images/1.gif 请求将匹配配置 D；
    location ~* \.(gif|jpg|jpeg)$ {
        # [ 配置 E ]
    }
    // 当访问 www.shiyanlou.com/docs/1.jpg 请求将匹配配置 E。
> 在 location 中处理请求的方式有很多，如上文中的 try_files $uri $uri/ =404;，它是一种特别常用的写法。
我们来分析一下 try_files $uri $uri/ =404;。这里假设我定义的 root 为 /usr/share/nginx/html/，访问的 URI 是 /hello/shiyanlou。
> - 第一步：当 URI 被匹配后，会先查找 /usr/share/nginx/html//hello/shiyanlou 这个文件是否存在，如果存在则返回，不存在进入下一步。
> - 第二步：查找 /usr/share/nginx/html//hello/shiyanlou/ 目录是否存在，如果存在，按 index 指定的文件名进行查找，比如 index.html，如果存在则返回，不存在就进入下一步。
> - 第三步：返回 404 Not Found。
### 创建虚拟服务器

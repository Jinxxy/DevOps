#!/bin/bash
# auto install lnmp web
# by Johnny Jin

# Install Nginx Web
yum install -y wget gzip tar make gcc
yum install -y pcre pcre-devel zlib zlib-devel
wget -c http://nginx.org/download/nginx-1.16.0.tar.gz
tar -xzf nginx-1.16.0.tar.gz
cd nginx-1.16.0
useradd -s /sbin/nologin www -M
./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-http_realip_module    # 编译时添加的一些模块
make && make install
/usr/local/nginx/sbin/nginx
ps -ef | grep nginx 
setenforce 0
firewall-cmd --add-port=80/tcp --permanent
systemctl reload firewalld.service
iptables -t filter -A INPUT -m tcp -p tcp --dport 80 -j ACCEPT

# Install MySQL 



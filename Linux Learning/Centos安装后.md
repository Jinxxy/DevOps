```shell
安装好Centos后，需要做的几件事情。
1、定义习惯用的别名
vim .bashrc
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias yy='yum install -y'
2、修改网卡信息,配置固定ip
vim /etc/sysconfig/network-scripts/ifcfg-ens33
PREFIX=24
BOOTPROTO=static
IPADDR=192.168.245.7
NAME=ens33
DEVICE=ens33
ONBOOT=yes
3、修改ssh协议默认端口
vim /etc/ssh/sshd_config
#Port 22
Port 10086 # 修改默认端口
systemctl restart sshd.service
4、安装命令自动补全工具
yum install bash-completion -y
5、安装上传下载工具
yum install lrzsz -y
6、安装防火墙
yum install firewalld
systemctl start firewalld
7、最小化安装后安装基础命令包和开发工具
yum install gcc gcc-c++ glibc-devel pcre pcre-devel openssl openssl-devel systemd-devel net-tools vim iotop bc zip unzip zlib-devel lrzsz tree screen lsof tcpdump wget ntpdate bash-completion -y
8、 更新、更新、每天更新、每天自动更新

手动更新所有预先安装的软件：
#yum -y update

跟着设定系统定时自动更新
安装cron：
#yum -y install yum-cron
#vim /etc/yum/yum-cron.conf，
查找：apply_updates = no 修改为：apply_updates = yes
启动服务：
#systemctl start crond systemctl start yum-cron

```

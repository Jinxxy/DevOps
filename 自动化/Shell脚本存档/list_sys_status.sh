#!/bin/bash
#
#********************************************************************
#Author:        Johnny Jin
#QQ:            315181356
#Date:          2021-07-07
#FileName：     list_sys_status.sh
#显示系统使用的以下信息：主机名、IP地址、子网掩码、网关、DNS服务器IP地址信息
#********************************************************************
IP=`ifconfig eth0 | head -2 | tail -1 | awk '{print $2}' | awk -F":" '{print $2}'`
ZW=` ifconfig eth0 | head -2 | tail -1 | awk '{print $3}' | awk -F":" '{print $2}'`
GW=`route -n | tail -1 | awk '{print $2}'`
HN=`hostname`
DNS=`head -1 /etc/resolv.conf | awk '{print $2}'`
echo '此机IP地址是' $IP
echo '此机子网掩码是' $ZW
echo '此机网关是' $GW
echo '此机主机名是' $HN
echo '此机DNS是' $DNS

#!/bin/bash
#
#********************************************************************
#Author:        Johnny Jin
#QQ:            315181356
#Date:          2020-02-12
#FileName：     get hostname.sh
#查找80端口请求数最高的前20个IP地址，判断中间最小的请求数是否大于500，如大于500，则输出系统活动情况报告到alert.txt，如果没有，则在600s后重试，直到有输出为止。
#********************************************************************
state="true"

while $state
do
    SMALL_REQUESTS=$(netstat -ant | awk -F'[ :]+' '/:22/{count[$4]++} END {for(ip in count) print count[ip]}' | sort -n | head -20 | head -1)
    if [ "$SMALL_REQUESTS" -gt 500 ];then
        sar -A > alert.txt
        state="false"
    else
        sleep 6
        continue
    fi
done
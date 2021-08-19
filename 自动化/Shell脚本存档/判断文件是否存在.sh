#!/bin/bash
#
#********************************************************************
#Author:        Johnny Jin
#QQ:            315181356
#Date:          2020-02-12
#FileName：     get hostname.sh
#判断目录 /tmp/jstack 是否存在，不存在则新建一个目录，若存在则删除目录下所有内容。
#每隔1小时打印inceptor server的jstack信息，并以jstack_${当前时间}命名文件，每当目录下超过10个文件后，删除最旧的文件。

#********************************************************************
DIRPATH='/tmp/jstack'
CURRENT_TIME=$(date +'%F'-'%H:%M:%S')

if [ ! -d "$DIRPATH" ];then
    mkdir "$DIRPATH"
else
    rm -rf "$DIRPATH"/*
fi

cd "$DIRPATH"

while true
do
    sleep 3600
    # 这里需要将inceptor改后自己的java进程名称
    pid=$(ps -ef | grep 'inceptor' | grep -v grep | awk '{print $2}')
    jstack $pid >> "jstack_${CURRENT_TIME}"
    dir_count=$(ls | wc -l)
    if [ "$dir_count" -gt 10 ];then
       rm -f $(ls -tr | head -1)
    fi
done
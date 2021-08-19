#!/bin/bash
#
#********************************************************************
#Author:        Johnny Jin
#QQ:            315181356
#Date:          2020-02-12
#FileName：     get hostname.sh
#将当前目录下大于 10K 的文件转移到 /tmp 目录，再按照文件大小顺序，从大到小输出文件名。
#********************************************************************
# 目标目录
DIRPATH='/tmp'
# 查看目录
FILEPATH='.'

find "$FILEPATH" -size +10k -type f | xargs -i mv {} "$DIRPATH"
ls -lS "$DIRPATH" | awk '{if(NR>1) print $NF}'
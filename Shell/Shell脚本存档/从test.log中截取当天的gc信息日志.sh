#!/bin/bash
#
#********************************************************************
#Author:        Johnny Jin
#QQ:            315181356
#Date:          2020-02-12
#FileName：     get hostname.sh
#从test.log中截取当天的所有gc信息日志，并统计gc时间的平均值和时长最长的时间。
#********************************************************************
awk '{print $2}' hive-server2.log | tr -d ':' | awk '{sum+=$1} END {print "avg: ", sum/NR}' >>capture_hive_log.log
awk '{print $2}' hive-server2.log | tr -d ':' | awk '{max = 0} {if ($1+0 > max+0) max=$1} END {print "Max: ", max}'>>capture_hive_log.log
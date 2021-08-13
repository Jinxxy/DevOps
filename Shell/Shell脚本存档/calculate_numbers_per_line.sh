#!/bin/bash
#
#********************************************************************
#Author:        Johnny Jin
#QQ:            315181356
#Date:          2021-08-05
#FileName：     calculate_numbers_per_line.sh
#计算文档每行出现的数字个数，并计算整个文档的数字总数
#********************************************************************
#使用awk只输出文档行数（截取第一段）
n=`wc -l a.txt|awk '{print $1}'`
sum=0
#文档中每一行可能存在空格，因此不能直接用文档内容进行遍历
for i in `seq 1 $n`
do
#输出的行用变量表示时，需要用双引号
line=`sed -n "$i"p a.txt`
#wc -L选项，统计最长行的长度
n_n=`echo $line|sed s'/[^0-9]//'g|wc -L`
echo $n_n
sum=$[$sum+$n_n]
done
echo "sum:$sum"

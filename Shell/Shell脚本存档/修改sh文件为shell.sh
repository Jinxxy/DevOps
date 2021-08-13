#!/bin/bash
#
#********************************************************************
#Author:        Johnny Jin
#QQ:            315181356
#Date:          2020-02-12
#FileName：     get hostname.sh
#把当前目录（包含子目录）下所有后缀为 ".sh" 的文件后缀变更为 ".shell"，之后删除每个文件的第二行。
#********************************************************************
ALL_SH_FILE=$(find . -type f -name "*.sh")
for file in ${ALL_SH_FILE[*]}
do
    filename=$(echo $file | awk -F'.sh' '{print $1}')
    new_filename="${filename}.shell"
    mv "$file" "$new_filename"
    sed -i '2d' "$new_filename"
done
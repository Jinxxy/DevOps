# linux中使用corntab和shell脚本自动备份nginx日志,按天备份

```shell
#!/bin/sh
# 备份nginx日志到指定目录,以年月日格式命名
 
 
# ngingx目录和需要备份的日志名称
NG_DIR=/usr/local/nginx
NG_LOG_NAME=host.access.log
 
# ng日志目录和备份存放目录
NG_LOG_DIR=$NG_DIR/logs
NG_BAK_PATH=$NG_DIR/baklogs
 
# 需要备份文件名与备份之后的文件名
NG_LOG_FILE=$NG_LOG_DIR/$NG_LOG_NAME
# 此处date命令需要使用反斜杠``
BAK_TIME=`date -d yesterday +%Y%m%d`
BAK_LOG_FILE=$NG_BAK_PATH/$BAK_TIME-$NG_LOG_NAME
 
echo $BAK_LOG_FILE
 
# 备份,停止后再重启
$NG_DIR/sbin/nginx -s stop
 
mv $NG_LOG_FILE $BAK_LOG_FILE
 
$NG_DIR/sbin/nginx
```

# 编写定时任务

`0 3 * * * sh /usr/local/nginx/sbin/baklog.sh # 每天半夜三点执行!!`
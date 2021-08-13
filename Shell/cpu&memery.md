# 当cpu占用超过95%同时60s间隔内httpd的 pid相同时候 则杀死该pid

```shell
#!/bin/sh
# qiyulin to monitor used CPU
record=0
while true;
do
cpu=$(top -b -n1 | grep "httpd" | head -1 | awk '{print $9}')
pid=$(top -b -n1 | grep "httpd" | head -1 | awk '{print $1}')
#cpu check
result=${cpu/.*}
if [[ $record == $pid ]];then kill -9 $pid;echo "$pid was killed";fi
if [[ $result > 95 || $result == 100 ]];then let record=${pid};else let record=0;fi
#echo
echo `date +%F" "%H:%M:%S`+" cpu:$result% record pid:$record pid:$pid"
sleep 60
done
```
# 当内存超过95%时重启httpd

```shell
#!/bin/sh
# qiyulin to monitor used CPU
record=0
while true;
do
cpu=$(top -b -n1 | grep "httpd" | head -1 | awk '{print $9}')
pid=$(top -b -n1 | grep "httpd" | head -1 | awk '{print $1}')
#cpu check
result=${cpu/.*}
if [[ $record == $pid ]];then kill -9 $pid;echo "$pid was killed";fi
if [[ $result > 95 || $result == 100 ]];then let record=${pid};else let record=0;fi
#mem check
mem=$(free -m | awk 'NR==2 {print $3}')
if [[ $mem > 3638 ]];then apache-restart;echo "$mem is out 95%,so the httpd restart";fi
#echo
echo `date +%F" "%H:%M:%S`+" cpu:$result% record pid:$record pid:$pid mem:$mem"
sleep 60
done
```

# 现在每隔3秒对电脑的cpu和内存使用情况进行检测，内存使用率或cpu使用率超过90%给出警告

```shell
echo "开始监控电脑cpu和内存使用情况:"

#循环执行
while true
do

#总内存
total=`expr 1024 \* 8`
echo -e "\n\n你的mac内存总共$total M"

#使用内存
useds=$(top | head -n 10 | grep PhysMem | awk '{print $2}')
#截取去掉M
used=${useds%*M}
#求百分比
percent=$(printf "%d" $((used*100/total)))
#做出判断，输出结果
echo "已使用$used M,占比$percent %"
if [ $percent -gt 90 ]
then
    echo '卧槽，内存快爆炸了,电脑不行了....'
else
    echo '你的内存还算正常，可以放心使用^.^'
fi

#cpu变量
user_cpu=$(top | head  -n 10 | grep CPU | awk '{print $3}')
syst_cpu=$(top | head  -n 10 | grep CPU | awk '{print $5}')
user_cpu=${user_cpu%*%}
syst_cpu=${syst_cpu%*%}
cpu_percent=$(echo "$user_cpu+$syst_cpu"|bc)
echo -e "\n\nCpu用户使用率$user_cpu %"
echo "Cpu系统使用$syst_cpu %"
echo "Cpu使用率$cpu_percent %"
if [ $(echo "$cpu_percent >= 90"|bc) = 1 ]
then
    echo '卧槽，CPU要崩溃了....'
else
    echo '你的cpu还能工作，可以放心使用^.^'
fi
sleep 3
done
```

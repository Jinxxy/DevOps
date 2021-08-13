#!/bin/bash
mydate=`date +%Y%m%d_%H%M%S`
myhomedir="/dydata/pro_deliveryFoodSendOrderTask"
mylogdir="${myhomedir}/logs"
ps axf -o "pid %cpu" | awk '{if($2>=3.0) print $1}' | while read procid
do
kill -9 $procid
sleep 10
[ ! -d $mylogdir ] && mkdir $mylogdir
cd ${myhomedir}
nohup dotnet ./FoodOrderTask.dll >>${mylogdir}/start_${mydate}.log 2>&1 &
done

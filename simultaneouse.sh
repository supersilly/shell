#!/bin/bash
#for i in $(ps -ef | grep lx | grep -v grep | awk '{print $2}');do kill 9 $i;done
for i in $(seq 20)
do
  w_cnt=$(ps -ef | grep ping | grep -v grep | wc -l)
  while true;
    do
      w_cnt=$(ps -ef | grep ping | grep -v grep | wc -l)
      if [ $w_cnt -lt 5 ]; then
        echo "the times is ${w_cnt},begin to work..."
        break
      else
        echo "the times is ${w_cnt},sleep 1s ..."
        sleep 1
      fi
    done
  da=$(date +%H%M%S)
  echo "the task is ${i},the date is ${da}..."
  ping -c $((${RANDOM}%5+5)) www.baidu.com >>test${i}.txt 2>&1 &
done
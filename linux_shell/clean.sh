#!/bin/bash
set -x
#elean tomcat log
ln=30
#zip inv_server3 data bf_in bak,and clean it
for bf_in_s in `find /data/invdata/BF_IN/S/WORK/OUT/BAK/ -mindepth 1 -type d -mtime +30 -printf "%P\n"`; 
do 
  while true;
  do 
    w_cnt=`ps -ef | grep --color  "tar -czvf" | grep -v grep | wc -l`
      if [ $w_cnt -lt $ln ]; then
        echo "the times is ${w_cnt},begin to work..."
        break
      else
        echo "the times is ${w_cnt},sleep 1s ..."
        sleep 1
      fi
  done
  (cd /data/invdata/BF_IN/S/WORK/OUT/BAK && tar -czvf ${bf_in_s}.tar.gz ${bf_in_s} && rm -rf ${bf_in_s}) >/dev/null 2>&1 &
done

#zip inv_server3 data batchdown,and clean it
for b_d in `find /data/invdata/BatchDown -mindepth 1 -maxdepth 1 -type d -mtime +30 -printf "%P\n"`; 
do 
  while true;
  do
    w_cnt=`ps -ef | grep --color  "tar -czvf" | grep -v grep | wc -l`
      if [ $w_cnt -lt $ln ]; then
        echo "the times is ${w_cnt},begin to work..."
        break
      else
        echo "the times is ${w_cnt},sleep 1s ..."
        sleep 1
      fi
  done
  (cd /data/invdata/BatchDown && tar -czvf ${b_d}.tar.gz ${b_d} && rm -rf ${b_d}) >/dev/null 2>&1 &
done

#zip inv_server3 data dkdetail,and clean it
for b_dk in `find /data/invdata/DKDetail -mindepth 1 -maxdepth 1 -type d -mtime +30 -printf "%P\n"`; 
do 
  while true;
  do
    w_cnt=`ps -ef | grep --color  "tar -czvf" | grep -v grep | wc -l`
      if [ $w_cnt -lt $ln ]; then
        echo "the times is ${w_cnt},begin to work..."
        break
      else
        echo "the times is ${w_cnt},sleep 1s ..."
        sleep 1
      fi
  done
  (cd /data/invdata/DKDetail && tar -czvf ${b_dk}.tar.gz ${b_dk} && rm -rf ${b_dk}) >/dev/null 2>&1 & 
done

#clean inv_server3/4 excel file
#rm -rf /home/boss/inv_server3/webapps/fpcj/upload/excelUpload/Invoice*/*.xls

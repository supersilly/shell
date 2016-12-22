#!/bin/bash
rm -rf 20000_result 
rm -rf 20000_statistic
for i in $(cat 20000_imei_real)
do
  echo "---------------${i}----------------">>20000_result;
  echo "---------------${i}----------------">>20000_statistic;

  echo "st_${i}">>20000_result;
  echo "st_${i}">>20000_statistic;
  echo "c_pull c_pull_succ c_time c_show imei imei_real op_banner op_inter op_nativ op_splash date">>20000_result;
  echo "c_pull_succ c_show op_nativ">>20000_statistic;
#  cat dspst202040020000_1205.csv | grep $i >>20000_result;
  cat 20000_st | grep $i >>20000_result;
  cat 20000_st | grep $i | awk -F" " '{print $2,$4,$9}' >>20000_statistic;

  echo "adsucc_${i}">>20000_result;
#  echo "adsucc_${i}">>20000_statistic;
  echo "ad_type_id,adtype,p_id,ckey,fver,imei,imei_real,date,time,error">>20000_result;
  cat 20000_adsuc | grep $i >>20000_result;
  suc=$(cat 20000_adsuc | grep $i | wc -l)

  echo "adfail_${i}">>20000_result;
#  echo "adfail_${i}">>20000_statistic;
  echo "ad_type_id,adtype,p_id,ckey,fver,imei,imei_real,date,time,error">>20000_result;
  cat 20000_adfai | grep $i >>20000_result;
  fail=$(cat 20000_adfai | grep $i | wc -l)

  echo "op_${i}">>20000_result;
#  echo "op_${i}">>20000_statistic;
  echo "ad_source,fver,ckey,imei,imei_real,date,time">>20000_result;
  cat 20000_op | grep $i >>20000_result;
  op=$(cat 20000_op | grep $i | wc -l)
  ((app_pull=${suc}+${fail}))
  echo "pullandshow: ${app_pull} ${op}">>20000_statistic
done
for i in $(cat dspst_08ok1.csv | cut -d" " -f 3 | sort | uniq); do if [ ${#i} -eq 10 ]; then  tt=`date -d @"$i" +%Y%m%d`; echo $tt; sed -i s/$i/$tt/g dspst_08ok1.csv1;fi; done

#!/bin/bash
c_date=$(date +%Y%m%d_%H%M)
cd /data/mongodb/bin
case $1 in
  dspcl)
    ./mongoexport -d dspmsg -c dspcl  -f ad_source,bid,brand,ckey,clickid,imei,ip,isp,mac,model,net,pos,ver,date,cl_time  --type=csv -o dspcl${c_date}.csv
    ;;
  dspthirdad)
    ./mongoexport -d dspmsg -c dspthirdad  -f imei,ckey,adtype,date,addtime  --type=csv -o dspthirdad${c_date}.csv
    ;;
  dspop)
    ./mongoexport -d dspmsg -c dspop -q '{"ckey": "202040010200"}' -f imei,imsi,model,mac,net,pos,ckey,bid,obid,fver,isp,ad_source,ip,brand,date,op_time,policy_id  --type=csv -o dspop${c_date}.csv
    ;;
  dspst)
    ./mongoexport -d dspmsg -c dspst  -f imei,ckey,addtime,date,ip  --type=csv -o dspst${c_date}.csv
    ;;
  dspactivate)
    ./mongoexport -d dspmsg -c dspactivate  -f imei,ckey,addtime,date  --type=csv -o dspactivate${c_date}.csv
    ;;
  dspdayactive)
    ./mongoexport -d dspmsg -c dspdayactive -q '{"bid": "com.aliyun.homeshell","adddate": "20161017"}' -f bid,imei,ckey,model,net,ip,adddate,addtime,fver  --type=csv -o dspdayactive${c_date}.csv
    ;;
  dspdayactiveret)
    ./mongoexport -d dspmsg -c dspdayactiveret202040040100 -q '{"bid": "com.aliyun.homeshell","adddate": "20161020"}' -f bid,imei,ckey,model,net,ip,adddate,addtime,fver,error  --type=csv -o dspdayactiveret_${c_date}.csv
    ;;
  *)
    echo "you have to use the param   dspcl dspthridad dspop dspst dspactivate dspdayactive dspdayactiveret"
    ;;
esac

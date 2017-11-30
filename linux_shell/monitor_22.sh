#/bin/bash
#set -x
source /etc/profile
#echo $(pwd)
dir="/home/boss/monitor/"
if [ ! -d "$dir" ]; then
  echo "cannot find monitor dir...exit"
  exit 0
fi
cd ${dir}
if [ ! -d "log" ]; then
  mkdir log
fi
log="${dir}log/monitor.log"
#text="${dir}listentext.txt"
webfile="${dir}webs.txt"
time_out=10
retry_times=3
sleep_time=5
key1="dktjMxDownloadQxrzSbqrxx"
key2="SYSTIME"
rm -rf ${dir}listen*
if [ ! -f "${webfile}" ]; then
  echo "can not find webs to listen...,exit"
  exit 0
fi

function web_check {
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo ${da}" check ${1}"
  get_va=`curl -s -k --connect-timeout ${time_out} -m ${time_out} ${1} | egrep -i "${key1}|${key2}" | wc -l`
  if [[ ${get_va} -ne "0" ]]; then
    da=$(date '+%Y-%m-%d %H:%M:%S')
    echo "${da} success: website ${1} is OK!"
    echo "${da} success: website ${1} is OK!" >>$log
  else
    da=$(date '+%Y-%m-%d %H:%M:%S')
#    echo ${da}" failed: website ${1} is down!"
    echo ${da}" failed: website ${1} will retry!" >>$log
#    echo ${da}" failed: website ${1} will retry!" >>$text
    echo "${1}">>${dir}listen_retry
  fi
}
echo "------------------------------------------------------------------------------">>$log
webs=`cat webs.txt`
for we in ${webs[@]}
do
{
  web_check ${we}
}&
done
wait
echo ""
echo "">>$log

if [ -f ${dir}listen_retry ]; then
  for ((i=1;i<${retry_times};i++))
  do
    if [ -f ${dir}listen_retry ]; then
      echo "retry ${i}"
      echo "retry ${i}">>$log
      lr=`cat listen_retry`
      if [[ "${lr}" =~ "http" ]]; then
        echo "retry $i..."
        mv ${dir}listen_retry ${dir}listen_retry${i}
        webi=`cat listen_retry${i}`
        for wi in ${webi[@]}
        do
          {
            echo "retry ${wi}"
            echo "retry ${wi}">>$log
            web_check ${wi}
          }&
        done
        wait
        sleep ${sleep_time}
      fi
    fi
  done
fi
if [ -f ${dir}listen_retry ]; then
  echo "follows are failures...."
  echo "follows are failures....">>${log}
  to_restart=`cat ${dir}listen_retry`
  echo "${to_restart}"
  echo "${to_restart}">>${log}
  for sv in 8180 8181 8182 8183 8184 8185 8186 8187 8188 8189
  do
#    echo "server: ${sv}"
    if [[ "${to_restart}" =~ "${sv}" ]]; then
       tn=${sv:0-1:1} 
       echo "tn: ${tn}"
       echo "find ${sv} to be restarted!"
       echo "find ${sv} to be restarted,stop and start it!">>$log
#       /home/boss/${port}_inv${tn}.sh stop
#       /home/boss/${port}_inv${tn}.sh stop
       if [ -f "/home/boss/${sv}.sh" ]; then
          /home/boss/${sv}.sh stop
       else
         echo "cannot find server ${sv} shutdown script,please check it, exit! "
         exit 1;
       fi
       if [  -f "/home/boss/inv_server${tn}/bin/startup.sh" ]; then
         nohup /home/boss/inv_server${tn}/bin/startup.sh >/dev/null 2>&1 &
       else
         echo "cannot find server ${sv} startup script,please check it, exit! "
         exit 1;
       fi
    fi
  done
fi
echo "over"
rm -rf "${dir}"listen*

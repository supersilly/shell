#/bin/bash
set -x
source /etc/profile
para=$1
dir="/root/monitor"
if [ ! -d "$dir" ]; then
  echo "cannot find monitor dir...exit"
  exit 0
fi
cd ${dir}
if [ ! -d "log" ]; then
  mkdir log
fi
log="${dir}log/monitor.log"
web_url="http://47.93.89.8:8180/cyfwpt/ws/GetInvService?wsdl"
key1="getInvForAll"
time_out=30
function web_check {
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo ${da}" check ${1}"
  get_va=`curl -s -k --connect-timeout ${time_out} -m ${time_out} ${1} | egrep -i "${key1}|${key2}" | wc -l`
  if [[ ${get_va} -ne "0" ]]; then
    da=$(date '+%Y-%m-%d %H:%M:%S')
    echo "${da} success: website ${1} is OK!"
	if [ -f monitor_fail ]; then
	   rm -rf monitor_fail && echo ${da}" back OK: website ${1} back to OK!" >>$log 
    fi
  else
    da=$(date '+%Y-%m-%d %H:%M:%S')
    echo ${da}" failed: website ${1} is down!"
	touch monitor_fail && echo ${da}" failed: website ${1} is down!" >>$log
  fi
}
function change_nginx {
case $1 in
    239)
	  if [ -f /etc/nginx/conf.d/8080.conf -a -f /etc/nginx/conf.d/239.conf_bak ]; then  
	    da=$(date '+%Y-%m-%d %H:%M:%S')
        mv /etc/nginx/conf.d/8080.conf /etc/nginx/conf.d/8080.conf_bak
        mv /etc/nginx/conf.d/239.conf_bak /etc/nginx/conf.d/239.conf
        echo ${da}" change nginx to 239"
        service nginx reload
	  else
	  	da=$(date '+%Y-%m-%d %H:%M:%S')
	    echo "nginx no change ...cannot find conf 8080.conf 239.conf_bak file in /etc/nginx/conf" >>$log
	  fi
    ;;
    8)
      if [ -f /etc/nginx/conf.d/8080.conf_bak -a -f /etc/nginx/conf.d/239.conf ]; then  
	    da=$(date '+%Y-%m-%d %H:%M:%S')
        mv /etc/nginx/conf.d/8080.conf_bak /etc/nginx/conf.d/8080.conf
        mv /etc/nginx/conf.d/239.conf /etc/nginx/conf.d/239.conf_bak
        echo ${da}" change nginx to 8" >>$log
        service nginx reload
	  else
	  	da=$(date '+%Y-%m-%d %H:%M:%S')
	    echo "nginx no change ...cannot find conf 8080.conf_bak 239.conf file in /etc/nginx/conf" >>$log
	  fi
    ;;
    *)
	  da=$(date '+%Y-%m-%d %H:%M:%S')
	  echo ${da} "change nginx para error,exit" >>$log
	  exit 1
    ;;
esac
}
if [ ${para} -eq "restart" ]; then
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo "${da} restart 8 tomcat,change nginx to 239..." >>$log   
  change_nginx 239  
  su - boss -s /bin/bash /home/boss/8180.sh restart
else
  #begin check 8180 status
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo "${da} check 8180 tomcat..." >>$log 
  web_check "${web_url}"
fi
exit 0


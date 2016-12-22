#!/bin/bash
c_date=$(date +%Y%m%d_%H%M)
tomcat_dir="/home/boss/tm_server"
start_sh=${tomcat_dir}"/bin/startup.sh"
stop_sh=${tomcat_dir}"/bin/shutdown.sh"
log=${tomcat_dir}"/logs/catalina.out"
function start_tm {
  if [ $(ps -ef | grep java | grep tm_server/bin | grep -v grep | wc -l) -eq '0' ]; then
    nohup $start_sh >/dev/null 2>&1 &
    sleep 1
  else
    echo "The tomcat is already started!"
    exit 0
  fi
  tail -f $log
}

function stop_tm {
  if [ -f conf_nginx/nginx_105 ]; then
    echo "change the server to 105..."
    touch /home/boss/conf_nginx/105
    \cp conf_nginx/nginx_105 /etc/nginx/nginx.conf
    sudo service nginx reload
  fi
  if [ $(ps -ef | grep java | grep tm_server/bin | grep -v grep | wc -l) -eq '1' ]; then
    $stop_sh
  else
    echo "The tomcat is not running!"
    exit 0
  fi
  sleep 2
  if [ $(ps -ef | grep java | grep tm_server/bin | grep -v grep | wc -l) -eq '0' ]; then
    echo "Shutdown the tomcat successfully!"
  else  
    echo "Find tomcat is still running,kill it!"
    ps -ef | grep java | grep tm_server/bin | grep -v grep | awk '{print $2}' | xargs kill -9
  fi
  echo "begin to move the log to a new name"
  mv "$log" $log"_"${c_date}
}

function status_tm {
  echo "The follows:"
  if [ $(ps -ef | grep java | grep tm_server/bin | grep -v grep | wc -l) -eq '0' ]; then
    echo "Tomcat is not running!"
    exit 0
  else
    ps -ef | grep java | grep tm_server/bin | grep -v grep
  fi
}

function restart_tm {
  echo "begin to restart the tomcat!"
  stop_tm
  sleep 2
  start_tm
}
if [ $# -eq 0 ]; then
  tail -f $log
elif [ $# = 1 -a $1 = "start" ]; then
  echo "Begin to start the tomcat ..."
  start_tm
elif [ $# = 1 -a $1 = "stop" ]; then
  echo "Begin to shutdown the tomcat ..."
  stop_tm
elif [ $# = 1 -a $1 = "restart" ]; then
  echo "Begin to restart the tomcat ..."
  restart_tm
elif [ $# = 1 -a $1 = "status" ]; then
  status_tm
elif [ $# = 1 -a $1 = "log" ]; then
  tail -f $log
else
  echo "Your param is wrong!"
  echo "usage:"
  echo "$0 [ start | stop | restart | status | log ]"
  echo "The default param:log"
  exit 1
fi
echo "Finished!"

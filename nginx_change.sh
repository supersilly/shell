#!/bin/bash
#set -x
#if [ ! -f /home/boss/conf_nginx/nginx_104 -o ! -f /home/boss/conf_nginx/nginx_105 ]; then
#  echo "cannot find nginx_conf files,please check it exit!"
#  exit 0
#fi
if [ $# -eq 0 ]; then
  sudo cat /etc/nginx/nginx.conf | sed /#/d | sed /^[[:space:]]*$/d
elif [ $# = 1 -a $1 = "8080" ]; then
  m_date=$(date +%Y%m%d_%H%M)
  echo "Begin to uncomment the nginx 8080 ..."
  sudo \cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf_8080_${m_date}
  sudo sed -i 's/#server 127.0.0.1:8080;/server 127.0.0.1:8080;/g' /etc/nginx/nginx.conf
  sudo service nginx reload
elif [ $# = 1 -a $1 = "8081" ]; then
  m_date=$(date +%Y%m%d_%H%M)
  echo "Begin to uncomment the nginx 8081 ..."
  sudo \cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf_8081_${m_date}
  sudo sed -i 's/#server 127.0.0.1:8081;/server 127.0.0.1:8081;/g' /etc/nginx/nginx.conf
  sudo service nginx reload
elif [ $# = 1 -a $1 = "status" ]; then
  sudo cat /etc/nginx/nginx.conf | sed /#/d | sed /^[[:space:]]*$/d
else
  echo "Your param is wrong!"
  echo "usage:"
  echo "$0 [ 8080 | 8081 | status ]"
  echo "The default param:status"
  exit 1
fi
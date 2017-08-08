#!/bin/bash
c_date=$(date +%Y%m%d_%H%M)
if [ -f nginx_163 -a -f nginx_104 -a -f 104 ]; then
  echo "find nginx_163 and nginx_104!"
  echo ${c_date}
else
  echo "can not find nginx_163 and nginx_104,exit!"
  exit 0
fi
get_va=$(curl --connect-timeout 5 -m 5 127.0.0.1:8161 | grep "保驾")
if [[ $get_va =~ "保驾" ]]; then
  mv "/usr/local/nginx/conf/nginx.conf" "/root/nginx_bak/nginx.conf${c_date}"
  cp nginx_163 /usr/local/nginx/conf/nginx.conf
  rm 104
  touch 163
  service nginx reload
else
  exit 0
fi
#!/bin/bash
m_date=$(date +%Y%m%d_%H%M)
log=auto_nginx_log.txt
web_8080=http://127.0.0.1:8080/1.html
web_8081=http://127.0.0.1:8081/1.html
conten=hello
for web in web_8080 web_8081
do
  if [ -f /home/boss/conf_nginx/${web} ]; then
    da=$(date '+%Y-%m-%d %H:%M:%S')
    echo ${da}" Find the nginx ${web} is commented,check whether the server ${web} is ok.."
    echo ${da}" Find the nginx ${web} is commented,check whether the server ${web} is ok..">>$log
    get_va=$(curl --connect-timeout 10 -m 10 ${web_${web}} | grep "${conten}")
    if [[ $get_va =~ "${conten}" ]]; then
      da=$(date '+%Y-%m-%d %H:%M:%S')
      echo ${da}" server ${web}  is OK now,uncomment the nginx ${web}"
      echo ${da}" server ${web}  is OK now,uncomment the nginx ${web}">>$log
      rm -rf /home/boss/conf_nginx/${web}
      sudo \cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf_${web}_${m_date}
      sudo sed -i 's/#server 127.0.0.1:${web};/server 127.0.0.1:${web};/g' /etc/nginx/nginx.conf
      sudo service nginx reload
    else
      da=$(date '+%Y-%m-%d %H:%M:%S')
      echo ${da}" server ${web} is not OK now,nothing to do!">>$log
      echo ${da}" server ${web} is not OK now,nothing to do!"
    fi
  fi
done
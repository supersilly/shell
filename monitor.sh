#!/bin/bash
#web="http://weixin.100baojia.com" curl http://xm.100baojia.com:11800/ | grep 'languagechange(e1)'
web="http://xm.100baojia.com:11800/"
log=net_status.log
test=net_error.txt
da=$(date '+%Y-%m-%d %H:%M:%S')
echo $da" listening ..." >> $log

function net_check {
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo ${da}" check net status" >> $log
  get_va=$(curl ${web} | grep 'languagechange(e1)')
  if [[ $get_va =~ "languagechange" ]]; then
    da=$(date '+%Y-%m-%d %H:%M:%S')
    echo ${da}" net status is OK!" >> $log
    return 0
  else
    da=$(date '+%Y-%m-%d %H:%M:%S')
    echo ${da}" net status is down!" >> $log
    return 1
  fi
}

#check net status,if ok,exit;else wait 30s,check it again,if ok,exit;if not,check tomcat
net_check
if [ $? -eq '0' ]; then
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo $da" check net status OK,exit" >> $log
  if [ -f net_error ]; then
    echo $da"The status of Lebao network is OK!"
    mail -s 'Dear TangYangyang:Network of Lebao is OK!' tangyangyang@100baojia.com < ${text}
    rm -rf net_error
    rm -rf ${text}
  fi
  exit 0
else
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo $da" check net status failed,wait 30s and will recheck!" >> $log
  sleep 30
  net_check
    if [ $? -eq '0' ]; then
      da=$(date '+%Y-%m-%d %H:%M:%S')
      echo $da" check net status -2 OK,exit" >> $log
      exit 0
    else
      da=$(date '+%Y-%m-%d %H:%M:%S')
      echo $da" check net status -2 failed,wait 30s,and check tomcat!" >> $log
      sleep 30
      net_check
        if [ $? -eq '0' ]; then
          da=$(date '+%Y-%m-%d %H:%M:%S')
          echo $da" check net status -3 OK,exit" >> $log  
          exit 0
        else
          da=$(date '+%Y-%m-%d %H:%M:%S')
          echo ${da}" check net status -3 failed,network is down!" >> $log
		  echo ${da}"The network of Lebao is disconnected now,please check it...IP:[119.253.39.102]" > ${text}
		  if [ ! -f net_error ]; then
		    mail -s 'Dear TangYangyang:Network of Lebao is disconnected!' tangyangyang@100baojia.com < ${text}
			rm -rf ${text}
		    touch net_error
		  else
		    echo ${da}"the mail has been sent,won't send again!" >> $log
		  fi
        fi
    fi
fi
da=$(date '+%Y-%m-%d %H:%M:%S')
echo $da" ----------------------------------------------------------------------------" >> $log

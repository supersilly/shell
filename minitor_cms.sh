#!/bin/bash
arr=($(cat url.txt))
value=($(cat value.txt))
len=${#arr[@]}
log=monitor_mc.log
text=monitor_mc_err.log
is_err=0
da=$(date '+%Y-%m-%d %H:%M:%S')
echo "$da micang is listening ..." >> $log

function url_check {
  if [ -f url.txt -a -f value.txt ]; then
    echo "find url.txt and value.txt!"
  else
    echo "cannot find url.txt or value.txt,exit!"
    exit 0
  fi
}

function web_check {
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo ${da}" check website"
  get_va=$(curl ${2} | grep "${value}")
  if [[ $get_va =~ "${value}" ]]; then
    da=$(date '+%Y-%m-%d %H:%M:%S')
    echo "${da} success: website ${1} ${2} is OK!"
    echo "${da} success: website ${1} ${2} is OK!" >>$log
  else
    da=$(date '+%Y-%m-%d %H:%M:%S')
    echo ${da}" failed: website ${1} ${2} is down!"
    echo ${da}" failed: website ${1} ${2} is down!" >>$log
    echo ${da}" failed: website ${1} ${2} is down!" >>$text
  fi
}

function check_send {
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo ${da}" check whether to send the email"
  echo ${da}" check whether to send the email" >>$log
  if [ -f ${text} ]; then
    echo "find ${text}, and will send the email!"
    is_err=1
  else
    echo "there is no error to send!"
  fi
}

function mail_send {
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo ${da}" begin to send the email" >>$log
  if [ ${is_err} -eq '0' ] ; then
    da=$(date '+%Y-%m-%d %H:%M:%S')
    echo $da" there is no mail to send!"
    echo $da" there is no mail to send!" >>$log
  elif [ ${is_err} -eq '1' ] ; then
    da=$(date '+%Y-%m-%d %H:%M:%S')
    echo $da" find the error,and mail it!"
    echo $da" find the error,and mail it!" >>$log
#    mail -s 'The website is down!' tangyangyang@100baojia.com < ${text}
    mail -s 'Dear TangYangyang:The website is down!' tangyangyang@100baojia.com < ${text}
#    mail -s 'Dear LiuFeifei:The website is down!' liufeifei@imicang.com < ${text}
#    mail -s 'Dear YangQi:The website is down!' yanqi@imicang.com < ${text}
#    mail -s 'Dear LuoXinlin:The website is down!' luoxinlin@imicang.com < ${text}
#    mail -s 'Dear XiangMeng:The website is down!' xiangmeng@100baojia.com < ${text}
#    mail -s 'Dear TangZhi:The website is down!' tangzhi@imicang.com < ${text}
    rm -rf ${text}
  fi
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo $da" OVER!"
  echo $da" OVER!" >>$log
}

url_check
for ((i=0;i<$len;i++))
  do
    eval wx=\${arr[$i]}
    ((i=i+1))
    eval url=\${arr[$i]}
    web_check $wx $url
  done

check_send
mail_send
#!/bin/bash
push_lebao(){
  if [ ! -d /home/boss/tm_server/webapps/lebao ];then
    echo "Cannot find lebao in /home/boss/tm_server/webapps!exit"
    exit 0
  fi
  if [ -d lebao -o -f lebao.tar ];then
    echo "find the old lebao,delete it!"
    rm -rf lebao
    rm -rf lebao.tar
#    rm -rf userfiles
  fi
  echo "begin to copy lebao"
  cp -r /home/boss/tm_server/webapps/lebao lebao
#  mv lebao/userfiles .
  tar -cvf lebao.tar lebao
  if [ -f lebao.tar ];then
    echo "Find lebao.tar!"
    scp -P 2188 lebao.tar boss@192.168.23.105:/home/boss/sync_to104
    rm -rf lebao
    touch tarok.txt
    scp -P 2188 tarok.txt boss@192.168.23.105:/home/boss/sync_to104
    rm -rf lebao.tar
    rm -rf tarok.txt
    echo "SUCCESS!"
  else
    echo "Cannot find lebao.tar in this dir!"
    exit 0
  fi
}
if [ $# -eq 1 ]; then
  if [ ! -f ${1} ];then
    if [ ! -d ${1} ];then
      echo "Cannot find the ${1},exit!"
      exit 0
    fi
  fi
  echo "copy ${1} to 105..."
  scp -P 2188 -r ${1} boss@192.168.23.105:/home/boss/temp
else
  push_lebao
fi

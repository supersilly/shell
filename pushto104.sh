#!/bin/bash
push_lebao(){
  if [ ! -d /home/boss/tm_server/webapps/lebao ];then
    echo "Cannot find lebao in /home/boss/tm_server/webapps!exit"
    exit 0
  fi
  if [ -d lebao -o -f lebao.zip ];then
    echo "find the old lebao or lebao.zip,delete it!"
    rm -rf lebao
    rm -rf lebao.zip
    rm -rf userfiles
  fi
  cp -r /home/boss/tm_server/webapps/lebao lebao
  mv lebao/userfiles .
  zip -r lebao.zip lebao
  if [ -f lebao.zip ];then
    echo "Find lebao.zip!"
    scp -P 2188 lebao.zip boss@192.168.23.104:/home/boss/temp
    rm -rf lebao
    touch zipok.txt
    scp -P 2188 zipok.txt boss@192.168.23.104:/home/boss/temp
   #rm -rf lebao.zip
    echo "SUCCESS!"
  else
    echo "Cannot find lebao.zip in this dir!"
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
  echo "copy ${1} to 104..."
  scp -P 2188 -r ${1} boss@192.168.23.104:/home/boss/temp
else
  push_lebao
fi

#!/bin/bash
size_m=2048
if [ $# -ne 1 ]; then
  echo "you must specified a filedir!"
  exit 0
fi
if [ ! -d ${1} ]; then
  echo "the dir ${1} is not exist,please verify it!"
  exit 0
fi
echo "the dir is $1"
si=$(du -sm ${1} | awk '{print $1}')
echo $si
if [[ $si -gt ${size_m} ]]; then
  echo "there is no enough space to use,you cannot write anything!"
  chmod -w ${1}
else
  echo "there is still some free space left to use!"
  chmod +w ${1}
fi
#!/bin/bash
if [ $# = 1 ]; then
  echo "checking....."
else
  echo "Your param is wrong!"
  echo "usage:"
  echo "$0 param"
  exit 1;
ip=$1
curl -s "http://ip138.com/ips138.asp?ip=${ip}&action=2"| iconv -f gb2312 -t utf-8 | grep -e 'h1\|ul1' | sed /^\.ul1/d | sed 's/\(.*\)<h1>\(.*\)<\/h1>.*/\2/g' |  sed 's/\(.*\)本站数据：\(.*\)<\/li><li>参考数据1.*/\2/g'
echo ""

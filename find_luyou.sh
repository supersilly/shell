#!/bin/bash
for ((i=20;i<200;i++))
do
{
content=$(curl --connect-timeout 1 -m 1 192.168.0.${i} | grep "小米路由器")
echo "the IP is "${i}
if [[ ${content} =~ "小米" ]]; then
  echo "--------------------"
  echo "find ip ${i} have xiaomiluyou!">>xiaomi.txt
fi
}&
done
wait
echo "###########################################"
cat xiaomi.txt
echo "###########################################"

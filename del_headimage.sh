#!/bin/bash
arr=($(cat deljpg.txt))
len=${#arr[@]}
for ((i=0;i<$len;i++))
do
find /home/boss/baojia_server/webapps/lebao/userfiles/headimages/2015* -name "*${arr[$i]}" -exec rm -rf {} \;
done
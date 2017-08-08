#!/bin/bash 
set -x
updir=/root/soft    #要上传的文件夹
todir=123          #目标文件夹
ip=192.168.0.221      #服务器
user=test          #ftp用户名
password=123        #ftp密码
sss=`find $updir -type d -printf $todir/'%P\n'| awk '{if ($0 == "")next;print "mkdir " $0}'`
aaa=`find $updir -type f -printf 'put %p %P \n'`
ftp -nv $ip <<EOF 
user $user $password
type binary 
prompt 
$sss 
cd $todir 
$aaa 
quit 
EOF
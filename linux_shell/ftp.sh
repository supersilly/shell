#!/bin/bash 
set -x
updir=/root/soft    #Ҫ�ϴ����ļ���
todir=123          #Ŀ���ļ���
ip=192.168.0.221      #������
user=test          #ftp�û���
password=123        #ftp����
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
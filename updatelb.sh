#!/bin/bash
#source ~/.bash_profile
JAVA_HOME=/usr/java/jdk1.7.0_79
m_date=$(date +%Y%m%d_%H%M)
file_dir="/home/boss/tm_server/appbak/"
tar_dir="/home/boss/sync_to104/"
tar="lebao.tar"
log="${tar_dir}sync.log"
pro_tmp_dir="/home/boss/sync_to104/lebao/"
pro_dir="/home/boss/tm_server/webapps/lebao"
echo ${m_date}" : begin to update ...">>$log
check_user()
{
  #if the user is not boss,exit
  echo "check whether the user is boss">>$log
  USER_NOW=$(whoami)
  if [ ${USER_NOW} = "boss" ]; then
    echo "You are boss."
  else
    echo "To execute this shell,you must be boss!"
    exit 0
  fi
}
check_user
echo "make the update webapp...">>$log

if [ ! -f "${tar_dir}tarok.txt" ]; then
  echo "There is no update for lebao!"
  echo "There is no update for lebao!">>$log
  exit 0
else
  echo "Find update tar for lebao,begin to update..."
  echo "Find update tar for lebao,begin to update...">>$log
  rm -rf "${tar_dir}tarok.txt"
fi

if [ ! -f "${tar_dir}${tar}" ]; then
  echo "Cannot find lebao.tar in /home/boss/sync_to104! update failed,exit"
  echo "Cannot find lebao.tar in /home/boss/sync_to104! update failed,exit">>$log
  exit 0
fi
if [ -d ${pro_tmp_dir} ]; then
  echo "Find the old lebao,delete it!"
  rm -rf ${pro_tmp_dir}
fi
tar -xvf ${tar_dir}${tar} -C "${tar_dir}"
#rm -rf "${dest_dir}${file}"
#cp "${file_dir}${file}" ${dest_dir}
echo "stop tomcat,back up and update to latest!">>$log
sh /home/boss/server.sh stop
mv "/home/boss/tm_server/webapps/lebao" "${file_dir}/bak/lebao${m_date}"
mv ${pro_tmp_dir} ${pro_dir}
mv "${tar_dir}${tar}" "${tar_dir}${tar}${m_date}"
echo "start the tomcat!">>$log
sh /home/boss/server.sh start
echo "-------------Finished!"

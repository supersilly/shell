#!/bin/bash

c_date=$(date +%m%d)
svn="/home/svn/"


#if the user is not svn,exit
echo "check whether the user is svn"
USER_NOW=$(whoami)
if [ ${USER_NOW}=svn ] ;then
  echo "You are svn."
else
  echo "To execute this shell,you must be svn!"
  exit 0
fi

echo "#check whether the new_pro exists,if it does,delete it."
if [ -d $new_pro ]; then
  echo "Find the path: "$new_pro" has already existed,maybe it is the old,delete it..."
  rm -rf $new_pro
  echo "Delete the path "$new_pro" successfully!"
fi

echo "#check whether zipfile exists,if it does not,exit."
if [ ! -f $zipfile ]; then
  echo "Cannot find zipfile "$zipfile"!"
  exit 0
fi

echo "begin to unzip the lebao..."
unzip $zipfile -d $unzipdir
echo "unzip the "$zipfile" to "$unzipdir" successfully!"

echo "#check whether unzipdir exists,if it does not,send error message and exit."
if [ -d $new_userfile ]; then
  echo  "the "$new_pro" is ready!"
elif [ -d $new_pro -a ! -d $new_userfile]; then
  echo "find the "$new_pro" ,but is not OK!"
  exit 0
else
  echo "Cannot find the "$new_pro" ,do make sure the zip is legal!"
  exit 0
fi

echo "#check whether lebao and bak_pro both exist,if they do ,delete it."
if [ -d $bak_pro -a -d $pro ]; then
  echo "find the "${bak_pro}" has already existed,delete it..."
  rm -rf $bak_pro
  echo "delete the "${bak_pro}" successfully!"
fi

echo "shutdown tomcat! --test"
ps -ef | grep tomcat | grep -v grep | awk '{print $2}' | xargs kill -9

echo "backup project lebao..."
#check whether lebao exists,if it does,copy it.
if [ -d ${pro} ]; then
  echo "Find lebao,back it..."
  cp -r $pro $bak_pro
  echo "copy the "${pro}" successfully!"
else
  echo "connot find lebao,exit..."
  exit 0
fi

echo "#check whether the bak_pro exists,if it does not ,exit"
if [ ! -d "$bak_pro" ]; then
  echo "cannot find the lebao_back: "${bak_pro}" ,check the error..."
  exit 0
fi

echo "#make product lebao"
echo "#check whether the  lib folder  exists,if it does not,copy it from the back."
if [ ! -d $new_lib ]; then
  echo "Cannot find the "${new_lib}" ,copy it from pro..."
  cp -r $lib $new_lib
  echo "copy the "${lib}" successfully!"
fi

echo "delete "$new_userfile" and "$new_config
rm -rf $new_userfile
rm -rf $new_config

if [ -d $new_userfile ]; then
  echo "delete failed! exit"
  exit 0
else
  echo "copy "$config" and "$userfile
  cp -r $config $new_config
  cp -r $userfile $new_userfile
fi
if [ -d $new_userfile ]; then
  echo "make it successfully!"
else
  echo "make it failed!"
  exit 0
fi

echo "move newpro to webapps..."
rm -rf $pro
if [ ! -d $pro ]; then
  echo "move new_pro to pro"
  mv $new_pro $pro
else
  echo "delete the "$pro" faied,exit"
  exit 0
fi

#check whether it is all right
if [ -d $pro ]; then
  echo "new lebao is ready!"
  echo "delete "$zipfile" and "$new_pro
  rm -rf $zipfile
  rm -rf $new_pro
else
  echo "new lebao is failed!"
  exit 0
fi

echo "Finished!"

#chown -R baojia ${tomcat}"/webapps"
#chmod -R 777 ${tomcat}"/webapps"
echo "startup tomcat..."
${tomcat}"bin/startup.sh"
if [ $(ps -ef | grep tomcat | grep -v grep | wc -l) -eq '1' ]; then
  echo "startup tomcat successfully!"
else
  echo "tomcat start failed! You should start it manually!"
fi
tail -f ${tomcat}"logs/catalina.out"

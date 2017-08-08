#!/bin/bash
m_date=$(date +%Y%m%d_%H%M)
tomcat="/home/boss/tm_server/"
zipfile="/home/boss/temp/lebao.war"
bak_zip="/home/boss/war_zip/lebao${m_date}.war"
if [ ! -d "/home/boss/war_zip" ]; then 
  mkdir "/home/boss/war_zip" 
fi
unzipdir="/home/boss/temp/"
if [ ! -d $unzipdir ]; then 
  mkdir $unzipdir 
fi
new_pro="/home/boss/temp/lebao"
log=${tomcat}"logs/catalina.out"
bak_dir=${tomcat}"appbak/bak/"
if [ ! -d $bak_dir ]; then 
  mkdir $bak_dir 
fi
bak_pro=${bak_dir}"lebao"${m_date}
pro=${tomcat}"webapps/lebao"
bak_userfile=${bak_pro}"/userfiles"
userfile=${tomcat}"webapps/lebao/userfiles"
bak_config=${bak_pro}"/WEB-INF/classes/platform.properties"
#config=${tomcat}"webapps/lebao/WEB-INF/classes/platform.properties"
bak_lib=${bak_pro}"/WEB-INF/lib"
#lib=${tomcat}"webapps/lebao/WEB-INF/lib"
new_userfile=${new_pro}"/userfiles"
new_config=${new_pro}"/WEB-INF/classes/platform.properties"
new_lib=${new_pro}"/WEB-INF/lib"
bak_html=${bak_pro}"/*.html"
bak_img=${bak_pro}"/img"
bak_css=${bak_pro}"/css"
bak_ico=${bak_pro}"/favicon.ico"
new_html=${new_pro}"/*.html"
new_img=${new_pro}"/img"
new_css=${new_pro}"/css"
new_ico=${new_pro}"/favicon.ico"
#temp_image=${userfile}"/tempImages"
bak_third=${bak_pro}"/WEB-INF/classes/config/third_config.properties"
new_third=${new_pro}"/WEB-INF/classes/config/third_config.properties"


check_user()
{
  #if the user is not boss,exit
  echo "check whether the user is boss"
  USER_NOW=$(whoami)
  if [ ${USER_NOW} = "boss" ]; then
    echo "You are boss."
  else
    echo "To execute this shell,you must be boss!"
    exit 0
  fi
}

check_pro()
{
  echo "#check whether the new_pro exists,if it does,delete it."
  if [ -d $new_pro ]; then
    echo "Find the path: "$new_pro" has already existed,maybe it is the old,delete it..."
    rm -rf $new_pro
    echo "Delete the path "$new_pro" successfully!"
  fi
}

check_zip()
{
  echo "#check whether zipfile exists,if it does not,exit."
  if [ ! -f $zipfile ]; then
    echo "Cannot find zipfile "$zipfile"!"
    exit 0
  fi
}

unzip_pro()
{
  echo "begin to unzip the lebao..."
  unzip $zipfile -d ${new_pro}
  echo "unzip the "$zipfile" to "$unzipdir" successfully!"
  echo "#check whether unzipdir exists,if it does not,send error message and exit."
  if [ -d $new_userfile ]; then
    echo  "the "$new_pro" is ready!"
  elif [ -d $new_pro -a ! -d $new_userfile ]; then
    echo "find the "$new_pro" ,but is not OK!"
    exit 0
  else
    echo "Cannot find the "$new_pro" ,do make sure the zip is legal!"
    exit 0
  fi
}
#echo "#check whether lebao and bak_pro both exist,if they do ,delete it."
#if [ -d $bak_pro -a -d $pro ]; then
#  echo "find the "${bak_pro}" has already existed,delete it..."
#  rm -rf $bak_pro
#  echo "delete the "${bak_pro}" successfully!"
#fi

shutdown_tmc()
{
  if [ -f conf_nginx/nginx_105 ]; then
    echo "change the server to 105..."
    touch /home/boss/conf_nginx/105
    \cp conf_nginx/nginx_105 /etc/nginx/nginx.conf
    sudo service nginx reload
  fi
  echo "shutdown tomcat,and move the log to new day! --test"
  ps -ef | grep tm_server | grep -v grep | awk '{print $2}' | xargs kill -9
  mv "$log" "${tomcat}/logs/catalina${m_date}.out"
  
}

back_pro()
{
  echo "backup project lebao..."
  #check whether lebao exists,if it does,copy it.
  if [ -d ${pro} -a ! -d $bak_pro ]; then
    echo "Find lebao,begin to back it..."
#    if [ -d ${temp_image} ]; then
#      echo "find temp_image,back the temp_image ${temp_image}"
#      \cp -rf ${temp_image} ${bak_dir}
#      echo "back the temp_image OK,then delete it!"
#      rm -rf ${temp_image}
#      echo "delete the ${temp_image} OK!"
#    else
#      echo "Cannot find temp_image ${temp_image}"
#    fi
    echo "find userfiles,back it!"
    rsync -avzPL --delete "${userfile}" "${bak_dir}/"
    mv $pro $bak_pro
    echo "move the "${pro}" successfully!"
  elif [ -d ${pro} -a -d $bak_pro ]; then
    echo "You hava already back the project,delete it and  back again!"
    rm -rf $bak_pro
    mv $pro $bak_pro
  else
    echo "connot find lebao,exit..."
    exit 0
  fi
}

check_bak()
{
  echo "#check whether the bak_pro exists,if it does not ,exit"
  if [ ! -d "$bak_pro" ]; then
    echo "cannot find the lebao_back: "${bak_pro}" ,check the error..."
    exit 0
  fi
}

make_pro()
{
  echo "#make product lebao"
  echo "#check whether the  lib folder  exists,if it does not,copy it from the back."
  if [ ! -d $new_lib ]; then
    echo "Cannot find the "${new_lib}" ,copy it from pro..."
    cp -r ${bak_lib} $new_lib
    echo "copy the "${bak_lib}" successfully!"
  fi
  
  echo "delete "$new_userfile" and "$new_config" and "$new_html" and "$new_img" and "$new_css" and "$new_ico
  rm -rf $new_userfile
  rm -rf $new_config
  rm -rf $new_html
  rm -rf $new_img
  rm -rf $new_css
  rm -rf $new_ico
  rm -rf $new_third  

  if [ -d $new_userfile ]; then
    echo "delete failed! exit"
    exit 0
  else
    echo "copy "${bak_config}" and "${bak_userfile}
    cp -r ${bak_config} $new_config
    mv ${bak_userfile} $new_userfile
#   cp -r $userfile $new_userfile
    echo "copy "$bak_img" and "$bak_css" and "$bak_html" and "$bak_ico" and"$bak_third
    cp -r ${bak_img} $new_img
    cp -r ${bak_css} $new_css
    cp ${bak_html} $new_pro
    cp ${bak_ico} $new_ico
    cp -r ${bak_third} ${new_third}
  fi
  if [ -d $new_userfile ]; then
    echo "make it successfully!"
  else
    echo "make it failed!"
    exit 0
  fi
}

move_app()
{
  echo "move newpro to webapps..."
  rm -rf $pro
  if [ ! -d $pro ]; then
    echo "move new_pro to pro"
    mv $new_pro $pro
  else
    echo "delete the "$pro" faied,exit"
    exit 0
  fi
}

move_cer()
{
 echo "move cer..."
 rm -rf ${pro}"/WEB-INF/data/lebao"
 cp -r ${bak_pro}"/WEB-INF/data/lebao" ${pro}"/WEB-INF/data/lebao"
}

after_make()
{
  #check whether it is all right
  if [ -d $pro ]; then
    echo "new lebao is ready!"
    echo "delete "$zipfile" and "$new_pro
#    rm -rf $zipfile
     mv ${zipfile} ${bak_zip}
#    rm -rf $new_pro
  else
    echo "new lebao is failed!"
    exit 0
  fi
  echo "Finished!"
}

ch_own()
{
  chown -R baojia ${tomcat}"/webapps"
  chown -R baojia ${tomcat}"/appbak"
  chmod -R 777 ${tomcat}"/webapps"
}
start_tmc()
{
  echo "startup tomcat..."
  nohup ${tomcat}"bin/startup.sh" &
  if [ $(ps -ef | grep java | grep tm_server | grep -v grep | wc -l) -eq '1' ]; then
    echo "startup tomcat successfully!"
  else
    echo "tomcat start failed! You should start it manually!"
  fi
  tail -f ${log}
}
check_user
check_pro
check_zip
unzip_pro
shutdown_tmc
back_pro
check_bak
make_pro
move_app
move_cer
after_make
start_tmc

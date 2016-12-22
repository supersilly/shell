#!/bin/bash
m_date=$(date +%Y%m%d_%H%M)
tomcat="/home/boss/tomcat/"
zipfile="/home/boss/temp/adsdk.war"
bak_zip="/home/boss/war_zip/adsdk${m_date}.war"
if [ ! -d "/home/boss/war_zip" ]; then 
  mkdir "/home/boss/war_zip" 
fi
unzipdir="/home/boss/temp/"
if [ ! -d $unzipdir ]; then 
  mkdir $unzipdir 
fi
new_pro="/home/boss/temp/adsdk"
log=${tomcat}"logs/catalina.out"
bak_dir=${tomcat}"appbak/bak/"
if [ ! -d $bak_dir ]; then 
  mkdir $bak_dir 
fi
bak_pro=${bak_dir}"adsdk"${m_date}
pro=${tomcat}"webapps/adsdk"
bak_db=${bak_pro}"/WEB-INF/classes/dbconfig.properties"
bak_redis=${bak_pro}"/WEB-INF/classes/redis.properties"
bak_mongo=${bak_pro}"/WEB-INF/classes/mongo.properties"
new_db=${new_pro}"/WEB-INF/classes/dbconfig.properties"
new_redis=${new_pro}"/WEB-INF/classes/redis.properties"
new_mongo=${new_pro}"/WEB-INF/classes/mongo.properties"


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
  echo "begin to unzip the adsdk..."
  unzip $zipfile -d ${new_pro}
  echo "unzip the "$zipfile" to "$unzipdir" successfully!"
 
}

shutdown_tmc()
{
sh /home/boss/server.sh stop  
}

back_pro()
{
  echo "backup project adsdk..."
  #check whether adsdk exists,if it does,copy it.
  if [ -d ${pro} -a ! -d $bak_pro ]; then
    echo "Find adsdk,begin to back it..."
    mv $pro $bak_pro
    echo "move the "${pro}" successfully!"
  elif [ -d ${pro} -a -d $bak_pro ]; then
    echo "You hava already back the project,delete it and  back again!"
    rm -rf $bak_pro
    mv $pro $bak_pro
  else
    echo "connot find adsdk,exit..."
    exit 0
  fi
}

check_bak()
{
  echo "#check whether the bak_pro exists,if it does not ,exit"
  if [ ! -d "$bak_pro" ]; then
    echo "cannot find the adsdk_back: "${bak_pro}" ,check the error..."
    exit 0
  fi
}

make_pro()
{
  echo "#make product adsdk"

  echo "delete "$new_db" and "$new_redis" and "$new_mongo
  rm -rf $new_db
  rm -rf $new_redis
  rm -rf $new_mongo
  echo "copy "$bak_db" and "$bak_redis" and "$bak_mongo
  cp ${bak_db} $new_db
  cp ${bak_redis} $new_redis
  cp ${bak_mongo} $new_mongo

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


after_make()
{
  #check whether it is all right
  if [ -d $pro ]; then
    echo "new adsdk is ready!"
    echo "delete "$zipfile" and "$new_pro
#    rm -rf $zipfile
     mv ${zipfile} ${bak_zip}
#    rm -rf $new_pro
  else
    echo "new adsdk is failed!"
    exit 0
  fi
  echo "Finished!"
}

ch_own()
{
  chown -R boss ${tomcat}"/webapps"
  chown -R boss ${tomcat}"/appbak"
  chmod -R 777 ${tomcat}"/webapps"
}
start_tmc()
{
   sh /home/boss/server.sh start
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
after_make
start_tmc

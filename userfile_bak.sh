#!/bin/bash
tomcat="/home/boss/tm_server/"
userfile=${tomcat}"webapps/lebao/userfiles"
bak_dir=${tomcat}"appbak/bak/"
rsync -avzPL --delete "${userfile}" "${bak_dir}/"

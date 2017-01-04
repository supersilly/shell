#/bin/bash
#set -x
#echo $(pwd)
log=tax.log
text=listentext.txt
time_out=30
retry_times=3
rm -rf listen*
if [ ! -f "webs.txt" ]; then
  echo "can not find webs to listen...,exit"
  exit 0
fi

function web_check {
  da=$(date '+%Y-%m-%d %H:%M:%S')
  echo ${da}" check ${1}"
  get_va=`curl -s -k --connect-timeout ${time_out} -m ${time_out} ${1} | grep "key1"`
  if [[ $get_va =~ "key1" ]]; then
    da=$(date '+%Y-%m-%d %H:%M:%S')
 #   echo "${da} success: website ${1} is OK!"
    echo "${da} success: website ${1} is OK!" >>$log
  else
    da=$(date '+%Y-%m-%d %H:%M:%S')
#    echo ${da}" failed: website ${1} is down!"
    echo ${da}" failed: website ${1} will retry!" >>$log
#    echo ${da}" failed: website ${1} will retry!" >>$text
    echo "${1}">>listen_retry
  fi
}
echo "------------------------------------------------------------------------------">>$log
webs=`cat webs.txt`
for we in ${webs[@]}
do
{
  web_check ${we}
}&
done
wait
echo ""
echo "">>$log

for ((i=0;i<${retry_times};i++))
do
  if [ -f listen_retry ]; then
    lr=`cat listen_retry`
    if [[ $lr =~ "http" ]]; then
    echo "retry $i..."
    mv listen_retry listen_retry${i}
    webi=`cat listen_retry${i}`
    for wi in ${webi[@]}
    do
    {
      web_check ${wi}
    }&
    done
    wait
    echo ""
    echo "">>$log
    fi
  fi
done
echo "follows are failures...."
cat listen_retry
echo "over"
rm -rf listen*

#/bin/bash
#set -x
#echo $(pwd)
log=tax.log
text=listentext.txt
time_out=30
retry_times=3
rm -rf listen*

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
echo 'https://fpcy.he-n-tax.gov.cn:82/WebQuery/yzmQuery?fpdm=1300142170&callback=jQuery1703763539
https://fpcy.tax.sx.cn:443/WebQuery/yzmQuery?fpdm=1400142170&callback=jQuery1703763539
https://fpcy.nm-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=1500142170&callback=jQuery1703763539
https://fpcy.tax.ln.cn:443/WebQuery/yzmQuery?fpdm=2100142170&callback=jQuery1703763539
https://fpcy.dlntax.gov.cn:443/WebQuery/yzmQuery?fpdm=2102142170&callback=jQuery1703763539
https://fpcy.jl-n-tax.gov.cn:4432/WebQuery/yzmQuery?fpdm=2200142170&callback=jQuery1703763539
https://fpcy.hl-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=2300142170&callback=jQuery1703763539
https://fpcyweb.tax.sh.gov.cn:1001/WebQuery/yzmQuery?fpdm=3100142170&callback=jQuery1703763539
https://fpdk.jsgs.gov.cn:80/WebQuery/yzmQuery?fpdm=3200142170&callback=jQuery1703763539
https://fpcyweb.zjtax.gov.cn:443/WebQuery/yzmQuery?fpdm=3300142170&callback=jQuery1703763539
https://fpcy.nb-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=3302142170&callback=jQuery1703763539
https://fpcy.ah-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=3400142170&callback=jQuery1703763539
https://fpcyweb.fj-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=3500142170&callback=jQuery1703763539
https://fpcy.xm-n-tax.gov.cn/WebQuery/yzmQuery?fpdm=3502142170&callback=jQuery1703763539
https://fpcy.jxgs.gov.cn:82/WebQuery/yzmQuery?fpdm=3600142170&callback=jQuery1703763539
https://fpcy.sd-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=3700142170&callback=jQuery1703763539
https://fpcy.qd-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=3702142170&callback=jQuery1703763539
https://fpcy.ha-n-tax.gov.cn/WebQuery/yzmQuery?fpdm=4100142170&callback=jQuery1703763539
https://fpcy.hb-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=4200142170&callback=jQuery1703763539
https://fpcy.hntax.gov.cn:8083/WebQuery/yzmQuery?fpdm=4300142170&callback=jQuery1703763539
https://fpcy.gd-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=4400142170&callback=jQuery1703763539
https://fpcy.szgs.gov.cn:443/WebQuery/yzmQuery?fpdm=4403142170&callback=jQuery1703763539
https://fpcy.gxgs.gov.cn:8200/WebQuery/yzmQuery?fpdm=4500142170&callback=jQuery1703763539
https://fpcy.hitax.gov.cn:443/WebQuery/yzmQuery?fpdm=4600142170&callback=jQuery1703763539
https://fpcy.cqsw.gov.cn:80/WebQuery/yzmQuery?fpdm=5000142170&callback=jQuery1703763539
https://fpcy.sc-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=5100142170&callback=jQuery1703763539
https://fpcy.gz-n-tax.gov.cn:80/WebQuery/yzmQuery?fpdm=5200142170&callback=jQuery1703763539
https://fpcy.yngs.gov.cn:443/WebQuery/yzmQuery?fpdm=5300142170&callback=jQuery1703763539
https://fpcy.xztax.gov.cn:81/WebQuery/yzmQuery?fpdm=5400142170&callback=jQuery1703763539
https://fpcyweb.sn-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=6100142170&callback=jQuery1703763539
https://fpcy.gs-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=6200142170&callback=jQuery1703763539
https://fpcy.qh-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=6300142170&callback=jQuery1703763539
https://fpcy.nxgs.gov.cn:443/WebQuery/yzmQuery?fpdm=6400142170&callback=jQuery1703763539
https://fpcy.xj-n-tax.gov.cn:443/WebQuery/yzmQuery?fpdm=6500142170&callback=jQuery1703763539'>webs.txt
if [ ! -f "webs.txt" ]; then
  echo "can not find webs to listen...,exit"
  exit 0
fi
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
if [ -f listen_retry ]; then
echo "follows are failures...."
cat listen_retry
else
echo "All are OK!">>$log
echo "All are OK!"
fi
echo "over"
rm -rf listen*

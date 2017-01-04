#!/bin/bash
#set -x
#i=0
rm -rf this.csv
while read L
do
#((i=i+1))
#echo $i
#id=$(echo $L| cut -d',' -f 1)
#echo -n $id
echo "value">>this.csv
#arr=(obid model isp imei mac ver net ip asver ckey brand bid addtime)
arr=(model imei_real net ckey brand addtime)
#arr=(obid isp)
#echo ${arr[@]}
for ar in ${arr[@]}
  do
#    echo $ar
    if [[ "$L" =~ "$ar" ]]; then
      arr[$ar]=$(echo $L | sed 's/\(.*\)"'"$ar"'":"\?\([^"|^,]*\)"\?\(.*\)/\2/g')
      eval echo ${arr[$ar]}>>this.csv
    else
      echo "null">>this.csv
    fi
  done
#cat this.csv
#sleep 1
done < "dev.txt"
#echo "---------------this.csv"
#cat this.csv
awk '/^value/{print"";next} {printf $0","}' this.csv >ok.csv
#echo "---------------ok.csv"
#cat ok.csv
sed -i 's/,$//g' ok.csv
sed -i '/^$/d' ok.csv

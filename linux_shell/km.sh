#!/bin/bash
rm -rf this.csv
arr=(brand ckey ip addtime)
while read L
do
#id=$(echo $L| cut -d',' -f 1)
#echo -n $id
echo "value">>this.csv
#echo ${arr[@]}
for ar in ${arr[@]}
  do
    echo $ar
    read -p "Press any key to continue ..." goon
    arr[$ar]=$(echo $L | sed 's/\(.*\)"'"$ar"'":"\?\([^"|^,]*\)"\?\(.*\)/\2/g')
    eval echo ${arr[$ar]}
    read -p "Press any key to continue ..." goon
    eval echo  ${arrar[$ar]}>>this.csv
  done

done < "2010.txt"
#echo "---------------this.csv"
#cat this.csv
awk '/^value/{next;print""} {printf $0" "}' this.csv >ok.csv
#echo "---------------ok.csv"
cat ok.csv

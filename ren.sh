#! /bin/bash
VER=ver_num.txt

#<<<CHECK param and get name
if [ $# -eq 0 ]; then
  NAME=lebao
elif [ $# = 1 -a $1 = "lebao" ]; then
  NAME=lebao
elif [ $# = 1 -a $1 = "baojia" ]; then
  NAME=baojia
elif [ $# = 1 -a $1 = "51lebao" ]; then
  NAME=51lebao
else
  echo "Your param is wrong!"
  echo "usage:"
  echo "$0 [ lebao | baojia | 51lebao]"
  exit 1;
fi
#CHECK param>>>
echo "the version is belong to "${NAME}

#<<<CHECK whether VER file and BaoJia exist
checkipa (){
  if [ ! -f "$VER" ]; then
    echo ${VER}" file is not Found,Please check it!"
    exit 0
  fi
  #check ipa,if not only exist one,exit

  ipas=$(ls | grep -i *ao*.ipa | wc -l )
  if (($ipas == 0 )); then
    echo "No BaoJia ipa to be found!"
    exit 1;
  elif (($ipas >1 )); then
    echo "There are too many ipas,but only one will be used!"
    exit 1;
  else
    echo "ipa is ready!"
    oipa=$(ls | grep -i *ao*.ipa)
    echo "The old ipa is "${oipa}
  fi
}
checkipa

#CHECK FILE AND BAOJIA>>>

#<<<get date
c_date=$(date  +%Y%m%d_%H%M)
echo "The date string is "${c_date}
#get date>>>

#<<<get ver num
while read LINE
do
#echo $LINE
#((NUM=$LINE+1))
#let "NUM=$LINE+1"
NUM=`expr $LINE + 1`
done < $VER
echo $NUM > $VER
#cat $VER
#get ver num >>>
new="BaoJia_V1.0.2."${NUM}"_"${c_date}"_"${NAME}".ipa"
echo "The new ipa name is "${new}
mv "$oipa" "$new"

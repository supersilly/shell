#! /bin/bash
VER_PRE="BaoJia1.0.3."
VER="ver_num.txt"

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

ipas=$(ls | grep -i *ao*.ipa | wc -l )
if (($ipas != 0 )); then
  rm -rf Baoj*.ipa
fi

#build
cd /Users/baojia/Documents/dev/LeBao
RELEASE_BUILDDIR="/Users/baojia/Documents/dev/LeBao/build/Release-iphoneos"
APPLICATION_NAME="BaoJia"
DEST_DIR="/Users/baojia/Desktop"
PROVISONING_PROFILE="/Users/baojia/Documents/baojia_dev.mobileprovision"
SIGN_NAME="iPhone Distribution: Beijing Lebaotianxia Technology Co., Ltd. (YDP3983CN4)"
xcodebuild clean
xcodebuild -target BaoJia
# CODE_SIGN_IDENTITY="iPhone Distribution: Beijing Lebaotianxia Technology Co., Ltd. (YDP3983CN4)"
xcrun -sdk iphoneos PackageApplication -v "${RELEASE_BUILDDIR}/${APPLICATION_NAME}.app" -o "${DEST_DIR}/${APPLICATION_NAME}.ipa"  --embed "${PROVISONING_PROFILE}"

#<<<CHECK whether VER file and BaoJia exist
checkipa (){
  if [ ! -f "$VER" ]; then
    echo ${VER}" file is not Found,Please check it!"
    exit 0
  fi

  #check ipa,if not only exist one,exit
  ipas=$(ls | grep -i *baojia*.ipa | wc -l )
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

new=${VER_PRE}${NUM}"_"${c_date}"_"${NAME}".ipa"
echo "The new ipa name is "${new}
mv "$oipa" "$new"
echo "SUCCESS!"

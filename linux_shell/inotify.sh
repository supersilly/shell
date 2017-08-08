src=/home/boss/data/
des=/home/boss/data
user=boss
ip=192.168.23.105

/usr/local/bin/inotifywait -mrq --timefmt '%d/%m/%y/%H:%M' --format '%T%w%f' -e modify,delete,create,attrib $src | while read file
do
rsync -avzP --delete --partial --progress -e "ssh -p2188" $src $user@$ip:$des
done

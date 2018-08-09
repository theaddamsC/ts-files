#!/bin/bash
# Program: ts video more download and merge
# Author: vonchuang
# execution: ./ts.command "playlist.m3u8 url" "save file name"
#example: ./ts.command http://wow01.ibrain.com.tw/vod//_definst_/ibrain/15744//mp4:65v015744007.mp4/playlist.m3u8 系統分析與設計_第7堂

# get playlist file
mkdir downloading
DIR="./downloading"
wget -O ${DIR}/playlist.m3u8 $1

# get chunklist file
LIST=`grep 'chunklist' ${DIR}/playlist.m3u8`
echo ${LIST}
# https://stackoverflow.com/questions/4676459/write-to-file-but-overwrite-it-if-it-exists
echo $1 > ${DIR}/url.txt
# http://wow01.ibrain.com.tw/vod//_definst_/ibrain/15747//mp4:65v015747002.mp4/playlist.m3u8
# https://stackoverflow.com/questions/27658675/how-to-remove-last-n-characters-from-a-string-in-bash#comment71002787_27658733
URL=${1%??????????????}	
echo ${URL}/{LIST}
wget -O ${DIR}/${LIST} ${URL}/${LIST}

# get number of *.ts files
LAST=`tail -n 2 ${DIR}/${LIST} | head -n 1`
echo ${LAST} > ${DIR}/last.txt
# media_w229507567_529.ts
NUM=`cat ${DIR}/last.txt | cut -d '_' -f 3 | cut -d '.' -f 1`
echo ${NUM}

# get split *.ts files
# http://wow01.ibrain.com.tw/vod//_definst_/ibrain/15747//mp4:65v015747002.mp4/media_w2020401927_2.ts
MEDIA=`cat ${DIR}/last.txt | cut -d '_' -f 2`
for (( i=0; i<=${NUM}; i=i+1 ))
do
	wget -O ${DIR}/media_${MEDIA}_${i}.ts ${URL}/media_${MEDIA}_${i}.ts
	echo ${DIR}/media_${MEDIA}_${i}.ts | tr " " "\n" >> ${DIR}/tslist.txt
done

while read line
do
	cat $line >> $2.ts;
done < ${DIR}/tslist.txt

ffmpeg -i $2.ts -bsf:a aac_adtstoasc -acodec copy -vcodec copy $2.mp4

# clean files
rm $2_第${j}堂.ts
rm -rf ${DIR}

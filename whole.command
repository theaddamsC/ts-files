#!/bin/bash
# Program: ts video more download and merge, download whole ep. in one time, change ts to mp4
# Author: vonchuang
# execution: ./whole.command "no. of course" "save file name" "num. of ep." "shotdown after finished of not"
# example:sudo ./whole.command 15744 系統分析與設計 40 1
# playlist.m3u8 url: http://wow01.ibrain.com.tw/vod//_definst_/ibrain/15744//mp4:65v015744007.mp4/playlist.m3u8
# shotdown after finished if input 1
# get playlist file


for (( j=1; j<=$3; j=j+1 ))
do
    if [[  -f $2_第${j}堂.ts ]]; then
        ffmpeg -i $2_第${j}堂.ts -bsf:a aac_adtstoasc -acodec copy -vcodec copy $2_第${j}堂.mp4
        rm $2_第${j}堂.ts
    elif [[ ! -f $2_第${j}堂.mp4 ]]; then
        if(( j<10 )); then
            COURSE="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/$1///mp4:65v0$100${j}.mp4/playlist.m3u8"
        else
            COURSE="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/$1///mp4:65v0$10${j}.mp4/playlist.m3u8"
        fi

    #    echo ${COURSE}
        mkdir downloading_第${j}堂
        DIR="./downloading_第${j}堂"
        wget -O ${DIR}/playlist.m3u8 ${COURSE}

        # get chunklist file
        LIST=`grep 'chunklist' ${DIR}/playlist.m3u8`
        echo ${LIST}
        # https://stackoverflow.com/questions/4676459/write-to-file-but-overwrite-it-if-it-exists
        echo ${COURSE} > ${DIR}/url.txt
        # http://wow01.ibrain.com.tw/vod//_definst_/ibrain/15747//mp4:65v015747002.mp4/playlist.m3u8
        # https://stackoverflow.com/questions/27658675/how-to-remove-last-n-characters-from-a-string-in-bash#comment71002787_27658733
        URL=${COURSE%??????????????}
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
    cat $line >> $2_第${j}堂.ts;
        done < ${DIR}/tslist.txt

        # convert ts to mp4
        ffmpeg -i $2_第${j}堂.ts -bsf:a aac_adtstoasc -acodec copy -vcodec copy $2_第${j}堂.mp4

        # clean files
        rm $2_第${j}堂.ts
        rm -rf ${DIR}
    else
        echo "File $2_第${j}堂.mp4 exist!"
    fi
done

if (($4 == 1)); then
    shutdown -h now
fi


# minify script: http://bash-minifier.appspot.com/
# https://github.com/precious/bash_minifier

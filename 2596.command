#!/bin/bash
# Program: ts video more download and merge, download whole ep. in one time, change ts to mp4
# Author: vonchuang
# execution: sudo ./2227.command
# playlist.m3u8 url: http://wow01.ibrain.com.tw/vod//_definst_/ibrain/15744//mp4:65v015744007.mp4/playlist.m3u8


read -p "是否在下載完後自動關機(y/n)？" AUTOSHOOTDOWN

FILENAME='courseID.txt'

while read line; do
    for (( j=1; j<=999; j=j+1 ))
    do

        # create dir
        if [[ -d ${line} ]]; then
            echo "Dir ${line} already exist!"
        else
            mkdir ${line}
        fi
        if(( j < 10 && line < 10000 )); then
            CHECK="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/${line}///mp4:65v00${line}00${j}.mp4/playlist.m3u8"
        elif((j < 10 && line >= 10000)); then
            CHECK="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/${line}///mp4:65v0${line}00${j}.mp4/playlist.m3u8"

        elif((j >= 10 && line < 10000)); then
            CHECK="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/${line}///mp4:65v00${line}0${j}.mp4/playlist.m3u8"
        elif((j >= 10 && line >= 10000)); then
            CHECK="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/${line}///mp4:65v0${line}0${j}.mp4/playlist.m3u8"
        fi

        if wget -S --spider ${CHECK} 2>&1 | grep -q 'Remote file exists'; then
# https://stackoverflow.com/questions/32126653/how-does-end-work-in-bash-to-create-a-multi-line-comment-block
            if [[  -f ./${line}/${line}_第${j}堂.ts ]]; then
                ffmpeg -i ${line}_第${j}堂.ts -bsf:a aac_adtstoasc -acodec copy -vcodec copy ${line}_第${j}堂.mp4
                rm ${line}_第${j}堂.ts
            elif [[ ! -f ./${line}/${line}_第${j}堂.mp4 ]]; then
                if(( j<10 )); then
                    COURSE="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/${line}///mp4:65v0${line}00${j}.mp4/playlist.m3u8"
                else
                    COURSE="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/${line}///mp4:65v0${line}0${j}.mp4/playlist.m3u8"
                fi

            #    echo ${COURSE}
                mkdir ./${line}/downloading_第${j}堂
                DIR="./${line}/downloading_第${j}堂"
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
            cat $line >> ${line}_第${j}堂.ts;
                done < ${DIR}/tslist.txt

                # convert ts to mp4
                ffmpeg -i ./${line}/${line}_第${j}堂.ts -bsf:a aac_adtstoasc -acodec copy -vcodec copy ./${line}/${line}_第${j}堂.mp4

                # clean files
                rm ./${line}${line}_第${j}堂.ts
                rm -rf ${DIR}
            else
                echo "File ${line}_第${j}堂.mp4 exist!"
            fi
        else
            echo  ${line}
            j=j-1
            echo  ${j}
            break
        fi
    done
done < ${FILENAME}


# shotdown after done
if [ "${AUTOSHOOTDOWN}" == "Y" ] || [ "${AUTOSHOOTDOWN}" == "y" ]; then
    shutdown -h now
elif [ "${AUTOSHOOTDOWN}" == "N" ] || [ "${AUTOSHOOTDOWN}" == "n" ]; then
    echo "Download Done!"
else
    echo "Download Done!"
fi


# minify script: http://bash-minifier.appspot.com/
# https://github.com/precious/bash_minifier

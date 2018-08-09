#!/bin/bash
# Program: ts video more download and merge, download whole ep. in one time, change ts to mp4
# Author: vonchuang
# execution: ./whole.command "no. of course" "save file name" "num. of ep." "shotdown after finished of not"
# example:sudo ./whole.command 15744 系統分析與設計 40 1
# playlist.m3u8 url: http://wow01.ibrain.com.tw/vod//_definst_/ibrain/6699//mp4:65v006699007.mp4/playlist.m3u8
# shotdown after finished if input 1
# get playlist file


for (( j=1000; j<=9999; j=j+1 ))
do
    URL="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/${j}//mp4:65v00${j}001.mp4/playlist.m3u8"
    if wget -S --spider ${URL} 2>&1 | grep -q 'Remote file exists'; then
        echo ${j} >> courseID.txt
        echo "File ${j} exist!"

    else
        echo "File ${j} not exist!"
    fi
done


# minify script: http://bash-minifier.appspot.com/
# https://github.com/precious/bash_minifier

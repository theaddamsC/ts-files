for((j=1;j<=$3;j=j+1));do if [[ -f $2_第${j}堂.ts ]];then ffmpeg -i $2_第${j}堂.ts -bsf:a aac_adtstoasc -acodec copy -vcodec copy $2_第${j}堂.mp4;rm $2_第${j}堂.ts;elif [[ ! -f $2_第${j}堂.mp4 ]];then if((j<10));then COURSE="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/$1///mp4:65v0$100${j}.mp4/playlist.m3u8";else COURSE="http://wow01.ibrain.com.tw/vod//_definst_/ibrain/$1///mp4:65v0$10${j}.mp4/playlist.m3u8";fi;mkdir downloading_第${j}堂;DIR="./downloading_第${j}堂";wget -O ${DIR}/playlist.m3u8 ${COURSE};LIST=`grep 'chunklist' ${DIR}/playlist.m3u8`;echo ${LIST};echo ${COURSE}>${DIR}/url.txt;URL=${COURSE%??????????????};echo ${URL}/{LIST};wget -O ${DIR}/${LIST} ${URL}/${LIST};LAST=`tail -n 2 ${DIR}/${LIST}|head -n 1`;echo ${LAST}>${DIR}/last.txt;NUM=`cat ${DIR}/last.txt|cut -d '_' -f 3|cut -d '.' -f 1`;echo ${NUM};MEDIA=`cat ${DIR}/last.txt|cut -d '_' -f 2`;for((i=0;i<=${NUM};i=i+1));do wget -O ${DIR}/media_${MEDIA}_${i}.ts ${URL}/media_${MEDIA}_${i}.ts;echo ${DIR}/media_${MEDIA}_${i}.ts|tr " " "\n">>${DIR}/tslist.txt;done;while read line;do cat $line>>$2_第${j}堂.ts;done<${DIR}/tslist.txt;ffmpeg -i $2_第${j}堂.ts -bsf:a aac_adtstoasc -acodec copy -vcodec copy $2_第${j}堂.mp4;rm $2_第${j}堂.ts;rm -rf ${DIR};else echo "File $2_第${j}堂.mp4 exist!";fi;done;if(($4 == 1));then shutdown -h now;fi

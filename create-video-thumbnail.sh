#!/bin/sh

file_part=`echo $1 | sed 's/\.[^\.]\+$//'`

tmp_image=`mktemp`

#convert -define jpeg:size=500x180 $1 -auto-orient -thumbnail 250x90 -unsharp 0x.5 ../thumbnails/$1
ffmpeg -itsoffset -0 -i $1 -vcodec mjpeg -vframes 1 -an -f rawvideo -s 160x90 -y $tmp_image
composite -dissolve 25% -gravity center ../../scripts/play.png $tmp_image ../thumbnails/$file_part.jpg

rm $tmp_image

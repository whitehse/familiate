#!/bin/sh

old_file=$1
directory=$2

file_part=`echo $old_file | sed 's/\.[^\.]\+$//'`

#ffmpeg -i $old_file -s hd480 -b:v 1000000 -acodec copy $new_file
#ffmpeg -i $old_file -s hd480 -pix_fmt yuv420p -b:v 1000000 -acodec copy $new_file
#ffmpeg -i $old_file -s hd480 -pix_fmt yuv420p -acodec copy $new_file
#ffmpeg -i $old_file -s 848,480 -acodec copy $new_file
#ffmpeg -i $old_file -s 848,480 -r 30 -acodec copy $new_file
#ffmpeg -i $old_file -s 848,480 -r 30 -acodec libaacplus -ar 44.1k $new_file

if [ -f $directory/$file_part.mp4 ]; then
  exit
fi

#Create mpeg:
# wheezy
ffmpeg -i $old_file -vcodec mpeg4 -s 480x320 -b:v 1000k -ac 2 -acodec libmp3lame -ab 192k $directory/$file_part.mp4
# squeeze
ffmpeg -i $old_file -vcodec mpeg4 -s 480x320 -b 1000k -ac 2 -acodec libmp3lame -ab 192k $directory/$file_part.mp4

# ogg
# wheezy
ffmpeg -i $old_file -s 480x320 -b:v 1000k -f ogg -r 30 -ac 2 -acodec libvorbis -ab 192k $directory/$file_part.ogg
# squeeze
ffmpeg -i $old_file -s 480x320 -b 1000k -f ogg -r 30 -ac 2 -acodec libvorbis -ab 192k $directory/$file_part.ogg

# webm
ffmpeg -i $old_file -s 480x320 -b 1000k -pass 1 -f webm -ac 2 -ab 192k -y $directory/$file_part.webm
ffmpeg -i $old_file -s 480x320 -b 1000k -pass 2 -f webm -ac 2 -ab 192k -y $directory/$file_part.webm

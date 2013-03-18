#!/bin/sh

dates=`mktemp`

scripts/list-days.sh images/orig > $dates
scripts/list-days.sh videos/orig >> $dates

cat $dates | sort -r | uniq > $dates.2
mv $dates.2 $dates

cat << EOF
<!DOCTYPE html>
<html>
    <head>
        <meta charset='utf-8'/>
        <title>Test</title>
        <style>
            body{font:12px/1.2 Verdana, sans-serif; padding:0 10px;}
            a:link, a:visited{text-decoration:none; color:#416CE5; border-bottom:1px solid #416CE5;}
            h2{font-size:13px; margin:15px 0 0 0;}
        </style>
        <link rel="stylesheet" href="scripts/colorbox.css" />
        <link rel="stylesheet" href="scripts/video-js.css" />
        <link rel="stylesheet" href="scripts/familiate.css" />
        <script src="scripts/jquery.min.js"></script>
        <script src="scripts/jquery.colorbox.js"></script>
        <script src="scripts/video.js"></script>
        <script src="scripts/jquery.lazyload.js"></script>
        <script>
            \$(document).ready(function(){
EOF
for foo in `cat $dates`
do
  echo "                \$(\".$foo\").colorbox({rel:'$foo', transition:\"fade\"});"
done
  echo "                \$(\".iframe\").colorbox({iframe:true, width:\"915\", height:\"570\"});"
cat << EOF
                \$(".callbacks").colorbox({
                    onOpen:function(){ alert('onOpen: colorbox is about to open'); },
                    onLoad:function(){ alert('onLoad: colorbox has started to load the targeted content'); },
                    onComplete:function(){ alert('onComplete: colorbox has displayed the loaded content'); },
                    onCleanup:function(){ alert('onCleanup: colorbox has begun the close process'); },
                    onClosed:function(){ alert('onClosed: colorbox has completely closed'); }
                });
            });
        </script>
    </head>
    <body>
EOF

last_day="1969-12-31"

#for foo in `ls -t images/orig/`
for foo in `cat $dates`
do
  echo ""
  echo "      <h2>$foo</h2>"
  echo "      <div class=\"image_collection\">"
  for bar in `ls --full-time images/orig/ | grep "$foo " | awk '{print $9}'`
  do
    #echo "      <p><a class=\"$foo\" href=\"images/popup/$bar\"><img src=\"images/thumbnails/$bar\"></a></p>"
    image_width=`exiv2 images/thumbnails/$bar 2> /dev/null | grep 'Image size' | awk '{print $4}'`
    image_height=`exiv2 images/thumbnails/$bar 2> /dev/null | grep 'Image size' | awk '{print $6}'`
    echo "      <p><a class=\"$foo\" href=\"images/popup/$bar\"><img class=\"lazy\" src=\"images/grey.gif\" data-original=\"images/thumbnails/$bar\" width=\"$image_width\" height=\"$image_height\"></a></p>"
  done
  echo "      </div>"
  echo "      <div class=\"video_collection\">"

  for bar in `ls --full-time videos/orig/ | grep "$foo " | awk '{print $9}'`
  do
    file_part=`echo $bar | sed 's/\.[^\.]\+$//'`
    image_width=`exiv2 videos/thumbnails/$bar 2> /dev/null | grep 'Image size' | awk '{print $4}'`
    image_height=`exiv2 videos/thumbnails/$bar 2> /dev/null | grep 'Image size' | awk '{print $6}'`
    #echo "      <p><a class='iframe' href="videos/$file_part.html"><img src=\"videos/thumbnails/$file_part.jpg\"></a></p>"
    echo "      <p><a class='iframe' href="videos/$file_part.html"><img class=\"lazy\" src=\"images/grey.gif\" data-original=\"videos/thumbnails/$file_part.jpg\" width=\"$image_width\" height=\"$image_height\"></a></p>"
    cat > videos/$file_part.html << EOF
<html>
<head>
  <link href="/scripts/video-js.css" rel="stylesheet">
  <script src="/scripts/video.js"></script>
</head>
<body>
<video id="$bar" class="video-js vjs-default-skin" controls width="848" height="480" poster="" preload="auto" loop data-setup="{}">
  <source type="video/ogg" src="/videos/popup/$file_part.ogg">
  <source type="video/webm" src="/videos/popup/$file_part.webm">
  <source type="video/mp4" src="/videos/popup/$file_part.mp4">
</video>
</body>
</html>
EOF
  done

  echo "      </div>"
done

cat << EOF
    The <img src="images/play.png">Play</img> image icon is copyrighted by <a href="http://www.creativefreedom.co.uk/">Creative Freedom Ltd</a>, released under the <a href="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 Unported (CC BY 3.0)</a> license. jQuery is copyrighted by the jQuery Foundation and other contributors. You may use jQuery under the terms of either the MIT License or the GNU General Public License (GPL) Version 2. Video.js: Copyright 2011 Zencoder, Inc. It can be used under the terms of the GNU Lesser General Public License (LGPL), either version 3, or (at your option) any later version. Colorbox: (c) 2011 Jack Moore - jacklmoore.com. It can be used under the MIT License. LazyLoad: Copyright (c) 2007-2012 Mika Tuupola. It is distributed under the MIT license. All other rights, including image distribution, are reserved. Copying pictures or video from this site is prohibited, unless you're a close friend or family member.

    <script type="text/javascript" charset="utf-8">
        \$(function() {
            \$("img.lazy").lazyload({
                effect : "fadeIn"
            });
        });
    </script>
    </body>
</html>
EOF

rm $dates

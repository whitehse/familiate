#!/bin/sh

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
        <script src="scripts/jquery.min.js"></script>
        <script src="scripts/jquery.colorbox.js"></script>
        <script src="scripts/video.js"></script>
        <script>
            \$(document).ready(function(){
EOF
for foo in `ls videos/orig/`
do
  echo -n "" 
done
  #echo "                \$(\".iframe\").colorbox({iframe:true, width:\"80%\", height:\"80%\"});"
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

for foo in `ls -t videos/orig/`
do
  file_part=`echo $foo | sed 's/\.[^\.]\+$//'`
  this_day=`scripts/print-day-of-file.sh videos/orig/$foo`
  if [ "$this_day" != "$last_day" ]; then
    last_day="$this_day"
    echo ""
    echo "      <h2>$this_day</h2>"
  fi
  echo "      <p><a class='iframe' href="videos/$file_part.html"><img src=\"videos/thumbnails/$file_part.jpg\"</a></p>"
cat > videos/$file_part.html << EOF
<html>
<head>
  <link href="/scripts/video-js.css" rel="stylesheet">
  <script src="/scripts/video.js"></script>
</head>
<body>
<video id="$foo" class="video-js vjs-default-skin" controls width="848" height="480" poster="" preload="auto" loop data-setup="{}">
  <source type="video/ogg" src="/videos/popup/$file_part.ogg">
  <source type="video/webm" src="/videos/popup/$file_part.webm">
  <source type="video/mp4" src="/videos/popup/$file_part.mp4">
</video>
</body>
</html>
EOF

done

cat << EOF
    The <img src="images/play.png">Play</img> image icon is copyrighted by <a href="http://www.creativefreedom.co.uk/">Creative Freedom Ltd</a>, released under the <a href="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 Unported (CC BY 3.0)</a> license. All other rights are reserved.
    </body>
</html>
EOF

#!/bin/sh

timestamp=`exif $1 | grep "Date and Time" | tail -1 | sed 's/.*|//' | sed 's/://g' | sed 's/ //g' | sed 's/\(.*\)\([0-9][0-9]\)$/\1.\2/'`

touch -t $timestamp $1

#!/bin/sh

convert -define jpeg:size=500x180 $1 -auto-orient -thumbnail 250x90 -unsharp 0x.5 ../thumbnails/$1

#!/bin/sh

IFS='
'

date -d "`ls --full-time $1 | awk '{print $6, $7, $8}'`" +%Y-%m-%d

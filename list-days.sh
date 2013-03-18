#!/bin/sh

for foo in `find images/orig -name "*JPG"`
do
  scripts/print-day-of-file.sh $foo
done | sort -r | uniq

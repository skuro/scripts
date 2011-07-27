#!/bin/sh

for i in `find . -name "*.jar"`
do
  COUNT=`unzip -l $i | grep $1 | wc -l`
  if [ $COUNT -gt 0 ]
  then
    echo $i
  fi
done

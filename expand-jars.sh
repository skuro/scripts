#!/bin/sh

# useful params:
EXT=".jar"
EXT_LENGTH=${#EXT}

# params:
LIB_DIR=$1
TARGET_DIR=$2

for LIB in `find $LIB_DIR -name *$EXT`
do
  case $LIB in
    *.jar )
      LIB=`basename $LIB`
      echo "Processing $LIB"
      LEN=${#LIB}
      LEN=$((LEN - EXT_LEN))

      echo "Name length of $NAME is $LEN"

      NAME=${LIB:0:LEN}

      echo $NAME
  esac
done

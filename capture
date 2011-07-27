#!/bin/sh

function usage(){
  echo "$0 -- write a network capture file using tcpdump to be used with WireShark"
  echo ""
  echo "Usage:"
  echo "   $i <iface> <file> \"tcpdump filter expression\""

  exit 1
}

if [ 2 -gt $# ]
then
  usage
fi

iface=$1
shift

file=$1
shift

filter=$@

tcpdump -i $iface -s 65535 -w $file $filter

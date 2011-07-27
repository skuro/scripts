#!/bin/sh
#
# Count lines --  a slightly less flexible but more useful wc son for devs
#
# Please report bugs and comments to Carlo Sciolla <carlo.sciolla@gmail.com>

VERSION=0.1
WC="wc -l"
BASEPATH="."

COUNTER=0
STEP=0

function count {
	STEP=0
	for i in `find . -name $1`
	do
		STEP+=`$WC $i`
	done
}

function usage {
	echo "$0 v$VERSION -- by Carlo Sciolla <carlo.sciolla@gmail.com>"
	echo "usage:"
	echo "		$0 <pattern1> [<pattern2> ...]"
	echo ""
	echo "Find files matching the provided patterns in the current folder tree and count their lines, displaying a total sum at the end."
}

# Parse the cmdline ->
#                   ->
if [ $# -eq 0 ]
then
	usage;
	exit 1
fi

for i in $@
do
	count $i;
	echo $STEP
done

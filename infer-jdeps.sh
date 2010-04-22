#!/bin/bash
#
# infer-jdeps.sh
#
# It is sometimes needed to know which dependencies a Java application has having only its source code
# as a starting base. This script looks into the Java sources for the `import` statements, looking
# for such classes within the source tree (no external deps) or within the JARs contained in a specific
# library folder.
#
# Author:	Carlo Sciolla <skuro@skuro.tk>
# Version:	0.1

VERSION=0.1
APPNAME=$0
AUTHOR="Carlo Sciolla <skuro@skuro.tk>"
SRCDIR="src/main/java"
LIBDIR="."

function usage
{
	echo "$APPNAME v.$VERSION by $AUTHOR"
	echo "usage:"
	echo "	$APPNAME [--<OPTION>=value] [--OPTION=value] ..."
	echo
	echo "Supported options:"
	echo
	echo "	src		base folder where Java sources are stored (defaults to ./src/main/java)"
	echo "	libs		folder containing a set of JAR libraries where to look for possible matches (defaults to .)"
	echo "	help		displays this help and exits"
	echo
}

## parse arguments
## thanks to:
## 	OpenSourcery -- http://www.opensourcery.co.uk/2008/04/parsing-parameters-bash-shell-script/ 
until [[ ! "$*" ]]
do
  if [[ ${1:0:2} = '--' ]]
  then
    PAIR=${1:2}
    PARAMETER=`echo ${PAIR%%=*} | tr [:lower:] [:upper:]`
    eval P_$PARAMETER=${PAIR#*=}
  fi
  shift
done

if [ $P_HELP ]
then
	usage
	exit 0
fi

if [ $P_SRC ]
then
	SRCDIR=$P_SRC
fi

if [ $P_LIBS ]
then
	LIBDIR=$P_LIBS
fi

deps=""
for javaSrc in `find $SRCDIR -type f -name *.java`
do
	echo -e "Evaluating imports from $javaSrc..."
	for import in `grep -e '^import' $javaSrc | cut -f2 -d' '`
	do		
		fullPkg=`echo $import | cut -f1 -d';'`
		
		# exclude language built in
		if [ `expr $fullPkg : "^java."` -gt 0 ]
		then
			continue
		fi
		
		# from now on, we look for files
		fullPkg="${fullPkg//.//}.class"
		
		# look in the local source tree first
		if [ -f "$SRCDIR/$fullPkg.java" ]
		then
			echo "internal import, skipping"
			continue
		fi
		
		for lib in `ls $LIBDIR/*.jar`
		do
			libName=`basename $lib`
			# skip already identified potential matches
			if [ ${#deps} -gt 0 ]
			then
			 	if [ `expr $deps : ".*$libName"` -gt 0 ]
				then
					continue
				fi
			fi
		
			unzipResult=`unzip -l $lib | grep "$fullPkg"`
			if [ ! ${#unzipResult} -gt 0 ]
			then
				continue
			fi
				
			echo "	$libName"
				
			if [ ${#deps} -gt 0 ]
			then
				deps="$deps;$libName"
			else
				deps="$libName"
			fi
				
			#echo "deps is now: $deps"
			break
		done
	done
done

#OLD_IFS=$IFS
#IFS=';'
#deps=($deps)
#IFS=$OLD_IFS

#echo "Found potential matches:"
#for i in ${deps[@]}
#do
#	echo "	$i"
#done
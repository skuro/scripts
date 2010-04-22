#!/bin/sh

VERSION=0.1
PRG=workspace
LS=`which ls` # avoid aliases

function usage()
{
  echo "$PRG -- switch to Eclipse workspace for a specific environments"
  echo "v$VERSION by Carlo Sciolla <carlo.sciolla@gmail.com>"
  echo
  echo "Usage:"
  echo "    $PRG <environment>"
  echo
  echo "<environment> is one of the currently available Eclipse environment listed below:"
  echo

  for i in `$LS $SELECTOR_DIR`
  do
    echo "  - $i"
  done

  echo
}

if [ $# == 0 ]
then
  usage
else
  ENV=`readlink $SELECTOR_DIR/$1`
  cd $SELECTOR_DIR/$ENV/../workspace # smarter ways probably easy
  echo "-> $PWD"
fi

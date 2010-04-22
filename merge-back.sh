#!/bin/sh

# Copy filesets from one folder to another
# useful for merging back to a branch

SRCDIR=$1
shift

DSTDIR=$1
shift

FILES=$@

echo "Copying following files from $SRCDIR to $DSTDIR:"
echo $FILES

go()
{
  for FILE in $FILES
  do
    
    case $PROMPT in
      [Yy]  )  echo -n "$SRCDIR$FILE => $DSTDIR$FILE ? [Y] "
               read OK <&1
               
               if [ -z $OK ]
               then
                OK=Y
               fi

               case $OK in
                [Yy]  ) cp $SRCDIR$FILE  $DSTDIR$FILE
                        ;;
                *     ) echo skipping
                        ;;
               esac

              ;;
      *     )  echo -n "$SRCDIR$FILE => $DSTDIR$FILE"
               cp $SRCDIR$FILE  $DSTDIR$FILE
               ;;
    esac

  done
}

echo ""
echo -n "OK? [Y] "

read OK <&1

echo

if [ -z "$OK" ]
then
  OK="Y"
fi

case "$OK" in
  [yY]  ) go
          ;;

  *     ) echo "Aborting"
          ;;
esac


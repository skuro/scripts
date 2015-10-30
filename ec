#!/bin/sh

# default location of emacsclient for OS X installations
EC="/usr/local/bin/emacsclient"

# start Emacs daemon in case if it's not running yet
if [ ! -e $TMPDIR/emacs$UID/server ]
then
    echo "Emacs is not running. Start it with:"
    echo "     launchctl load ~/Library/LaunchAgents/homebrew.mxcl.emacs.plist"
    exit -1
fi

# -n : return immediately
ARGS="-n $@"

# apparently, when the daemon runs with no windows open it still lists
# one frame.
WINDOWED=`$EC -e "window-system"`
if [ "xnil" == "x$WINDOWED" ]
then
    # create a new Emacs window
    ARGS="-c $ARGS"
fi

$EC $ARGS

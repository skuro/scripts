#!/bin/sh

URL=http://build.chromium.org/buildbot/snapshots/chromium-rel-mac
TMP=/tmp
TMP_FOLDER=chrome-mac
FINAL=/Applications
APP=Chromium.app
CURL=`which curl`
UNZIP=`which unzip`

if ps ax | grep -v grep | grep $APP > /dev/null
then
	echo "$APP is running, please quit and try again..."
	exit 1
fi

# Get the latest version number
LATEST=`$CURL -s $URL/LATEST`

if test -d $FINAL/$APP
then
	CURRENT=`cat $FINAL/$APP/Contents/Info.plist |
		grep -A1 SVNRevision | grep -v key |
		sed -e 's/.*<string>\([0-9]*\)<\/string>/\1/'`

	echo "Current version: $CURRENT"

	# Check to see if you are already at the newest version
	if test $CURRENT -eq $LATEST 
	then
		echo "At newest revision, quitting..."
		exit 0
	fi
fi

echo "Changing into $TMP directory..."
cd $TMP

# Test to see if file is present, and delete if there
test -e $TMP_FOLDER.zip && (echo "Removing old files..."; rm -rf $TMP_FOLDER*)

echo "Downloading revision $LATEST..."

# Download the latest version, and unzip
$CURL $URL/$LATEST/chrome-mac.zip -o $TMP_FOLDER.zip

echo "Download complete unziping..."
$UNZIP -qq $TMP_FOLDER.zip

# Check to make sure the file is properly unziped
if test -d $TMP_FOLDER/$APP
then
	echo "Unzip successful moving files..."
	rm -rf $TMP_FOLDER.zip
else
	echo "Unzip failed..."
	rm -rf $TMP_FOLDER*
	exit 1
fi

# Check to see if Chromium.app is in $FINAL, and remove
test -d $FINAL/$APP && (echo "Removing $FINAL/$APP...";	rm -rf $FINAL/$APP)

# Move the app into $FINAL 
echo "Moving $TMP/$TMP_FOLDER/$APP to $FINAL/$APP..."
mv $TMP_FOLDER/$APP $FINAL/$APP

# Check to make sure the move was successful, othewise remove temp files
test -d $FINAL/$APP || (echo "Move failed..."; rm -rf $TMP_FOLDER*; exit 1)

# Remove temporary information
echo "Removing temporary files..."
rm -rf $TMP_FOLDER*

echo "Update to revision $LATEST completed successfully."

exit 0

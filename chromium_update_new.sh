#!/bin/sh
latest="$(curl http://build.chromium.org/buildbot/snapshots/chromium-rel-mac/LATEST)"
touch chrome-$latest-mac.zip
echo "Getting release $latest..."
download="Y"
if [ -e chrome-$latest-mac.zip ]; then
 echo "File chrome-$latest-mac.zip already exist, should I download it again? Y/N"
 echo -n " > "
 read download
fi

if [ $download = "Y" ]; then
 curl http://build.chromium.org/buildbot/snapshots/chromium-rel-mac/$latest/chrome-mac.zip > chrome-$latest-mac.zip
fi

if [ -d chrome-mac ]; then rm -rf chrome-mac ; fi
echo "Ready to install release $latest, ok? Y/N"
echo -n " > "
read command
if [ $command = 'Y' ]; then
 echo "Unzipping chrome-$latest-mac.zip..."
 unzip chrome-$latest-mac.zip
 echo "Creating backup copy of /Applications/Chromium.app in /tmp/chromium-old.app..."
 mv /Applications/Chromium.app /tmp/chromium-old.app
 echo "Installing release $latest in /Applications/Chromium.app..."
 mv chrome-mac/Chromium.app /Applications/
 rm -rf chrome-mac
 echo "Done!"
fi
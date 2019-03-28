#!/bin/bash
#
VERSION="2019-03-28 16:28"
THIS_FILE="pkg-upgrade.sh"
#
# Brief Description
#
# Usage: bash pkg-upgrade.sh
#        (not sh pkg-upgrade.sh)
#
# Script osup.sh will show a description of each upgradeable package before
# upgrading each package.
#
## After each edit made, please update Code History and VERSION.
##
## Code Change History
##
## 2019-03-28 *Adjusted displayed package descriptions format.
##
## 2019-03-26 *Added detection of installed file viewer.
##
## 2019-03-24 *Initial release.
##
sudo apt update
sudo apt list --upgradable > uplist.tmp  # Raw data output from command, "apt list".
awk -F / '{ print $1 }' uplist.tmp > uplist2.tmp  # Parse raw data to show each package title only.
sed -i s/Listing...// uplist2.tmp  # Delete string "Listing...Done" from list of packages.
awk 'NF' uplist2.tmp > uplist.tmp  # Delete empty line left-over from deleting string.
TITLE="***Description of upgradeable packages***"
echo $TITLE > uplist2.tmp
#
echo $TITLE
echo
while read XSTR
do
      echo >> uplist2.tmp
      echo $XSTR >> uplist2.tmp
      apt-cache show $XSTR | grep Description --max-count=1 --after-context=2 >> uplist2.tmp
done < uplist.tmp
# Detect installed file viewer.
RUNAPP=0
for FILEVR in most more less
do
    if [ $RUNAPP -eq 0 ] ; then
       type $FILEVR >/dev/null 2>&1  # Test if $FILEVR application is installed.
       ERROR=$?
       if [ $ERROR -eq 0 ] ; then
          $FILEVR uplist2.tmp
          RUNAPP=1
       fi
    fi
done
sudo apt upgrade
rm uplist*.tmp

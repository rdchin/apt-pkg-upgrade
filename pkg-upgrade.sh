#!/bin/bash
#
VERSION="2019-03-28 16:28"
THIS_FILE="pkg-upgrade.sh"
#
# Brief Description
#
# Usage: bash osup.sh
#        (not sh osup.sh)
#
# Script osup.sh will show a description of each upgradeable package before
# upgrading each package.
#
## After each edit made, please update Code History and VERSION.
##
## Code Change History
##
## 2019-03-28 *Adjusted displayed package descriptions format. 
##            *Added message if there are no packages to update.
##            *if there are no packages to update, do not create a report.
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
if [ -s uplist.tmp ] ; then  # If tmp file has data (list of packages to be updated).
   TITLE="***Description of upgradeable packages***"
   echo $TITLE > uplist2.tmp
   #
   echo $TITLE
   echo
   # Extract the "Description" from the raw data output from command "apt-cache show <pkg name>". 
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
else
   echo
   echo "No packages to update. All packages are up to date."
   #rm uplist*.tmp
fi
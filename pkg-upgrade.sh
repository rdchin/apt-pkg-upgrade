#!/bin/bash
#
VERSION="2019-09-06 22:50"
THIS_FILE="pkg-upgrade.sh"
#
# Brief Description
#
# Script pkg-upgrade.sh will show a description of each upgradeable package before
# upgrading each package.
#
# Usage: bash pkg-upgrade.sh
#        (not sh pkg-upgrade.sh)
#
# After each edit made, please update Code History and VERSION.
##
## Code Change History
##
## 2019-09-06 *Main Program regression bug fixes and minor enhancements.
##
## 2019-09-05 *Main Program enhancement if no updates, then do not offer
##             to list package descriptions.
##
## 2019-08-29 *f_list_packages added for modularity.
##            *Main Program added question for choice to list package
##             descriptions before upgrading or not.
##
## 2019-04-02 *f_abort_txt, f_test_connection added.
##            *Main Program move f_test_connection after f_arguments.
##            *f_arguments pattern matching adjusted.
##
## 2019-03-31 *Main Program added f_help_message to beginning of Main Program. 
##
## 2019-03-29 *f_arguments, f_code_history_txt, f_version_txt, f_help_message
##             added actions for optional command arguments.
##            *f_script_path, f_press_enter_key_to_continue added.
##
## 2019-03-28 *Adjusted displayed package descriptions format. 
##            *Added message if there are no packages to update.
##            *If there are no packages to update, do not create a report.
##
## 2019-03-26 *Added detection of installed file viewer.
##
## 2019-03-24 *Initial release.
##
# +----------------------------------------+
# |            Function f_abort_txt        |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: None.
# Outputs: None.
#
f_abort_txt() {
      echo $(tput setaf 1) # Set font to color red.
      echo >&2 "***************"
      echo >&2 "*** ABORTED ***"
      echo >&2 "***************"
      echo
      echo "An error occurred. Exiting..." >&2
      exit 1
      echo -n $(tput sgr0) # Set font to normal color.
} # End of function f_abort_txt.
#
# +----------------------------------------+
# |         Function f_script_path         |
# +----------------------------------------+
#
#  Inputs: $BASH_SOURCE (System variable).
#    Uses: None.
# Outputs: SCRIPT_PATH.
#
f_script_path () {
      # BASH_SOURCE[0] gives the filename of the script.
      # dirname "{$BASH_SOURCE[0]}" gives the directory of the script
      # Execute commands: cd <script directory> and then pwd
      # to get the directory of the script.
      # NOTE: This code does not work with symlinks in directory path.
      #
      # !!!Non-BASH environments will give error message about line below!!!
      SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
}  # End of function f_script_path.
#
# +----------------------------------------+
# |        Function f_test_connection      |
# +----------------------------------------+
#
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 Network name of server. 
#    Uses: None.
# Outputs: ERROR. 
#
f_test_connection () {
      # Check if there is an internet connection before doing a download.
      case $1 in
           whiptail | dialog)
           ping -c 1 -q $2 >/dev/null # Ping server address.
           ERROR=$?
           if [ $ERROR -ne 0 ] ; then
              $1 --title "Ping Test Connection" --msgbox "Network connnection to $2 file server failed.\nCannot get list of upgradeable packages." 12 70
           fi
           ;;
           text)
           echo
           echo "Test LAN Connection to $2"
           echo
           ping -c 1 -q $2  # Ping server address.
           ERROR=$?
           echo
           if [ $ERROR -ne 0 ] ; then
              echo -n $(tput setaf 1) # Set font to color red.
              echo -n $(tput bold)
              echo ">>> Network connnection to $2 failed. <<<"
              echo "    Cannot get list of upgradeable packages."
              echo -n $(tput sgr0)
              f_press_enter_key_to_continue
           fi
           ;;
      esac
} # End of function f_test_connection.
#
# +----------------------------------------+
# | Function f_press_enter_key_to_continue |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: X.
# Outputs: None.
#
f_press_enter_key_to_continue () { # Display message and wait for user input.
      echo
      echo -n "Press '"Enter"' key to continue."
      read X
      unset X  # Throw out this variable.
} # End of function f_press_enter_key_to_continue.
#
# +----------------------------------------+
# |       Function f_list_packages         |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: None.
# Outputs: None.
#
f_list_packages () {
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
      else
         echo
         echo "No packages to update. All packages are up to date."
      fi
}  # End of function f_list_packages.
#
# +----------------------------------------+
# |         Function f_arguments           |
# +----------------------------------------+
#
#  Inputs: $1=Argument
#             [--help] [ --? ] [ -? ] [ ? ]
#             [--about]
#             [--version] [ -ver ] [ -v ]
#             [--history]
#             [ text ] [ dialog ] [ whiptail ]
#    Uses: None.
# Outputs: ERROR.
#
f_arguments () {
      # If there is more than one argument, display help USAGE message, because only one argument is allowed.
      if [ $# -ge 2 ] ; then
         f_help_message
         exit 0  # This cleanly closes the process generated by #!bin/bash. 
                 # Otherwise every time this script is run, another instance of
                 # process /bin/bash is created using up resources.
      fi
      #
      case $1 in
           --help | "--?" | "-?" | "?")
           # If the one argument is "--help" display help USAGE message.
           f_help_message
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           -v | -ver | --version | --about)
           f_about_txt
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           --history)
           f_code_history_txt
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           -*)
           # If the one argument is "-<unrecognized>" display help USAGE message.
           f_help_message
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           "text" | "dialog" | "whiptail")
           GUI=$1  # Do not exit script, no "exit 0".
           ;;
           "")
           # Null is a valid argument.
           ;;
           *)
           # if the argument is out of bounds, then display the help USAGE message.
           echo "Invalid argument input. See help above or type command, \"bash $THIS_FILE --help\""
           f_abort_txt
           ;;
      esac
}  # End of function f_arguments.
#
# +------------------------------------+
# |        Function f_about_txt        |
# +------------------------------------+
#
#  Inputs: THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_about_txt () {
      echo
      echo "Script $THIS_FILE."
      echo "Version: $VERSION"
      echo
      echo "Script pkg-upgrade.sh will show a description of each upgradeable package"
      echo "before upgrading each package."
      echo
}  # End of f_about_txt.
#
# +----------------------------------------+
# |       Function f_code_history_txt      |
# +----------------------------------------+
#
#  Inputs: THIS_DIR, THIS_FILE.
#    Uses: None.
# Outputs: None.
#
f_code_history_txt () {
      # Display Code History (all lines beginning with "##" but do not print "##").
      # sed substitutes null for "##" at the beginning of each line
      # so it is not printed.
      # less -P customizes prompt for
      # %f <FILENAME> page <num> of <pages> (Spacebar, PgUp/PgDn . . .)
      sed -n 's/^##//'p $THIS_DIR/$THIS_FILE | less -P '(Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)'
}  # End of function f_code_history_txt.
#
# +----------------------------------------+
# |       Function f_help_message          |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: None.
# Outputs: None.
#
f_help_message () {
      echo
      echo "Usage: bash pkg-upgrade.sh [OPTION]"
      echo
      echo "       bash pkg-upgrade.sh --help     # Displays this help message."
      echo "       bash pkg-upgrade.sh --version  # Displays script version."
      echo "       bash pkg-upgrade.sh --about    # Displays script version."
      echo "       bash pkg-upgrade.sh --history  # Displays script code history."
      echo
}  # End of function f_help_message.
#
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
clear  # Clear screen.
echo "***************************************"
echo "***  Running script $THIS_FILE  ***"
echo "***    Revision $VERSION    ***"
echo "***************************************"
echo
sleep 1  # pause for 3 seconds automatically.
#
TEMP_FILE="uplist.tmp"
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
##
TEMP_FILE="uplist2.tmp"
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
f_help_message
#
f_script_path
THIS_DIR=$SCRIPT_PATH
#
# Test for Optional Arguments.
f_arguments $1  # Also sets variable GUI.
#
f_test_connection text 8.8.8.8
if [ $ERROR -ne 0 ] ; then
   f_abort_txt   
fi
#
sudo apt update | tee -a uplist.tmp
X=$(tail -n 1 uplist.tmp)
if [ "$X" = "All packages are up to date." ] ; then
   echo "Up-to-date"
else
   echo "Not up-to-date"
   echo
   echo -n "Do you want to view package descriptions? (there may be a delay to display descriptions) y/N: "
   read X
   case $X in
        [Yy] | [Yy][Ee] | [Yy][Ee][Ss] ) f_list_packages ;;
        * ) ;;
   esac
   echo
   echo
   echo "   *** Upgrading Packages ***"
   echo
   sudo apt upgrade
fi
#
unset X  # Throw out this variable.
#
if [ -r uplist.tmp ] ; then
   rm uplist.tmp
fi
#
if [ -r uplist2.tmp ] ; then
   rm uplist2.tmp
fi
# All dun dun noodles.

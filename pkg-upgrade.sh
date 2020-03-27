#!/bin/bash
#
VERSION="2020-03-26 21:01"
THIS_FILE="pkg-upgrade.sh"
#
#@ Brief Description
#@
#@ Script pkg-upgrade.sh will show a description of each upgradable package before
#@ upgrading each package.
#@
#@ Usage: bash pkg-upgrade.sh
#@        (not sh pkg-upgrade.sh)
#@
#@ After each edit made, please update Code History and VERSION.
#
#?
#? Usage: bash pkg-upgrade.sh [OPTION]
#?        bash pkg-upgrade.sh --help     # Displays this help message.
#?        bash pkg-upgrade.sh --version  # Displays script version.
#?        bash pkg-upgrade.sh --about    # Displays script version.
#?        bash pkg-upgrade.sh --history  # Displays script code history.
#?
##
## Code Change History
##
## 2020-03-26 *Rewrote code to include Dialog UI along with CLI.
##
## 2020-03-22 *f_list_packages improved display of package descriptions.
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
#
# +----------------------------------------+
# |              Function f_abort          |
# +----------------------------------------+
#
#  Inputs: $1=GUI.
#    Uses: None.
# Outputs: None.
#
f_abort () {
      case $1 in
           whiptail | dialog)
           f_message $1 "Exiting Script" "\n\n                        ***************\n                        *** ABORTED ***\n                        ***************\n\n         An error occurred, cannot continue. Exiting script."
           #
           clear # Blank the screen.
           #
           ;;
           *)
           echo $(tput setaf 1)    # Set font to color red.
           echo -n $(tput bold)
           f_message $1 "Exiting Script" "***************\n*** ABORTED ***\n***************\n\nAn error occurred, cannot continue. Exiting script"
           echo -n $(tput sgr0) # Set font to normal color.
           ;;
      esac
      exit 1
} # End of function f_abort.
#
# +----------------------------------------+
# |          Function f_detect_ui          |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: ERROR.
# Outputs: GUI (dialog, whiptail, text).
#
f_detect_ui () {
      command -v dialog >/dev/null
      # "&>/dev/null" does not work in Debian distro.
      # 1=standard messages, 2=error messages, &=both.
      ERROR=$?
      # Is Dialog GUI installed?
      if [ $ERROR -eq 0 ] ; then
         # Yes, Dialog installed.
         GUI="dialog"
      else
         # Is Whiptail GUI installed?
         command -v whiptail >/dev/null
         # "&>/dev/null" does not work in Debian distro.
         # 1=standard messages, 2=error messages, &=both.
         ERROR=$?
         if [ $ERROR -eq 0 ] ; then
            # Yes, Whiptail installed.
            GUI="whiptail"
         else
            # No CLI GUIs installed
            GUI="text"
         fi
      fi
} # End of function f_detect_ui.
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
              f_message $1 "Ping Test Internet Connection" "Internet connnection to $2 file server failed.\n    Cannot get list of upgradable packages."
              else
              f_message $1 "Ping Test Internet Connection" "Internet connnection to $2 is good."
           fi
            #
           clear # Blank the screen.
           #
           ;;
           *)
           echo
           echo "Test Internet Connection to $2"
           echo
           ping -c 1 -q $2  # Ping server address.
           ERROR=$?
           if [ $ERROR -ne 0 ] ; then
              echo -n $(tput setaf 1) # Set font to color red.
              echo -n $(tput bold)
              f_message $1 "Ping Test Internet Connecton" ">>> Internet connnection to $2 failed. <<<\n    Cannot get list of upgradable packages."
              echo -n $(tput sgr0)
              f_press_enter_key_to_continue
           else
              f_message $1 "Ping Test Internet Connecton" "Internet connnection to $2 is good."
              f_press_enter_key_to_continue
              echo
              echo
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
           f_abort text
           ;;
      esac
}  # End of function f_arguments.
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
      # File uplist.tmp contains only the package names of upgradable packages.
      # File uplist2.tmp is a scratch file to support the creation of uplist.tmp.
      sudo apt list --upgradable > uplist.tmp  # Raw data output from command, "apt list".
      awk -F / '{ print $1 }' uplist.tmp > uplist2.tmp  # Parse raw data to show each package title only.
      sed -i s/Listing...// uplist2.tmp  # Delete string "Listing...Done" from list of packages.
      awk 'NF' uplist2.tmp > uplist.tmp  # Delete empty line left-over from deleting string.
      #
      if [ -s uplist.tmp ] ; then  # If tmp file has data (list of packages to be updated).
         #
         # Create file uplist2.tmp to contain package name and short description.
	 #
         TITLE="***Description of upgradable packages***"
         echo $TITLE > uplist2.tmp
         #
         echo $TITLE
         echo
	 #
         # Extract the "Description" from the raw data output from command "apt-cache show <pkg name>". 
         # Read the file uplist.tmp.
         while read XSTR
         do
               echo >> uplist2.tmp
               echo "---------------------------" >> uplist2.tmp
               echo $XSTR >> uplist2.tmp
	       # grep all package description text between strings "Description" and "Description-md5".
               apt-cache show $XSTR | grep Description --max-count=1 --after-context=99 | grep Description-md5 --max-count=1 --before-context=99 | sed 's/^Description-md5.*$//'>> uplist2.tmp
         done < uplist.tmp
         #
         f_show_package_descriptions
      else
         f_message $GUI "Up-to-Date" "No packages to update. All packages are up to date."
      fi
}  # End of function f_list_packages.
#
# +----------------------------------------+
# |  Function f_show_package_descriptions  |
# +----------------------------------------+
#
#  Inputs: GUI.
#    Uses: None.
# Outputs: None.
#
f_show_package_descriptions () {
      case $GUI in
           dialog | whiptail)
           # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
           # The "Word Count" wc command output will not include the TEMP_FILE name
           # if you redirect "<$TEMP_FILE" into wc.
           TEMP_FILE="uplist2.tmp"
           X=$(wc --max-line-length <$TEMP_FILE)
           let X=X+6
           #
           # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
           Y=$(wc --lines <$TEMP_FILE)
           let Y=Y+6
           #
           $GUI --title "About $THIS_FILE (use arrow keys to scroll up/down/side-ways)" --textbox $TEMP_FILE $Y $X
           #
           if [ -r $TEMP_FILE ] ; then
              rm $TEMP_FILE
           fi
           #
           clear # Blank the screen.
           #
           ;;
           text)
           # Detect installed file viewer ("most", "more", or "less" file viewers).
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
	   #
           clear # Blank the screen.
           #
           ;;    
      esac
}  # End of function f_show_package_descriptions.
#
# +------------------------------+
# |       Function f_message     |
# +------------------------------+
#
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - Title.
#          $3 - Text message. 
#    Uses: None.
# Outputs: ERROR. 
#
f_message () {
      # Check if there is an internet connection before doing a download.
      case $1 in
           whiptail | dialog)
           $1 --title "$2" --msgbox "$3" 12 70
           ;;
           *)
           echo
           echo -e "$2"
           echo
           echo -e "$3"
           echo
           ;;
      esac
} # End of function f_message.
#
# +------------------------------------+
# |          Function f_about          |
# +------------------------------------+
#
#  Inputs: $1=GUI (May or may not exist).
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_about () {
      case $GUI in
           "dialog" | "whiptail") 
           f_about_gui $GUI
           ;;
           *)
           f_about_txt
           ;;
      esac
} # End of f_about.
#
# +------------------------------------+
# |        Function f_about_txt        |
# +------------------------------------+
#
#  Inputs: None.
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_about_txt () {
      #
      THIS_FILE="pkg-upgrade.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      clear # Blank the screen.
      echo
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed reads each line of this file and substitutes null for "#@"
      # at the beginning of each line so it is not printed.
      sed -n 's/^#@//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      # less -P customizes prompt for
      # %f <FILENAME> page <num> of <pages> (Spacebar, PgUp/PgDn . . .)
      #less -P '(Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)' $TEMP_FILE
      #
      # Alternate display using <Enter> instead of <q> to continue.
      cat $TEMP_FILE
      f_press_enter_key_to_continue
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
      clear # Blank the screen.
      #
} # End of f_about_txt.
#
# +------------------------------------+
# |        Function f_about_gui        |
# +------------------------------------+
#
#  Inputs: $1=GUI - "dialog" or "whiptail" The CLI GUI application in use.
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_about_gui () {
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="pkg-upgrade.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed reads each line of this file and substitutes null for "#@"
      # at the beginning of each line so it is not printed.
      sed -n 's/^#@//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
      # The "Word Count" wc command output will not include the TEMP_FILE name
      # if you redirect "<$TEMP_FILE" into wc.
      X=$(wc --max-line-length <$TEMP_FILE)
      let X=X+6
      #
      # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
      Y=$(wc --lines <$TEMP_FILE)
      let Y=Y+6
      #
      $1 --title "About $THIS_FILE (use arrow keys to scroll up/down/side-ways)" --textbox $TEMP_FILE $Y $X
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
      clear # Blank the screen.
      #
} # End of f_about_gui.
#
# +------------------------------------+
# |      Function f_code_history       |
# +------------------------------------+
#
#  Inputs: $1=GUI (May or may not exist).
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_code_history () {
      case $GUI in
           "dialog" | "whiptail") 
           f_code_history_gui $GUI
           ;;
           *)
           f_code_history_txt
           ;;
       esac
} # End of f_code_history.
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
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="pkg-upgrade.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      clear # Blank the screen.
      echo
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "##" but do not print "##").
      # sed reads each line of this file and substitutes null for "##"
      # at the beginning of each line so it is not printed.
      sed -n 's/^##//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      # less -P customizes prompt for
      # %f <FILENAME> page <num> of <pages> (Spacebar, PgUp/PgDn . . .)
      less -P '(Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)' $TEMP_FILE
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
      clear # Blank the screen.
      #
} # End of function f_code_history_txt.
#
# +----------------------------------------+
# |       Function f_code_history_gui      |
# +----------------------------------------+
#
#  Inputs: $1=GUI - "dialog" or "whiptail" The CLI GUI application in use.
#          THIS_DIR, THIS_FILE.
#    Uses: None.
# Outputs: temp.txt.
#
f_code_history_gui () {
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="pkg-upgrade.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed substitutes null for "#@" at the beginning of each line
      # so it is not printed.
      sed -n 's/^##//'p $THIS_DIR/$THIS_FILE >>$TEMP_FILE
      #
      # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
      # The "Word Count" wc command output will not include the TEMP_FILE name
      # if you redirect "<$TEMP_FILE" into wc.
      X=$(wc --max-line-length <$TEMP_FILE)
      let X=X+10
      #
      # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
      Y=$(wc --lines <$TEMP_FILE)
      let Y=Y+6
      #
      $1 --title "Code History (use arrow keys to scroll up/down/side-ways)" --textbox $TEMP_FILE $Y $X
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
      clear # Blank the screen.
      #
} # End of function f_code_history_gui.
#
# +------------------------------------+
# |      Function f_help_message       |
# +------------------------------------+
#
#  Inputs: $1=GUI (May or may not exist).
#    Uses: None.
# Outputs: None.
#
f_help_message () {
      case $GUI in
           "dialog" | "whiptail") 
           f_help_message_gui $GUI
           ;;
           *)
           f_help_message_txt
           ;;
      esac
} # End of f_code_history.
#
# +----------------------------------------+
# |     Function f_help_message_txt        |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: None.
# Outputs: None.
#
f_help_message_txt () {
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="pkg-upgrade.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      clear # Blank the screen.
      echo
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#?" but do not print "#?").
      # sed reads each line of this file and substitutes null for "#?"
      # at the beginning of each line so it is not printed.
      sed -n 's/^#?//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      # less -P customizes prompt for
      # %f <FILENAME> page <num> of <pages> (Spacebar, PgUp/PgDn . . .)
      #less -P '(Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)' $TEMP_FILE
      #
      # Alternate display using <Enter> instead of <q> to continue.
      cat $TEMP_FILE
      f_press_enter_key_to_continue
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
      clear # Blank the screen.
      #
} # End of function f_help_message_txt.
#
# +----------------------------------------+
# |     Function f_help_message_gui        |
# +----------------------------------------+
#
#  Inputs: $1=GUI - "dialog" or "whiptail" the preferred user-interface.
#    Uses: None.
# Outputs: None.
#
f_help_message_gui () {
      #
      # The variable $THIS_FILE is set to a library file when
      # menu is generated so it needs to be reset to "menu.sh".
      THIS_FILE="pkg-upgrade.sh"
      TEMP_FILE=$THIS_FILE"_temp.txt"
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed substitutes null for "#@" at the beginning of each line
      # so it is not printed.
      sed -n 's/^#?//'p $THIS_DIR/$THIS_FILE >>$TEMP_FILE
      #
      # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
      # The "Word Count" wc command output will not include the TEMP_FILE name
      # if you redirect "<$TEMP_FILE" into wc.
      X=$(wc --max-line-length <$TEMP_FILE)
      let X=X+10
      #
      # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
      Y=$(wc --lines <$TEMP_FILE)
      let Y=Y+6
      #
      $1 --title "Help Message (use arrow keys to scroll up/down/side-ways)" --textbox $TEMP_FILE $Y $X
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
      clear # Blank the screen.
      #
} # End of f_help_message_gui.
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
clear  # Clear screen.
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
f_script_path
THIS_DIR=$SCRIPT_PATH
#
# Test for Optional Arguments.
f_arguments $1  # Also sets variable GUI.
#
# If command already specifies GUI, then do not detect GUI i.e. "bash dropfsd.sh dialog" or "bash dropfsd.sh text".
if [ -z $GUI ] ; then
   # Test for GUI (Whiptail or Dialog) or pure text environment.
   f_detect_ui
fi
#
# Show About this script message.
f_about $GUI
#
# Show Usage message.
f_help_message $GUI
#
#GUI="whiptail"  #Test diagnostic line.
#GUI="dialog"    #Test diagnostic line.
#GUI="text"      #Test diagnostic line.
#
f_test_connection $GUI 8.8.8.8
if [ $ERROR -ne 0 ] ; then
   f_abort $GUI
fi
#
# Run a sudo command to catch bad sudo passwords.
sudo --validate
ERROR=$?
if [ $ERROR -ne 0 ] ; then
   f_abort $GUI
fi
#
sudo apt update | tee -a uplist.tmp
#
#
# Read the last line in the file uplist.tmp.
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

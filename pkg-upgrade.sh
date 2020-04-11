#!/bin/bash
#
# ©2020 Copyright 2020 Robert D. Chin
#
# Usage: bash pkg-upgrade.sh
#        (not sh pkg-upgrade.sh)
#
# +----------------------------------------+
# |        Default Variable Values         |
# +----------------------------------------+
#
VERSION="2020-04-11 15:01"
THIS_FILE="pkg-upgrade.sh"
#
# +----------------------------------------+
# |            Brief Description           |
# +----------------------------------------+
#
#@ Brief Description
#@
#@ Script pkg-upgrade.sh will show a description of each upgradable package before
#@ upgrading each package.
#@
#@ Required scripts: None
#@
#@ Usage: bash pkg-upgrade.sh
#@        (not sh pkg-upgrade.sh)
#
# +----------------------------------------+
# |             Help and Usage             |
# +----------------------------------------+
#
#?    Usage: bash pkg-upgrade.sh [OPTION]
#? Examples:
#?bash pkg-upgrade.sh text       Use Cmd-line user-interface (80x24 min.).
#?                    dialog     Use Dialog   user-interface.
#?                    whiptail   Use Whiptail user-interface.
#?
#?bash pkg-upgrade.sh --help     Displays this help message.
#?                    -?
#?
#?bash pkg-upgrade.sh --about    Displays script version.
#?                    --version
#?                    --ver
#?                    -v
#?
#?bash pkg-upgrade.sh --history  Displays script code history.
#?                    --hist
#
# +----------------------------------------+
# |           Code Change History          |
# +----------------------------------------+
#
##
## Code Change History
##
## (After each edit made, please update Code History and VERSION.)
##
## 2020-04-11 *f_message and messages throughout script rewritten
##             for better compatibility between CLI, Dialog, Whiptail. 
##
## 2020-04-06 *f_arguments standardized.
##
## 2020-04-05 *f_message made more Whiptail compatible.
##
## 2020-03-31 *f_message, f_test_connection bug fixes for Whiptail.
##
## 2020-03-31 *f_message rewritten to handle string and temp file input.
##
## 2020-03-28 *f_bad_sudo_password added.
##            *f_arguments added --hist.
##
## 2020-03-27 *f_abort, f_ques_upgrade improved Dialog UI messages.
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
      #
      case $1 in
           dialog | whiptail)
           # Temporary file has \Z commands embedded for red bold font.
           #
           # \Z commands are used by Dialog to change font attributes 
           # such as color, bold/normal.
           #
           # A single string is used with echo -e \Z1\Zb\Zn commands
           # and output as a single line of string wit \Zn commands embedded.
           #
           # Single string is neccessary because \Z commands will not be
           # recognized in a temp file containing <CR><LF> multiple lines also.
           #
           #f_message $1 "NOK" "Exiting script" " \n\Z1\ZbFATAL ERROR\n \n \nAn error occurred, cannot continue.\n Exiting script.\Zn"
           f_message $1 "NOK" "Exiting script" " \n\Z1\ZbAn error occurred, cannot continue. Exiting script.\Zn"
           ;;
           *)
           # The only reason to have a separate message for GUI=text, is for red color fonts.
           echo $(tput setaf 1)    # Set font to color red.
           echo -n $(tput bold)
           f_message $1 "NOK" "Exiting Script" ">>>FATAL ERROR<<<\n\nAn error occurred, cannot continue."
           echo -n $(tput sgr0)    # Set font to normal color.
           ;;
      esac
      exit 1
} # End of function f_abort.
#
# +----------------------------------------+
# |      Function f_bad_sudo_password      |
# +----------------------------------------+
#
#  Inputs: $1=GUI.
#    Uses: None.
# Outputs: None.
#
f_bad_sudo_password () {
      #
      case $1 in
           whiptail | dialog)
           f_message $1 "NOK" "Incorrect Sudo password" "\n\Z1\ZbWrong Sudo password. Cannot upgrade software.\Zn"
           #
           clear # Blank the screen.
           #
           ;;
           *)
           # The only reason to have a separate message for GUI=text, is for red color fonts.
           echo
           echo $(tput setaf 1)    # Set font to color red.
           echo -n $(tput bold)
           f_message $1 "NOK" "     Password Error" ">>> Wrong Sudo password <<<\n\n\nCannot upgrade software. Exiting script."
           echo -n $(tput sgr0)    # Set font to normal color.
           ;;
      esac
} # End of function f_bad_sudo_password.
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
      #
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
      #
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
      #
      # Check if there is an internet connection before doing a download.
      case $1 in
           whiptail | dialog)
           ping -c 1 -q $2 >/dev/null # Ping server address.
           ERROR=$?
           if [ $ERROR -ne 0 ] ; then
              f_message $1 "NOK" "Ping Test Internet Connection" " \n\Z1\Zb  No Internet connection, cannot get list of upgradable packages.\Zn"
              else
              f_message $1 "NOK" "Ping Test Internet Connection" "Internet connnection to $2 is good."
           fi
            #
           clear # Blank the screen.
           #
           ;;
           *)
           # The only reason to have a separate message for GUI=text, is for red color fonts.
           echo
           echo "Test Internet Connection to $2"
           echo
           ping -c 1 -q $2  # Ping server address.
           ERROR=$?
           if [ $ERROR -ne 0 ] ; then
              echo -n $(tput setaf 1) # Set font to color red.
              echo -n $(tput bold)
              f_message $1 "NOK" "Ping Test Internet Connecton" ">>> No Internet connection, cannot get list of upgradable packages. <<<"
              echo -n $(tput sgr0)
           else
              f_message $1 "NOK" "Ping Test Internet Connecton" "Internet connnection to $2 is good."
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
f_press_enter_key_to_continue () { 
      #
      # Display message and wait for user input.
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
         f_help_message text
         exit 0  # This cleanly closes the process generated by #!bin/bash. 
                 # Otherwise every time this script is run, another instance of
                 # process /bin/bash is created using up resources.
      fi
      #
      case $1 in
           --help | "-?")
           # If the one argument is "--help" display help USAGE message.
           f_help_message text
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           --about | --version | --ver | -v)
           f_about text
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           --history | --hist)
           f_code_history text
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           -*)
           # If the one argument is "-<unrecognized>" display help USAGE message.
           f_help_message text
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
           "" | "text" | "dialog" | "whiptail")
           GUI=$1
           ;;
           *)
           # Display help USAGE message.
           f_help_message text
           exit 0  # This cleanly closes the process generated by #!bin/bash. 
                   # Otherwise every time this script is run, another instance of
                   # process /bin/bash is created using up resources.
           ;;
      esac
} # End of function f_arguments.
#
# +------------------------------------+
# |      Function f_ques_upgrade       |
# +------------------------------------+
#
#  Inputs: $1=GUI.
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_ques_upgrade () {
      #
      # Read the last line in the file uplist.tmp.
      X=$(tail -n 1 uplist.tmp)
      if [ "$X" = "All packages are up to date." ] ; then
         f_message $1 "NOK" "Status of Software Packages" "All packages are at the latest version."
         #
         clear # Blank the screen.
         #
      else
         # Yes/No Question.
         f_yn_question $1 "Y" "View Package Descriptions?" "\nSome packages are not up-to-date and need upgrading.\n\nNote: There may be a delay to display descriptions.\n      (especially if many packages need to be updated)\n\nDo you want to view package descriptions?"

         # ANS=0 when <Yes> button pressed.
         # ANS=1 when <No> button pressed.
         #
         # if <Yes> button pressed, then list packages.
         if [ $ANS -eq 0 ] ; then
            f_list_packages
         fi
         f_message $1 "NOK" "Upgrade Packages" "Running command: \"sudo apt upgrade\" to upgrade packages."
         #
         clear # Blank the screen.
         #
         sudo apt upgrade
      fi
}  # End of function f_ques_upgrade_gui.
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
      #
      # File TEMP_FILE="$THIS_FILE_temp_file.txt" contains only the package names of upgradable packages.
      # File TEMP_FILE2="$THIS_FILE_temp_file2.txt is a scratch file to support the creation of uplist.tmp.
      #
      TEMP_FILE="$THIS_FILE_temp_file.txt"
      # Raw data output from command, "apt list".
      sudo apt list --upgradable > $TEMP_FILE
      #
      # Parse raw data to show each package title only.
      TEMP_FILE2="$THIS_FILE_temp_file2.txt"
      awk -F / '{ print $1 }' $TEMP_FILE > $TEMP_FILE2
      #
      # Delete string "Listing...Done" from list of packages.
      sed -i s/Listing...// $TEMP_FILE2
      #
      # Delete empty line left-over from deleting string.
      awk 'NF' $TEMP_FILE2 > $TEMP_FILE
      #
      # If tmp file has data (list of packages to be updated).
      if [ -s $TEMP_FILE ] ; then
         #
         # Create file $TEMP_FILE2 to contain package name and short description.
         #
         TITLE="***Description of upgradable packages***"
         echo $TITLE > $TEMP_FILE2
         #
         # Extract the "Description" from the raw data output from command "apt-cache show <pkg name>". 
         # Read the file uplist.tmp.
         while read XSTR
         do
               echo >> $TEMP_FILE2
               echo "---------------------------" >> $TEMP_FILE2
               echo $XSTR >> $TEMP_FILE2
               #
               # grep all package description text between strings "Description" and "Description-md5".
               apt-cache show $XSTR | grep Description --max-count=1 --after-context=99 | grep Description-md5 --max-count=1 --before-context=99 | sed 's/^Description-md5.*$//'>> $TEMP_FILE2
         done < $TEMP_FILE
         #
         f_message $GUI "OK" "Package Description" $TEMP_FILE
         #
      else
         f_message $GUI "NOK" "Up-to-Date" "No packages to update. All packages are up to date."
      fi
}  # End of function f_list_packages.
#
# +------------------------------+
# |       Function f_message     |
# +------------------------------+
#
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button at end of text but pause n seconds
#                     to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#          
#    Uses: None.
# Outputs: ERROR. 
#
f_message () {
      #
      case $1 in
           "dialog" | "whiptail")
              # Dialog boxes "--msgbox" "--infobox" can use option --colors with "\Z" commands for font color bold/normal.
              # Dialog box "--textbox" and Whiptail cannot use option --colors with "\Z" commands for font color bold/normal.
              #
              # If text strings have Dialog "\Z" commands for font color bold/normal, 
              # they must be used AFTER \n (line break) commands.
              # Example: "This is a test.\n\Z1\ZbThis is in bold-red letters.\n\ZnThis is in normal font."
              #
              # Get the screen resolution or X-window size.
              # Get rows (height).
              YSCREEN=$(stty size | awk '{ print $1 }')
              # Get columns (width).
              XSCREEN=$(stty size | awk '{ print $2 }')
              #
              # Is $4 a text string or a text file?
              if [ -r "$4" ] ; then
                 # If $4 is a text file.
                 #
                 # If text file, calculate number of lines and length of sentences.
                 # to calculate height and width of Dialog box.
                 #
                 # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
                 # The "Word Count" wc command output will not include the TEMP_FILE name
                 # if you redirect "<$TEMP_FILE" into wc.
                 X=$(wc --max-line-length <$4)
                 #
                 # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
                 Y=$(wc --lines <$4)
                 #
                 if [ "$2" = "OK" ] ; then
                    # $4 is a text file.
                    #If $2 is "OK" then use a Dialog/Whiptail textbox.
                    #
                    case $1 in
                         dialog)
                            # Dialog needs about 6 more lines for the header and [OK] button.
                            let Y=Y+6
                            # If number of lines exceeds screen/window height then set textbox height.
                            if [ $Y -ge $YSCREEN ] ; then
                               Y=$YSCREEN
                            fi
                            #
                            # Dialog needs about 10 more spaces for the right and left window frame. 
                            let X=X+10
                            # If line length exceeds screen/window width then set textbox width.
                            if [ $X -ge $XSCREEN ] ; then
                               X=$XSCREEN
                            fi
                            #
                            # Dialog box "--textbox" and Whiptail cannot use "\Z" commands.
                            # No --colors option for Dialog --textbox.
                            dialog --title "$3" --textbox "$4" $Y $X
                         ;;
                         whiptail)
                            # Whiptail needs about 7 more lines for the header and [OK] button.
                            let Y=Y+7
                            # If number of lines exceeds screen/window height then set textbox height.
                            if [ $Y -ge $YSCREEN ] ; then
                               Y=$YSCREEN
                            fi
                            #
                            # Whiptail needs about 5 more spaces for the right and left window frame. 
                            let X=X+5
                            # If line length exceeds screen/window width then set textbox width.
                            if [ $X -ge $XSCREEN ] ; then
                               X=$XSCREEN
                            fi
                            #
                            # Whiptail does not have option "--colors" with "\Z" commands for font color bold/normal.
                            whiptail --scrolltext --title "$3" --textbox "$4" $Y $X
                         ;;
                    esac
                    #
                 else
                    # $4 is a text file.
                    # If $2 is "NOK" then use a Dialog infobox or Whiptail textbox.
                    case $1 in
                         dialog)
                            # Dialog needs about 6 more lines for the header and [OK] button.
                            let Y=Y+6
                            # If number of lines exceeds screen/window height then set textbox height.
                            if [ $Y -ge $YSCREEN ] ; then
                               Y=$YSCREEN
                            fi
                            #
                            # Dialog needs about 10 more spaces for the right and left window frame. 
                            let X=X+10
                            # If line length exceeds screen/window width then set textbox width.
                            if [ $X -ge $XSCREEN ] ; then
                               X=$XSCREEN
                            fi
                            #
                            # Dialog boxes "--msgbox" "--infobox" can use option --colors with "\Z" commands for font color bold/normal.
                            dialog --colors --title "$3" --infobox "$Z" $Y $X ; sleep 3
                         ;;
                         whiptail)
                            # Whiptail only has options --textbox or --msgbox (not --infobox).
                            # Whiptail does not have option "--colors" with "\Z" commands for font color bold/normal.
                            #
                            # Whiptail needs about 7 more lines for the header and [OK] button.
                            let Y=Y+7
                            # If number of lines exceeds screen/window height then set textbox height.
                            if [ $Y -ge $YSCREEN ] ; then
                               Y=$YSCREEN
                            fi
                            #
                            # Whiptail needs about 5 more spaces for the right and left window frame. 
                            let X=X+5
                            # If line length exceeds screen/window width then set textbox width.
                            if [ $X -ge $XSCREEN ] ; then
                               X=$XSCREEN
                            fi
                            whiptail --title "$3" --textbox "$4" $Y $X
                         ;;
                    esac
                 fi
                 #
                 if [ -r $TEMP_FILE ] ; then
                    rm $TEMP_FILE
                 fi
                 #
              else
                 # If $4 is a text string.
                 #
                 # Does $4 contain "\n"?  Does the string $4 contain multiple sentences?
                 case $4 in
                      *\n*)
                         # Yes, string $4 contains multiple sentences.
                         #
                         # Use command "sed" with "-e" to filter out multiple "\Z" commands.
                         # Filter out "\Z[0-7]", "\Zb", \ZB", "\Zr", "\ZR", "\Zu", "\ZU", "\Zn".
                         ZNO=$(echo $4 | sed -e 's|\\Z0||g' -e 's|\\Z1||g' -e 's|\\Z2||g' -e 's|\\Z3||g' -e 's|\\Z4||g' -e 's|\\Z5||g' -e 's|\\Z6||g' -e 's|\\Z7||g' -e 's|\\Zb||g' -e 's|\\ZB||g' -e 's|\\Zr||g' -e 's|\\ZR||g' -e 's|\\Zu||g' -e 's|\\ZU||g' -e 's|\\Zn||g')
                         # Calculate the length of the longest sentence with the $4 string.
                         # How many sentences?
                         # Replace "\n" with "%" and then use awk to count how many sentences.
                         # Save number of sentences.
                         Y=$(echo $ZNO | sed 's|\\n|%|g'| awk -F '%' '{print NF}')
                         #
                         # Extract each sentence
                         # Replace "\n" with "%" and then use awk to print current sentence.
                         TEMP_FILE=$THIS_FILE"_temp.txt"
                         echo -e $ZNO > $TEMP_FILE
                         # This is the long way... echo $ZNO | sed 's|\\n|%|g'| awk -F "%" '{ for (i=1; i<NF+1; i=i+1) print $i }' >$TEMP_FILE
                         # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
                         # The "Word Count" wc command output will not include the TEMP_FILE name
                         # if you redirect "<$TEMP_FILE" into wc.
                         X=$(wc --max-line-length < $TEMP_FILE)
                      ;;
                      *)
                         # No, line length is $4 string length. 
                         X=$(echo -n "$4" | wc -c)
                         Y=1
                      ;;
                 esac
                 #
                 if [ "$2" = "OK" ] ; then
                    # $4 is a text string.
                    # If $2 is "OK" then use a Dialog/Whiptail msgbox.
                    #
                    # Calculate line length of $4 if it contains "\n" <new line> markers.
                    # Find length of all sentences delimited by "\n"
                    #
                    case $1 in
                         dialog)
                            # Dialog needs about 5 more lines for the header and [OK] button.
                            let Y=Y+5
                            # If number of lines exceeds screen/window height then set textbox height.
                            if [ $Y -ge $YSCREEN ] ; then
                               Y=$YSCREEN
                            fi
                            #
                            # Dialog needs about 10 more spaces for the right and left window frame. 
                            let X=X+10
                            # If line length exceeds screen/window width then set textbox width.
                            if [ $X -ge $XSCREEN ] ; then
                               X=$XSCREEN
                            fi
                            #
                            # Dialog boxes "--msgbox" "--infobox" can use option --colors with "\Z" commands for font color bold/normal.
                            dialog --colors --title "$3" --msgbox "$4" $Y $X
                         ;;
                         whiptail)
                            # Whiptail only has options --textbox or--msgbox (not --infobox).
                            # Whiptail does not have option "--colors" with "\Z" commands for font color bold/normal.
                            # Filter out any "\Z" commands when using the same string for both Dialog and Whiptail.
                            # Use command "sed" with "-e" to filter out multiple "\Z" commands.
                            # Filter out "\Z[0-7]", "\Zb", \ZB", "\Zr", "\ZR", "\Zu", "\ZU", "\Zn".
                            ZNO=$(echo $4 | sed -e 's|\\Z0||g' -e 's|\\Z1||g' -e 's|\\Z2||g' -e 's|\\Z3||g' -e 's|\\Z4||g' -e 's|\\Z5||g' -e 's|\\Z6||g' -e 's|\\Z7||g' -e 's|\\Zb||g' -e 's|\\ZB||g' -e 's|\\Zr||g' -e 's|\\ZR||g' -e 's|\\Zu||g' -e 's|\\ZU||g' -e 's|\\Zn||g')
                            #
                            # Whiptail needs about 6 more lines for the header and [OK] button.
                            let Y=Y+6
                            # If number of lines exceeds screen/window height then set textbox height.
                            if [ $Y -ge $YSCREEN ] ; then
                               Y=$YSCREEN
                            fi
                            #
                            # Whiptail needs about 5 more spaces for the right and left window frame. 
                            let X=X+5
                            # If line length exceeds screen/window width then set textbox width.
                            if [ $X -ge $XSCREEN ] ; then
                               X=$XSCREEN
                            fi
                            #
                            whiptail --title "$3" --msgbox "$ZNO" $Y $X
                         ;;
                    esac
                 else
                    # $4 is a text string.
                    # If $2 in "NOK" then use a Dialog infobox or Whiptail msgbox.
                    #
                    case $1 in
                         dialog)
                            # Dialog boxes "--msgbox" "--infobox" can use option --colors with "\Z" commands for font color bold/normal.
                            # Dialog needs about 5 more lines for the header and [OK] button.
                            let Y=Y+5
                            # If number of lines exceeds screen/window height then set textbox height.
                            if [ $Y -ge $YSCREEN ] ; then
                               Y=$YSCREEN
                            fi
                            #
                            # Dialog needs about 10 more spaces for the right and left window frame. 
                            let X=X+6
                            # If line length exceeds screen/window width then set textbox width.
                            if [ $X -ge $XSCREEN ] ; then
                               X=$XSCREEN
                            fi
                            #
                            dialog --colors --title "$3" --infobox "$4" $Y $X ; sleep 3
                         ;;
                         whiptail)
                            # Whiptail only has options --textbox or--msgbox (not --infobox).
                            # Whiptail does not have option "--colors" with "\Z" commands for font color bold/normal.
                            # Filter out any "\Z" commands when using the same string for both Dialog and Whiptail.
                            # Use command "sed" with "-e" to filter out multiple "\Z" commands.
                            # Filter out "\Z[0-7]", "\Zb", \ZB", "\Zr", "\ZR", "\Zu", "\ZU", "\Zn".
                            ZNO=$(echo $4 | sed -e 's|\\Z0||g' -e 's|\\Z1||g' -e 's|\\Z2||g' -e 's|\\Z3||g' -e 's|\\Z4||g' -e 's|\\Z5||g' -e 's|\\Z6||g' -e 's|\\Z7||g' -e 's|\\Zb||g' -e 's|\\ZB||g' -e 's|\\Zr||g' -e 's|\\ZR||g' -e 's|\\Zu||g' -e 's|\\ZU||g' -e 's|\\Zn||g')
                            #
                            # Whiptail needs about 6 more lines for the header and [OK] button.
                            let Y=Y+6
                            # If number of lines exceeds screen/window height then set textbox height.
                            if [ $Y -ge $YSCREEN ] ; then
                               Y=$YSCREEN
                            fi
                            #
                            # Whiptail needs about 5 more spaces for the right and left window frame. 
                            let X=X+5
                            # If line length exceeds screen/window width then set textbox width.
                            if [ $X -ge $XSCREEN ] ; then
                               X=$XSCREEN
                            fi
                            #
                            whiptail --title "$3" --msgbox "$ZNO" $Y $X
                         ;;
                     esac
                  fi
              fi
              ;;
           *)
              # Text only
              #Is $4 a text string or a text file?
              #
              if [ -r "$4" ] ; then
                 # If $4 is a text file.
                 #
                 if [ "$2" = "OK" ] ; then
                    # If $2 is "OK" then use command "less".
                    #
                    clear  # Blank the screen.
                    #
                    # Display text file contents.
                    less -P '%P\% (Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)' $4
                    #
                    clear  # Blank the screen.
                    #
                 else
                    # If $2 is "NOK" then use "cat" and "sleep" commands to give time to read it.
                    #
                    clear  # Blank the screen.
                    # Display title.
                    echo
                    echo $3
                    echo
                    echo
                    # Display text file contents.
                    cat $4
                    sleep 5
                    #
                    clear  # Blank the screen.
                    #
                 fi
                 #
                 if [ -r $TEMP_FILE ] ; then
                    rm $TEMP_FILE
                 fi
                 #
              else
                 # If $4 is a text string.
                 #
                 if [ "$2" = "OK" ] ; then
                    # If $2 is "OK" then use f_press_enter_key_to_continue.
                    #
                    clear  # Blank the screen.
                    #
                    # Display title.
                    echo
                    echo -e $3
                    echo
                    echo
                    # Display text file contents.
                    echo -e $4
                    echo
                    f_press_enter_key_to_continue
                    #
                    clear  # Blank the screen.
                    #
                 else
                    # If $2 is "NOK" then use "echo" followed by "sleep" commands
                    # to give time to read it.
                    #
                    clear  # Blank the screen.
                    #
                    # Display title.
                    echo
                    echo -e $3
                    echo
                    echo
                    # Display text file contents.
                    echo -e $4
                    echo
                    echo
                    sleep 5
                    #
                    clear  # Blank the screen.
                    #
                 fi
              fi
           ;;
      esac
} # End of function f_message.
#
# +------------------------------------+
# |          Function f_about          |
# +------------------------------------+
#
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_about () {
      #
      TEMP_FILE=$THIS_FILE"_temp.txt"
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed substitutes null for "#@" at the beginning of each line
      # so it is not printed.
      sed -n 's/^#@//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      f_message $1 "OK" "About (use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
      #
} # End of f_about.
#
# +------------------------------------+
# |      Function f_code_history       |
# +------------------------------------+
#
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: None.
#
f_code_history () {
      #
      TEMP_FILE=$THIS_FILE"_temp.txt"
      f_script_path
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed substitutes null for "#@" at the beginning of each line
      # so it is not printed.
      sed -n 's/^##//'p $THIS_DIR/$THIS_FILE >>$TEMP_FILE
      #
      f_message $1 "OK" "Code History (use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
      #
} # End of function f_code_history.
#
# +------------------------------------+
# |      Function f_help_message       |
# +------------------------------------+
#
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#    Uses: None.
# Outputs: None.
#
f_help_message () {
      #
      # Display text (all lines beginning with "#?" but do not print "#?").
      # sed substitutes null for "#?" at the beginning of each line
      # so it is not printed.
      #
      TEMP_FILE=$THIS_FILE"_temp.txt"
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      sed -n 's/^#?//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      f_message $1 "OK" "Usage (use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
      #
} # End of f_help_message.
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
clear  # Clear screen.
#
TEMP_FILE="$THIS_FILE_temp_file.txt"
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
##
TEMP_FILE="$THIS_FILE_temp_file2.txt"
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
if [ $ERROR -eq 0 ] ; then
   #
   # Find latest updates to packages.
   sudo apt update | tee -a uplist.tmp
   #
   # If updates exist, do you want to see package descriptions?
   # And do you want to upgrade the packages?
   f_ques_upgrade $GUI
   #
else
   f_bad_sudo_password $GUI
fi
#
TEMP_FILE="$THIS_FILE_temp_file.txt"
if [ -r $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
TEMP_FILE2="$THIS_FILE_temp_file2.txt"
if [ -r $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
# All dun dun noodles.



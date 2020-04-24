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
VERSION="2020-04-24 00:39"
THIS_FILE="pkg-upgrade.sh"
TEMP_FILE=$THIS_FILE"_temp.txt"
#
# +----------------------------------------+
# |            Brief Description           |
# +----------------------------------------+
#
#@ Brief Description
#@
#@ Script pkg-upgrade.sh will show a description of each upgradable package
#@ before upgrading each package.
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
## Code Change History
##
## (After each edit made, please update Code History and VERSION.)
##
## 2020-04-24 *f_message split into several functions for clarity and
##             simplicity f_msg_(txt/ui)_(file/string)_(ok/nok).
##            *f_yn_question split off f_yn_defaults.
##            *f_obsolete_packages added.
##
## 2020-04-14 *f_ques_upgrade added command "apt autoremove".
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
#
# +----------------------------------------+
# |         Function f_script_path         |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $BASH_SOURCE (System variable).
#    Uses: None.
# Outputs: SCRIPT_PATH, THIS_DIR.
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
      THIS_DIR=$SCRIPT_PATH  # Set $THIS_DIR to location of this script.
      #
} # End of function f_script_path.
#
# +----------------------------------------+
# |         Function f_arguments           |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $1=Argument
#             [--help] [ -h ] [ -? ]
#             [--about]
#             [--version] [ -ver ] [ -v ] [--about ]
#             [--history] [--hist ]
#             [] [ text ] [ dialog ] [ whiptail ]
#    Uses: None.
# Outputs: GUI, ERROR.
#
f_arguments () {
      #
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
      #
}  # End of function f_arguments.
#
# +----------------------------------------+
# |          Function f_detect_ui          |
# +----------------------------------------+
#
#     Rev: 2020-04-20
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
      #
} # End of function f_detect_ui.
#
# +----------------------------------------+
# |      Function f_test_environment       |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $BASH_VERSION (System variable).
#    Uses: None.
# Outputs: None.
#
f_test_environment () {
      #
      # What shell is used? DASH or BASH?
      f_test_dash
      #
      # Test for X-Windows environment. Cannot run in CLI for LibreOffice.
      #if [ x$DISPLAY = x ] ; then
      #   f_message $1 "OK" "Cannot run LibreOffice" "Cannot run LibreOffice without an X-Windows environment.\ni.e. LibreOffice must run in a terminal emulator in an X-Window."
      #   f_abort
      #fi
      #
} # End of function f_test_environment.
#
# +----------------------------------------+
# |          Function f_test_dash          |
# +----------------------------------------+
#
# Test the environment. Are you in the BASH environment?
# Some scripts will have errors in the DASH environment that is the
# default command-line interface shell in Ubuntu.
#
#     Rev: 2020-04-20
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $BASH_VERSION (System variable), GUI.
#    Uses: None.
# Outputs: exit 1.
#
f_test_dash () {
      #
      # $BASH_VERSION is null if you are not in the BASH environment.
      # Typing "sh" at the CLI may invoke a different shell other than BASH.
      # if [ -z "$BASH_VERSION" ]; then
      # if [ "$BASH_VERSION" = '' ]; then
      #
      if [ -z "$BASH_VERSION" ]; then 
         # DASH Environment detected, display error message 
         # to invoke the BASH environment.
         f_detect_ui # Automatically detect UI environment.
         #
         TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
         #
         clear  # Blank the screen.
         #
         f_message $1 "OK" ">>> Warning: Must use BASH <<<" "\n                   You are using the DASH environment.\n\n        *** This script cannot be run in the DASH environment. ***\n\n    Ubuntu and Linux Mint default to DASH but also have BASH available."
         f_message $1 "OK" "HOW-TO" "\n  You can invoke the BASH environment by typing:\n    \"bash $THIS_FILE\"\nat the command line prompt (without the quotation marks).\n\n          >>> Now exiting script <<<"
         #
         f_abort text
      fi
      #
} # End of function f_test_dash
#
# +----------------------------------------+
# |        Function f_test_connection      |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 Network name of server. 
#    Uses: None.
# Outputs: ERROR. 
#
f_test_connection () {
      #
      # Check if there is an internet connection before doing a download.
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
} # End of function f_test_connection.
#
# +----------------------------------------+
# |      Function f_bad_sudo_password      |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $1=GUI.
#    Uses: None.
# Outputs: None.
#
f_bad_sudo_password () {
      #
      f_message $1 "NOK" "Incorrect Sudo password" "\n\Z1\ZbWrong Sudo password. Cannot upgrade software.\Zn"
      #
      clear # Blank the screen.
      #
} # End of function f_bad_sudo_password.
#
# +----------------------------------------+
# | Function f_press_enter_key_to_continue |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: None.
#    Uses: X.
# Outputs: None.
#
f_press_enter_key_to_continue () { # Display message and wait for user input.
      #
      echo
      echo -n "Press '"Enter"' key to continue."
      read X
      unset X  # Throw out this variable.
      #
} # End of function f_press_enter_key_to_continue.
#
# +----------------------------------------+
# |              Function f_abort          |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $1=GUI.
#    Uses: None.
# Outputs: None.
#
f_abort () {
      #
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
      f_message $1 "NOK" "Exiting script" " \n\Z1\ZbAn error occurred, cannot continue. Exiting script.\Zn"
      exit 1
      #
} # End of function f_abort.
#
# +------------------------------------+
# |          Function f_about          |
# +------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
f_about () {
      #
      # Specify $THIS_FILE name of any file containing the text to be displayed.
      THIS_FILE="pkg-upgrade.sh"
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      X=$(grep --max-count=1 "VERSION" $THIS_FILE)
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      eval $X
      #
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
#     Rev: 2020-04-20
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
f_code_history () {
      #
      # Specify $THIS_FILE name of any file containing the text to be displayed.
      THIS_FILE="pkg-upgrade.sh"
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      X=$(grep --max-count=1 "VERSION" $THIS_FILE)
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      eval $X
      #
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
#     Rev: 2020-04-20
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
f_help_message () {
      #
      # Specify $THIS_FILE name of any file containing the text to be displayed.
      THIS_FILE="pkg-upgrade.sh"
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      X=$(grep --max-count=1 "VERSION" $THIS_FILE)
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      eval $X
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#?" but do not print "#?").
      # sed substitutes null for "#?" at the beginning of each line
      # so it is not printed.
      sed -n 's/^#?//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      f_message $1 "OK" "Usage (use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
      #
} # End of f_help_message.
#
# +----------------------------------------+
# |          Function f_yn_question        |
# +----------------------------------------+
#
# This will display a title and a question using dialog/whiptail/text.
# It will automatically calculate the optimum size of the displayed
# Dialog or Whiptail box depending on screen resolution, number of lines
# of text, and length of sentences to be displayed. 
#
# It is a lengthy function, but using it allows for an easy way to display 
# a yes/no question using either Dialog, Whiptail or text.
#
# You do not have to worry about the differences in syntax between Dialog
# and Whiptail, handling the answer, or about calculating the box size for
# each text message.
#
#     Rev: 2020-04-23
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2 - "Y" or "N" - the default answer.         
#          $3 - Title string (may be null).
#          $4 - Question text string.
#    Uses: None.
# Outputs: ANS=0 is "Yes".
#          ANS=1 is "No".
#          ANS=255 if <Esc> is pressed in dialog/whiptail --yesno box.
# Example: f_yn_question $GUI "Y" "Title Goes Here" "I am hungry.\nAre you hungry?"
#          f_yn_question "dialog" "Y" "Title Goes Here" hungry.txt
#
f_yn_question () {
      #
      # Ask Yes/No question.
      #
      # Get the screen resolution or X-window size.
      # Get rows (height).
      YSCREEN=$(stty size | awk '{ print $1 }')
      # Get columns (width).
      XSCREEN=$(stty size | awk '{ print $2 }')
      #
      case $1 in
           dialog | whiptail)
           f_msg_ui_str_box_size $1 $2 "$3" "$4"
      esac
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
              # Whiptail needs about 6 more spaces for the right and left window frame. 
              let X=X+6
              # If line length exceeds screen/window width then set textbox width.
              if [ $X -ge $XSCREEN ] ; then
                 X=$XSCREEN
              fi
           ;;
      esac
      #
      case $1 in
           dialog | whiptail)
              # Default answer.
              f_yn_defaults $1 $2 "$3" "$4"
           ;;
           text)
              #
              clear  # Blank screen.
              #
              THIS_FILE="dropfsd_module_main.lib"
              TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
              #
              # Does $4 contain "\n"?  Does the string $4 contain multiple sentences?
              case $4 in
                   *\n*)
                      # Yes, string $4 contains multiple sentences.
                      #
                      # Use command "sed" with "-e" to filter out multiple "\Z" commands.
                      # Filter out "\Z[0-7]", "\Zb", \ZB", "\Zr", "\ZR", "\Zu", "\ZU", "\Zn".
                      ZNO=$(echo $4 | sed -e 's|\\Z0||g' -e 's|\\Z1||g' -e 's|\\Z2||g' -e 's|\\Z3||g' -e 's|\\Z4||g' -e 's|\\Z5||g' -e 's|\\Z6||g' -e 's|\\Z7||g' -e 's|\\Zb||g' -e 's|\\ZB||g' -e 's|\\Zr||g' -e 's|\\ZR||g' -e 's|\\Zu||g' -e 's|\\ZU||g' -e 's|\\Zn||g')
                      #
                      # Create a text file from the string.
                      echo -e $ZNO > $TEMP_FILE
                   ;;
                   *)
                      # No, string $4 contains a single sentence. 
                      #
                      # Create a text file from the string.
                      echo $4 > $TEMP_FILE
                   ;;
              esac
              #
              # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
              Y=$(wc --lines < $TEMP_FILE)
              #
              # Display Title and Question.
              echo $3
              echo
              NSEN=1
              while read XSTR
                    do
                       if [ $NSEN -lt $Y ] ; then
                          echo $XSTR
                       fi
                       let NSEN=NSEN+1
                    done < $TEMP_FILE
                    #
              XSTR=$(tail -n 1 $TEMP_FILE)
              #
              # Default answer.
              f_yn_defaults $1 $2 "$3" "$4"
           ;;
      esac
      #
} # End of function f_yn_question
#
# +------------------------------+
# |    Function f_yn_defaults    |
# +------------------------------+
#
#     Rev: 2020-04-23
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ANS. 
# Example:
#         whiptail --yesno text height width
#                  --defaultno
#                  --yes-button text
#                  --no-button text
#                  --backtitle backtitle
#                  --title title
#
#         dialog --yesno text height width
#                --defaultno
#                --yes-label string
#                --default-button string
#                --backtitle backtitle
#                --title title
#
f_yn_defaults () {
      #
      case $1 in
           dialog | whiptail)
              case $2 in
                   [Yy] | [Yy][Ee][Ss])
                      # "Yes" is the default answer.
                      $1 --title "$3" --yesno "$4" $Y $X
                      ANS=$?
                   ;;
                   [Nn] | [Nn][Oo])
                      # "No" is the default answer.
                      $1 --title "$3" --defaultno --yesno "$4" $Y $X
                      ANS=$?
                   ;;
              esac
           #
           ;;
           text)
              case $2 in
                   [Yy] | [Yy][Ee][Ss])
                      # "Yes" is the default answer.
                      echo -n "$XSTR (Y/n) "; read ANS
                      #
                      case $ANS in
                           [Nn] | [Nn][Oo])
                              ANS=1  # No.
                           ;;
                           *)
                              ANS=0  # Yes (Default).
                           ;;
                      esac
                   ;;
                   [Nn] | [Nn][Oo])
                      # "No" is the default answer.
                      echo -n "$XSTR (y/N) "; read ANS
                      case $ANS in
                           [Yy] | [Yy][Ee] | [Yy][Ee][Ss])
                              ANS=0  # Yes.
                           ;;
                           *)
                              ANS=1  # No (Default).
                           ;;
                      esac
                   ;;
              esac
           ;;
      esac
      #
} # End of function f_yn_defaults
#
# +------------------------------+
# |       Function f_message     |
# +------------------------------+
#
# This will display a title and some text using dialog/whiptail/text.
# It will automatically calculate the optimum size of the displayed
# Dialog or Whiptail box depending on screen resolution, number of lines
# of text, and length of sentences to be displayed. 
#
# It is a lengthy function, but using it allows for an easy way to display 
# some text (in a string or text file) using either Dialog, Whiptail or text.
#
# You do not have to worry about the differences in syntax between Dialog
# and Whiptail or about calculating the box size for each text message.
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
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
                 # If $4 is a text file, then calculate number of lines and length
                 # of sentences to calculate height and width of Dialog box.
                 # Calculate dialog/whiptail box dimensions $X, $Y.
                 f_msg_ui_file_box_size $1 $2 "$3" "$4"
                 #
                 if [ "$2" = "OK" ] ; then
                    # Display contents of text file with an [OK] button.
                    f_msg_ui_file_ok $1 $2 "$3" "$4"
                 else
                    # Display contents of text file with a pause for n seconds.
                    f_msg_ui_file_nok $1 $2 "$3" "$4"
                 fi
                 #
                 if [ -r $TEMP_FILE ] ; then
                    rm $TEMP_FILE
                 fi
                 #
              else
                 # If $4 is a text string, then does it contain just one
                 # sentence or multiple sentences delimited by "\n"?
                 # Calculate the length of the longest of sentence.
                 # Calculate dialog/whiptail box dimensions $X, $Y.
                 f_msg_ui_str_box_size $1 $2 "$3" "$4"
                 #
                 if [ "$2" = "OK" ] ; then
                    # Display contents of text string with an [OK] button.
                    f_msg_ui_str_ok $1 $2 "$3" "$4"
                 else
                    # Display contents of text string with a pause for n seconds.
                    f_msg_ui_str_nok $1 $2 "$3" "$4"
                 fi
              fi
              ;;
           *)
           # Text only.
              #Is $4 a text string or a text file?
              #
              if [ -r "$4" ] ; then
                 # If $4 is a text file.
                 #
                 if [ "$2" = "OK" ] ; then
                    # Display contents of text file using command "less" <q> to quit.
                    f_msg_txt_file_ok $1 $2 "$3" "$4"
                 else
                    f_msg_txt_file_nok $1 $2 "$3" "$4"
                    # Display contents of text file using command "cat" then pause for n seconds.
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
                    # Display contents of text string using command "echo -e" then
                    # use f_press_enter_key_to_continue.
                    f_msg_txt_str_ok $1 $2 "$3" "$4"
                 else
                    # Display contents of text string using command "echo -e" then pause for n seconds.
                    f_msg_txt_str_nok $1 $2 "$3" "$4"
                 fi
              fi
           ;;
      esac
      #
} # End of function f_message.
#
# +-------------------------------+
# |Function f_msg_ui_file_box_size|
# +-------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_ui_file_box_size () {
      #
      # If $4 is a text file.
      # Calculate dialog/whiptail box dimensions $X, $Y.
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
} # End of function f_msg_ui_file_box_size.
#
# +------------------------------+
# |   Function f_msg_ui_file_ok  |
# +------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_ui_file_ok () {
      #
      # $4 is a text file.
      # If $2 is "OK" then use a Dialog/Whiptail textbox.
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
} # End of function f_msg_ui_file_ok
#
# +------------------------------+
# |  Function f_msg_ui_file_nok  |
# +------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_ui_file_nok () {
      #
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
      #
} # End of function f_msg_ui_str_nok
#
# +------------------------------+
# |Function f_msg_ui_str_box_size|
# +------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_ui_str_box_size () {
      #
      # Calculate dialog/whiptail box dimensions $X, $Y.
      #
      # Does $4 contain "\n"?  Does the string $4 contain multiple sentences?
      #
      case $4 in
           *\n*)
              # Yes, string $4 contains multiple sentences.
              #
              # Use command "sed" with "-e" to filter out multiple "\Z" commands.
              # Filter out "\Z[0-7]", "\Zb", \ZB", "\Zr", "\ZR", "\Zu", "\ZU", "\Zn".
              ZNO=$(echo $4 | sed -e 's|\\Z0||g' -e 's|\\Z1||g' -e 's|\\Z2||g' -e 's|\\Z3||g' -e 's|\\Z4||g' -e 's|\\Z5||g' -e 's|\\Z6||g' -e 's|\\Z7||g' -e 's|\\Zb||g' -e 's|\\ZB||g' -e 's|\\Zr||g' -e 's|\\ZR||g' -e 's|\\Zu||g' -e 's|\\ZU||g' -e 's|\\Zn||g')
              #
              # Calculate the length of the longest sentence with the $4 string.
              # How many sentences?
              # Replace "\n" with "%" and then use awk to count how many sentences.
              # Save number of sentences.
              Y=$(echo $ZNO | sed 's|\\n|%|g'| awk -F '%' '{print NF}')
              #
              # Extract each sentence
              # Replace "\n" with "%" and then use awk to print current sentence.
              TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
              echo -e $ZNO > $TEMP_FILE
              # This is the long way... echo $ZNO | sed 's|\\n|%|g'| awk -F "%" '{ for (i=1; i<NF+1; i=i+1) print $i }' >$TEMP_FILE
              # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
              # The "Word Count" wc command output will not include the TEMP_FILE name
              # if you redirect "<$TEMP_FILE" into wc.
              X=$(wc --max-line-length < $TEMP_FILE)
              unset ZNO
           ;;
           *)
              # No, line length is $4 string length. 
              X=$(echo -n "$4" | wc -c)
              Y=1
           ;;
      esac
      #
} # End of function f_msg_ui_str_box_size
#
# +------------------------------+
# |   Function f_msg_ui_str_ok   |
# +------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_ui_str_ok () {
      #
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
      #
} # End of function f_msg_ui_str_ok.
#
# +------------------------------+
# |   Function f_msg_ui_str_nok  |
# +------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_ui_str_nok () {
      #
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
      #
} # End of function f_msg_ui_str_nok.
#
# +------------------------------+
# |  Function f_msg_txt_str_ok   |
# +------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_txt_str_ok () {
      #
      # If $2 is "OK" then use f_press_enter_key_to_continue.
      #
      clear  # Blank the screen.
      #
      # Display title.
      echo
      echo -e $3
      echo
      echo
      # Display text string contents.
      echo -e $4
      echo
      f_press_enter_key_to_continue
      #
      clear  # Blank the screen.
      #
} # End of function f_msg_txt_str_ok
#
# +------------------------------+
# |  Function f_msg_txt_str_nok  |
# +------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_txt_str_nok () {
      #
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
      # Display text string contents.
      echo -e $4
      echo
      echo
      sleep 5
      #
      clear  # Blank the screen.
      #
} # End of function f_msg_txt_str_nok
#
# +------------------------------+
# |  Function f_msg_txt_file_ok  |
# +------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_txt_file_ok () {
      #
      # If $2 is "OK" then use command "less".
      #
      clear  # Blank the screen.
      #
      # Display text file contents.
      less -P '%P\% (Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)' $4
      #
      clear  # Blank the screen.
      #
} # End of function f_msg_txt_file_ok
#
# +------------------------------+
# |  Function f_msg_txt_file_nok |
# +------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_txt_file_nok () {
      #
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
} # End of function f_msg_txt_file_nok
#
# +------------------------------------+
# |      Function f_ques_upgrade       |
# +------------------------------------+
#
#  Inputs: $1=GUI.
#          THIS_FILE, VERSION.
#    Uses: None.
# Outputs: File $TEMP_FILE.
#
f_ques_upgrade () {
      #
      # Save $TEMP_FILE.
      TEMP_FILE2=$THIS_FILE"_temp2".txt
      cat $TEMP_FILE > $TEMP_FILE2
      #
      f_obsolete_packages $1
      #
      # Restore $TEMP_FILE.
      TEMP_FILE=$TEMP_FILE2
      # Read the last line in the file $TEMP_FILE.
      X=$(tail -n 1 $TEMP_FILE)
      #
      if [ "$X" = "All packages are up to date." ] ; then
         f_message $1 "NOK" "Status of Software Packages" "All software packages are at the latest version."
      else
         # Yes/No Question.
         f_yn_question $1 "Y" "View Software Package Descriptions?" " \nSome software packages are not up-to-date and need upgrading.\n \nNote: There may be a delay to display descriptions.\n      (especially if many software packages need to be updated)\n \nDo you want to view software package descriptions?"
         # ANS=0 when <Yes> button pressed.
         # ANS=1 when <No> button pressed.
         #
         # if <Yes> button pressed, then list packages.
         if [ $ANS -eq 0 ] ; then
            f_list_packages
         fi
         f_message $1 "NOK" "Upgrade Software Packages" "Running command: \"sudo apt upgrade\" to upgrade software packages."
         #
         clear  # Blank the screen.
         #
         # Clean up temporary files before running "sudo apt upgrade".
         # If you quit out of "sudo apt upgrade", then execution terminates
         # within this function and never goes back to Main.
         TEMP_FILE=$THIS_FILE"_temp.txt"
         if [ -e $TEMP_FILE ] ; then
            rm $TEMP_FILE
         fi
         #
         TEMP_FILE=$THIS_FILE"_temp2".txt
         if [ -e $TEMP_FILE ] ; then
            rm $TEMP_FILE
         fi
         #
         TEMP_FILE=$THIS_FILE"_temp.txt"
         sudo apt upgrade | tee $TEMP_FILE #2>/dev/null
         #
         f_obsolete_packages $1
         #
         TEMP_FILE=$THIS_FILE"_temp.txt"
         if [ -e $TEMP_FILE ] ; then
            rm $TEMP_FILE
         fi
      fi
      #
      clear  # Clear screen.
      #
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
      # File TEMP_FILE="$THIS_FILE_temp.txt" contains only the package names of upgradable packages.
      # File TEMP_FILE2="$THIS_FILE_temp2.txt contains the package names and descriptions.
      #
      TEMP_FILE=$THIS_FILE"_temp.txt"
      # Raw data output from command, "apt list".
      sudo apt list --upgradable > $TEMP_FILE 2>/dev/null
      #
      # Parse raw data to show each package title only.
      TEMP_FILE2=$THIS_FILE"_temp2.txt"
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
         f_message $GUI "OK" "Package Description" $TEMP_FILE2
         #
      else
         f_message $GUI "NOK" "Up-to-Date" "No packages to update. All packages are up to date."
      fi
      #
}  # End of function f_list_packages.
#
# +----------------------------------------+
# |       Function f_obsolete_packages     |
# +----------------------------------------+
#
#  Inputs: File $TEMP_FILE.
#    Uses: None.
# Outputs: None.
#
f_obsolete_packages () {
      #
      # Are there any software packages automatically installed but are no longer required?
      ANS=$(grep autoremove $TEMP_FILE)
      if [ -n "$ANS" ] ; then
         # If $ANS is not zero length and contains the string "autoremove".
         # Yes/No Question.
         f_yn_question $1 "Y" "Remove extraneous software packages?" "Some software packages are no longer needed and may be removed.\n \nDo you want to remove unneeded software packages?"
         # ANS=0 when <Yes> button pressed.
         # ANS=1 when <No> button pressed.
         #
         # if <Yes> button pressed, then remove unneeded software packages.
         if [ $ANS -eq 0 ] ; then
            #
            clear  # Blank the screen.
            #
            sudo apt autoremove
            f_press_enter_key_to_continue
         fi
      fi
      #
} # End of function f_obsolete_packages
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
clear  # Clear screen.
#
TEMP_FILE=$THIS_FILE"_temp.txt"
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
##
TEMP_FILE=$THIS_FILE"_temp2.txt"
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
   f_message $GUI "NOK" "Searching for Software Updates" "Finding latest updates to software packages."
   #
   TEMP_FILE=$THIS_FILE"_temp.txt"
   sudo apt update > $TEMP_FILE 2>/dev/null
   #
   # If updates exist, do you want to see package descriptions?
   # And do you want to upgrade the packages?
   f_ques_upgrade $GUI
   #
else
   f_bad_sudo_password $GUI
fi
#
TEMP_FILE=$THIS_FILE"_temp.txt"
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
TEMP_FILE=$THIS_FILE"_temp2.txt"
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
# All dun dun noodles.

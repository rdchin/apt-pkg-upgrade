#!/bin/bash
#
# ©2020 Copyright 2020 Robert D. Chin
#
# Usage: bash sample.sh
#        (not sh sample.sh)
#
# +----------------------------------------+
# |        Default Variable Values         |
# +----------------------------------------+
#
VERSION="2020-08-07 16:41"
THIS_FILE="github_repo_scripts.sh"
TEMP_FILE=$THIS_FILE"_temp.txt"
#
# Specify TARGET Directory.
TARGET_DIR="scripts_downloaded_from_github"
#
# +----------------------------------------+
# |            Brief Description           |
# +----------------------------------------+
#
#& Brief Description
#&
#& This script will download files from Github/rdchin repositories
#& to the host PC to assure that the latest released versions of the files
#& are available on the host PC.
#&
#& You may also specify the PC servers and sharepoints for the downloads.
#& To add more file server names, share-points with corresponding mount-points,
#& edit the text with the prefix "#@@" following the Code Change History.
#& Format <DELIMITER>//<Source File Server>/<Shared directory><DELIMITER>/<Mount-point on local PC>
#&
#& Usage: bash github_repo_scripts.sh
#&        (not sh github_repo_scripts.sh)
#
# +----------------------------------------+
# |             Help and Usage             |
# +----------------------------------------+
#
#?    Usage: bash github_repo_scripts.sh [OPTION(S)]
#? Examples:
#?
#?bash github_repo_scripts.sh text      # Use Cmd-line user-interface (80x24 min.)
#?                            dialog    # Use Dialog   user-interface.
#?                            whiptail  # Use Whiptail user-interface.
#?
#?bash github_repo_scripts.sh --help    # Displays this help message.
#?                            -?
#?
#?bash github_repo_scripts.sh --about   # Displays script version.
#?                            --version
#?                            --ver
#?                            -v
#?
#?bash github_repo_scripts.sh --history # Displays script code history.
#?                            --hist
#?
#? Examples using 2 arguments:
#?
#?bash github_repo_scripts.sh --hist text
#?                            --ver dialog
#
# +----------------------------------------+
# |           Code Change History          |
# +----------------------------------------+
#
## After each edit made, please update Code History and VERSION.
##
## Code Change History
##
## 2020-08-07 *Updated to latest standards.
##
## 2020-07-31 *Reaffirmed this script SHOULD NOT be dependent on BASH Function
##             Library because it may not be present and this script downloads
##             it from Github.com.
##            *Updated to latest standards.
##            *Main added chmod 755 $TARGET_DIR to make scripts executable.
##            *f_test_connection updated to latest standard.
##            *f_test_connect changed the display time to only 1 sec. of the
##             status message of the network connection.
##
## 2020-06-22 *Updated to latest standards.
##            *Added repository BASH Function Library.
##
## 2020-05-16 *Updated to latest standards.
##
## 2020-05-16 *f_wget of mountup repository added new file mountup_servers.lib.
##
## 2020-05-06 *f_msg_ui_file_box_size, f_msg_ui_file_ok bug fixed in display.
##
## 2020-05-01 *Updated to latest standards.
##            *f_wget added new files in git repositories.
##
## 2020-04-24 *Deleted from repository samba-mount,the scripts "mountup_gui.sh"
##             and "mountup_lib_gui.lib" and renamed both of them to
##             "mountup.sh" and "mountup.lib" thus effectively removing
##             the text-only version of "mountup.sh".
##
## 2020-03-21 *f_wget added menu_module_sub1.lib.
##
## 2019-09-17 *f_wget added new files from Development branch of repository
##             cli-app-menu.
##
## 2019-09-02 *f_wget added files from repository apt-pkg-upgrade.
##
## 2019-05-08 *f_wget added file_recursive_rename.sh from repository
##             file-rename.
##
## 2018-07-18 *f_wget get new files from Testing and Development branches of
##             repository cli-app-menu.
##
## 2018-03-16 *f_wget get new files in project cliappmenu.
##
## 2017-07-26 *Main program commented out wget to test script.
##            *f_edit_script_files added error message.
##            *f_edit_sharing_names fixed error at function entry:
##             "line 247: scripts_from_github.sh: No such file or
##             directory" caused by not specifying directory of
##             this script in redirection 
##             Change from "<$THIS_FILE" change to "< ~/$THIS_FILE."
##
## 2017-07-03 *Section "Add actual share-point and mount-point names
##             to scripts "mountup.sh" and "mountup_lib_gui.lib"
##             replaced extraneous delimiters "#@@" with comment "#"
##             to prevent bad server menu display.
##
## 2017-05-08 *f_edit_sharing_names fixed bug in target directory name.
##            *Reworked script to pass variable TARGET_DIR to functions.
##
## 2017-05-01 *f_wget_do, f_wget_ok Changed error message and try to
##             download file twice if wget fails the first time.
##
## 2017-04-21 *f_wget changed to download files in the GitHub repository
##             "cli-app-menu" from the Testing branch and download all
##             required files, documentation files and one module file.
##
## 2017-04-13 *Initial release.
##
## 2017-04-07 *First try to give this script the ability to edit scripts
##             mountup.sh and mountup_lib_gui.lib automatically to insert
##             actual data and disable the sample data.
##
## 2017-04-04 *Development started.
##
# +--------------------------------------------------------------------------+
# |                                                                          |
# | Add additional source file servers, share-points, and mount-points here. |
# |                                                                          |
# +--------------------------------------------------------------------------+
#
# Add actual share-point and mount-point names to scripts "mountup.sh" and "mountup.lib".
#
# Format <Delimiter>//<Source File Server>/<Shared directory><Delimiter>/<Mount-point on local PC><Delimiter><Shared directory description>
#
#@@//scotty/robert#@@/mnt/scotty/robert#@@Roberts documents.
#@@//scotty/public-no-backup#@@/mnt/scotty/public-no-backup#@@Public files but not backed up.
#@@//scotty/public#@@/mnt/scotty/public#@@Public files.
#
#@@//parsley/robert#@@/mnt/parsley/robert#@@Roberts documents.
#@@//parsley/public-no-backup#@@/mnt/parsley/public-no-backup#@@Public files but not backed up.
#@@//parsley/public#@@/mnt/parsley/public#@@Public files.
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
#     Rev: 2020-06-27
#  Inputs: $1=Argument
#             [--help] [ -h ] [ -? ]
#             [--about]
#             [--version] [ -ver ] [ -v ] [--about ]
#             [--history] [--hist ]
#             [] [ text ] [ dialog ] [ whiptail ]
#             [ --help dialog ]  [ --help whiptail ]
#             [ --about dialog ] [ --about whiptail ]
#             [ --hist dialog ]  [ --hist whiptail ]
#          $2=Argument
#             [ text ] [ dialog ] [ whiptail ] 
#    Uses: None.
# Outputs: GUI, ERROR.
#
f_arguments () {
      #
      # If there is more than two arguments, display help USAGE message, because only one argument is allowed.
      if [ $# -ge 3 ] ; then
         f_help_message text
         #
         clear # Blank the screen.
         #
         exit 0  # This cleanly closes the process generated by #!bin/bash. 
                 # Otherwise every time this script is run, another instance of
                 # process /bin/bash is created using up resources.
      fi
      #
      case $2 in
           "text" | "dialog" | "whiptail")
           GUI=$2
           ;;
      esac
      #
      case $1 in
           --help | "-?")
              # If the one argument is "--help" display help USAGE message.
              if [ -z $GUI ] ; then
                 f_help_message text
              else
                 f_help_message $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           --about | --version | --ver | -v)
              if [ -z $GUI ] ; then
                 f_about text
              else
                 f_about $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           --history | --hist)
              if [ -z $GUI ] ; then
                 f_code_history text
              else
                 f_code_history $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           -*)
              # If the one argument is "-<unrecognized>" display help USAGE message.
              if [ -z $GUI ] ; then
                 f_help_message text
              else
                 f_help_message $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           "text" | "dialog" | "whiptail")
              GUI=$1
           ;;
           "")
           # No action taken as null is a legitimate and valid argument.
           ;;
           *)
              # Check for 1st argument as a valid TARGET DIRECTORY.
              if [ -d $1 ] ; then
                 TARGET_DIR=$1
              else
                 # Display help USAGE message.
                 f_message "text" "OK" "Error Invalid Directory Name" "\Zb\Z1This directory does not exist:\Zn\n $1"
                 f_help_message "text"
                 exit 0  # This cleanly closes the process generated by #!bin/bash. 
                         # Otherwise every time this script is run, another instance of
                         # process /bin/bash is created using up resources.
              fi
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
#     Rev: 2020-05-01
#  Inputs: $1=GUI.
#          $BASH_VERSION (System variable).
#    Uses: None.
# Outputs: None.
#
f_test_environment () {
      #
      # What shell is used? DASH or BASH?
      f_test_dash $1
      #
      # Test for X-Windows environment. Cannot run in CLI for LibreOffice.
      #if [ x$DISPLAY = x ] ; then
      #   f_message $1 "OK" "Cannot run LibreOffice" "Cannot run LibreOffice without an X-Windows environment.\ni.e. LibreOffice must run in a terminal emulator in an X-Window."
      #   f_abort $1
      #fi
      #
} # End of function f_test_environment.
#
# +----------------------------------------+
# |          Function f_test_dash          |
# +----------------------------------------+
#
#     Rev: 2020-06-22
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $BASH_VERSION (System variable), GUI.
#    Uses: None.
# Outputs: exit 1.
#
# Test the environment. Are you in the BASH environment?
# Some scripts will have errors in the DASH environment that is the
# default command-line interface shell in Ubuntu.
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
         f_abort $1
      fi
      #
} # End of function f_test_dash
#
# +----------------------------------------+
# |         Function f_test_connect        |
# +----------------------------------------+
#
#     Rev: 2020-08-07
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#    Uses: None.
# Outputs: None.
#
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO ANY SCRIPT WHICH DEPENDS ON THE
#              LIBRARY FILE "common_bash_function.lib".
#
f_test_connect () {
      #
      # Test network connection to IP address or web site.
      #
      # Use ping <IP Address> or <URL> <pause secs. to read message>.
      # Examples:
      #f_test_connection 192.168.1.1
      #f_test_connection $1 8.8.8.8 2 (2-second pause to read messages).
      #f_test_connection $1 www.dropbox.com 1 (1-second pause to read messages).
      #
      f_test_connection $1 github.com 1
      #
} # End of function f_test_connect
#
# +----------------------------------------+
# |        Function f_test_connection      |
# +----------------------------------------+
#
#     Rev: 2020-07-16
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - Network name of server. 
#          $3 - Pause n seconds to read message (Optional).
#    Uses: None.
# Outputs: ERROR. 
#
f_test_connection () {
      #
      # Check if there is an internet connection before doing a download.
      ping -c 1 -q $2 >/dev/null # Ping server address.
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
         f_message $1 "NOK" "Ping Test Network Connection" " \n\Z1\Zb  No network connection to $2.\Zn" $3
      else
         f_message $1 "NOK" "Ping Test Network Connection" "Network connnection to $2 is good." $3
      fi
      #
      clear # Blank the screen.
      #
} # End of function f_test_connection.
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
# |         Function f_exit_script         |
# +----------------------------------------+
#
#     Rev: 2020-05-28
#  Inputs: $1=GUI.
#    Uses: None.
# Outputs: None.
#
f_exit_script() {
      #
      f_message $1 "NOK" "End of script" " \nExiting script." 1
      #
      # Blank the screen. Nicer ending especially if you chose custom colors for this script.
      clear 
      #
      if [ -r  $TEMP_FILE ] ; then
         rm  $TEMP_FILE
      fi
      #
      exit 0
} # End of function f_exit_script
#
# +----------------------------------------+
# |              Function f_abort          |
# +----------------------------------------+
#
#     Rev: 2020-05-28
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
      f_message $1 "NOK" "Exiting script" " \Z1\ZbAn error occurred, cannot continue. Exiting script.\Zn"
      exit 1
      #
      if [ -r  $TEMP_FILE ] ; then
         rm  $TEMP_FILE
      fi
      #
} # End of function f_abort.
#
# +------------------------------------+
# |          Function f_about          |
# +------------------------------------+
#
#     Rev: 2020-08-07
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $3=Pause $3 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: DELIM.
# Outputs: None.
#
#    NOTE: This function needs to be in the same library or file as
#          the function f_display_common.
#
f_about () {
      #
      # Display text (all lines beginning ("^") with "#& " but do not print "#& ").
      # sed substitutes null for "#& " at the beginning of each line
      # so it is not printed.
      DELIM="^#&"
      f_display_common $1 $DELIM $2 $3
      #
} # End of f_about.
#
# +------------------------------------+
# |      Function f_code_history       |
# +------------------------------------+
#
#     Rev: 2020-08-07
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $3=Pause $3 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: DELIM.
# Outputs: None.
#
#    NOTE: This function needs to be in the same library or file as
#          the function f_display_common.
#
f_code_history () {
      #
      # Display text (all lines beginning ("^") with "##" but do not print "##").
      # sed substitutes null for "##" at the beginning of each line
      # so it is not printed.
      DELIM="^##"
      f_display_common $1 $DELIM $2 $3
      #
} # End of function f_code_history.
#
# +------------------------------------+
# |      Function f_help_message       |
# +------------------------------------+
#
#     Rev: 2020-08-07
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $3=Pause $3 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: DELIM.
# Outputs: None.
#
#    NOTE: This function needs to be in the same library or file as
#          the function f_display_common.
#
f_help_message () {
      #
      # Display text (all lines beginning ("^") with "#?" but do not print "#?").
      # sed substitutes null for "#?" at the beginning of each line
      # so it is not printed.
      DELIM="^#?"
      f_display_common $1 $DELIM $2 $3
      #
} # End of f_help_message.
#
# +------------------------------------+
# |     Function f_display_common      |
# +------------------------------------+
#
#     Rev: 2020-08-07
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2=Delimiter of text to be displayed.
#          $3="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $4=Pause $4 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO ANY SCRIPT WHICH DEPENDS ON THE
#              LIBRARY FILE "common_bash_function.lib".
#
f_display_common () {
      #
      # Specify $THIS_FILE name of the file containing the text to be displayed.
      # $THIS_FILE may be re-defined inadvertently when a library file defines it
      # so when the command, source [ LIBRARY_FILE.lib ] is used, $THIS_FILE is
      # redefined to the name of the library file, LIBRARY_FILE.lib.
      # For that reason, all library files now have the line
      # THIS_FILE="[LIBRARY_FILE.lib]" deleted.
      #
      #================================================================================
      # EDIT THE LINE BELOW TO DEFINE $THIS_FILE AS THE ACTUAL FILE NAME WHERE THE 
      # ABOUT, CODE HISTORY, AND HELP MESSAGE TEXT IS LOCATED.
      #================================================================================
                                           #
      THIS_FILE="github_repo_scripts.sh"  # <<<--- INSERT ACTUAL FILE NAME HERE.
                                           #
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      X=$(grep --max-count=1 "VERSION" $THIS_FILE)
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      eval $X
      #
      echo "Script: $THIS_FILE. Version: $VERSION" > $TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning ("^") with $2 but do not print $2).
      # sed substitutes null for $2 at the beginning of each line
      # so it is not printed.
      sed -n "s/$2//"p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      case $3 in
           "NOK" | "nok")
              f_message $1 "NOK" "Message" $TEMP_FILE $4
           ;;
           *)
              f_message $1 "OK" "(use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
           ;;
      esac
      #
} # End of function f_display_common.
#
# +------------------------------+
# |       Function f_message     |
# +------------------------------+
#
#     Rev: 2020-07-16
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#          $5 - (Optional for functions f_msg_ui/txt_str_nok) Pause for $5 seconds to allow text to be read.
#    Uses: None.
# Outputs: ERROR.
#   Usage: 1. f_message $GUI "OK" "Test of String in quotes" "This is a test of \Z6cyan software BASH script.\Zn\nI hope it works!"
#
#          2. In this example, the quotation marks around the "$STRING" variable name are required.
#             STRING=$(echo "\"Roses are \Z1\ZbRED\Zn, Violets are \Z4BLUE\Zn, what say you?\"")
#             f_message $GUI "OK" "Test of String in a variable" "$STRING" <---!!Note required quotation marks around variable name!!
#
#          3. echo "Line 1 of text file" >$TEMP_FILE
#             echo "Line 2 of text file" >>$TEMP_FILE
#             echo "Line 3 of text file" >>$TEMP_FILE
#             f_message $GUI "OK" "Test of Text file" $TEMP_FILE
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
                 #
                 # If $4 is a text file, then calculate number of lines and length
                 # of sentences to calculate height and width of Dialog box.
                 # Calculate dialog/whiptail box dimensions $YBOX, $XBOX.
                 f_msg_ui_file_box_size "$4"
                 #
                 if [ "$2" = "OK" ] ; then
                    # Display contents of text file with an [OK] button.
                    f_msg_ui_file_ok $1 $2 "$3" "$4" $YBOX $XBOX
                 else
                    # Display contents of text file with a pause for n seconds.
                    f_msg_ui_file_nok $1 $2 "$3" "$4" $YBOX $XBOX "$5"
                 fi
                 #
              else
                 # If $4 is a text string, then does it contain just one
                 # sentence or multiple sentences delimited by "\n"?
                 # Calculate the length of the longest of sentence.
                 # Calculate dialog/whiptail box dimensions $YBOX, $XBOX.
                 f_msg_ui_str_box_size "$4"
                 #
                 if [ "$2" = "OK" ] ; then
                    # Display contents of text string with an [OK] button.
                    f_msg_ui_str_ok $1 $2 "$3" "$4" $YBOX $XBOX
                 else
                    # Display contents of text string with a pause for n seconds.
                    f_msg_ui_str_nok $1 $2 "$3" "$4" $YBOX $XBOX "$5"
                 fi
              fi
              ;;
           *)
              #
              # Text only.
              # Is $4 a text string or a text file?
              #
              # Change font color according to Dialog "\Z" commands.
              # Replace font color "\Z" commands with "tput" commands.
              # Output result to string $ZNO.
              f_msg_color "$4"
              #
              if [ -r "$4" ] ; then
                 # If $4 is a text file.
                 #
                 if [ "$2" = "OK" ] ; then
                    # Display contents of text file using command "less" <q> to quit.
                    f_msg_txt_file_ok $1 $2 "$3" "$4"
                 else
                    f_msg_txt_file_nok $1 $2 "$3" "$4" "$5"
                    # Display contents of text file using command "cat" then pause for n seconds.
                 fi
                 #
              else
                 # If $4 is a text string.
                 #
                 if [ "$2" = "OK" ] ; then
                    # Display contents of text string using command "echo -e" then
                    # use f_press_enter_key_to_continue.
                    f_msg_txt_str_ok $1 $2 "$3" "$ZNO"
                 else
                    # Display contents of text string using command "echo -e" then pause for n seconds.
                    f_msg_txt_str_nok $1 $2 "$3" "$ZNO" "$5"
                 fi
              fi
              #
              # Restore default font color.
              echo -n $(tput sgr0)
              #
           ;;
      esac
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
} # End of function f_message.
#
# +-------------------------------+
# |      Function f_msg_color     |
# +-------------------------------+
#
#     Rev: 2020-06-04
#  Inputs: $1 - Text string or text file. 
#    Uses: None.
# Outputs: ZNO. 
#
f_msg_color () {
      #
      # 1. Does the text string or file have embedded Dialog "\Z" commands?
      # 2. If so, what color?
      # 3. Use corresponding "tput" command to set same color for the text.
      # 4. Remove or filter out embedded dialog "\Z" commands.
      # 5. Display (colored) text on screen.
      # 6. Reset text color when done.
      #
      # man dialog --colors
      # Interpret embedded "\Z" sequences in the Dialog text by the following
      # character, which tells Dialog to set colors or video attributes:
      # *0 through 7 are the ANSI color numbers used in curses: black, red, green,
      #  yellow, blue, magenta, cyan and white respectively.
      # *Bold is set by 'b', reset by 'B'.
      # *Reverse is set by 'r', reset by 'R'.
      # *Underline is set by 'u', reset by 'U'.
      # *The settings are cumulative, e.g., "\Zb\Z1" makes the following text bold
      #  (perhaps bright) red.
      # *Restore normal settings with "\Zn".
      #
      # BASH commands to change the color of characters in a terminal.
      # bold    "$(tput bold)"
      # black   "$(tput setaf 0)"
      # red     "$(tput setaf 1)"
      # green   "$(tput setaf 2)"
      # yellow  "$(tput setaf 3)"
      # blue    "$(tput setaf 4)"
      # magenta "$(tput setaf 5)"
      # cyan    "$(tput setaf 6)"
      # white   "$(tput setaf 7)"
      # reset   "$(tput sgr0)"
      #
      # Change font color according to Dialog "\Z" commands.
      # Then delete the Dialog "\Z" commands from the text string/file.
      #
      if [ -r "$1" ] ; then
         # If $1 is a text file.
         for COLOR in 0 1 2 3 4 5 6 7 8 9
             do
                # Search the text file for a Dialog "\Z" command.
                ZCMD=$(grep --max-count=1 \\Z$COLOR "$1")
                #
                # Change font color according to Dialog "\Z" command.
                if [ -n "$ZCMD" ] ; then
                   # Delete Dialog "\Z" commands.
                   # Use command "sed" with "-e" to filter out multiple "\Z" commands.
                   # Filter out "\Z[0-7]", "\Zb", \ZB", "\Zr", "\ZR", "\Zu", "\ZU", "\Zn".
                   sed -i -e 's|\\Z0||g' -e 's|\\Z1||g' -e 's|\\Z2||g' -e 's|\\Z3||g' -e 's|\\Z4||g' -e 's|\\Z5||g' -e 's|\\Z6||g' -e 's|\\Z7||g' -e 's|\\Zb||g' -e 's|\\ZB||g' -e 's|\\Zr||g' -e 's|\\ZR||g' -e 's|\\Zu||g' -e 's|\\ZU||g' -e 's|\\Zn||g' $1
                   # Change font color using "tput" and "setaf" commands.
                   echo -n $(tput setaf $COLOR)
                fi
             done
      else
         # If $1 is a text string.
         for COLOR in 0 1 2 3 4 5 6 7 8 9
             do
                case "$1" in
                     *\Z0* | *\Z1* | *\Z2* | *\Z3* | *\Z4* | *\Z5* | *\Z6* | *\Z7* | *\Z8* | *\Z9*)
                        # Change font color using "tput" and "setaf" commands.
                        echo -n $(tput setaf $COLOR)
                        #
                        # Delete Dialog "\Z" commands.
                        # Use command "sed" with "-e" to filter out multiple "\Z" commands.
                        # Filter out "\Z[0-7]", "\Zb", \ZB", "\Zr", "\ZR", "\Zu", "\ZU", "\Zn".
                        ZNO=$(echo $1 | sed -e 's|\\Z0||g' -e 's|\\Z1||g' -e 's|\\Z2||g' -e 's|\\Z3||g' -e 's|\\Z4||g' -e 's|\\Z5||g' -e 's|\\Z6||g' -e 's|\\Z7||g' -e 's|\\Zb||g' -e 's|\\ZB||g' -e 's|\\Zr||g' -e 's|\\ZR||g' -e 's|\\Zu||g' -e 's|\\ZU||g' -e 's|\\Zn||g')
                     ;;
                     *)
                        ZNO=$1
                esac
             done
         #
      fi
} # End of function f_msg_color.
#
# +-------------------------------+
# |Function f_msg_ui_file_box_size|
# +-------------------------------+
#
#     Rev: 2020-07-16
#  Inputs: $1 - Text string or text file. 
#    Uses: None.
# Outputs: XBOX, YBOX.
#
f_msg_ui_file_box_size () {
      #
      # If $1 is a text file.
      # Calculate dialog/whiptail box dimensions $XBOX, $YBOX.
      #
      # If text file, calculate number of lines and length of sentences.
      # to calculate height and width of Dialog box.
      #
      # Calculate longest line length in TEMP_FILE to find maximum menu width for Dialog or Whiptail.
      # The "Word Count" wc command output will not include the TEMP_FILE name
      # if you redirect "<$TEMP_FILE" into wc.
      XBOX=$(wc --max-line-length <$1)
      #
      # Calculate number of lines or Menu Choices to find maximum menu lines for Dialog or Whiptail.
      YBOX=$(wc --lines <$1)
      #
} # End of function f_msg_ui_file_box_size.
#
# +------------------------------+
# |   Function f_msg_ui_file_ok  |
# +------------------------------+
#
#     Rev: 2020-05-14
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#          $5 - Box Height in characters.
#          $6 - Box Width  in characters.
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
              let Y=$5+6
              # If number of lines exceeds screen/window height then set textbox height.
              if [ $Y -ge $YSCREEN ] ; then
                 Y=$YSCREEN
              fi
              #
              # Dialog needs about 10 more spaces for the right and left window frame. 
              let X=$6+10
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
              let Y=$5+7
              # If number of lines exceeds screen/window height then set textbox height.
              if [ $Y -ge $YSCREEN ] ; then
                 Y=$YSCREEN
              fi
              #
              # Whiptail needs about 5 more spaces for the right and left window frame. 
              let X=$6+5
              # If line length exceeds screen/window width then set textbox width.
              if [ $X -ge $XSCREEN ] ; then
                 X=$XSCREEN
              fi
              #
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
#     Rev: 2020-08-07
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file.
#          $5 - Box Height in characters.
#          $6 - Box Width  in characters.
#          $7 - Pause for $7 seconds to allow text to be read.
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
              let Y=$5+6
              # If number of lines exceeds screen/window height then set textbox height.
              if [ $Y -ge $YSCREEN ] ; then
                 Y=$YSCREEN
              fi
              #
              # Dialog needs about 10 more spaces for the right and left window frame. 
              let X=$6+10
              # If line length exceeds screen/window width then set textbox width.
              if [ $X -ge $XSCREEN ] ; then
                 X=$XSCREEN
              fi
              #
              # Dialog boxes "--msgbox" "--infobox" can use option --colors with "\Z" commands for font color bold/normal.
              # Use --infobox to display text without an "OK" button.
              # Convert text file to a string with "\n" (line feeds)
              # because Dialog or Whiptail infobox needs a string for input.
              STRING=$(sed 's/$/\\n/g' $4)
              STRING=$(echo $STRING | sed 's/\\n /\\n/g')
              dialog --colors --title "$3" --infobox "$STRING" $Y $X
              #
              if [ -z $7 ] ; then
                 sleep 3
              else
                 sleep "$7"
              fi
           ;;
           whiptail)
              # Whiptail only has options --textbox or--msgbox (not --infobox in earlier versions).
              # Whiptail does not have option "--colors" with "\Z" commands for font color bold/normal.
              #
              # Whiptail needs about 7 more lines for the header and [OK] button.
              let Y=$5+7
              # If number of lines exceeds screen/window height then set textbox height.
              if [ $Y -ge $YSCREEN ] ; then
                 Y=$YSCREEN
              fi
              #
              # Whiptail needs about 5 more spaces for the right and left window frame. 
              let X=$6+5
              # If line length exceeds screen/window width then set textbox width.
              if [ $X -ge $XSCREEN ] ; then
                 X=$XSCREEN
              fi
              # Whiptail only has options --textbox or--msgbox (not --infobox in earlier versions).
              # Therefore for earlier versions cannot use Whiptail --infobox for no "OK" button but must use --textbox instead.
              # Uncomment line below for older versions of Whiptail lacking --infobox option.
              whiptail --title "$3" --textbox "$4" $Y $X
              #
              # Later versions of Whiptail have --infobox option.
              #
              # Use --infobox to display text without an "OK" button.
              # Convert text file to a string with "\n" (line feeds)
              # because Dialog or Whiptail infobox needs a string for input.
              #STRING=$(sed 's/$/\\n/g' $4)
              #STRING=$(echo $STRING | sed 's/\\n /\\n/g')
              #whiptail --title "$3" --infobox "$STRING" $Y $X
              #
              #if [ -z $7 ] ; then
              #   sleep 3
              #else
              #   sleep "$7"
              #fi
           ;;
      esac
      #
} # End of function f_msg_ui_file_nok
#
# +------------------------------+
# |Function f_msg_ui_str_box_size|
# +------------------------------+
#
#     Rev: 2020-07-16
#  Inputs: $1 - Text string or text file. 
#    Uses: None.
# Outputs: XBOX, YBOX, ZNO (string stripped of Dialog "\Z" commands).
#
f_msg_ui_str_box_size () {
      #
      # Calculate dialog/whiptail box dimensions $X, $Y.
      #
      # Does $1 string contain "\n"?  Does the string $4 contain multiple sentences?
      #
      # Debug hint: If the box has the minimum size regardless of length or width of text,
      #             the variable $TEMP_FILE may have been unset (i.e. unset TEMP_FILE).
      #             If the $TEMP_FILE is undefined, you will have a minimum box size.
      #
      case $1 in
           *\n*)
              # Yes, string $1 contains multiple sentences.
              #
              # Use command "sed" with "-e" to filter out multiple "\Z" commands.
              # Filter out "\Z[0-7]", "\Zb", \ZB", "\Zr", "\ZR", "\Zu", "\ZU", "\Zn".
              ZNO=$(echo $1 | sed -e 's|\\Z0||g' -e 's|\\Z1||g' -e 's|\\Z2||g' -e 's|\\Z3||g' -e 's|\\Z4||g' -e 's|\\Z5||g' -e 's|\\Z6||g' -e 's|\\Z7||g' -e 's|\\Zb||g' -e 's|\\ZB||g' -e 's|\\Zr||g' -e 's|\\ZR||g' -e 's|\\Zu||g' -e 's|\\ZU||g' -e 's|\\Zn||g')
              #
              # Calculate the length of the longest sentence with the $4 string.
              # How many sentences?
              # Replace "\n" with "%" and then use awk to count how many sentences.
              # Save number of sentences.
              # Use wc --lines on TEMP_FILE instead of sed-awk below.
              #YBOX=$(echo $ZNO | sed 's|\\n|%|g'| awk -F '%' '{print NF}')
              #
              # Output string without Dialog "\Z" commands into file $TEMP_FILE for wc processing.
              # The echo -e option replaces "\n" with actual <CR><LF> for wc to calculate actual longest line length.
              echo -e "$ZNO" > $TEMP_FILE
              #
              # More complex method to calculate longest sentence length,
              # without depending on "wc" but using "awk" instead.
              # Extract each sentence
              # Replace "\n" with "%" and then use awk to print current sentence.
              # This is the long way... echo $ZNO | sed 's|\\n|%|g'| awk -F "%" '{ for (i=1; i<NF+1; i=i+1) print $i }' >$TEMP_FILE
              #
              # Simpler method to calculate longest sentence length,
              # using "wc".
              # Calculate longest line length in TEMP_FILE
              # to find maximum menu width for Dialog or Whiptail.
              # The "Word Count" wc command output will not include
              # the TEMP_FILE name if you redirect "<$TEMP_FILE" into wc.
              XBOX=$(wc --max-line-length < $TEMP_FILE)
              YBOX=$(wc --lines < $TEMP_FILE)
           ;;
           *)
              # Use command "sed" with "-e" to filter out multiple "\Z" commands.
              # Filter out "\Z[0-7]", "\Zb", \ZB", "\Zr", "\ZR", "\Zu", "\ZU", "\Zn".
              ZNO=$(echo $1 | sed -e 's|\\Z0||g' -e 's|\\Z1||g' -e 's|\\Z2||g' -e 's|\\Z3||g' -e 's|\\Z4||g' -e 's|\\Z5||g' -e 's|\\Z6||g' -e 's|\\Z7||g' -e 's|\\Zb||g' -e 's|\\ZB||g' -e 's|\\Zr||g' -e 's|\\ZR||g' -e 's|\\Zu||g' -e 's|\\ZU||g' -e 's|\\Zn||g')
              #
              # No, line length is $4 string length. 
              XBOX=$(echo -n "$ZNO" | wc -c)
              # Only one sentence and one line in the $1 string.
              YBOX=1
           ;;
      esac
      #
} # End of function f_msg_ui_str_box_size
#
# +------------------------------+
# |   Function f_msg_ui_str_ok   |
# +------------------------------+
#
#     Rev: 2020-05-14
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#          $5 - Box Height in characters.
#          $6 - Box Width  in characters.
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
              let Y=$5+5
              # If number of lines exceeds screen/window height then set textbox height.
              if [ $Y -ge $YSCREEN ] ; then
                 Y=$YSCREEN
              fi
              #
              # Dialog needs about 10 more spaces for the right and left window frame. 
              let X=$6+10
              # If line length exceeds screen/window width then set textbox width.
              if [ $X -ge $XSCREEN ] ; then
                 X=$XSCREEN
              fi
              #
              # Dialog boxes "--msgbox" "--infobox" can use option --colors with "\Z" commands for font color bold/normal.
              dialog --colors --title "$3" --msgbox "$4" $Y $X
           ;;
           whiptail)
              # Whiptail only has options --textbox or--msgbox (not --infobox in earlier versions).
              # Whiptail does not have option "--colors" with "\Z" commands for font color bold/normal.
              #
              # Whiptail needs about 6 more lines for the header and [OK] button.
              let Y=$5+6
              # If number of lines exceeds screen/window height then set textbox height.
              if [ $Y -ge $YSCREEN ] ; then
                 Y=$YSCREEN
              fi
              #
              # Whiptail needs about 5 more spaces for the right and left window frame. 
              let X=$6+5
              # If line length exceeds screen/window width then set textbox width.
              if [ $X -ge $XSCREEN ] ; then
                 X=$XSCREEN
              fi
              #
              # Whiptail only has options --textbox or--msgbox (not --infobox in earlier versions).
              # f_msg_ui_str_box_size creates $ZNO which is the text string $4 but stripped of any Dialog "\Z" commands.
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
#     Rev: 2020-05-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file. 
#          $5 - Box Height in characters.
#          $6 - Box Width  in characters.
#          $7 - Pause for $7 seconds to allow text to be read.
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
              let Y=$5+5
              # If number of lines exceeds screen/window height then set textbox height.
              if [ $Y -ge $YSCREEN ] ; then
                 Y=$YSCREEN
              fi
              #
              # Dialog needs about 10 more spaces for the right and left window frame. 
              let X=$6+6
              # If line length exceeds screen/window width then set textbox width.
              if [ $X -ge $XSCREEN ] ; then
                 X=$XSCREEN
              fi
              #
              dialog --colors --no-ok --title "$3" --infobox "$4" $Y $X
              #
              if [ -z $7 ] ; then
                 sleep 3
              else
                 sleep "$7"
              fi
           ;;
           whiptail)
              # Whiptail only has options --textbox or--msgbox (not --infobox in earlier versions).
              # Whiptail does not have option "--colors" with "\Z" commands for font color bold/normal.
              #
              # Whiptail needs about 6 more lines for the header and [OK] button.
              let Y=$5+6
              # If number of lines exceeds screen/window height then set textbox height.
              if [ $Y -ge $YSCREEN ] ; then
                 Y=$YSCREEN
              fi
              #
              # Whiptail needs about 5 more spaces for the right and left window frame. 
              let X=$6+5
              # If line length exceeds screen/window width then set textbox width.
              if [ $X -ge $XSCREEN ] ; then
                 X=$XSCREEN
              fi
              #
              # Whiptail only has options --textbox or--msgbox (not --infobox in earlier versions).
              # f_msg_ui_str_box_size creates $ZNO which is the text string $4 but stripped of any Dialog "\Z" commands.
              # Ideally we want to use whiptail --title "$3" --infobox "$ZNO" $Y $X
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
#     Rev: 2020-05-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file.
#          $5 - Pause for $5 seconds to allow text to be read.
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
      echo -e "$3"
      echo
      echo
      # Display text string contents.
      echo -e "$4"
      echo
      echo
      #
      if [ -z $5 ] ; then
         sleep 3
      else
         sleep "$5"
      fi
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
#     Rev: 2020-05-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - "OK"  [OK] button at end of text.
#               "NOK" No [OK] button or "Press Enter key to continue"
#               at end of text but pause n seconds
#               to allow reader to read text by using sleep n command.
#          $3 - Title.
#          $4 - Text string or text file.
#          $5 - Pause for $5 seconds to allow text to be read.
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
      if [ -z $5 ] ; then
         sleep 3
      else
         sleep "$5"
      fi
      #
      #
      clear  # Blank the screen.
      #
} # End of function f_msg_txt_file_nok
#
# +----------------------------------------+
# |             Function f_wget            |
# +----------------------------------------+
#
#  Inputs: $1=GUI
#          $2=TARGET_DIR.
#    Uses: REPOSITORY, SCRIPT, ANS.
# Outputs: None.
#
f_wget () {
      #
      # Repository BASH Function Library.
      REPOSITORY="https://raw.githubusercontent.com/rdchin/BASH_function_library/master/"
      for SCRIPT in common_bash_function.lib example.sh
          do
             f_wget_do $1 $REPOSITORY $SCRIPT $2
          done
      #
      # Repository clamav-script.
      REPOSITORY="https://raw.githubusercontent.com/rdchin/clamav-script/master/"
      SCRIPT="virusscan_clamav.sh"
      f_wget_do $1 $REPOSITORY $SCRIPT $2
      #
      # Repository rsync directories.
      REPOSITORY="https://raw.githubusercontent.com/rdchin/rsync_directories/master/"
      for SCRIPT in server_rsync.sh server_rsync.lib
          do
             f_wget_do $1 $REPOSITORY $SCRIPT $2
          done
      #
      # Repository file-rename.
      REPOSITORY="https://raw.githubusercontent.com/rdchin/file-rename/master/"
      for SCRIPT in file_rename.sh file_recursive_rename.sh
          do
             f_wget_do $1 $REPOSITORY $SCRIPT $2
          done
      #
      # Repository apt-pkg-upgrade.
      REPOSITORY="https://raw.githubusercontent.com/rdchin/apt-pkg-upgrade/master/"
      for SCRIPT in pkg-upgrade.sh github_repo_scripts.sh
          do
             f_wget_do $1 $REPOSITORY $SCRIPT $2
          done
      #
      # Repository samba-mount.
      REPOSITORY="https://raw.githubusercontent.com/rdchin/samba-mount/master/"
      for SCRIPT in mountup.sh mountup.lib mountup_servers.lib
          do
             f_wget_do $1 $REPOSITORY $SCRIPT $2
          done
      #
      # Repository bash-automatic-menu-creator.
      REPOSITORY="https://raw.githubusercontent.com/rdchin/bash-automatic-menu-creator/master/"
      for SCRIPT in menu.sh menu_module_main.lib menu_module_sub0.lib menu_module_sub1.lib
          do
             f_wget_do $1 $REPOSITORY $SCRIPT $2
          done
      #
      # Repository cli-app-menu.
      case $1 in
           text)
             echo -n "Choose repository for project 'cli-app-menu' (Master/Testing/Develpment) (Testing): "; read ANS
             f_wget_repos $1 $2 "cli-app-menu"
          ;;
          dialog | whiptail)
             $1 --inputbox "Choose repository for project 'cli-app-menu' (Master/Testing/Develpment)" 10 70 "Master"
             ANS=$?
             f_wget_repos $1 $2 "cli-app-menu"
          ;;
      esac
      #
      TEMP_FILE=/$THIS_DIR/$THIS_FILE"_temp2.txt"
      f_message $1 "OK" "Review wget log files" "$TEMP_FILE"
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
}  # End of function f_wget.
#
# +----------------------------------------+
# |          Function f_wget_repos         |
# +----------------------------------------+
#
#  Inputs: $1=GUI
#          $2=TARGET_DIR.
#          $3=REPOSITORY
#          ANS
#    Uses: SCRIPT.
# Outputs: None.
#
f_wget_repos () {
      #
      case $ANS in
           [Mm][Aa][Ss][Tt][Ee][Rr] | [Mm][Aa][Ss][Tt][Ee] | [Mm][Aa][Ss][Tt] | [Mm][Aa][Ss] | [Mm][Aa] | [Mm])
              REPOSITORY="https://raw.githubusercontent.com/rdchin/$3/master/"
              for SCRIPT in cliappmenu.sh lib_cli-common.lib lib_cli-menu-cat.lib lib_cli-web-sites.lib mod_apps-system.lib CODE_HISTORY COPYING EDIT_HISTORY LIST_APPS README
                  do
                     f_wget_do $1 $REPOSITORY $SCRIPT $2
                  done
           ;;
           [Tt][Ee][Ss][Tt][Ii][Nn][Gg] | Tt][Ee][Ss][Tt][Ii][Nn] | Tt][Ee][Ss][Tt][Ii] | Tt][Ee][Ss][Tt] | Tt][Ee][Ss] | [Tt][Ee] | [Tt])
              REPOSITORY="https://raw.githubusercontent.com/rdchin/$3/testing/"
              for SCRIPT in cliappmenu.sh lib_cli-common.lib lib_cli-menu-cat.lib lib_cli-web-sites.lib menu_module_configuration.lib menu_module_information.lib menu_module_main.lib lib mod_apps-system.lib CODE_HISTORY COPYING EDIT_HISTORY LIST_APPS README
                  do
                     f_wget_do $1 $REPOSITORY $SCRIPT $2
                  done
           ;;
           [Dd][Ee][Vv][Ee][Ll][Oo][Pp][Mm][Ee][Nn][Tt] | [Dd][Ee][Vv][Ee][Ll][Oo][Pp][Mm][Ee][Nn] | [Dd][Ee][Vv][Ee][Ll][Oo][Pp][Mm][Ee] | [Dd][Ee][Vv][Ee][Ll][Oo][Pp][Mm] | [Dd][Ee][Vv][Ee][Ll][Oo][Pp] | [Dd][Ee][Vv][Ee][Ll][Oo] | [Dd][Ee][Vv][Ee][Ll] | [Dd][Ee][Vv][Ee] | [Dd][Ee][Vv] | [Dd][Ee] | [Dd])
              REPOSITORY="https://raw.githubusercontent.com/rdchin/$3/develop/"
              for SCRIPT in cliappmenu.sh lib_cli-common.lib lib_cli-menu-cat.lib lib_cli-web-sites.lib menu_module_app_categories.lib menu_module_app_mod_management.lib menu_module_configuration.lib menu_module_information.lib menu_module_list_find_menus.lib menu_module_main.lib menu_module_mod_management.lib menu_module_term_color.lib mod_apps-system.lib CODE_HISTORY COPYING EDIT_HISTORY LIST_APPS README
                  do
                     f_wget_do $1 $REPOSITORY $SCRIPT $2
                  done
           ;;
           *)
              REPOSITORY="https://raw.githubusercontent.com/rdchin/$3/master/"
              for SCRIPT in cliappmenu.sh lib_cli-common.lib lib_cli-menu-cat.lib lib_cli-web-sites.lib mod_apps-system.lib CODE_HISTORY COPYING EDIT_HISTORY LIST_APPS README
                  do
                     f_wget_do $1 $REPOSITORY $SCRIPT $2
                  done
           ;;
      esac
      #
}  # End of function f_wget_repos.
#
# +----------------------------------------+
# |            Function f_wget_do          |
# +----------------------------------------+
#
#  Inputs: $1=GUI.
#          $2=REPOSITORY.
#          $3=SCRIPT.
#          $4=TARGET_DIR.
#    Uses: None.
# Outputs: None.
#
f_wget_do () {
      #
      # If using wget --backups=4, then comment out.
      #
      # Check to see if $TARGET_DIR/<filename> exists.
      # If filename exists, then rename it to *.bak.
      if [ -r ~/$4/$3 ] ; then
         f_message $1 "NOK" "Back-up file" "Saving existing file\nFrom ~/$4/$3\n  To ~/$4/$3.bak" 0
         mv ~/$4/$3 ~/$4/$3.bak
      fi
      #
      clear # Blank the screen.
      #
      TEMP_FILE=$THIS_FILE"_temp2.txt"
      #wget --show-progress --backups=4 --append-output=/$THIS_DIR/$TEMP_FILE $2$3
      wget --show-progress --append-output=/$THIS_DIR/$TEMP_FILE $2$3
      ERROR=$?
      TEMP_FILE=$THIS_FILE"_temp.txt"
      if [ $ERROR -ne 0 ] ; then
         f_message $1 "OK" "Wget Download" "!!! \Z1\Zbwget download failed\Zn !!! for file: ~\n$2$3" 2
         #
         clear # Blank the screen.
         #
         # try wget download one more time.
         TEMP_FILE=$THIS_FILE"_temp2.txt"
         #wget --show-progress --backups=4 --append-output=/$THIS_DIR/$TEMP_FILE $2$3
         wget --show-progress --append-output=/$THIS_DIR/$TEMP_FILE $2$3
         ERROR=$?
         TEMP_FILE=$THIS_FILE"_temp.txt"
         # If wget download failed, then print error and rename <TARGET_DIR>/<Script-Name>.sh.bak to <Script-Name>.sh.
         if [ $ERROR -ne 0 ] ; then
            f_message $1 "OK" "Wget Download" "!!! \Z1\Zbwget download retry failed\Zn !!! for file:\n$2$3" 2
            #
            # Rename <TARGET_DIR>/<SCRIPT>.bak to <TARGET_DIR>/<SCRIPT>.
            mv ~/$4/$3.bak ~/$4/$3
         fi
      fi
      #
      # if using wget --backups=4, then comment out f_bak.
      f_bak $1 $4 $3  # Delete unneeded *.bak files.
      #
}  # End of function f_wget_do.
#
# +----------------------------------------+
# |              Function f_bak            |
# +----------------------------------------+
#
#  Inputs: $1=GUI.
#          $2=TARGET_DIR.
#          $3=SCRIPT.
#    Uses: ERROR.
# Outputs: None.
#
f_bak () {
      #
      # Check to see if $TARGET_DIR/<latest version filename> exists.
      # If filename exists and *.bak filename exists, then compare it to *.bak.
      #    If same version of file, then delete *.bak.
      #    If different versions of file, then do nothing.
      #
      if [ -r ~/$2/$3.bak ] && [ -r ~/$2/$3 ] ; then
         cmp -s ~/$2/$3 ~/$2/$3.bak
         ERROR=$?
         if [ $ERROR -eq 0 ] ; then
            f_message $1 "NOK" "Clean-up" "Deleting redundant file:\n~/$2/$3.bak" 0
            rm ~/$2/$3.bak
         fi
      fi
      #
}  # End of function f_bak.
#
# +----------------------------------------+
# |      Function f_edit_script_files      |
# +----------------------------------------+
#
#  Inputs: $1=GUI.
#          $2=TARGET_DIR.
#    Uses: SCRIPT.
# Outputs: None.
#
f_edit_script_files () {
      #
      for SCRIPT in mountup.sh mountup.lib
      do
          # Does file exist and is writeable?
          if [ -w ~/$1/$SCRIPT ] ; then
             f_edit_sharing_names $2 $SCRIPT
          else
            f_message $1 "NOK" "Error" "\Z1\Zb!!! Cannot modify $1/$SCRIPT !!!\Zn" 1
          fi
      done
      #
}  # End of function f_edit_script_files.
#
# +----------------------------------------+
# |      Function f_edit_sharing_names     |
# +----------------------------------------+
#
#  Inputs: $1=TARGET_DIR.
#          $2=SCRIPT.
#          THIS_FILE.
#    Uses: X, XSTR.
# Outputs: None.
#
f_edit_sharing_names () {
      #
      # Disable the sample share-point and mount-point names
      # by substituting "#@@" with "\#@@" within the script file.
      sed -i 's/^#@@/# @@/' ~/$1/$2
      #
      # Get line number of string to insert data below that line.
      X=$(grep -n "Add your actual data below" ~/$1/$2 | awk -F ":#" '{ print $1}')
      if [ -n "$X" ] ; then
         let X=1+$X
      fi
      # echo "$1 Line number=$X"  # Diagnostic test line.
      #
      # Loop to read a line of data above, then insert that line into the script.
      if [ -n "$X" ] ; then
         while read XSTR
         do
               case $XSTR in
                    # Insert that line into script, "mountup.sh" or "mountup.lib".
                    [#][@][@]) # echo "XSTR=$XSTR"
                       # Insert the line of the real share-point and mount-point names into the script.
                       sed -i "$X"i"#" ~/$1/$2
                    ;;
                    [#][@][@]*) # echo "XSTR=$XSTR"
                       # Insert the line of the real share-point and mount-point names into the script.
                       sed -i "$X"i"$XSTR" ~/$1/$2
                    ;;
               esac
         done < ~/$THIS_FILE
      fi
      unset X XSTR
      #
}  # End of function f_edit_sharing_names.
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
#     Rev: 2020-07-01
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
clear  # Blank the screen.
#
echo "Running script $THIS_FILE"
echo "***   Rev. $VERSION   ***"
echo
sleep 1  # pause for 1 second automatically.
#
clear # Blank the screen.
#
# Set THIS_DIR, SCRIPT_PATH to directory path of script.
f_script_path
#
# Set Temporary file using $THIS_DIR from f_script_path.
TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
#
# Test for Optional Arguments.
f_arguments $1 $2 # Also sets variable GUI.
#
# If command already specifies GUI, then do not detect GUI i.e. "bash dropfsd.sh dialog" or "bash dropfsd.sh text".
if [ -z $GUI ] ; then
   # Test for GUI (Whiptail or Dialog) or pure text environment.
   f_detect_ui
fi
#
# Show About this script message.
f_about $GUI "NOK" 5
#
#GUI="whiptail"  # Diagnostic line.
#GUI="dialog"    # Diagnostic line.
#GUI="text"      # Diagnostic line.
#
# Test for BASH environment.
f_test_environment
#
# Check for existence of directory, ~/scripts_from_github.
cd ~
if [ ! -e ~/$TARGET_DIR ] ; then
    mkdir $TARGET_DIR
fi
#
if [ -e ~/$TARGET_DIR ] ; then
   # Directory exists, then wget script files there.
   cd $TARGET_DIR
   # Download files from GitHub.
   # Check internet connectivity to raw.githubusercontent.com.
   f_test_connect $GUI
   #
   # If there is a good internet connection, continue to wget download.
   if [ $ERROR -eq 0 ] ; then
      f_wget $GUI $TARGET_DIR
   fi
   #
   # Edit files mountup.sh and mountup.lib to customize for my LAN Host Names.
   #f_edit_script_files $1 $TARGET_DIR
   #
   # Make newly downloaded files executable.
   chmod -R 755 ~/$TARGET_DIR
else
   f_message $GUI "OK" "Error" " >>> \Z1\ZbDownload directory does not exist: ~/$TARGET_DIR\Zn <<<"
fi
#
TEMP_FILE=$THIS_FILE"_temp.txt"
if [ -r $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
clear # Blank the screen.
#
exit 0  # This cleanly closes the process generated by #!bin/bash. 
        # Otherwise every time this script is run, another instance of
        # process /bin/bash is created using up resources.
        #
# all dun dun noodles.

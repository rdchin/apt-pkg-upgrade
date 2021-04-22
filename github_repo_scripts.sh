#!/bin/bash
#
# ©2021 Copyright 2021 Robert D. Chin
# Email: RDevChin@Gmail.com
#
# Usage: bash github_repo_scripts.sh
#        (not sh github_repo_scripts.sh)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# +--------------------------------------------------------------------------+
# |                                                                          |
# |                 Customize Menu choice options below.                     |
# |                                                                          |
# +--------------------------------------------------------------------------+
#
# Format: <#@@> <Menu Option> <#@@> <Description of Menu Option> <#@@> <Corresponding function or action or cammand>
#
#@@Exit#@@Exit to command-line prompt.#@@break
#
#@@Download Projects#@@Download project source code from GitHub.#@@f_git_download^$GUI^$LOCAL_DIR
#
#@@Manage Local Project files#@@Manage GitHub Project files on this PC.#@@f_file_manager^$GUI^~/scripts_downloaded_from_github/
#
#@@About#@@Version information of this script.#@@f_about^$GUI
#
#@@Code History#@@Display code change history of this script.#@@f_code_history^$GUI
#
#@@Version Update#@@Check for updates to this script and download.#@@f_check_version^$GUI
#
#@@Help#@@Display help message.#@@f_help_message^$GUI
#
# +----------------------------------------+
# |        Default Variable Values         |
# +----------------------------------------+
#
VERSION="2021-04-01 01:57"
THIS_FILE=$(basename $0)
FILE_TO_COMPARE=$THIS_FILE
TEMP_FILE=$THIS_FILE"_temp.txt"
GENERATED_FILE=$THIS_FILE"_menu_generated.lib"
#
# Specify LOCAL Directory.
LOCAL_DIR="scripts_downloaded_from_github"
#
#
#================================================================
# EDIT THE LINES BELOW TO SET REPOSITORY SERVERS AND DIRECTORIES
# AND TO INCLUDE ALL DEPENDENT SCRIPTS AND LIBRARIES TO DOWNLOAD.
#================================================================
#
#
#--------------------------------------------------------------
# Set variables to mount the Local Repository to a mount-point.
#--------------------------------------------------------------
#
# LAN File Server shared directory.
# SERVER_DIR="[FILE_SERVER_DIRECTORY_NAME_GOES_HERE]"
  SERVER_DIR="//file_server/public"
#
# Local PC mount-point directory.
# MP_DIR="[LOCAL_MOUNT-POINT_DIRECTORY_NAME_GOES_HERE]"
  MP_DIR="/mnt/file_server/public"
#
# Local PC mount-point with LAN File Server Local Repository full directory path.
# Example: 
#                   File server shared directory is "//file_server/public".
# Repostory directory under the shared directory is "scripts/BASH/Repository".
#                 Local PC Mount-point directory is "/mnt/file_server/public".
#
# LOCAL_REPO_DIR="$MP_DIR/[DIRECTORY_PATH_TO_LOCAL_REPOSITORY]"
  LOCAL_REPO_DIR="$MP_DIR/scripts/BASH/Repository"
#
#
#=================================================================
# EDIT THE LINES BELOW TO SPECIFY THE FILE NAMES TO UPDATE.
# FILE NAMES INCLUDE ALL DEPENDENT SCRIPTS LIBRARIES.
#=================================================================
#
#
# --------------------------------------------
# Create a list of all dependent library files
# and write to temporary file, FILE_LIST.
# --------------------------------------------
#
# Temporary file FILE_LIST contains a list of file names of dependent
# scripts and libraries.
#
FILE_LIST=$THIS_FILE"_file_temp.txt"
#
# Format: [File Name]^[Local/Web]^[Local repository directory]^[web repository directory]
echo "common_bash_function.lib^Web^$LOCAL_REPO_DIR^https://raw.githubusercontent.com/rdchin/BASH_function_library/master/" >> $FILE_LIST
#
# Create a name for a temporary file which will have a list of files which need to be downloaded.
FILE_DL_LIST=$THIS_FILE"_file_dl_temp.txt"
#
# +----------------------------------------+
# |            Brief Description           |
# +----------------------------------------+
#
#& Brief Description
#&
#& This script will download files from Github/rdchin repositories
#& to the host PC into directory ~/scripts_downloaded_from_github/
#& to assure that the latest released versions of the files are available
#& on the host PC.
#&
#& Usage: bash github_repo_scripts.sh
#&        (not sh github_repo_scripts.sh)
#&
#&    This program is free software: you can redistribute it and/or modify
#&    it under the terms of the GNU General Public License as published by
#&    the Free Software Foundation, either version 3 of the License, or
#&    (at your option) any later version.
#&
#&
#&    This program is distributed in the hope that it will be useful,
#&    but WITHOUT ANY WARRANTY; without even the implied warranty of
#&    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#&    GNU General Public License for more details.
#&
#&    You should have received a copy of the GNU General Public License
#&    along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# +----------------------------------------+
# |             Help and Usage             |
# +----------------------------------------+
#
#?    Usage: bash github_repo_scripts.sh [OPTION(S)]
#?
#? Examples:
#?
#?                            Force display to use a different UI.
#? bash github_repo_scripts.sh text      Use Cmd-line user-interface.
#?                             dialog    Use Dialog   user-interface.
#?                             whiptail  Use Whiptail user-interface.
#?
#? bash github_repo_scripts.sh --help    Displays this help message.
#?                             -?
#?
#? bash github_repo_scripts.sh --about   Displays script version.
#?                             --version
#?                             --ver
#?                             -v
#?
#? bash github_repo_scripts.sh --history Displays script code history.
#?                             --hist
#?
#? bash github_repo_scripts.sh --update
#?                             -u
#?
#? bash convert_address_data_newton_assessor_web_site.sh --history
#?                                                       --hist
#? Examples using 2 arguments:
#?
#? bash github_repo_scripts.sh --hist text
#?                             --ver dialog
#
# +----------------------------------------+
# |                Code Notes              |
# +----------------------------------------+
#
# To disable the [ OPTION ] --update -u to update the script:
#    1) Comment out the call to function fdl_download_missing_scripts in
#       Section "Start of Main Program".
#
# To completely delete the [ OPTION ] --update -u to update the script:
#    1) Delete the call to function fdl_download_missing_scripts in
#       Section "Start of Main Program".
#    2) Delete all functions beginning with "f_dl"
#    3) Delete instructions to update script in Section "Help and Usage".
#
# To disable the Main Menu:
#    1) Comment out the call to function f_menu_main under "Run Main Code"
#       in Section "Start of Main Program".
#    2) Add calls to desired functions under "Run Main Code"
#       in Section "Start of Main Program".
#
# To completely remove the Main Menu and its code:
#    1) Delete the call to function f_menu_main under "Run Main Code" in
#       Section "Start of Main Program".
#    2) Add calls to desired functions under "Run Main Code"
#       in Section "Start of Main Program".
#    3) Delete the function f_menu_main.
#    4) Delete "Menu Choice Options" in this script located under
#       Section "Customize Menu choice options below".
#       The "Menu Choice Options" lines begin with "#@@".
#
# +----------------------------------------+
# |           Code Change History          |
# +----------------------------------------+
#
## Code Change History
##
## (After each edit made, please update Code History and VERSION.)
##
## Includes changes to github_repo_scripts.sh.
##
## 2021-04-01 *Section "Code Notes" added. Improved comments.
##            *Updated to latest standards.
##            *Comment cleanup. Move the appended comments to start on the
##             previous line to improve readability.
##            *f_check_version updated to add a second optional argument.
##             so a single copy in dropfsd_module_main.lib can replace the
##             customized versions in fsds.sh, and fsdt.sh.
##             Rewrote to eliminate comparing the version of a hard-coded
##             script or file name in favor of passing any script or file
##             name as an argument whose version is then compared to
##             determine whether or not to upgrade.
##            *Section "Main Program" detect UI before detecting arguments.
##            *Comment cleanup. Move the appended comments to start on the
##             previous line to improve readability.
##            *fdl_source bug ERROR not initialized fixed.
##            *Section "Default Variable Values" defined FILE_TO_COMPARE and
##             defined THIS_FILE=$(basename $0) to reduce maintenance.
##            *fdl_download_missing_scripts added 2 arguments for file names
##             as arguments.
##            *fdl_download_missing_scripts, f_run_app, and application
##             functions changed to allow missing dependent scripts to be
##             automatically downloaded rather than simply displaying an
##             error message that they were missing.
##            *f_display_common, f_menu_main, f_check_version,
##            *f_update_library, updated to latest standards.
##            *fdl_source added. f_source deleted.
##            *fdl_download_missing_scripts changed to use fdl_source.
##            *Section "Main Menu", "Application Menu" changed the order of
##             menu choices.
##            *Section "Application Menu" added with in new library
##             men_module_apps.lib.
##            *Delete obsolete library men_module_download.lib.
##            *Section "Update Menu" added option to update .bashrc.
##            *fdl_download_missing_scripts rewrote logic for downloading,
##             extensively tested mountpoint action, Local Repository and
##             Web Repository error fallback logic of downloading when
##             either repository and/or target file were not available.
##            *f_choose_dl_source, f_choose_download_source deleted.
##            *Section "Code Change History" added instructions.
##            *fdl_download_missing_scripts added to modulize existing code
##             under Section "Main Program" to allow easier deletion of code
##             the "Update Version" feature is not desired.
##            *Functions related to "Update Version" renamed with an "fdl"
##             prefix to identify dependent functions to delete if that
##             function is not desired.
##            *Section "Code Change History" added instructions on how to
##             disable/delete "Update Version" feature or "Main Menu".
##            *Changed menu item wording from "Exit to command-line" prompt.
##                                         to "Exit this menu."
##
## 2021-02-16 *Added Main Menu.
##
## 2020-09-09 *Updated to latest standards.
##
## 2020-08-07 *Updated to latest standards.
##
## 2020-07-31 *Reaffirmed this script SHOULD NOT be dependent on BASH
##             Function Library because it may not be present and this
##             script downloadsit from Github.com.
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
## 2020-05-16 *f_wget of mountup repository added file mountup_servers.lib.
##
## 2020-05-06 *f_msg_ui_file_box_size, f_msg_ui_file_ok display bug fixed.
##
## 2020-05-01 *Updated to latest standards.
##            *f_wget added new files in git repositories.
##
## 2020-04-24 *Deleted from repository samba-mount, scripts "mountup_gui.sh"
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
# +------------------------------------+
# |     Function f_display_common      |
# +------------------------------------+
#
#     Rev: 2021-03-31
#  Inputs: $1=UI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2=Delimiter of text to be displayed.
#          $3="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $4=Pause $4 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
# Summary: Display lines of text beginning with a given comment delimiter.
#
# Dependencies: f_message.
#
f_display_common () {
      #
      # Set $THIS_FILE to the file name containing the text to be displayed.
      #
      # WARNING: Do not define $THIS_FILE within a library script.
      #
      # This prevents $THIS_FILE being inadvertently re-defined and set to
      # the file name of the library when the command:
      # "source [ LIBRARY_FILE.lib ]" is used.
      #
      # For that reason, all library files now have the line
      # THIS_FILE="[LIBRARY_FILE.lib]" commented out or deleted.
      #
      #
      #==================================================================
      # EDIT THE LINE BELOW TO DEFINE $THIS_FILE AS THE ACTUAL FILE NAME
      # CONTAINING THE BRIEF DESCRIPTION, CODE HISTORY, AND HELP MESSAGE.
      #==================================================================
      #
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
      sed --silent "s/$2//p" $THIS_DIR/$THIS_FILE >> $TEMP_FILE
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
# +----------------------------------------+
# |        Function f_check_version        |
# +----------------------------------------+
#
#     Rev: 2021-03-25
#  Inputs: $1 - UI "dialog" or "whiptail" or "text".
#          $2 - [OPTIONAL] File name to compare.
#          FILE_TO_COMPARE.
#    Uses: SERVER_DIR, MP_DIR, TARGET_DIR, TARGET_FILE, VERSION, TEMP_FILE, ERROR.
# Outputs: ERROR.
#
# Summary: Check the version of a single, local file or script,
#          FILE_TO_COMPARE with the version of repository file.
#          If the repository file has latest version, then copy all 
#          dependent files and libraries from the repository to local PC.
#
# TO DO enhancement: If local (LAN) repository is unavailable, then
#          connect to repository on the web if available.
#
# Dependencies: f_version_compare.
#
f_check_version () {
      #
      #
      #=================================================================
      # EDIT THE LINES BELOW TO DEFINE THE LAN FILE SERVER DIRECTORY,
      # LOCAL MOUNTPOINT DIRECTORY, LOCAL REPOSITORY DIRECTORY AND
      # FILE TO COMPARE BETWEEN THE LOCAL PC AND (LAN) LOCAL REPOSITORY.
      #=================================================================
      #
      #
      # LAN File Server shared directory.
      # SERVER_DIR="[FILE_SERVER_DIRECTORY_NAME_GOES_HERE]"
        SERVER_DIR="//file_server/public"
      #
      # Local PC mount-point directory.
      # MP_DIR="[LOCAL_MOUNT-POINT_DIRECTORY_NAME_GOES_HERE]"
        MP_DIR="/mnt/file_server/public"
      #
      # Local PC mount-point with LAN File Server Local Repository full directory path.
      # Example: 
      #                   File server shared directory is "//file_server/public".
      # Repository directory under the shared directory is "scripts/BASH/Repository".
      #                 Local PC Mount-point directory is "/mnt/file_server/public".
      #
      # Local PC mount-point with LAN File Server Local Repository full directory path.
      # LOCAL_REPO_DIR="$MP_DIR/[DIRECTORY_PATH_TO_LOCAL_REPOSITORY]"
        LOCAL_REPO_DIR="$MP_DIR/scripts/BASH/Repository"
      #
      # Local PC file to be compared.
      if [ $# -eq 2 ] ; then
         # There are 2 arguments that have been passed to this function.
         # $2 contains the file name to compare.
         FILE_TO_COMPARE=$2
      else
         # $2 is null, so specify file name.
         if [ -z "$FILE_TO_COMPARE" ] ; then
            # FILE_TO_COMPARE is undefined so specify file name.
            FILE_TO_COMPARE=$(basename $0)
         fi
      fi
      #
      # Version of Local PC file to be compared.
      VERSION=$(grep --max-count=1 "VERSION" $FILE_TO_COMPARE)
      #
      FILE_LIST=$THIS_DIR/$THIS_FILE"_file_temp.txt"
      ERROR=0
      #
      #
      #=================================================================
      # EDIT THE LINES BELOW TO SPECIFY THE FILE NAMES TO UPDATE.
      # FILE NAMES INCLUDE ALL DEPENDENT SCRIPTS AND LIBRARIES.
      #=================================================================
      #
      #
      # Create list of files to update and write to temporary file, FILE_LIST.
      #
      echo "github_repo_scripts.sh"    > $FILE_LIST  # <<<--- INSERT ACTUAL FILE NAME HERE.
      echo "common_bash_function.lib" >> $FILE_LIST  # <<<--- INSERT ACTUAL FILE NAME HERE.
      #
      f_version_compare $1 $SERVER_DIR $MP_DIR $LOCAL_REPO_DIR $FILE_TO_COMPARE "$VERSION" $FILE_LIST
      #
      if [ -r  $FILE_LIST ] ; then
         rm  $FILE_LIST
      fi
      #
}  # End of function f_check_version.
#
# +----------------------------------------+
# |          Function f_menu_main          |
# +----------------------------------------+
#
#     Rev: 2021-03-07
#  Inputs: $1 - "text", "dialog" or "whiptail" the preferred user-interface.
#    Uses: ARRAY_FILE, GENERATED_FILE, MENU_TITLE.
# Outputs: None.
#
# Summary: Display Main-Menu.
#          This Main Menu function checks its script for the Main Menu
#          options delimited by "#@@" and if it does not find any, then
#          it it defaults to the specified library script.
#
# Dependencies: f_menu_arrays, f_create_show_menu.
#
f_menu_main () { # Create and display the Main Menu.
      #
      GENERATED_FILE=$THIS_DIR/$THIS_FILE"_menu_main_generated.lib"
      #
      # Does this file have menu items in the comment lines starting with "#@@"?
      grep --silent ^\#@@ $THIS_DIR/$THIS_FILE
      ERROR=$?
      # exit code 0 - menu items in this file.
      #           1 - no menu items in this file.
      #               file name of file containing menu items must be specified.
      if [ $ERROR -eq 0 ] ; then
         # Extract menu items from this file and insert them into the Generated file.
         # This is required because f_menu_arrays cannot read this file directly without
         # going into an infinite loop.
         grep ^\#@@ $THIS_DIR/$THIS_FILE >$GENERATED_FILE
         #
         # Specify file name with menu item data.
         ARRAY_FILE="$GENERATED_FILE"
      else
         #
         #
         #================================================================================
         # EDIT THE LINE BELOW TO DEFINE $ARRAY_FILE AS THE ACTUAL FILE NAME (LIBRARY)
         # WHERE THE MENU ITEM DATA IS LOCATED. THE LINES OF DATA ARE PREFIXED BY "#@@".
         #================================================================================
         #
         #
         # Specify library file name with menu item data.
         # ARRAY_FILE="[FILENAME_GOES_HERE]"
           ARRAY_FILE="$THIS_DIR/dummy_file.lib"
      fi
      #
      # Create arrays from data.
      f_menu_arrays $ARRAY_FILE
      #
      # Calculate longest line length to find maximum menu width
      # for Dialog or Whiptail using lengths calculated by f_menu_arrays.
      let MAX_LENGTH=$MAX_CHOICE_LENGTH+$MAX_SUMMARY_LENGTH
      #
      # Create generated menu script from array data.
      #
      # Note: ***If Menu title contains spaces,
      #       ***the size of the menu window will be too narrow.
      #
      # Menu title MUST use underscores instead of spaces.
      MENU_TITLE="Action_Menu"
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_menu_main_temp.txt"
      #
      f_create_show_menu $1 $GENERATED_FILE $MENU_TITLE $MAX_LENGTH $MAX_LINES $MAX_CHOICE_LENGTH $TEMP_FILE
      #
      if [ -r $GENERATED_FILE ] ; then
         rm $GENERATED_FILE
      fi
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
} # End of function f_menu_main.
#
# +----------------------------------------+
# |  Function fdl_dwnld_file_from_web_site |
# +----------------------------------------+
#
#     Rev: 2021-03-08
#  Inputs: $1=GitHub Repository
#          $2=file name to download.
#    Uses: None.
# Outputs: None.
#
# Summary: Download a list of file names from a web site.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: wget.
#
#
fdl_dwnld_file_from_web_site () {
      #
      # $1 ends with a slash "/" so can append $2 immediately after $1.
      echo
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<"
      echo ">>> Download file from Web Repository <<<"
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<"
      echo
      wget --show-progress $1$2
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
            echo
            echo ">>>>>>>>>>>>>><<<<<<<<<<<<<<"
            echo ">>> wget download failed <<<"
            echo ">>>>>>>>>>>>>><<<<<<<<<<<<<<"
            echo
            echo "Error copying from Web Repository file: \"$2.\""
            echo
      else
         # Make file executable (useable).
         chmod +x $2
         #
         if [ -x $2 ] ; then
            # File is good.
            ERROR=0
         else
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> File Error after download from Web Repository <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
            echo "$2 is missing or file is not executable."
            echo
         fi
      fi
      #
      # Make downloaded file executable.
      chmod 755 $2
      #
} # End of function fdl_dwnld_file_from_web_site.
#
# +-----------------------------------------------+
# | Function fdl_dwnld_file_from_local_repository |
# +-----------------------------------------------+
#
#     Rev: 2021-03-08
#  Inputs: $1=Local Repository Directory.
#          $2=File to download.
#    Uses: TEMP_FILE.
# Outputs: ERROR.
#
# Summary: Copy a file from the local repository on the LAN file server.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: None.
#
fdl_dwnld_file_from_local_repository () {
      #
      echo
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<"
      echo ">>> File Copy from Local Repository <<<"
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<"
      echo
      eval cp -p $1/$2 .
      ERROR=$?
      #
      if [ $ERROR -ne 0 ] ; then
         echo
         echo ">>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<"
         echo ">>> File Copy Error from Local Repository <<<"
         echo ">>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<"
         echo
         echo -e "Error copying from Local Repository file: \"$2.\""
         echo
         ERROR=1
      else
         # Make file executable (useable).
         chmod +x $2
         #
         if [ -x $2 ] ; then
            # File is good.
            ERROR=0
         else
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> File Error after copy from Local Repository <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
            echo -e "File \"$2\" is missing or file is not executable."
            echo
            ERROR=1
         fi
      fi
      #
      if [ $ERROR -eq 0 ] ; then
         echo
         echo -e "Successful Update of file \"$2\" to latest version.\n\nScript must be re-started to use the latest version."
         echo "____________________________________________________"
      fi
      #
} # End of function fdl_dwnld_file_from_local_repository.
#
# +-------------------------------------+
# |       Function fdl_mount_local      |
# +-------------------------------------+
#
#     Rev: 2021-03-10
#  Inputs: $1=Server Directory.
#          $2=Local Mount Point Directory
#          TEMP_FILE
#    Uses: TARGET_DIR, UPDATE_FILE, ERROR, SMBUSER, PASSWORD.
# Outputs: ERROR.
#
# Summary: Mount directory using Samba and CIFS and echo error message.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: Software package "cifs-utils" in the Distro's Repository.
#
fdl_mount_local () {
      #
      # Mount local repository on mount-point.
      # Write any error messages to file $TEMP_FILE. Get status of mountpoint, mounted?.
      mountpoint $2 >/dev/null 2>$TEMP_FILE
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
         # Mount directory.
         # Cannot use any user prompted read answers if this function is in a loop where file is a loop input.
         # The read statements will be treated as the next null parameters in the loop without user input.
         # To solve this problem, specify input from /dev/tty "the keyboard".
         #
         echo
         read -p "Enter user name: " SMBUSER < /dev/tty
         echo
         read -s -p "Enter Password: " PASSWORD < /dev/tty
         echo sudo mount -t cifs $1 $2
         sudo mount -t cifs -o username="$SMBUSER" -o password="$PASSWORD" $1 $2
         #
         # Write any error messages to file $TEMP_FILE. Get status of mountpoint, mounted?.
         mountpoint $2 >/dev/null 2>$TEMP_FILE
         ERROR=$?
         #
         if [ $ERROR -ne 0 ] ; then
            echo
            echo ">>>>>>>>>><<<<<<<<<<<"
            echo ">>> Mount failure <<<"
            echo ">>>>>>>>>><<<<<<<<<<<"
            echo
            echo -e "Directory mount-point \"$2\" is not mounted."
            echo
            echo -e "Mount using Samba failed. Are \"samba\" and \"cifs-utils\" installed?"
            echo "------------------------------------------------------------------------"
            echo
         fi
         unset SMBUSER PASSWORD
      fi
      #
} # End of function fdl_mount_local.
#
# +------------------------------------+
# |        Function fdl_source         |
# +------------------------------------+
#
#     Rev: 2021-03-25
#  Inputs: $1=File name to source.
# Outputs: ERROR.
#
# Summary: Source the provided library file and echo error message.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: None.
#
fdl_source () {
      #
      # Initialize ERROR.
      ERROR=0
      #
      if [ -x "$1" ] ; then
         # If $1 is a library, then source it.
         case $1 in
              *.lib)
                 source $1
                 ERROR=$?
                 #
                 if [ $ERROR -ne 0 ] ; then
                    echo
                    echo ">>>>>>>>>><<<<<<<<<<<"
                    echo ">>> Library Error <<<"
                    echo ">>>>>>>>>><<<<<<<<<<<"
                    echo
                    echo -e "$1 cannot be sourced using command:\n\"source $1\""
                    echo
                 fi
              ;;
         esac
         #
      fi
      #
} # End of function fdl_source.
#
# +----------------------------------------+
# |  Function fdl_download_missing_scripts |
# +----------------------------------------+
#
#     Rev: 2021-03-11
#  Inputs: $1 - File containing a list of all file dependencies.
#          $2 - File name of generated list of missing file dependencies.
# Outputs: ANS.
#
# Summary: This function can be used when script is first run.
#          It verifies that all dependencies are satisfied. 
#          If any are missing, then any missing required dependencies of
#          scripts and libraries are downloaded from a LAN repository or
#          from a repository on the Internet.
#
#          This function allows this single script to be copied to any
#          directory and then when it is executed or run, it will download
#          automatically all other needed files and libraries, set them to be
#          executable, and source the required libraries.
#          
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: None.
#
fdl_download_missing_scripts () {
      #
      # Delete any existing temp file.
      if [ -r  $2 ] ; then
         rm  $2
      fi
      #
      # ****************************************************
      # Create new list of files that need to be downloaded.
      # ****************************************************
      #
      # While-loop will read the file names listed in FILE_LIST (list of
      # script and library files) and detect which are missing and need 
      # to be downloaded and then put those file names in FILE_DL_LIST.
      #
      while read LINE
            do
               FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
               if [ ! -x $FILE ] ; then
                  # File needs to be downloaded or is not executable.
                  # Write any error messages to file $TEMP_FILE.
                  chmod +x $FILE 2>$TEMP_FILE
                  ERROR=$?
                  #
                  if [ $ERROR -ne 0 ] ; then
                     # File needs to be downloaded. Add file name to a file list in a text file.
                     # Build list of files to download.
                     echo $LINE >> $2
                  fi
               fi
            done < $1
      #
      # If there are files to download (listed in FILE_DL_LIST), then mount local repository.
      if [ -s "$2" ] ; then
         echo
         echo "There are missing file dependencies which must be downloaded from"
         echo "the local repository or web repository."
         echo
         echo "Missing files:"
         while read LINE
               do
                  echo $LINE | awk -F "^" '{ print $1 }'
               done < $2
         echo
         echo "You will need to present credentials."
         echo
         echo -n "Press '"Enter"' key to continue." ; read X ; unset X
         #
         #----------------------------------------------------------------------------------------------
         # From list of files to download created above $FILE_DL_LIST, download the files one at a time.
         #----------------------------------------------------------------------------------------------
         #
         while read LINE
               do
                  # Get Download Source for each file.
                  DL_FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
                  DL_SOURCE=$(echo $LINE | awk -F "^" '{ print $2 }')
                  TARGET_DIR=$(echo $LINE | awk -F "^" '{ print $3 }')
                  DL_REPOSITORY=$(echo $LINE | awk -F "^" '{ print $4 }')
                  #
                  # Initialize Error Flag.
                  ERROR=0
                  #
                  # If a file only found in the Local Repository has source changed
                  # to "Web" because LAN connectivity has failed, then do not download.
                  if [ -z DL_REPOSITORY ] && [ $DL_SOURCE = "Web" ] ; then
                     ERROR=1
                  fi
                  #
                  case $DL_SOURCE in
                       Local)
                          # Download from Local Repository on LAN File Server.
                          # Are LAN File Server directories available on Local Mount-point?
                          fdl_mount_local $SERVER_DIR $MP_DIR
                          #
                          if [ $ERROR -ne 0 ] ; then
                             # Failed to mount LAN File Server directory on Local Mount-point.
                             # So download from Web Repository.
                             fdl_dwnld_file_from_web_site $DL_REPOSITORY $DL_FILE
                          else
                             # Sucessful mount of LAN File Server directory. 
                             # Continue with download from Local Repository on LAN File Server.
                             fdl_dwnld_file_from_local_repository $TARGET_DIR $DL_FILE
                             #
                             if [ $ERROR -ne 0 ] ; then
                                # Failed to download from Local Repository on LAN File Server.
                                # So download from Web Repository.
                                fdl_dwnld_file_from_web_site $DL_REPOSITORY $DL_FILE
                             fi
                          fi
                       ;;
                       Web)
                          # Download from Web Repository.
                          fdl_dwnld_file_from_web_site $DL_REPOSITORY $DL_FILE
                          if [ $ERROR -ne 0 ] ; then
                             # Failed so mount LAN File Server directory on Local Mount-point.
                             fdl_mount_local $SERVER_DIR $MP_DIR
                             #
                             if [ $ERROR -eq 0 ] ; then
                                # Successful mount of LAN File Server directory.
                                # Continue with download from Local Repository on LAN File Server.
                                fdl_dwnld_file_from_local_repository $TARGET_DIR $DL_FILE
                             fi
                          fi
                       ;;
                  esac
               done < $2
         #
         if [ $ERROR -ne 0 ] ; then
            echo
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> Download failed. Cannot continue, exiting program. <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
         else
            echo
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> Download is good. Re-run required, exiting program. <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
         fi
         #
      fi
      #
      # Source each library.
      #
      while read LINE
            do
               FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
               # Invoke any library files.
               fdl_source $FILE
               if [ $ERROR -ne 0 ] ; then
                  echo
                  echo ">>>>>>>>>><<<<<<<<<<<"
                  echo ">>> Library Error <<<"
                  echo ">>>>>>>>>><<<<<<<<<<<"
                  echo
                  echo -e "$1 cannot be sourced using command:\n\"source $1\""
                  echo
               fi
            done < $1
      if [ $ERROR -ne 0 ] ; then
         echo
         echo
         echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
         echo ">>> Invoking Libraries failed. Cannot continue, exiting program. <<<"
         echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
         echo
      fi
      #
} # End of function fdl_download_missing_scripts.
#
# +----------------------------------------+
# |         Function f_file_manager        |
# +----------------------------------------+
#
#  Inputs: $1=GUI
#          $2=FSDT_DIR.
#    Uses: RUNAPP
# Outputs: ERROR.
#
# Summary: Detect file manager application and run it on the $2 Directory.
f_file_manager () {
      #
      RUNAPP=0
      # Detect installed file manager (in order of preference GUI file managers before CLI file managers).
      #
      #
      #================================================================================
      # EDIT THE LINE BELOW TO DEFINE $FILEMGR AS THE ACTUAL APPLICATION FILE MANAGER.
      # FOR-LOOP CONTAINS LIST OF ALL RECOGNIZED FILE MANAGERS IN ORDER OF PREFERENCE.
      #================================================================================
      #
      #
      for FILEMGR in pcmanfm pcmanfm-qt caja nemo nautilus konqueror krusader dolphin thunar xfe spacefm doublecmd-gtk worker wcm 4pane ranger mc vifm nnn
          do
             if [ $RUNAPP -eq 0 ] ; then
                type $FILEMGR >/dev/null 2>&1  # Test if $FILEMGR application is installed.
                ERROR=$?
                if [ $ERROR -eq 0 ] ; then
                   eval $FILEMGR $2
                   ERROR=$?
                   if [ $ERROR -eq 0 ] ; then
                      RUNAPP=1
                   else
                      RUNAPP=0
                      f_message $1 "OK" "File Manager Error" "\nFile Manager $FILEMGR failed to run."
                   fi
                fi
             fi
          done
      #
      if [ $RUNAPP -eq 0 ] ; then
         f_message $1 "OK" "File Manager Error" "\nFile Manager $FILEMGR was not automatically detected.\nPausing here to manually delete any old files in Dropbox folder."
      fi
      #
      unset RUNAPP
      #
} # End of function f_file_manager.
#
# +----------------------------------------+
# |         Function f_git_download        |
# +----------------------------------------+
#
#  Inputs: $1=GUI
#          $2=TARGET_DIR.
#    Uses: REPOSITORY, SCRIPT, ANS.
# Outputs: None.
#
f_git_download () {
      #
      # Check for existence of directory, ~/scripts_from_github.
      cd ~
      if [ ! -e ~/$2 ] ; then
          mkdir $2
      fi
      #
      if [ -e ~/$2 ] ; then
         # Directory exists, then wget script files there.
         cd $2
         # Download files from GitHub.
         # Check internet connectivity to raw.githubusercontent.com.
         f_test_connect $1
         #
         # If there is a good internet connection, continue to wget download.
         if [ $ERROR -eq 0 ] ; then
            f_wget $1 $2
         fi
         #
         # Edit files mountup.sh and mountup.lib to customize for my LAN Host Names.
         #f_edit_script_files $1 $TARGET_DIR
         #
         # Make newly downloaded files executable.
         chmod -R 755 ~/$2
      else
         f_message $1 "OK" "Error" " >>> \Z1\ZbDownload directory does not exist: ~/$2\Zn <<<"
      fi
      #
} # End of function f_git_download.
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
#
#
# **************************************
# **************************************
# ***     Start of Main Program      ***
# **************************************
# **************************************
#     Rev: 2021-03-11
#
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
# Blank the screen.
clear
#
echo "Running script $THIS_FILE"
echo "***   Rev. $VERSION   ***"
echo
# pause for 1 second automatically.
sleep 1
#
# Blank the screen.
clear
#
#-------------------------------------------------------
# Detect and download any missing scripts and libraries.
#-------------------------------------------------------
#
#----------------------------------------------------------------
# Variables FILE_LIST and FILE_DL_LIST are defined in the section
# "Default Variable Values" at the beginning of this script.
#----------------------------------------------------------------
#
# Are any files/libraries missing?
fdl_download_missing_scripts $FILE_LIST $FILE_DL_LIST
#
# Are there any problems with the download/copy of missing scripts?
if [ -r  $FILE_DL_LIST ] || [ $ERROR -ne 0 ] ; then
   # Yes, there were missing files or download/copy problems so exit program.
   #
   # Delete temporary files.
   if [ -e $TEMP_FILE ] ; then
      rm $TEMP_FILE
   fi
   #
   if [ -r  $FILE_LIST ] ; then
      rm  $FILE_LIST
   fi
   #
   if [ -r  $FILE_DL_LIST ] ; then
      rm  $FILE_DL_LIST
   fi
   #
   exit 0  # This cleanly closes the process generated by #!bin/bash.
           # Otherwise every time this script is run, another instance of
           # process /bin/bash is created using up resources.
fi
#
#***************************************************************
# Process Any Optional Arguments and Set Variables THIS_DIR, GUI
#***************************************************************
#
# Set THIS_DIR, SCRIPT_PATH to directory path of script.
f_script_path
#
# Set Temporary file using $THIS_DIR from f_script_path.
TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
#
# If command already specifies GUI, then do not detect GUI.
# i.e. "bash pkg-upgrade.sh dialog" or "bash pkg-upgrade.sh text".
if [ -z $GUI ] ; then
   # Test for GUI (Whiptail or Dialog) or pure text environment.
   f_detect_ui
fi
#
# Final Check of Environment
#GUI="whiptail"  # Diagnostic line.
#GUI="dialog"    # Diagnostic line.
#GUI="text"      # Diagnostic line.
#
# Test for Optional Arguments.
# Also sets variable GUI.
f_arguments $1 $2
#
# Delete temporary files.
if [ -r  $FILE_LIST ] ; then
   rm  $FILE_LIST
fi
#
if [ -r  $FILE_DL_LIST ] ; then
   rm  $FILE_DL_LIST
fi
#
# Test for X-Windows environment. Cannot run in CLI for LibreOffice.
# if [ x$DISPLAY = x ] ; then
#    f_message text "OK" "\Z1\ZbCannot run LibreOffice without an X-Windows environment.\ni.e. LibreOffice must run in a terminal emulator in an X-Window.\Zn"
# fi
#
# Test for BASH environment.
f_test_environment $1
#
# If an error occurs, the f_abort() function will be called.
# trap 'f_abort' 0
# set -e
#
#********************************
# Show Brief Description message.
#********************************
#
f_about $GUI "NOK" 1
#
#***************
# Run Main Code.
#***************
#
f_menu_main $GUI
#
# Delete temporary files.
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
if [ -e  $FILE_LIST ] ; then
   rm  $FILE_LIST
fi
#
if [ -e  $FILE_DL_LIST ] ; then
   rm  $FILE_DL_LIST
fi
#
# Nicer ending especially if you chose custom colors for this script.
# Blank the screen.
clear
#
exit 0  # This cleanly closes the process generated by #!bin/bash.
        # Otherwise every time this script is run, another instance of
        # process /bin/bash is created using up resources.
        #
# All dun dun noodles.

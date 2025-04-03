#!/bin/bash
#
# ©2024 Copyright 2024 Robert D. Chin
# Email: RDevChin@Gmail.com
#
# Usage: bash pkg-upgrade.sh
#        (not sh pkg-upgrade.sh)
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
# +----------------------------------------+
# |        Default Variable Values         |
# +----------------------------------------+
#
VERSION="2024-06-08 23:54"
THIS_FILE=$(basename $0)
FILE_TO_COMPARE=$THIS_FILE
TEMP_FILE=$THIS_FILE"_temp.txt"
GENERATED_FILE=$THIS_FILE"_menu_generated.lib"
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
  SERVER_DIR="//scotty/files"
#
# Local PC mount-point directory.
# MP_DIR="[LOCAL_MOUNT-POINT_DIRECTORY_NAME_GOES_HERE]"
  MP_DIR="/mnt/scotty/files"
#
# Local PC mount-point with LAN File Server Local Repository full directory path.
# Example:
#                   File server shared directory is "//file_server/public".
# Repostory directory under the shared directory is "scripts/BASH/Repository".
#                 Local PC Mount-point directory is "/mnt/file_server/public".
#
# LOCAL_REPO_DIR="$MP_DIR/[DIRECTORY_PATH_TO_LOCAL_REPOSITORY]"
  LOCAL_REPO_DIR="$MP_DIR/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository"
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
echo "common_bash_function.lib^Local^$LOCAL_REPO_DIR^https://raw.githubusercontent.com/rdchin/BASH_function_library/master/" >> $FILE_LIST
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
#& Script pkg-upgrade.sh will show a description of each upgradable package
#& before upgrading each package.
#&
#& Required scripts: pkg-upgrade.sh
#&                   common_bash_function.lib
#&
#& Usage: bash pkg-upgrade.sh
#&        (not sh pkg-upgrade.sh)
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
#?    Usage: bash pkg-upgrade.sh [OPTION(S)]
#?
#? Examples:
#?
#?                               Force display to use a different UI.
#?bash pkg-upgrade.sh text       Use Cmd-line user-interface (80x24 min.)
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
#?
#? Examples using 2 arguments:
#?
#?bash pkg-upgrade.sh --hist text
#?                    --ver dialog
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
## Includes changes to pkg-upgrade.sh.
##
## 2024-06-08 *f_check_version, f_display_common, fdl_mount_local,
##             fdl_dwnld_file_from_web_site,
##             fdl_dwnld_file_from_local_repository,
##             fdl_download_missing_scripts were updated to latest version.
##            *f_menu_main deleted and replaced by f_menu_main_all_menus.
##            *f_menu_main_all_menus added.
##
## 2023-03-22 *f_ques_upgrade_gui bug fixed to display results of "apt update"
##             and "apt upgrade".
##
## 2023-02-24 *f_find_updates, f_ques_upgrade improve documentation.
##
## 2023-01-25 *f_ques_upgrade "View Software Package Descriptions?"
##             changed default answer to "N".
##
## 2022-10-05 *f_menu_main improved comments.
##            *f_ques_upgrade improved user messages.
##
## 2022-09-22 *f_ques_upgrade improved user messages, display the number of
##             upgradeable packages before asking if user wants to view the
##             package descriptions.
##             (If there are many upgradeable packages, getting the
##             descriptions may take a while to retrieve and download).
##
## 2022-05-08 *f_find_upgrade bug fixed in "apt dist-upgrade" command.
##             Added user messages with status of dist-upgrade.
##
## 2022-05-03 *f_find_upgrade added to apt dist-upgrade.
##
## 2022-04-24 *f_ques_upgrade add comments to clarify temporay file usage.
##
## 2022-04-20 *fdl_download_missing_scripts fixed bug to prevent downloading
##             from the remote repository if the local repository was
##             unavailable and the script was only in the local repository.
##
## 2022-04-19 *f_list_packages changed display to show the package
##              description before the changelog and prevented errors from
##              being displayed when changelog could not be retrieved.
##
## 2022-04-18 *f_list_packages limited display of changelog to first 15
##             lines of description.
##
## 2022-04-17 *f_list_packages bug fixed preventing aptitude from running
##             even when installed, so command "aptitude changelog" was
##             never run.
##
## 2022-04-10 *f_list_packages added aptitude to display changelog.
##
## 2022-03-18 *f_ques_upgrade added existence check for temporary file.
##             This may have fixed bug with script intermittently
##             quitting after displaying description page.
##
## 2021-09-06 *f_ques_upgrade added question to "apt dist-upgrade".
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
##            *Section "Default Variable Values" defined FILE_TO_COMPARE
##             and defined THIS_FILE=$(basename $0) to reduce maintenance.
##            *fdl_download_missing_scripts added 2 arguments for file
##             names as arguments.
##            *fdl_download_missing_scripts, f_run_app, and application
##             functions changed to allow missing dependent scripts to be
##             automatically downloaded rather than simply displaying an
##             error message that they were missing.
##            *f_display_common, f_menu_main, f_check_version,
##            *f_update_library, updated to latest standards.
##            *fdl_source added. f_source deleted.
##            *fdl_download_missing_scripts changed to use fdl_source.
##            *Section "Main Menu", "Application Menu" changed the order
##             of menu choices.
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
##             under Section "Main Program" to allow easier deletion of
##             code.
##            *Functions related to "Update Version" renamed with an "fdl"
##             prefix to identify dependent functions to delete if that
##             function is not desired.
##            *Section "Code Change History" added instructions on how to
##             disable/delete "Update Version" feature or "Main Menu".
##            *Changed menu item wording from "Exit to command-line" prompt.
##                                         to "Exit this menu."
##
## 2021-02-11 *Added Main Menu.
##
## 2020-09-09 *Updated to latest standards.
##
## 2020-08-07 *f_about, f_help_message, f_code_history deleted since
##             these functions are maintained in common_bash_function.lib.
##            *f_display_common updated to add option to display
##             without an "OK" button in Dialog.
##             However, Whiptail only displays with an "OK" button.
##
## 2020-08-06 *f_obsolete_packages added checking for packages held back
##             and display of applicable apt messages.
##
## 2020-07-25 *Main Program altered f_test_connection to have 1 s delay.
##
## 2020-06-30 *f_ques_upgrade added message about checking for obsolete
##             packages.
##
## 2020-06-27 *f_display_common, f_about, f_code_history, f_help_message
##             rewritten to simplify code.
##            *Use library common_bash_function.lib.
##
## 2020-06-22 *Release 1.0 "Amy".
##             Last release without dependency on common_bash_function.lib.
##             *Updated to latest standards.
##
## 2020-05-31 *f_obsolete_packages, f_ques_upgrade fixed bug and simplified
##             detection of obsolete packages to be removed.
##
## 2020-05-16 *Updated to latest standards.
##
## 2020-05-06 *f_msg_ui_file_box_size, f_msg_ui_file_ok bug fixed
##             in display.
##
## 2020-04-28 *Main updated to latest standards.
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
## 2019-03-31 *Main Program added f_help_message to the beginning.
##
## 2019-03-29 *f_arguments, f_code_history_txt, f_version_txt,
##             f_help_message added actions for optional command arguments.
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
# +--------------------------------------------------------------------------+
# |                                                                          |
# |                 Customize Menu choice options below.                     |
# |                                                                          |
# +--------------------------------------------------------------------------+
#
#                 >>> !!!Warning!!! <<<
#
# The Menu Item Descriptions cannot have semi-colons, colons, asterisks,
# single-quotes (apostrophes), double-quotes, ampersands, greater-than
# and less-than signs.
#
# Forbidden characters include ; : * ' " & > < \
#
# These characters will compromise the creation of arrays which
# in turn creates the menu.
#
# Note: The single-quotes (') and double-quotes (") and back-slashes (\)
#       are ignored when the arrays are created, even if they are included
#       in the Menu Item Description.
#
# General Format: <#@@> <Menu Option> <#@@> <Description of Menu Option> <#@@> <Corresponding function or action or command>
#
# Format of <Corresponding function or action or command> when using f_menu_main_all_menus.
#        f_menu_main_all_menus^"text", "dialog", or "whiptail"^Menu Name^Library name containing menu entries
#
#! +--------------------------------------------------------------+
#! | Start Listing Upgrade Menu                                   |
#! |               (Required header, do not delete).              |
#! +--------------------------------------------------------------+
#
#@@Exit#@@Exit this menu.#@@break
#
#@@Update Operating System#@@Find and install latest software.#@@f_find_updates^$GUI
#
#@@Upgrade Operating System#@@Upgrade to the next version.#@@f_find_upgrade^$GUI
#
#@@About#@@Version information of this script.#@@f_about^$GUI
#
#@@Code History#@@Display code change history of this script.#@@f_code_history^$GUI
#
#@@Version Update#@@Check for updates to this script and download.#@@f_check_version^$GUI
#
#@@Help#@@Display help message.#@@f_help_message^$GUI
#
#! End Listing Upgrade Menu (Required line, do not delete).
#
# +------------------------------------+
# |     Function f_display_common      |
# +------------------------------------+
#
#     Rev: 2024-02-24
#  Inputs: $1 - "text", "dialog" or "whiptail" the command-line user-interface in use.
#          $2 - Delimiter of text to be displayed.
#          $3 - [OPTIONAL] to control display of prompt to continue.
#                          null (Default) - "OK" button or text prompt, display until either Enter key or "OK" button is pressed.
#                          "OK"           - "OK" button or text prompt, display until either Enter key or "OK" button is pressed.
#                          "NOK"          - No "OK" button or text prompt, display for $3 seconds before continuing automatically.
#          $4 - [OPTIONAL] to control pause duration. Only used if $3="NOK".
#                          $4 seconds pause to allow text to be read before continuing automatically.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
# Summary: Display lines of text beginning with a given comment delimiter.
#
# Dependencies: f_message.
#
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO ANY SCRIPT WHICH DEPENDS ON THE
#              LIBRARY FILE "common_bash_function.lib".
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
      THIS_FILE="pkg-upgrade.sh"  # <<<--- INSERT ACTUAL FILE NAME HERE.
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
#     Rev: 2024-02-22
#  Inputs: $1 - "text", "dialog" or "whiptail" the command-line user-interface in use.
#          $2 - [OPTIONAL] File name to compare.
#          $3 - [OPTIONAL] to control display of messages and interactive user questions.
#                          null (default) - Display error and status messages and interactive user questions.
#                          1              - Display error messages only (Silent mode).
#          FILE_TO_COMPARE.
#    Uses: SERVER_DIR, MP_DIR, LOCAL_REPO_DIR, $FILE_TO_COMPARE, FILE_LIST,
#          VERSION, TEMP_FILE, ERROR.
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
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO ANY SCRIPT WHICH DEPENDS ON THE
#              LIBRARY FILE "common_bash_function.lib".
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
      if [ -z "$SERVER_DIR" ] ; then
        SERVER_DIR="//scotty//files"
      fi
      #
      # Local PC mount-point directory.
      # MP_DIR="[LOCAL_MOUNT-POINT_DIRECTORY_NAME_GOES_HERE]"
      if [ -z "$MP_DIR" ] ; then
        MP_DIR="/mnt/scotty/files"
      fi
      #
      # Local PC mount-point with LAN File Server Local Repository full directory path.
      # Example:
      #                   File server shared directory is "//file_server/public".
      # Repository directory under the shared directory is "scripts/BASH/Repository".
      #                 Local PC Mount-point directory is "/mnt/file_server/public".
      #
      # Local PC mount-point with LAN File Server Local Repository full directory path.
      # LOCAL_REPO_DIR="$MP_DIR/[DIRECTORY_PATH_TO_LOCAL_REPOSITORY]"
      if [ -z "$LOCAL_REPO_DIR" ] ; then
        LOCAL_REPO_DIR="$MP_DIR/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository"
      fi
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
      # Initialize variables.
      FILE_LIST=$THIS_DIR/$THIS_FILE"_file_temp.txt"
      ERROR=0
      #
      # Delete any existing file.
      # This assures that FILE_LIST is not appended to but is newly created
      # in the code below. Added because typo may occur when using redirection
      # where typo ">>" is used instead of ">" at FILE NAME1.
      # i.e. typo at echo "[ FILE NAME1 GOES HERE ]"  >> $FILE_LIST
      if [ -e $FILE_LIST ] ; then
         rm $FILE_LIST
      fi
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
      echo "pkg-upgrade.sh"            > $FILE_LIST  # <<<--- INSERT ACTUAL FILE NAME HERE.
      echo "common_bash_function.lib" >> $FILE_LIST  # <<<--- INSERT ACTUAL FILE NAME HERE.
      #
      f_version_compare $1 "$SERVER_DIR" "$MP_DIR" "$LOCAL_REPO_DIR" "$FILE_TO_COMPARE" "$VERSION" "$FILE_LIST" "$3"
      #
      if [ -r  $FILE_LIST ] ; then
         rm  $FILE_LIST
      fi
      #
      unset FILE_LIST
      #
}  # End of function f_check_version.
#
# +-----------------------------------------+
# | Function f_menu_main_all_menus          |
# +-----------------------------------------+
#
#     Rev: 2024-02-18
#  Inputs: $1 - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2 - MENU_TITLE Title of menu which must also match the header
#               and tail strings for the menu data in the ARRAY_SOURCE_FILE.
#              !!!Menu title MUST use underscores instead of spaces!!!
#          $3 - ARRAY_SOURCE_FILE is the file name where the menu data is stored.
#               This can be the run-time script or a separate *.lib library file.
#    Uses: ARRAY_SOURCE_FILE, ARRAY_TEMP_FILE, GENERATED_FILE, MENU_TITLE, TEMP_FILE.
# Outputs: None.
#
# Summary: Display any menu. Use this same function to display
#          both Main-Menu and any sub-menus. The Main Menu and all sub-menu data
#          may either be in the run-time script (*.sh) or a separate library (*.lib)
#
#          A single script/library file contains data for multiple menus
#          where there may be 1 or more menus within 1 file.
#
#          Simply state the Path/Filename of the library file, ARRAY_SOURCE_FILE
#          which contains the menu data.
#
# Dependencies: f_menu_arrays, f_create_show_menu.
#
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO THE MAIN SCRIPT WHICH WILL CALL IT.
#
f_menu_main_all_menus () {
      #
      #
      #================================================================================
      # EDIT THE LINE BELOW TO DEFINE $ARRAY_SOURCE_FILE AS THE ACTUAL FILE NAME
      # WHERE THE MENU ITEM DATA IS LOCATED. THE LINES OF DATA ARE PREFIXED BY "#@@".
      #================================================================================
      #
      #
      # Note: Alternate menu data storage scheme.
      # For a separate library file for each menu data (1 menu/1 library file),
      # or for the run-time program to contain the Main Menu data (1 Main menu/run-time script),
      # then see f_menu_main_TEMPLATE in common_bash_function.lib
      #
      # Specify the library file name with menu item data.
      # ARRAY_SOURCE_FILE (Not a temporay file) includes menu items
      # from one or more menus (multiple menus/1 library file ARRAY_SOURCE_FILE).
      ARRAY_SOURCE_FILE=$3
      #
      #
      #================================================================================
      # EDIT THE LINE BELOW TO DEFINE MENU_TITLE AS THE ACTUAL TITLE OF THE MENU THAT
      # CONTAINS THE MENU ITEM DATA. THE LINES OF DATA ARE PREFIXED BY "#@@".
      #================================================================================
      #
      #
      # Note: ***If Menu title contains spaces,
      #       ***the size of the menu window will be too narrow.
      #
      # Menu title MUST use underscores instead of spaces.
      MENU_TITLE=$2
      #
      # Examples of valid $2 parameters:
      # MENU_TITLE="Main_Menu"
      # MENU_TITLE="Task_Menu"
      # MENU_TITLE="Utility_Menu"
      #
      # The MENU_TITLE must match the strings in the ARRAY_SOURCE_FILE.
      #
      #  Example:
      #   The run-time script file, "ice_cream.sh" may also contain the data
      #   for both Main menu and sub-menus.
      #
      #     MENU_TITLE="All_Ice_Cream_Menu"
      #     ARRAY_SOURCE_FILE="ice_cream.sh"
      #
      #   If you have a lot of menus, you may want to have all the menu data
      #   for both Main menu and sub-menus in a separate library file,
      #   "all_ice_cream_menus.lib".
      #
      #     MENU_TITLE="All_Ice_Cream_Menu"
      #     ARRAY_SOURCE_FILE="all_ice_cream_menus.lib"
      #
      # Format for $ARRAY_SOURCE_FILE: ("ice_cream.sh" or "all_ice_cream_menus.lib")
      #
      #  Listing of $ARRAY_SOURCE_FILE ("ice_cream.sh" or "all_ice_cream_menus.lib")
      #          which includes menu item data:
      #
      #  Start Listing Tasty Ice Cream Menu (Required header, do not delete).
      #      Data for Menu item 1
      #      Data for Menu item 2
      #      Data for Menu item 3
      #  End Listing Tasty Ice Cream Menu (Required line, do not delete).
      #
      #  Start Listing Ice Cream Toppings Menu (Required header, do not delete).
      #      Data for Menu item 1
      #      Data for Menu item 2
      #      Data for Menu item 3
      #  End Listing Ice Cream Toppings Menu (Required line, do not delete).
      #
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_menu_temp.txt"
      #
      # GENERATED_FILE (The name of a temporary library file which contains the code to display the sub-menu).
      GENERATED_FILE=$THIS_DIR/$THIS_FILE"_menu_generated.lib"
      #
      # ARRAY_TEMP_FILE (Temporary file) includes menu items imported from $ARRAY_SOURCE_FILE of a single menu.
      ARRAY_TEMP_FILE=$THIS_DIR/$THIS_FILE"_menu_array_generated.lib"
      #
      # ARRAY_FILE is used by f_update_menu_gui and f_update_menu_txt.
      # It is not included in formal passed parameters but is used anyways
      # in the $GENERATED_FILE as a line: "source $ARRAY_FILE".
      # I wanted to retire this variable name, but it has existed in the
      # common_bash_function.lib library for quite a while.
      ARRAY_FILE=$GENERATED_FILE
      #
      # When using f_create_a_menu, all subsequent sub-menus do not need a separate
      # hard-coded function, since f_create_a_menu will generate sub-menu functions as needed.
      #
      # List of inputs for f_create_a_menu.
      #
      #  Inputs: $1 - "text", "dialog" or "whiptail" The command-line user-interface application in use.
      #          $2 - GENERATED_FILE (The name of a temporary library file containing the suggested phrase "generated.lib" which contains the code to display the sub-menu).
      #          $3 - MENU_TITLE (Title of the sub-menu)
      #          $4 - TEMP_FILE (Temporary file).
      #          $5 - ARRAY_TEMP_FILE (Temporary file) includes menu items imported from $ARRAY_SOURCE_FILE of a single menu.
      #          $6 - ARRAY_SOURCE_FILE (Not a temporary file) includes menu items from multiple menus.
      #
      f_create_a_menu $1 $GENERATED_FILE $MENU_TITLE $TEMP_FILE $ARRAY_TEMP_FILE $ARRAY_SOURCE_FILE
      #
      if [ -e $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
      if [ -e  $GENERATED_FILE ] ; then
         rm  $GENERATED_FILE
      fi
      #
} # End of function f_menu_main_all_menus_TEMPLATE
#
# +----------------------------------------+
# |  Function fdl_dwnld_file_from_web_site |
# +----------------------------------------+
#
#     Rev: 2024-02-25
#  Inputs: $1 - GitHub Repository
#          $2 - file name to download.
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
      wget --show-progress $1$2
      ERROR=$?
      #
      # Make downloaded file executable.
      chmod 755 $2
      #
      if [ $ERROR -ne 0 ] ; then
            echo
            echo ">>>>>>>>>>>>>><<<<<<<<<<<<<<"
            echo ">>> wget download failed <<<"
            echo ">>>>>>>>>>>>>><<<<<<<<<<<<<<"
            echo
            echo "Error copying file: \"$2.\""
            echo
            echo "from GitHub Repository:"
            echo "$WEB_REPOSITORY_URL"
            echo
            echo -e "Warning: If the Github Repository is \"Private\","
            echo "         then anonymous downloads are not permitted."
            echo
            echo ">>>>>>>>>>>>>><<<<<<<<<<<<<<"
            echo
      fi
      #
} # End of function fdl_dwnld_file_from_web_site.
#
# +-----------------------------------------------+
# | Function fdl_dwnld_file_from_local_repository |
# +-----------------------------------------------+
#
#     Rev: 2024-02-25
#  Inputs: $1 - Local Repository Directory.
#          $2 - File to download.
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
      eval cp -p $1/$2 .
      ERROR=$?
      #
      # Make downloaded file executable.
      chmod 755 $2
      #
      if [ $ERROR -ne 0 ] ; then
         echo
         echo ">>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<"
         echo ">>> File Copy Error from Local Repository <<<"
         echo ">>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<"
         echo
         echo -e "Error copying file: \"$2.\""
         echo
         echo "from Local Repository:"
         echo "$LOCAL_REPO_DIR"
         echo
         echo ">>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<"
         echo
         ERROR=1
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
#     Rev: 2024-02-25
#  Inputs: $1 - Server Directory.
#          $2 - Local Mount Point Directory
#          TEMP_FILE
#    Uses: TARGET_DIR, UPDATE_FILE, ERROR, SMBUSER, PASSWORD.
# Outputs: QUIT, ERROR.
#
# Summary: Mount directory using Samba and CIFS and echo error message.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: Software package "cifs-utils" in the Distro's Repository.
#
fdl_mount_local () {
      #
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Get status of mountpoint, mounted? Do not display status.
      mountpoint $2 >/dev/null
      ERROR=$?
      if [ $ERROR -eq 0 ] ; then
         # Directory is already mounted.
         # Outputs ERROR=0.
         # Quit loop.
         QUIT=1
      else
         # Mount failed, Do you want to try again?
         DEFAULT_ANS="Y"
         QUES_STR="Failed to mount\n\nShare-point:\n$1\n\nonto\n\nMount-point:\n$2\n\nTry another password to mount $1?"
         #
         clear  # Blank screen.
         #
         # Does $QUES_STR contain "\n"?  Does the string $QUES_STR contain multiple sentences?
         case $QUES_STR in
              *\n*)
                 # Yes, string $QUES_STR contains multiple sentences.
                 #
                 # Command-Line interface (CLI) does not have option "--colors" with "\Z" commands for font color bold/normal.
                 # Use command "sed" with "-e" to filter out multiple "\Z" commands.
                 # Filter out "\Z[0-7]", "\Zb", \ZB", "\Zr", "\ZR", "\Zu", "\ZU", "\Zn".
                 ZNO=$(echo $QUES_STR | sed -e 's|\\Z0||g' -e 's|\\Z1||g' -e 's|\\Z2||g' -e 's|\\Z3||g' -e 's|\\Z4||g' -e 's|\\Z5||g' -e 's|\\Z6||g' -e 's|\\Z7||g' -e 's|\\Zb||g' -e 's|\\ZB||g' -e 's|\\Zr||g' -e 's|\\ZR||g' -e 's|\\Zu||g' -e 's|\\ZU||g' -e 's|\\Zn||g')
                 TEXT_STR="$ZNO"
              ;;
              *)
                 # No, string $QUES_STR contains a single sentence.
                 #
                 # Create a text file from the string.
                 TEXT_STR="$QUES_STR"
              ;;
         esac
         #
         case $DEFAULT_ANS in
              [Yy] | [Yy][Ee][Ss])
                 # "Yes" is the default answer.
                 echo -e -n "$TEXT_STR (Y/n) "; read ANS # < /dev/tty
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
                 echo -e -n "$TEXT_STR (y/N) "; read ANS # < /dev/tty
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
         #
         # Outputs user response to $ANS.
         # Try another password to mount $1?"
         if [ $ANS -eq 0 ] ; then
            # Yes, try another SMB username and password to mount Share-point.
            QUIT=0
            # Try again to mount.
            # Set the default username to the SMB username entered previously.
            #
            # Cannot use any user prompted read answers if this function is in a loop where file is a loop input.
            # The read statements will be treated as the next null parameters in the loop without user input.
            # To solve this problem, specify input from /dev/tty "the keyboard".
            #
            echo
            echo "Mounting share-point $1 onto local mount-point $2"
            echo
            read -p "Enter user name: " SMBUSER < /dev/tty
            echo
            read -s -p "Enter Password: " PASSWORD < /dev/tty
            echo sudo mount -t cifs $1 $2
            sudo mount -t cifs -o username="$SMBUSER" -o password="$PASSWORD" $1 $2
            unset SMBUSER PASSWORD
            #
            # Write any error messages to file $TEMP_FILE. Get status of mountpoint, mounted?.
            mountpoint $2 >/dev/null 2>$TEMP_FILE
            ERROR=$?
            #
            if [ $ERROR -eq 0 ] ; then
               # Successful mounting of share-point $1 onto local mount-point $2.
               # Outputs ERROR=0.
               QUIT=1
            else
               # Failed to mount share-point $1 onto local mount-point $2.
               # Outputs ERROR=1.
               QUIT=0
            fi
         else
            # No, do not try another password just return to previous menu. Exit loop.
            # Quit f_mount loop, return to previous menu.
            # Outputs ERROR=1.
            QUIT=1
         fi
      fi
      #
      if [ -e  $TEMP_FILE ] ; then
         rm  $TEMP_FILE
      fi
      #
} # End of function fdl_mount_local.
#
# +------------------------------------+
# |        Function fdl_source         |
# +------------------------------------+
#
#     Rev: 2022-10-10
#  Inputs: $1 - File name to source.
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
#     Rev: 2024-02-21
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
      # Initialize variables.
      #
      TEMP_FILE=$THIS_FILE"_temp.txt"
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
      # While-loop will read the file names listed in FILE_LIST ($1 list of
      # script and library files) and detect which are missing and need
      # to be downloaded and then put those file names in FILE_DL_LIST ($2).
      #
      #
      # Download files from Local Repository or Web GitHub Repository
      # or extract files from the compressed file "cli-app-menu-new-main.zip"
      # which may be downloaded from the repository on the Github.com website.
      #
      while read LINE
            do
               ERROR=0
               #
               FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
               #
               # Does the file exist?
               if [ ! -e $FILE ] ; then
                  # No, file needs to be downloaded.
                  # Build list of files to download so add file name to download list.
                  echo $LINE >> $2
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
         echo "You may need to present credentials, unless anonymous downloads are permitted."
         echo
         echo -n "Press '"Enter"' key to continue." ; read X ; unset X
         #
         #----------------------------------------------------------------------------------------------
         # From list of files to download created above $FILE_DL_LIST, download the files one at a time.
         #----------------------------------------------------------------------------------------------
         #
         # Downloaded the list of files $DL_FILE from the Local Repository?
         grep Local^ $2 >/dev/null
         ERROR=$?
         #
         # Initialize for while-loop.
         QUIT=0
         #
         # Are any of the missing files to be downloaded from the Local Repository?
         if [ $ERROR -eq 0 ] ; then
            # Yes, there are files to be downloaded from the Local Repository.
            #
            # Are LAN File Server directories available on Local Mount-point?
             while [ $QUIT -ne 1 ]  # Start loop.
                   do
                     fdl_mount_local $SERVER_DIR $MP_DIR
                   done
         fi
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
                  # If a file which only exists in the Local Repository has
                  # its source changed to "Web" because LAN connectivity has
                  # failed, then do not download since the file is not in a
                  # GitHub.com Repository.
                  if [ -z $DL_REPOSITORY ] && [ $DL_SOURCE = "Web" ] ; then
                     ERROR=1
                  fi
                  case $DL_SOURCE in
                       Local)
                          # Download from Local Repository on LAN File Server.
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
                          if [ $ERROR -ne 0 ] && [ $LOCAL_REPO_CRED_FAIL -eq 0 ] ; then
                             # Failed to download from Web Repository.
                             # So download from Local Repository.
                             # Try to mount LAN File Server directory on Local Mount-point.
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
# +------------------------------------+
# |      Function f_find_upgrade       |
# +------------------------------------+
#
#  Inputs: $1=GUI.
#          TEMP_FILE Temporary file.
#    Uses: None.
# Outputs: File $TEMP_FILE.
#
# Summary: Update the Operating System using "apt update", "apt upgrade.
#
# Dependencies: apt, f_message, f_ques_upgrade, f_bad_sudo_password.
#
f_find_upgrade () {
      #
      f_test_connection $1 8.8.8.8 1
      #
      if [ $ERROR -eq 0 ] ; then
         #
         # Run a sudo command to catch bad sudo passwords.
         sudo --validate
         ERROR=$?
         #
         if [ $ERROR -eq 0 ] ; then
            #
            # Find latest updates to packages.
            f_message $1 "NOK" "Searching for a Software Upgrade" "\nUsing command 'apt dist-update'\nto find latest upgrade.\n\nPlease be patient."
            #
            echo "Searching for a Software Upgrade" "Using command 'apt dist-update' to find latest upgrade." > $TEMP_FILE
            echo >> $TEMP_FILE
            sudo apt dist-upgrade >> $TEMP_FILE 2>/dev/null
            echo >> $TEMP_FILE
            echo "Finished detecting and installing any new version upgrades to the Desktop." >> $TEMP_FILE
            f_message $1 "OK" "Finished with New Version Upgrades" $TEMP_FILE
         else
            f_bad_sudo_password $GUI
         fi
      fi
      #
} # End of function f_find_upgrade.
#
# +------------------------------------+
# |      Function f_find_updates       |
# +------------------------------------+
#
#  Inputs: $1=GUI.
#          TEMP_FILE Temporary file.
#    Uses: None.
# Outputs: File $TEMP_FILE.
#
# Summary: Update the Operating System using "apt update", "apt upgrade.
#
# Dependencies: apt, f_message, f_ques_upgrade, f_bad_sudo_password.
#
f_find_updates () {
      #
      f_test_connection $1 8.8.8.8 1
      #
      if [ $ERROR -eq 0 ] ; then
         #
         # Run a sudo command to catch bad sudo passwords.
         sudo --validate
         ERROR=$?
         #
         if [ $ERROR -eq 0 ] ; then
            #
            # Find latest updates to packages.
            f_message $GUI "NOK" "Searching for Software Updates" "\nUsing command 'apt update' to find latest updates. Please be patient."
            #
            sudo apt update > $TEMP_FILE 2>/dev/null
            #
            #-----------------------------------------------------------
            #
            # Output of "apt update" command. (apt version 2.0.9.)
            #
            # Hit:1 http://ubuntu.mirror.constant.com focal InRelease
            #  ...
            # Hit:10 https://mirrors.seas.harvard.edu/linuxmint-packages una Release
            # Fetched 114 kB in 3s (41.6 kB/s)
            # Reading package lists... Done
            # Building dependency tree
            # Reading state information... Done
            # 3 packages can be upgraded. Run 'apt list --upgradable' to see them.
            #
            #-----------------------------------------------------------
            #
            # In this example, the current version of apt is found using
            # the command "apt list apt".
            #
            # Output of "apt list apt" command.
            # Listing... Done
            # apt/focal-updates,now 2.0.9 amd64 [installed]
            # apt/focal-updates 2.0.9 i386
            #
            #-----------------------------------------------------------
            #
            # (See also "apt-get --simulate upgrade")
            # Output of "apt-get  --simulate upgrade command.
            #
            # NOTE: This is only a simulation!
            # apt-get needs root privileges for real execution.
            # Keep also in mind that locking is deactivated,
            # so don't depend on the relevance to the real current situation!
            # Reading package lists... Done
            # Building dependency tree
            # Reading state information... Done
            # Calculating upgrade... Done
            # The following packages have been kept back:
            # libvkd3d1 libvkd3d1:i386
            # 0 upgraded, 0 newly installed, 0 to remove and 2 not upgraded.
            #
            #-----------------------------------------------------------
            #
            # If updates exist, do you want to see package descriptions?
            # And do you want to upgrade the packages?
            f_ques_upgrade $GUI $TEMP_FILE
            #
         else
            f_bad_sudo_password $GUI
         fi
      fi
      #
} # End of function f_find_updates.
#
# +------------------------------------+
# |      Function f_ques_upgrade       |
# +------------------------------------+
#
#  Inputs: $1=GUI.
#          #2=Temporary file containing output from "sudo apt update".
#    Uses: None.
# Outputs: File $TEMP_FILE.
#
# Summary: Find upgradable software packages, ask user if want to upgrade.
#
# Dependencies: apt, f_message, f_obsolete_packages, f_yn_question.
#
f_ques_upgrade () {
      #
      # Temporary file contains output from "sudo apt update".
      # Read the last line in the file $TEMP_FILE.
      XSTR=$(tail -n 1 $2)
      #
      #-----------------------------------------------------------
      #
      # Output of tail -n 1 $2 from the example in f_find_updates.
      #
      # If updates are available:
      # 3 packages can be upgraded. Run 'apt list --upgradable' to see them.
      #
      #-----------------------------------------------------------
      #
      # If no updates are available:
      # 0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
      #
      #-----------------------------------------------------------
      #
      # If no updates are available:
      # All packages are up to date.
      #
      #-----------------------------------------------------------
      #
      # Are software packages up to date?
      if [ "$XSTR" = "All packages are up to date." ] ; then
         # Yes, software packages are up to date.
         #
         f_message $1 "OK" "Status of Software Packages" "\nAll software packages are at the latest version."
         #
         # Clean up temporary files before running "sudo apt upgrade".
         # If you quit out of "sudo apt upgrade", then execution terminates
         # within this function and never goes back to Main.
         if [ -e $TEMP_FILE ] ; then
            rm $TEMP_FILE
         fi
         #
         #-----------------------------------------------------------
         #
         # In some versions of apt, the string "autoremove" (to remove
         # obsolete packages) appears after "apt update" command, but
         # in the newer versions of apt, the string appears only after
         # the command "apt upgrade" is given.
         #
         # So even though there are no packages to upgrade, give the
         # command "apt upgrade to detect any obsolete packages to remove.
         #
         #-----------------------------------------------------------
         #
         f_message $1 "NOK" "Checking for obsolete Software Packages" "\nRunning command: \"sudo apt upgrade\"\nto check for obsolete software packages." 3
         #
         clear  # Blank the screen.
         #
         # Redirect error messages to bit bucket using command "2>/dev/null".
         # 1=standard messages, 2=error messages, &=both.
         # Don't display error message "WARNING: Apt does not have a stable CLI interface."
         sudo apt upgrade > $2 2>/dev/null
         f_obsolete_packages $1 $2
      else
         # Software packages need to be updated.
         #
         XSTR=$(echo $XSTR | awk -F "." '{ print $1"." }')
         NUM_PKGS=$(echo $XSTR | awk '{ print $1 }')
         #
         f_yn_question $1 "N" "View Software Package Descriptions?" " \n$XSTR\n\nThere may be a delay to display descriptions.\n\n(especially if many software packages need to be updated)\n \nDo you want to view the descriptions of the $NUM_PKGS software package(s)?"
         #
         # Throw out temporary variables.
         unset XSTR NUM_PKGS
         #
         # ANS=0 when <Yes> button pressed.
         # ANS=1 when <No> button pressed.
         #
         # if <Yes> button pressed, then list packages.
         if [ $ANS -eq 0 ] ; then
            #
            # Blank the screen.
            clear
            #
            # Display a list of upgradeable packages.
            f_list_packages
         fi
         #
         f_message $1 "NOK" "Upgrade Software Packages" "\nRunning command: \"sudo apt upgrade\" to upgrade software packages."
         #
         clear  # Blank the screen.
         #
         # Clean up temporary files before running "sudo apt upgrade".
         # If you quit out of "sudo apt upgrade", then execution terminates
         # within this function and never goes back to Main.
         TEMP_FILE=$THIS_FILE"_temp.txt"
         #
         # Delete temporary file.
         if [ -e $TEMP_FILE ] ; then
            rm $TEMP_FILE
         fi
         #
         # Get any package upgrades.
         sudo apt upgrade | tee $TEMP_FILE
         #
         # Copy $TEMP_FILE temp file to $TEMP_FILE"2.txt" because f_message below
         # deletes the temp file and want to keep $TEMP_FILE
         # since f_obsolete_packages needs to read it.
         cp $TEMP_FILE $TEMP_FILE"2.txt"
         #
         # Blank the screen.
         clear
         f_message $1 "OK" "apt upgrade Results" $TEMP_FILE"2.txt"
         #
         # Delete temporary file.
         if [ -e $TEMP_FILE"2.txt" ] ; then
            rm $TEMP_FILE"2.txt"
         fi
         #
         # Find any obsolete packages and delete them.
         f_obsolete_packages $1 $TEMP_FILE
         #
         # If packages are held back then have the option to "apt dist-upgrade".
         if [ -e $TEMP_FILE ] ; then
            # TEMP_FILE exists, so test it for any packages held back.
            ANS=$(grep --count "The following packages have been kept back" $TEMP_FILE)
         else
            # TEMP_FILE does not exist, so set ANS to zero (no packages held back).
            ANS=0
         fi
         #
         if [ $ANS -ne 0 ] ; then
            # Yes/No Question.
            f_yn_question $1 "Y" "Upgrade Linux distribution packages to new version?" "\nSome software packages are held back due to new version.\n \nRun \"apt dist-upgrade\"?"
            # ANS=0 when <Yes> button pressed.
            # ANS=1 when <No> button pressed.
            #
            if [ $ANS -eq 0 ] ; then
               # if <Yes> button pressed, then upgrade distribution.
               sudo apt dist-upgrade | tee $TEMP_FILE
               #
               # Blank the screen.
               clear
               f_message $1 "OK" "dist-upgrade Results" $TEMP_FILE
            fi
            #
         fi
         #
         TEMP_FILE=$THIS_FILE"_temp.txt"
         if [ -e $TEMP_FILE ] ; then
            # Delete temp file.
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
# Summary: Display a list of upgradable software packages.
#
# Dependencies: apt, aptitude, f_message.
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
         # Is application aptitude installed?
         # Use "command" to determine.
         #command -v aptitude >/dev/null
         # ERROR=$?
         #
         # Is application aptitude installed?
         # Use "type" to determine.
         type aptitude >/dev/null 2>&1
         ERROR=$?
         #
         # ERROR=0 Aptitude is installed.
         # ERROR=1 Aptitude is not installed.
         # "&>/dev/null" does not work in Debian distro.
         # 1=standard messages, 2=error messages, &=both.
         #
         # Create file $TEMP_FILE2 to contain package name and short description.
         TITLE="***Description of upgradable packages***"
         echo $TITLE > $TEMP_FILE2
         #
         # Extract the "Description" from the raw data output from command "apt-cache show <pkg name>".
         # Read the file uplist.tmp.
         while read XSTR
         do
               # grep all package description text between strings "Description" and "Description-md5".
               echo >> $TEMP_FILE2
               echo "---------------------------" >> $TEMP_FILE2
               echo >> $TEMP_FILE2
               echo $XSTR >> $TEMP_FILE2
               echo >> $TEMP_FILE2
               apt-cache show $XSTR | grep Description --max-count=1 --after-context=99 | grep Description-md5 --max-count=1 --before-context=99 | sed 's/^Description-md5.*$//'>> $TEMP_FILE2
               # Is Aptitude installed?
               if [ $ERROR -eq 0 ] ; then
                  # Yes, so use application aptitude to display changelog.
                  echo >> $TEMP_FILE2
                  echo "Retrieving changelog for $XSTR."
                  # Get changelog via Aptitude app and redirect error messages so they do not display.
                  aptitude changelog $XSTR  2>/dev/null | head -n 20 >> $TEMP_FILE2
               fi
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
#  Inputs: $1=GUI.
#          $2=Temporary file.
#    Uses: None.
# Outputs: None.
#
# Summary: Ask user to remove any packages that are installed yet obsolete.
#
# Dependencies: f_yn_question, f_message.
#
f_obsolete_packages () {
      #
      # In some versions of apt, the string "autoremove" (obsolete packages)
      # appears after "apt update" but in the newer versions of apt,
      # the string appears only after command "apt upgrade" is given.
      #
      # Prerequisite:
      # The command "apt upgrade" must be given before calling this function.
      # i.e. Command format:  "sudo apt upgrade | tee $TEMP_FILE".
      #                       "f_obsolete_packages $GUI $TEMP_FILE".
      #
      # Are there any software packages automatically installed but are no longer required?
      ANS=$(grep autoremove $2)
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
            sudo apt autoremove | tee $TEMP_FILE
            # Display temporary file containing messages from apt command.
            f_message $1 "OK" "Apt messages" $TEMP_FILE
         fi
      fi
      #
      # Are there any software packages that were held back?
      ANS=$(grep "held back" $2)
      if [ -n "$ANS" ] ; then
         # If $ANS is not zero length and contains the string "held back".
         # Display temporary file containing messages from apt command.
         f_message $1 "OK" "Apt messages" $2
      fi
      #
} # End of function f_obsolete_packages
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
f_menu_main_all_menus $GUI "Upgrade_Menu" "$THIS_FILE"
#
# Delete temporary files.
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
if [ -e  $FILE_LIST ] ; then
   rm $FILE_LIST
fi
#
if [ -e  $FILE_DL_LIST ] ; then
   rm $FILE_DL_LIST
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

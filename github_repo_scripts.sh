#!/bin/bash
#
VERSION="2019-09-17 22:38"
THIS_FILE="git_repo_scripts.sh"
#
# Specify TARGET Directory.
TARGET_DIR="scripts_downloaded_from_github"
#
## Brief Description
##
## This script will download rdchin's GitHub project files to a Target Directory.
##
## To add more file server names, share-points with corresponding mount-points,
## edit the text with the prefix "#@@" following the Code Change History.
## Format <DELIMITER>//<Source File Server>/<Shared directory><DELIMITER>/<Mount-point on local PC>
##
## After each edit made, please update Code History and VERSION.
##
## Code Change History
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
# Add actual share-point and mount-point names to scripts "mountup.sh" and "mountup_lib_gui.lib".
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
#@@//papyrus/robert#@@/mnt/papyrus/robert#@@Robert folder.
#@@//papyrus/public-no-backup#@@/mnt/papyrus/public-no-backup#@@Public folder but not backed up.
#@@//papyrus/public#@@/mnt/papyrus/public#@@Public folder.
#
#@@//beansprout/robert#@@/mnt/beansprout/robert#@@Roberts documents.
#@@//beansprout/public-no-backup#@@/mnt/beansprout/public-no-backup#@@Public files but not backed up.
#@@//beansprout/public#@@/mnt/beansprout/public#@@Public files.
#
#
# +----------------------------------------+
# |        Function f_test_connection      |
# +----------------------------------------+
#
#  Inputs: $1=URL. 
#    Uses: None.
# Outputs: ERROR. 
#
f_test_connection () {
      # Check if there is an internet connection before doing a download.
      echo
      echo "Test LAN Connection to $1"
      echo
      ping -c 1 -q $1  # Ping server address.
      ERROR=$?
      echo
      if [ $ERROR -ne 0 ] ; then
         echo -n $(tput setaf 1) # Set font to color red.
         echo -n $(tput bold)
         echo ">>> Network connnection to $1 failed. <<<"
         echo "    Cannot wget download files."
         echo -n $(tput sgr0)
         f_press_enter_key_to_continue
      fi
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
# |             Function f_wget            |
# +----------------------------------------+
#
#  Inputs: $1=TARGET_DIR.
#    Uses: REPOSITORY, SCRIPT, ANS.
# Outputs: None.
#
f_wget () {
      # Check internet connectivity to raw.githubusercontent.com.
      f_test_connection raw.githubusercontent.com
      #
      # If there is a good internet connection, continue to wget download.
      if [ $ERROR -eq 0 ] ; then
         #
         # Repository clamav-script.
         REPOSITORY="https://raw.githubusercontent.com/rdchin/clamav-script/master/"
         SCRIPT="virusscan_clamav.sh"
         f_wget_do $REPOSITORY $SCRIPT $1
         #
         # Repository rsync diroctories.
         REPOSITORY="https://raw.githubusercontent.com/rdchin/rsync_directories/master/"
         SCRIPT="server_rsync.sh"
         f_wget_do $REPOSITORY $SCRIPT $1
         #
         # Repository file-rename.
         REPOSITORY="https://raw.githubusercontent.com/rdchin/file-rename/master/"
         for SCRIPT in file_rename.sh file_recursive_rename.sh
         do
	          f_wget_do $REPOSITORY $SCRIPT $1
	      done
         #
         # Repository apt-pkg-upgrade.
         REPOSITORY="https://raw.githubusercontent.com/rdchin/apt-pkg-upgrade/master/"
         for SCRIPT in pkg-upgrade.sh $THIS_FILE
         do
             f_wget_do $REPOSITORY $SCRIPT $1
         done
         #
         # Repository samba-mount.
         REPOSITORY="https://raw.githubusercontent.com/rdchin/samba-mount/master/"
         for SCRIPT in mountup.sh mountup_gui.sh mountup_lib_gui.lib
         do
             f_wget_do $REPOSITORY $SCRIPT $1
         done
         #
         # Repository bash-automatic-menu-creator.
         REPOSITORY="https://raw.githubusercontent.com/rdchin/bash-automatic-menu-creator/master/"
         for SCRIPT in menu.sh menu_module_main.lib menu_module_sub0.lib menu_module_sub0.lib
         do
             f_wget_do $REPOSITORY $SCRIPT $1
         done
         #
         # Repository cli-app-menu.
         echo -n "Choose repository for project 'cli-app-menu' (Master/Testing/Develpment) (Testing): "; read ANS
         case $ANS in
              [Mm]*)
                     REPOSITORY="https://raw.githubusercontent.com/rdchin/cli-app-menu/master/"
                     for SCRIPT in cliappmenu.sh lib_cli-common.lib lib_cli-menu-cat.lib lib_cli-web-sites.lib mod_apps-system.lib CODE_HISTORY COPYING EDIT_HISTORY LIST_APPS README
                     do
                       f_wget_do $REPOSITORY $SCRIPT $1
                     done
              ;;
              [Tt]* | *)
                     REPOSITORY="https://raw.githubusercontent.com/rdchin/cli-app-menu/testing/"
                     for SCRIPT in cliappmenu.sh lib_cli-common.lib lib_cli-menu-cat.lib lib_cli-web-sites.lib menu_module_configuration.lib menu_module_information.lib menu_module_main.lib lib mod_apps-system.lib CODE_HISTORY COPYING EDIT_HISTORY LIST_APPS README
                     do
                       f_wget_do $REPOSITORY $SCRIPT $1
                     done
              ;;
              [Dd]*)
                     REPOSITORY="https://raw.githubusercontent.com/rdchin/cli-app-menu/development/"
                     for SCRIPT in cliappmenu.sh lib_cli-common.lib lib_cli-menu-cat.lib lib_cli-web-sites.lib menu_module_app_categories.lib menu_module_app_mod_management.lib menu_module_configuration.lib menu_module_information.lib menu_module_list_find_menus.lib menu_module_main.lib menu_module_mod_management.lib menu_module_term_color.lib mod_apps-system.lib CODE_HISTORY COPYING EDIT_HISTORY LIST_APPS README
                     do
                       f_wget_do $REPOSITORY $SCRIPT $1
                     done
              ;;
         esac
      fi
}  # End of function f_wget.
#
# +----------------------------------------+
# |            Function f_wget_do          |
# +----------------------------------------+
#
#  Inputs: $1=REPOSITORY.
#          $2=SCRIPT.
#          $3=TARGET_DIR.
#    Uses: None.
# Outputs: None.
#
f_wget_do () {
      # Check to see if $TARGET_DIR/<filename> exists.
      # If filename exists, then rename it to *.bak.
      if [ -r ~/$3/$2 ] ; then
         echo "Saving existing file"
         echo "From ~/$3/$2"
         echo "  To ~/$3/$2.bak"
         echo
         mv ~/$3/$2 ~/$3/$2.bak
      fi
      #
      wget $1$2
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
         echo
         echo "!!! wget download failed !!! for file:"
         echo "$1/$2"
         echo
         # try wget download one more time.
         wget $1$2
         ERROR=$?
         # If wget download failed, then print error and rename <TARGET_DIR>/<Script-Name>.sh.bak to <Script-Name>.sh.
         if [ $ERROR -ne 0 ] ; then
            echo
            echo "!!! wget download retry failed !!! for file:"
            echo "$1/$2"
            echo
            # Rename <TARGET_DIR>/<SCRIPT>.bak to <TARGET_DIR>/<SCRIPT>.
            mv ~/$3/$2.bak ~/$3/$2
            f_press_enter_key_to_continue
         fi
      fi
      #
      f_bak $3 $2  # Delete unneeded *.bak files.
}  # End of function f_wget_do.
#
# +----------------------------------------+
# |              Function f_bak            |
# +----------------------------------------+
#
#  Inputs: $1=TARGET_DIR.
#          $2=SCRIPT.
#    Uses: ERROR.
# Outputs: None.
#
f_bak () {
      # Check to see if $TARGET_DIR/<latest version filename> exists.
      # If filename exists and *.bak filename exists, then compare it to *.bak.
      #    If same version of file, then delete *.bak.
      #    If different versions of file, then do nothing.
      #
      if [ -r ~/$1/$2.bak ] && [ -r ~/$1/$2 ] ; then
         cmp -s ~/$1/$2 ~/$1/$2.bak
         ERROR=$?
         if [ $ERROR -eq 0 ] ; then
            echo "Deleting redundant file:"
            echo "~/$1/$2.bak"
            echo
            rm ~/$1/$2.bak
         fi
      fi
}  # End of function f_bak.
#
# +----------------------------------------+
# |      Function f_edit_script_files      |
# +----------------------------------------+
#
#  Inputs: $1=TARGET_DIR.
#    Uses: SCRIPT.
# Outputs: None.
#
f_edit_script_files () {
      for SCRIPT in mountup.sh mountup_lib_gui.lib
      do
          # Does file exist and is writeable?
          if [ -w ~/$1/$SCRIPT ] ; then
             f_edit_sharing_names $1 $SCRIPT
          else
            echo -n $(tput setaf 1) # Set font to color red.
            echo -n $(tput bold)
            echo "!!! Cannot modify $1/$SCRIPT !!!"
            echo
          fi
      done
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
                    # Insert that line into script, "mountup.sh" or "mountup_lib_gui.lib".
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
}  # End of function f_edit_sharing_names.
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
#  Inputs:
#    Uses:
# Outputs:
#
# Check for existance of directory, ~/scripts_from_github.
cd ~
if [ ! -e ~/$TARGET_DIR ] ; then
    mkdir $TARGET_DIR
fi
#
if [ -e ~/$TARGET_DIR ] ; then
   # Directory exists, then wget script files there.
   cd $TARGET_DIR
   # Download files from GitHub.
   f_wget $TARGET_DIR
   #
   # Edit files mountup.sh and mountup_lib_gui.lib to customize for my LAN Host Names.
   f_edit_script_files $TARGET_DIR
else
   echo -n $(tput setaf 1) # Set font to color red.
   echo -n $(tput bold)
   echo " >>> Download directory does not exist: ~/$TARGET_DIR <<<"
fi
#
# End of Main Program.
# all dun dun noodles.

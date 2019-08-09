##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure and implement callbacks in this file
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=true

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# The installation framework will export some variables and functions.
# You should use these variables and functions for installation.
#
# ! DO NOT use any Magisk internal paths as those are NOT public API.
# ! DO NOT use other functions in util_functions.sh as they are NOT public API.
# ! Non public APIs are not guranteed to maintain compatibility between releases.
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################
##########################################################################################
# If you need boot scripts, DO NOT use general boot scripts (post-fs-data.d/service.d)
# ONLY use module scripts as it respects the module status (remove/disable) and is
# guaranteed to maintain the same behavior in future Magisk releases.
# Enable boot scripts by setting the flags in the config section above.
##########################################################################################

# Set what you want to display when installing your module

print_modname() {
ui_print "*********************************************"
ui_print "     bash for Android       	    	       "
ui_print "         - v5.0.7                            "
ui_print "         - built by nelshh@xda-developers    "
ui_print "*********************************************"
}

# Copy/extract your module files into $MODPATH in on_install.

on_install() {
  ui_print "[1/8] Extracting files..";
  unzip -o "$ZIPFILE" '*' -d $MODPATH >&2;

  if [ -d /sdcard ]; then
    SDCARD=/sdcard
  elif [ -d /storage/emulated/0 ]; then
    SDCARD=/storage/emulated/0
  fi

  ui_print "[2/8] Setting $SDCARD location.."
  sed -i "s|<SDCARD>|$SDCARD|" $MODPATH/custom/.bashrc
  sed -i "s|<SDCARD>|$SDCARD|" $MODPATH/custom/.motd
  sed -i "s|<SDCARD>|$SDCARD|" $MODPATH/system/etc/mkshrc

  if [ ! -f $SDCARD/.bash_aliases ]; then
    ui_print "   Copying .bash_aliases to $SDCARD"
    cp $MODPATH/custom/.bash_aliases $SDCARD
  else
    ui_print "   $SDCARD/.bash_aliases found! Backing up and overwriting!"
    cp -rf $SDCARD/.bash_aliases $SDCARD/.bash_aliases.bak
    cp -rf $MODPATH/custom/.bash_aliases $SDCARD
  fi

  if [ ! -f $SDCARD/.inputrc ]; then
    ui_print "   Copying .inputrc to $SDCARD"
    cp $MODPATH/custom/.inputrc $SDCARD
  else
    ui_print "   $SDCARD/.inputrc found! Backing up and overwriting!"
    cp -rf $SDCARD/.inputrc $SDCARD/.inputrc.bak
    cp -rf $MODPATH/custom/.inputrc $SDCARD
  fi

  if [ ! -f $SDCARD/.bashrc ]; then
    ui_print "   Copying .bashrc to $SDCARD"
    cp $MODPATH/custom/.bashrc $SDCARD
  else
    ui_print "   $SDCARD/.bashrc found! Backing up and overwriting!"
    cp -rf $SDCARD/.bashrc $SDCARD/.bashrc.bak
    cp -rf $MODPATH/custom/.bashrc $SDCARD
  fi

  if [ ! -f $SDCARD/.motd ]; then
    ui_print "   Copying .motd to $SDCARD"
    cp $MODPATH/custom/.motd $SDCARD
  else
    ui_print "   $SDCARD/.motd found! Backing up and overwriting!"
    cp -rf $SDCARD/.motd $SDCARD/.motd.bak
    cp -rf $MODPATH/custom/.motd $SDCARD
  fi
  ui_print "[3/8] Installing files..";
}


symlink_from_file() {
   cat $1 | while read line
   do
      target=$(echo $line | sed 's/;/ /g' | awk '{printf $2}');
      symlink=$(echo $line | sed 's/;/ /g' | awk '{printf $1}');
      ln -sf $target $2/$symlink;
      chown 0:0 $2/$symlink;
      chmod 755 $2/$symlink;
   done
}

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0644;

  ui_print "[4/8] Setting up symlinks.."
  cd $MODPATH/system/share/bash-completion/completions
  symlink_from_file "$MODPATH/custom/symlinks_completions" "$MODPATH/system/share/bash-completion/completions"

  ui_print "[5/8] Installing to /system/bin.."
  chown 0:0 $MODPATH/system/bin/bash;
  chmod 755 $MODPATH/system/bin/bash;

  ui_print "[6/8] Installing to /system/share.."
  chown -R 0:0 $MODPATH/system/share;
  find $MODPATH/system/share -type d -exec chmod 755 {} +;
  find $MODPATH/system/share -type f -exec chmod 644 {} +;
  chmod 755 $MODPATH/system/share/bash-completion/bash_completion;
  chmod 755 $MODPATH/system/share/bash-completion/completions/*;


  ui_print "[7/8] Installing to /system/etc.."
  chown -R 0:0 $MODPATH/system/etc;
  find $MODPATH/system/etc -type d -exec chmod 755 {} +;
  find $MODPATH/system/etc -type f -exec chmod 644 {} +;
  chmod 755 $MODPATH/system/etc/profile.d/bash_completion.sh;
  chmod 755 $MODPATH/system/etc/profile;

  ui_print "[8/8] Installation finished";
}

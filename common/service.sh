#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*};

symlink_from_file() {
   tail -n +2 $1 | while read line; do
      target=$(echo $line | sed 's/;/ /g' | awk '{printf $2}');
      symlink=$(echo $line | sed 's/;/ /g' | awk '{printf $1}');
      ln -sf $target $2/$symlink;
      chown 0:0 $2/$symlink;
      chmod 755 $2/$symlink;
      echo $line;
   done
}

cp_man() {
   man_dir=$1;
   if [[ ! -d "/system/usr/share/man/$man_dir" ]]; then
      mkdir -p /system/usr/share/man/$man_dir;
   fi

   find $MODDIR/system/usr/share/man/$man_dir -type f -print | while read man_file; do
      cd $MODDIR;
      man_file=$(basename $man_file);
      cp -f system/usr/share/man/$man_dir/$man_file /system/usr/share/man/$man_dir/$man_file;
      chmod 644 /system/usr/share/man/$man_dir/$man_file;
   done
}

mount -o rw,remount /system;
mount -o rw,remount /system/usr/share;

for dir in $MODDIR/system/usr/share/man/man*/; do
    dir="${dir%/}";
    dir="${dir##*/}";
    cp_man $dir;
done

if [[ -s "/system/bin/mandoc" ]]; then
  makewhatis /system/usr/share/man;
fi

orig_dir=$(pwd);

find $MODDIR/symlinks -type f -print | while read symlink_file; do
    cd $MODDIR;
    symlink_file=$(basename $symlink_file);
    file_path=$(head -n 1 $MODDIR/symlinks/$symlink_file);
    #echo $symlink_file;
    #echo $file_path;
    mkdir -p $file_path;
    #echo "cp -f symlinks/$symlink_file $file_path/$symlink_file";
    cp -f symlinks/$symlink_file $file_path/$symlink_file;
    cd $file_path;
    symlink_from_file "$file_path/$symlink_file" "$file_path";
    cd $orig_dir;
done

mount -o ro,remount /system/usr/share;
mount -o ro,remount /system;

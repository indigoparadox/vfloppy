#!/bin/bash

ARG_ERROR=0
SHIFT_ONCE="/"
FLOPPY_DENSITY=2880
CURRENT_UID=`id -u`
CURRENT_GID=`id -g`

MCOPY=`which mcopy`
DD=`which dd`
UNZIP=`which unzip`
SUDO=`which sudo`
MKFS_VFAT=`which mkfs.vfat`

if [ ! -x "$MCOPY" ]; then
   echo "Missing dependency: mtools"
   exit 1
fi

while [ "$1" ]; do
   case "$1" in
      "-z"|"--zip")
         shift
         ZIP_PATH="$1"
         ;;

      "-d"|"--dir")
         shift
         DIR_PATH="$1"
          ;;

      "-1")
         shift
         SHIFT_ONCE="/$1/"
         ;;

      "-7"|"--720k")
         FLOPPY_DENSITY=1440
         ;;

      *)
         if [ -z "$IMG_PATH" ]; then
            IMG_PATH="$1"
         elif [ -z "$MOUNT_PATH"]; then
            MOUNT_PATH="$1"
         else
            ARG_ERROR=1
         fi
   esac
   shift
done

if [ $ARG_ERROR = 1 ] || [ -z "$IMG_PATH" ]; then
   echo "usage: $0 [-z zip_file] [-d source_dir] <image_path> [mount_path]"
   exit 1
fi

$DD if=/dev/zero bs=512 count=$FLOPPY_DENSITY of="$IMG_PATH" && \
$MKFS_VFAT "$IMG_PATH"

if [ -n "$ZIP_PATH" ]; then

   if [ ! -x "$UNZIP" ]; then
      echo "Missing dependency: unzip"
      exit 1
   fi

   TEMP_PATH="`mktemp -d`"

   $UNZIP -d "$TEMP_PATH" "$ZIP_PATH"
   
   $MCOPY -spmv -i "$IMG_PATH" "$TEMP_PATH$SHIFT_ONCE"* "::"

   rm -rf "$TEMP_PATH"

elif [ -n "$DIR_PATH" ]; then

   $MCOPY -spmv -i "$IMG_PATH" "$DIR_PATH$SHIFT_ONCE"* "::"

fi

if [ -f "$IMG_PATH" ] && [ -n "$MOUNT_PATH" ]; then
   $SUDO /bin/mount -o loop,uid=$CURRENT_UID,gid=$CURRENT_GID \
      "$IMG_PATH" "$MOUNT_PATH"
fi


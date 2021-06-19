#!/bin/bash

ARG_ERROR=0
FLOPPY_DENSITY=2880

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
   echo "usage: $0 [-z zipfile] [-d srcdir] [image_path] [mount_path]"
else

   /bin/dd if=/dev/zero bs=512 count=$FLOPPY_DENSITY of="$IMG_PATH" && \
   /sbin/mkfs.vfat "$IMG_PATH"

   if [ -n "$ZIP_PATH" ]; then
      TEMP_PATH="`mktemp -d`"
      unzip -d "$TEMP_PATH" "$ZIP_PATH"
      mcopy -spmv -i "$IMG_PATH" "$TEMP_PATH/"* "::"
      rm -rf "$TEMP_PATH"
   fi

   if [ -n "$DIR_PATH" ]; then
      mcopy -spmv -i "$IMG_PATH" "$DIR_PATH/"* "::"
   fi

   if [ -f "$IMG_PATH" ] && [ -n "$MOUNT_PATH" ]; then
      sudo /bin/mount -o loop,uid=1000,gid=1000 "$IMG_PATH" "$MOUNT_PATH"
   fi
fi


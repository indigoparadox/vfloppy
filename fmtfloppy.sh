#!/bin/bash

FD_PATH=""
USB_FLOPPY=0
ARG_ERROR=0

UFIFORMAT=`which ufiformat`
FDFORMAT=`which fdformat`
MKFS_VFAT=`which mkfs.vfat`

while [ "$1" ]; do
   case "$1" in
      "-u")
         USB_FLOPPY=1
         ;;

      *)
         if [ -z "$FD_PATH" ]; then
            FD_PATH="$1"
         else
            ARG_ERROR=1
         fi
         ;;
   esac
   shift
done

if [ -z "$FD_PATH" ] || [ $ARG_ERROR = 1 ]; then
   echo "usage: $0 [-u] <fd_path>"
   exit 1
fi

if [ ! -w "$FD_PATH" ]; then

if [ $USB_FLOPPY = 1 ]; then
   if [ ! -x "$UFIFORMAT" ]; then
      echo "Missing dependency: ufiformat"
      exit 1
   fi

   $UFIFORMAT "$FD_PATH"

else
   if [ ! -x "$FDFORMAT" ]; then
      echo "Missing dependency: fdformat"
      exit 1
   fi

   $FDFORMAT "$FD_PATH"
fi

# TODO: Add presets for other common high-level formats.
#case "${1}" in
#   *)
$MKFS_VFAT -I "$FD_PATH"
#      ;;
#esac


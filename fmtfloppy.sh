#!/bin/bash

FD_PATH=$1

UFIFORMAT=`which ufiformat`
MKFS_VFAT=`which mkfs.vfat`

if [ ! -x "$UFIFORMAT" ]; then
   echo "Missing dependency: ufiformat"
   exit 1
fi

if [ -z "$FD_PATH" ] || [ ! -w "$FD_PATH" ]; then
   echo "No environment floppy device or unable to write to floppy. Aborting."
   exit 2
fi

$UFIFORMAT "$FD_PATH"

# TODO: Add presets for other common high-level formats.
#case "${1}" in
#   *)
$MKFS_VFAT -I "$FD_PATH"
#      ;;
#esac


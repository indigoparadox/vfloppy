#!/bin/sh

ARG_ERROR=0
IMAGE_FILE=""
EXTRACT_DIR=""
EXT=".img"
INDIVIDUAL=0

MCOPY=`which mcopy`

if [ ! -x "$MCOPY" ]; then
   echo "Missing dependency: mtools"
   exit 1
fi

while [ "$1" ]; do
   case "$1" in
      "-i"|"--individual")
         INDIVIDUAL=1
         ;;

      "-e"|"--extension")
         shift
         EXT="$1"
         ;;

      *)
         if [ -z "$IMAGE_FILE" ]; then
            IMAGE_FILE="$1"
         elif [ -z "$EXTRACT_DIR" ]; then
            EXTRACT_DIR="$1"
         else
            ARG_ERROR=1
         fi
         ;;
   esac
   shift
done

if [ $ARG_ERROR = 1 ] || [ -z "$IMAGE_FILE" ] || [ -f "$EXTRACT_DIR" ]; then
   echo "Usage: $0 <image file> [destination dir]"
   exit 1
fi

if [ -z "$EXTRACT_DIR" ]; then
   EXTRACT_DIR="$(basename "$IMAGE_FILE" $EXT)"
   echo "Defaulting to extract directory: $EXTRACT_DIR"
fi

mkdir -p -v "$EXTRACT_DIR"

if [ $INDIVIDUAL -eq 1 ]; then
   mkdir -p -v "$EXTRACT_DIR/$(basename "$IMAGE_FILE" $EXT)"
   echo "Extracting $IMAGE_FILE to $EXTRACT_DIR/$(basename "$IMAGE_FILE" $EXT)..."
   $MCOPY -si "$IMAGE_FILE" ::\* "$EXTRACT_DIR/$(basename "$IMAGE_FILE" $EXT)"
else
   echo "Extracting $IMAGE_FILE to $EXTRACT_DIR..."
   $MCOPY -si "$IMAGE_FILE" ::\* "$EXTRACT_DIR"
fi


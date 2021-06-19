#!/bin/sh

IMAGE_FILES=""
EXTRACT_DIR=""
EXT=".img"
INDIVIDUAL=0

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
         if [ -z "$EXTRACT_DIR" ]; then
            EXTRACT_DIR="$1"
            mkdir -p -v "$EXTRACT_DIR"
         elif [ $INDIVIDUAL -eq 1 ]; then
            mkdir -p -v "$EXTRACT_DIR/$(basename "$1" $EXT)"
            echo "Extracting $1 to $EXTRACT_DIR/$(basename "$1" $EXT)..."
            mcopy -si "$1" ::\* "$EXTRACT_DIR/$(basename "$1" $EXT)"
         else
            echo "Extracting $1 to $EXTRACT_DIR..."
            mcopy -si "$1" ::\* "$EXTRACT_DIR"
         fi
         ;;
   esac
   shift
done


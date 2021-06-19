#!/bin/sh

IMAGE_FILE="$1"
EXTRACT_DIR="$2"

mkdir -p "$EXTRACT_DIR"
mcopy -si "$IMAGE_FILE" ::\* "$EXTRACT_DIR"


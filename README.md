# vfloppy

These are (relatively) simple shell scripts designed for simplifying working with virtual floppy disks that work with most retrocomputing emulators using mtools and loopback mounting.

## mkfloppy.sh

```
usage: mkfloppy.sh [-z zip_file] [-d source_dir] <image_path> [mount_path]
```

Creates a floppy image. When called with only **image path**, the image will be blank. Otherwise, the image will contain the contents of **zip file** or **source dir**. Behaviour is undefined if both are specified.

If **mount path** is specified, the script will then attempt to mount the image at the given path.

## exfloppy.sh

```
usage: exfloppy.sh <image_file> [destination_dir]
```

Extracts a floppy **image file** to **destination dir** if given and the current working directory if not.

## fmtfloppy.sh

```
usage: fmtfloppy.sh [-u] <fd_path>
```

Low- and high-level formats a floppy in the device at **fd path**. If **-u** is specified, the device is assumed to be a USB floppy drive.


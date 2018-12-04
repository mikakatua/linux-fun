#!/bin/bash
#
# Filesystem full
#

rm -f /mnt/file.fs 2> /dev/null
dd if=/dev/zero of=/mnt/file.fs bs=1024 count=102400
mkfs.ext4 -F /mnt/file.fs

umount /data 2> /dev/null
rm -rf /data 2> /dev/null
mkdir /data
mount /mnt/file.fs /data

dir=/usr/src/kernels/$(uname -r)
subdir=include/config/arch/has/debug

cp -a $dir/* /data
dd if=/dev/urandom of=/data/$subdir/deleteme.log

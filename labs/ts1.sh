#!/bin/bash

# Filesystem full
dd if=/dev/zero of=/mnt/file.fs bs=1024 count=102400
mkfs.ext4 -F /mnt/file.fs
mkdir /data 2> /dev/null
umount /data 2> /dev/null
mount /mnt/file.fs /data

dir=/usr/src/kernels/$(uname -r)
subdir=include/config/arch/has/debug

cp -a $dir/* /data
dd if=/dev/urandom of=/data/$subdir/deleteme.log

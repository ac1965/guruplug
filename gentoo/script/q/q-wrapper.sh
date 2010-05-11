#! /bin/sh

rfs=/root/cross/r
ldlib= #"env LD_LIBRARY_PATH=/usr/lib/gcc/armv5tel-softfloat-linux-gnueabi/4.3.2"

[ -d /proc/sys/fs/binfmt_misc ] || modprobe binfmt_misc
[ -f /proc/sys/fs/binfmt_misc/register ] || (
    mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
    echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/qemu-wrapper:' > /proc/sys/fs/binfmt_misc/register
)

[ -d ${rfs}/var/tmp/native ] || install -d ${rfs}/var/tmp/native
[ -d ${rfs}/var/tmp/distfiles ] || install -d ${rfs}/var/tmp/distfiles
[ -d ${rfs}/usr/portage ] || install -d ${rfs}/usr/portage
[ -d ${rfs}/etc/portage ] || install -d ${rfs}/etc/portage
[ -d ${rfs}/proc ] || install -d ${rfs}/proc
[ -d ${rfs}/sys ] || install -d ${rfs}/sys
[ -d ${rfs}/dev ] || install -d ${rfs}/dev
[ -d ${rfs}/root ] || install -d ${rfs}/root
[ -f ${rfs}/qemu-wrapper ] || cp $HOME/cross/qemu-wrapper ${rfs}

files=/root/cross/d
mount --bind ${files}/native ${rfs}/var/tmp/native
mount --bind ${files}/distfiles ${rfs}/var/tmp/distfiles
mount --bind ${files}/portage ${rfs}/usr/portage
mount --bind /root/cross/arm/portage-native ${rfs}/etc/portage
mount --bind /proc ${rfs}/proc
mount --bind /sys ${rfs}/sys

cp -L /etc/resolv.conf ${rfs}/etc
#chroot ${rfs} ${ldlib} /sbin/ldconfig
chroot ${rfs} ${ldlib} /bin/busybox mdev -s
#chroot ${rfs} ${ldlib} /usr/sbin/env-update
#chroot ${rfs} ${ldlib} /bin/bash --login --rcfile dot.bashrc
#chroot ${rfs} ${ldlib} /bin/bash --rcfile /root/dot.bashrc
chroot ${rfs} ${ldlib} /bin/bash --login

rm -f ${rfs}/etc/resolv.conf
rm -f ${rfs}/root/.bashrc_history

umount ${rfs}/usr/portage
umount ${rfs}/etc/portage
umount ${rfs}/sys
umount ${rfs}/proc
umount ${rfs}/var/tmp/distfiles
umount ${rfs}/var/tmp/native
umount /proc/sys/fs/binfmt_misc

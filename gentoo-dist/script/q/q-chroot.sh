#! /bin/sh

rfs=/root/armv5tel-softfloat-linux-gnueabi-rfs
files=/root/q # qemu-wrapper, this script ..

[ -d /proc/sys/fs/binfmt_misc ] || modprobe binfmt_misc
[ -f /proc/sys/fs/binfmt_misc/register ] || (
    mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
    echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/qemu-wrapper:' > /proc/sys/fs/binfmt_misc/register
)

[ -d ${rfs}/proc ] || install -d ${rfs}/proc
[ -d ${rfs}/sys ] || install -d ${rfs}/sys
[ -d ${rfs}/dev ] || install -d ${rfs}/dev
[ -d ${rfs}/dev/pts ] || install -d ${rfs}/dev/pts
[ -d ${rfs}/root ] || install -d ${rfs}/root
[ -f ${rfs}/qemu-wrapper ] || cp ${files}/qemu-wrapper ${rfs}

mount --bind /proc ${rfs}/proc
mount --bind /sys ${rfs}/sys

cp -L /etc/resolv.conf ${rfs}/etc
chroot ${rfs} /bin/busybox mdev -s
ps1='`uname -m`'
cat <<EOF > ${rfs}/root/dot.bashrc
gcc-config 1
env-update
source /etc/profile
export PS1="($ps1:chroot:\W) "
alias emerge='emerge --jobs=4 --load-average=3'
EOF
chroot ${rfs} /bin/bash --rcfile /root/dot.bashrc

rm -f ${rfs}/etc/resolv.conf
rm -f ${rfs}/root/.bashrc_history

umount ${rfs}/sys
umount ${rfs}/proc
umount /proc/sys/fs/binfmt_misc

#! /bin/sh

arch='arm'
base='10.0'
rev='last'

abort () {
    echo $1
    exit
}

target='armv5tel-softfloat-linux-gnueabi'

case "$1" in
    init|--init|-init|-i)	arg1=init;;
    proxy_use|--proxy_use|-proxy_use|-p) arg1=proxy_use;;
    rfs_nobind|--rfs_nobind|-rfs_nobind|-rn) arg1=rfs_nobind;;
    help|--help|-h|-?)	cat <<EOF
usage:
	`basename $0` [ init | proxy_use | rfs_nobind | help ]
EOF
	exit
esac

r=/root/cross

distrib=${r}/gentoo-dist
portage=${r}/portage
distfiles=${r}/distfiles
src=${r}/src
lib_layman=${distrib}/lib_layman
local_overlay=${distrib}/local_overlay
host_pkgs=${r}/${rev}/host
target_tmp=${r}/${rev}/target
target_pkgs=${r}/${rev}/binpkgs
native_tmp=${r}/${rev}/native
native_pkgs=${r}/${rev}/native_binpkgs
stage=${r}/${rev}/rfs

host_portage=${distrib}/host_etc_portage
target_portage=${distrib}/target_etc_portage

rfs=${distrib}/gentoo
[ -d ${rfs}/usr/${target} ] || abort "You must run crossdev."

[ x"${arg1}" = x"init" ] && (
    [ -d ${distrib}/${rev} ] || install -d ${distrib}/${rev}
    [ -d ${r}/${rev} ] || install -d ${r}/${rev}
    [ -d ${distrib}/${rev}/portage ] || install -d ${distrib}/${rev}/portage
    [ -d ${distrib}/${rev}/binpkgs ] || install -d ${distrib}/${rev}/binpkgs
    [ -d ${distrib}/${rev}/native_binpkgs ] || install -d ${distrib}/${rev}/native_binpkgs
    [ -d ${distrib}/${rev}/rfs ] || install -d ${distrib}/${rev}/rfs
    [ -L ${target_pkgs} ] || ln -s ${distrib}/${rev}/binpkgs ${target_pkgs}
    [ -L ${native_pkgs} ] || ln -s ${distrib}/${rev}/native_binpkgs ${native_pkgs}
)

[ -d ${rfs} ] || abort "${rfs} not found."
[ -d ${portage} ] || abort "${portage} not found. you must run \``basename $0` init\`"

[ -d ${distfiles} ] || install -d ${distfiles}
[ -d ${src} ] || install -d ${src}
[ -d ${src}/git ] || install -d ${src}/git
[ -d ${host_portage} ] || install -d ${host_portage}
[ -d ${target_portage} ] || install -d ${target_portage}
[ -d ${lib_layman} ] || install -d ${lib_layman}
[ -d ${local_overlay} ] || install -d ${local_overlay}
[ -d ${host_pkgs} ] || install -d ${host_pkgs}
[ -d ${target_tmp} ] || install -d ${target_tmp}
[ -d ${target_tmp}/binpkgs ] || install -d ${target_tmp}/binpkgs
[ -d ${native_tmp} ] || install -d ${native_tmp}
[ -d ${native_tmp}/binpkgs ] || install -d ${native_tmp}/binpkgs
[ -d ${stage} ] || install -d ${stage}

[ -d ${rfs}/dev ] || install -d ${rfs}/dev
[ -d ${rfs}/proc ] || install -d ${rfs}/proc
[ -d ${rfs}/sys ] || install -d ${rfs}/sys
[ -d ${rfs}/dev/pts ] || install -d ${rfs}/dev/pts
[ -d ${rfs}/usr/portage ] || install -d ${rfs}/usr/portage
[ -d ${rfs}/etc/portage ] || install -d ${rfs}/etc/portage
[ -d ${rfs}/var/tmp/distfiles ] || install -d ${rfs}/var/tmp/distfiles
[ -d ${rfs}/usr/${target}/usr/portage ] || install -d ${rfs}/usr/${target}/usr/portage
[ -d ${rfs}/usr/${target}/etc/portage ] || install -d ${rfs}/usr/${target}/etc/portage
[ -d ${rfs}/var/tmp/native ] || install -d ${rfs}/var/tmp/native
[ -d ${rfs}/var/tmp/cross ] || install -d ${rfs}/var/tmp/cross
[ -d ${rfs}/var/lib/layman ] || install -d ${rfs}/var/lib/layman
[ -d ${rfs}/usr/local/overlay ] || install -d ${rfs}/usr/local/overlay
[ -d ${rfs}/root/${target}-rfs ] || install -d ${rfs}/root/${target}-rfs

mount -o bind /dev ${rfs}/dev
mount -o bind /proc ${rfs}/proc
mount -o bind /sys ${rfs}/sys
mount -o bind /dev/pts ${rfs}/dev/pts
mount -o bind ${portage} ${rfs}/usr/portage
mount -o bind ${distfiles} ${rfs}/var/tmp/distfiles
mount -o bind ${host_portage} ${rfs}/etc/portage
mount -o bind ${portage} ${rfs}/usr/${target}/usr/portage
mount -o bind ${target_portage} ${rfs}/usr/${target}/etc/portage
mount -o bind ${host_pkgs} ${rfs}/var/tmp/native
mount -o bind ${target_tmp} ${rfs}/var/tmp/cross
mount -o bind ${target_pkgs} ${rfs}/var/tmp/cross/binpkgs
mount -o bind ${lib_layman} ${rfs}/var/lib/layman
mount -o bind ${local_overlay} ${rfs}/usr/local/overlay
mount -o bind ${src} ${rfs}/root/src
mount -o bind ${stage} ${rfs}/root/${target}-rfs

[ x"${arg1}" = x"proxy_use" ] && (
    echo proxy using.
    [ -d ${rfs}/.script ] || install -d ${rfs}/root/.script
    cp ${distrib}/files/proxyuse ${rfs}/root/.proxyuse
    cp ${distrib}/files/git-proxy.sh ${rfs}/root/.script
    chmod +x ${rfs}/root/.script/git-proxy.sh
    cp ${distrib}/files/servers ${rfs}/root
)

ps1='`uname -m`'
cat <<EOF > ${rfs}/root/dot.bashrc
env-update
source /etc/profile
[ -f /root/.proxyuse ] && (
    svn help >/dev/null 2>&1
    test -f /root/.subversion || mv /root/servers /root/.subversion
)
[ -f /root/.proxyuse ] && source /root/.proxyuse
[ -L /usr/${target}/etc/make.conf ] || ln -s portage/make.conf-${arch} /usr/${target}/etc/make.conf
[ -L /usr/${target}/etc/make.profile ] || ln -s ../usr/portage/profiles/default/linux/${arch}/${base} /usr/${target}/etc/make.profile
export STAGEDIR="/usr/${target}"
export PS1="(${ps1}:chroot:\W) "
alias pkg-config='cross-pkg-config'
alias emerge='emerge --jobs=4 --load-average=3'
EOF
#export CROSS_COMPILE="${target}-"
cp -a ${distrib}/script/q ${rfs}/root/cross
cp ${distrib}/files/chroot.sh ${rfs}/root
cp ${distrib}/files/mkubi.sh ${rfs}/root/src
chmod +x ${rfs}/root/src/mkubi.sh
cp -L /etc/resolv.conf ${rfs}/etc/resolv.conf

[ x"${arg1}" = x"rfs_nobind" ] || (
    if [ -x ${rfs}/root/cross/qemu-wrapper ]; then
	cp ${rfs}/root/cross/qemu-wrapper ${rfs}/root/${target}-rfs
    else
	if [ -f ${rfs}/root/cross/qemu-wrapper.c ]; then
	    gcc -static -o ${rfs}/root/cross/qemu-wrapper ${rfs}/root/cross/qemu-wrapper.c 2>/dev/null && \
		cp ${rfs}/root/cross/qemu-wrapper ${rfs}/root/${target}-rfs
	else
	    echo "qemu-wrapper: not found."
	fi
    fi
    [ -d ${rfs}/root/${target}-rfs/etc/portage ] || install -d ${rfs}/root/${target}-rfs/etc/portage
    [ -d ${rfs}/root/${target}-rfs/usr/portage ] || install -d ${rfs}/root/${target}-rfs/usr/portage
    [ -d ${rfs}/root/${target}-rfs/var/tmp/native ] || install -d ${rfs}/root/${target}-rfs/var/tmp/native
    [ -d ${rfs}/root/${target}-rfs/var/tmp/distfiles ] || install -d ${rfs}/root/${target}-rfs/var/tmp/distfiles
    [ -d ${rfs}/root/${target}-rfs/usr/src ] || install -d ${rfs}/root/${target}-rfs/usr/src
    mount -o bind ${target_portage} ${rfs}/root/${target}-rfs/etc/portage
    mount -o bind ${portage} ${rfs}/root/${target}-rfs/usr/portage
    mount -o bind ${native_tmp} ${rfs}/root/${target}-rfs/var/tmp/native
    mount -o bind ${native_pkgs} ${rfs}/root/${target}-rfs/var/tmp/native/binpkgs
    mount -o bind ${distfiles} ${rfs}/root/${target}-rfs/var/tmp/distfiles
    mount -o bind ${src} ${rfs}/root/${target}-rfs/usr/src
)

chroot ${rfs} /bin/bash --rcfile /root/dot.bashrc

# clean-up
rm -fr ${rfs}/root/cross
rm -fr ${rfs}/root/dot.bashrc
rm -fr ${rfs}/root/.proxyuse
rm -fr ${rfs}/root/.bash_history
rm -fr ${rfs}/root/.subversion
rm -fr ${rfs}/root/.viminfo
rm -fr ${rfs}/root/.lesshst
rm -fr ${rfs}/root/.ssh
rm -fr ${rfs}/root/.script
rm -fr ${rfs}/root/chroot.sh
rm -fr ${rfs}/etc/resolv.conf
rm -fr ${rfs}/root/${target}-rfs/qemu-wrapper

[ x"${arg1}" = x"rfs_nobind" ] || (
    umount ${rfs}/root/${target}-rfs/usr/src
    umount ${rfs}/root/${target}-rfs/var/tmp/distfiles
    umount ${rfs}/root/${target}-rfs/var/tmp/native/binpkgs
    umount ${rfs}/root/${target}-rfs/var/tmp/native
    umount ${rfs}/root/${target}-rfs/usr/portage
    umount ${rfs}/root/${target}-rfs/etc/portage
)
umount ${rfs}/root/${target}-rfs
umount ${rfs}/root/src
umount ${rfs}/usr/local/overlay
umount ${rfs}/var/lib/layman
umount ${rfs}/var/tmp/cross/binpkgs
umount ${rfs}/var/tmp/cross
umount ${rfs}/var/tmp/native
umount ${rfs}/usr/${target}/etc/portage
umount ${rfs}/usr/${target}/usr/portage
umount ${rfs}/etc/portage
umount ${rfs}/var/tmp/distfiles
umount ${rfs}/usr/portage
umount ${rfs}/dev/pts
umount ${rfs}/sys
umount ${rfs}/proc
umount ${rfs}/dev

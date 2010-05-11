#! /bin/sh

arch='arm'
base='10.0'
rev='last'

abort () {
	echo $1
	exit
}

target='armv5tel-softfloat-linux-gnueabi'
init=${1:init}
proxy_use=${1:proxy_use}
case "$1" in
	init|--init|-init|-i)	arg1=init;;
	proxy_use|--proxy_use|-proxy_use|-p) arg1=proxy_use;;
	help|--help|-h|-?)	cat <<EOF
usage:
	`basename $0` [ init | proxy_use | help ]
EOF
	exit
esac

r=/root/cross

distrib=${r}/gentoo-dist
portage=${r}/${rev}/portage
distfiles=${r}/${rev}/distfiles
lib_layman=${distrib}/lib_layman
local_overlay=${distrib}/local_overlay
host_pkgs=${r}/${rev}/host
target_tmp=${r}/${rev}/target
target_pkgs=${r}/${rev}/binpkgs
native_pkgs=${r}/${rev}/target_native
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
	[ -d ${distrib}/${rev}/target_native ] || install -d ${distrib}/${rev}/target_native
	[ -L ${portage} ] || ln -s ${distrib}/${rev}/portage ${portage}
	[ -L ${target_pkgs} ] || ln -s ${distrib}/${rev}/binpkgs ${target_pkgs}
	[ -L ${native_pkgs} ] || ln -s ${distrib}/${rev}/target_native ${native_pkgs}
)

[ -d ${rfs} ] || abort "${rfs} not found."
[ -L ${portage} ] || abort "${portage} not found. you must run \``basename $0` init\`"

[ -d ${distfiles} ] || install -d ${distfiles}
[ -d ${host_portage} ] || install -d ${host_portage}
[ -d ${target_portage} ] || install -d ${target_portage}
[ -d ${lib_layman} ] || install -d ${lib_layman}
[ -d ${local_overlay} ] || install -d ${local_overlay}
[ -d ${host_pkgs} ] || install -d ${host_pkgs}
[ -d ${target_tmp} ] || install -d ${target_tmp}
[ -d ${target_tmp}/binpkgs ] || install -d ${target_tmp}/binpkgs
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
[ -d ${rfs}/usr/${target}/var/tmp/native ] || install -d ${rfs}/usr/${target}/var/tmp/native
[ -d ${rfs}/var/lib/layman ] || install -d ${rfs}/var/lib/layman
[ -d ${rfs}/usr/local/overlay ] || install -d ${rfs}/usr/local/overlay
[ -d ${rfs}/root/stage ] || install -d ${rfs}/root/stage

cd ${distrib}
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
mount -o bind ${native_pkgs} ${rfs}/usr/${target}/var/tmp/native
mount -o bind ${lib_layman} ${rfs}/var/lib/layman
mount -o bind ${local_overlay} ${rfs}/usr/local/overlay
mount -o bind ${stage} ${rfs}/root/stage

cp ${distrib}/files/chroot.sh ${rfs}/root/chroot.sh
chmod +x ${rfs}/root/chroot.sh
[ x"${arg1}" = x"proxy_use" ] && (
echo proxy using.
test -d ${rfs}/.subversion
cp ${distrib}/files/proxyuse ${rfs}/root/.proxyuse
cp ${distrib}/files/servers ${rfs}/root
)
cat <<EOF > gentoo/root/dot.bashrc
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
export PS1="(`uname -m`:chroot:\W) "
alias pkg-config='cross-pkg-config'
EOF
#export CROSS_COMPILE="${target}-"
cp -L /etc/resolv.conf ${rfs}/etc/resolv.conf

chroot ${rfs} /bin/bash --rcfile /root/dot.bashrc

# clean-up
rm -fr ${rfs}/root/dot.bashrc
rm -fr ${rfs}/root/.proxyuse
rm -fr ${rfs}/root/.bash_history
rm -fr ${rfs}/root/.subversion
rm -fr ${rfs}/root/.script
rm -fr ${rfs}/root/.viminfo
rm -fr ${rfs}/root/chroot.sh
rm -fr ${rfs}/etc/resolv.conf

umount ${rfs}/root/stage
umount ${rfs}/usr/local/overlay
umount ${rfs}/var/lib/layman
umount ${rfs}/usr/${target}/var/tmp/native
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

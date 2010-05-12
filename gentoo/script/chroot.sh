#! /bin/sh

eopts="--usepkg"
#eopts=""

CHOST=armv5tel-softfloat-linux-gnueabi
SYSROOT="/usr/${CHOST}"
PKGCONFIG="${SYSROOT}"/usr/lib/pkgconfig


case "$1" in
--install|-install|-i) # make stage3 (cross-compiled)
	ROOT="/root/${CHOST}-rfs"
	;;
*)
	ROOT="/usr/${CHOST}"
	;;
esac

export ROOT SYSROOT PKGCONFIG

[ -d ${SYSROOT} ] || install -d ${SYSROOT}

armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree sys-apps/acl
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree sys-libs/gdbm
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree dev-db/sqlite
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  sys-libs/zlib
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/expat
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  app-arch/xz-utils
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/libffi
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  sys-apps/sandbox
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/gmp
cross-fix-root
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/mpfr
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-lang/perl
armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-lang/python
cross-fix-root
armv5tel-softfloat-linux-gnueabi-emerge ${eopts} --update system

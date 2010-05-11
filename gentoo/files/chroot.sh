#! /bin/sh

SYSROOT="/usr/armv5tel-softfloat-linux-gnueabi"
ROOT=${SYSROOT} 
PKGCONFIG="${SYSROOT}"/usr/lib/pkgconfig

[ -d ${SYSROOT} ] || install -d ${SYSROOT}

#eopts="--usepkg"
eopts=""

ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree sys-apps/acl
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree sys-libs/gdbm
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree dev-db/sqlite
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  sys-libs/zlib
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/expat
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  app-arch/xz-utils
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/libffi
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  sys-apps/sandbox
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/gmp
ROOT=${SYSROOT} SYSROOT=${SYSROOT} cross-fix-root
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/mpfr
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-lang/perl
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-lang/python
ROOT=${SYSROOT} SYSROOT=${SYSROOT} cross-fix-root
ROOT=${SYSROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts} --update system

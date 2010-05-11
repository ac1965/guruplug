#! /bin/sh

eopts="--usepkg"
#eopts=""

CHOST=armv5tel-softfloat-linux-gnueabi
ROOT="/root/${CHOST}-rfs"
SYSROOT="/usr/${CHOST}"
PKGCONFIG="${SYSROOT}"/usr/lib/pkgconfig

[ -d ${SYSROOT} ] || install -d ${SYSROOT}

ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree sys-apps/acl
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree sys-libs/gdbm
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree dev-db/sqlite
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  sys-libs/zlib
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/expat
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  app-arch/xz-utils
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/libffi
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  sys-apps/sandbox
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/gmp
ROOT=${ROOT} SYSROOT=${SYSROOT} cross-fix-root
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/mpfr
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-lang/perl
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-lang/python
ROOT=${ROOT} SYSROOT=${SYSROOT} cross-fix-root
ROOT=${ROOT} SYSROOT=${SYSROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts} --update system

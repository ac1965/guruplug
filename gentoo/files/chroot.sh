#! /bin/sh

CHOST=armv5tel-softfloat-linux-gnueabi
ROOT="/root/${CHOST}-rfs"
SYSROOT="/usr/${CHOST}"
PKGCONFIG="${SYSROOT}"/usr/lib/pkgconfig

[ -d ${SYSROOT} ] || install -d ${SYSROOT}

#eopts="--usepkg"
eopts=""

ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree sys-apps/acl
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree sys-libs/gdbm
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  --emptytree dev-db/sqlite
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  sys-libs/zlib
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/expat
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  app-arch/xz-utils
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/libffi
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  sys-apps/sandbox
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/gmp
ROOT=${ROOT} SYSROOT=${ROOT} cross-fix-root
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-libs/mpfr
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-lang/perl
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts}  dev-lang/python
ROOT=${ROOT} SYSROOT=${ROOT} cross-fix-root
ROOT=${ROOT} SYSROOT=${ROOT} PKGCONFIG=${PKGCONFIG} armv5tel-softfloat-linux-gnueabi-emerge ${eopts} --update system

#! /bin/sh

export PATH=/usr/local/sbin:$PATH

rfs=/root/armv5tel-softfloat-linux-gnueabi-rfs
image=rootfs.ubifs.img
ubifs=`echo $image | sed 's/ubifs/ubi/'`

cat << EOF > /tmp/ubi.cfg
[ubifs]
mode=ubi
image=${image}
vol_id=0
vol_size=356MiB
vol_type=dynamic
vol_name=rootfs
vol_flags=autoresize
EOF

echo mkfs.ubifs ${image}
mkfs.ubifs -x zlib -m 2048  -e 129024 -c 4096 -r ${rfs} ${image}
echo ubinize ${image} : ${ubifs}
ubinize -o ${ubifs} -m 2048 -p 128KiB -s 512 /tmp/ubi.cfg
rm -f ${image}

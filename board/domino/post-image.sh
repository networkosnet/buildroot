#!/bin/bash -e
echo 'compressing kernel...'
${HOST_DIR}/usr/bin/lzma_alone e ${BINARIES_DIR}/vmlinux.bin -lc1 -lp2 -pb2 ${BINARIES_DIR}/vmlinux.bin.lzma
${HOST_DIR}/usr/bin/mkimage -A mips -O linux -T kernel -n "MIPS NetworkOS" -a 0x80060000 -e 0x80060000 -C lzma -d ${BINARIES_DIR}/vmlinux.bin.lzma ${BINARIES_DIR}/uImage

./board/domino/concat_image.py ${BINARIES_DIR}/domino.img <<EOF
cat ${BINARIES_DIR}/uImage
seek 1280k
cat ${BINARIES_DIR}/rootfs.squashfs
pad 256k
writehex deadc0de
check 15936k
EOF

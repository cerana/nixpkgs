#!/usr/bin/env bash

# use binaries from Nix, not from host system
PACKAGES="grub bash multipath-tools coreutils utillinux cdrkit"
[[ -z $IN_THE_SHELL ]] && IN_THE_SHELL=1 exec $(which nix-shell) --run $0 -p ${PACKAGES}

# obtain grub stage 2
GRUB=$(which grub)
GRUB=${GRUB/bin*grub/}
cp ${GRUB}lib/grub/i386-pc/stage2_eltorito result-stage2
chmod +w result-stage2

genisoimage -R -f -b boot/grub/stage2_eltorito \
    -graft-points \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -o result-iso \
    boot/grub/stage2_eltorito=result-stage2 \
    boot/grub/menu.lst=result/menu.lst \
    bzImage=result/bzImage \
    initrd=result/initrd

rm result-stage2

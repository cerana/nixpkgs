#!/usr/bin/env bash

# use binaries from Nix, not from host system
PACKAGES="grub bash multipath-tools coreutils utillinux cdrkit ipxe"
[[ -z $IN_THE_SHELL ]] && IN_THE_SHELL=1 exec $(which nix-shell) --run $0 -p ${PACKAGES} -I nixpkgs=./

# obtain grub stage 2
GRUB=$(echo $nativeBuildInputs | sed 's| |\n|g' | grep grub)
IPXE=$(echo $nativeBuildInputs | sed 's| |\n|g' | grep ipxe)
cp ${GRUB}/lib/grub/i386-pc/stage2_eltorito result-stage2
chmod +w result-stage2

genisoimage -R -f -b boot/grub/stage2_eltorito \
    -graft-points \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -V CERANA \
    -o result-iso \
    boot/grub/stage2_eltorito=result-stage2 \
    boot/grub/menu.lst=result/menu.lst \
    bzImage=result/bzImage \
    initrd=result/initrd \
    ipxe.lkrn=${IPXE}/ipxe.lkrn

rm result-stage2

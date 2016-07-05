{ stdenv, cerana, utillinux, coreutils, systemd, gnugrep, gawk, zfs, bash, gptfdisk, grub2, lshw }:

stdenv.mkDerivation {
  name = "cerana-scripts-${cerana.rev}";

  src = cerana.src;

  installPhase = ''
    make DESTDIR=$out -C $src/boot install
    substituteInPlace $out/bin/fixterm --replace "stty" "${coreutils}/bin/stty"
    substituteInPlace $out/scripts/gen-hostid.sh --replace "tr" "${coreutils}/bin/tr"
    substituteInPlace $out/scripts/gen-hostid.sh --replace "uuidgen" "${utillinux}/bin/uuidgen"
    substituteInPlace $out/scripts/init-zpools.sh --replace "awk" "${gawk}/bin/gawk"
    substituteInPlace $out/scripts/init-zpools.sh --replace "/bin/bash" "${bash}/bin/bash"
    substituteInPlace $out/scripts/init-zpools.sh --replace "fdisk" "${utillinux}/bin/fdisk"
    substituteInPlace $out/scripts/init-zpools.sh --replace "grep" "${gnugrep}/bin/grep"
    substituteInPlace $out/scripts/init-zpools.sh --replace "grub-install" "${grub2}/bin/grub-install"
    substituteInPlace $out/scripts/init-zpools.sh --replace "lsblk" "${utillinux}/bin/lsblk"
    substituteInPlace $out/scripts/init-zpools.sh --replace "sgdisk" "${gptfdisk}/sbin/sgdisk"
    substituteInPlace $out/scripts/init-zpools.sh --replace "systemctl" "${systemd}/bin/systemctl"
    substituteInPlace $out/scripts/init-zpools.sh --replace "udevadm" "${systemd}/bin/udevadm"
    substituteInPlace $out/scripts/init-zpools.sh --replace "ZFS_CMD=zfs" "ZFS_CMD=${zfs}/bin/zfs"
    substituteInPlace $out/scripts/init-zpools.sh --replace "ZPOOL_CMD=zpool" "ZPOOL_CMD=${zfs}/bin/zpool"
    substituteInPlace $out/scripts/net-init.sh --replace "awk" "${gawk}/bin/gawk"
    substituteInPlace $out/scripts/net-init.sh --replace "grep" "${gnugrep}/bin/grep"
    substituteInPlace $out/scripts/net-init.sh --replace "lshw" "${lshw}/bin/lshw"
  '';

  meta = with stdenv.lib; {
    homepage    = http://cerana.org;
    description = "Cerana OS";
    license     = licenses.mit ;
    platforms   = platforms.linux;
  };
}

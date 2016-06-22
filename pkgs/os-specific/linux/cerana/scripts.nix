{ stdenv, cerana, utillinux, coreutils, systemd, gnugrep, gawk, zfs, bash, gptfdisk }:

stdenv.mkDerivation {
  name = "cerana-scripts-${cerana.rev}";

  src = cerana.src;

  installPhase = ''
    make DESTDIR=$out -C $src/boot install
    substituteInPlace $out/scripts/gen-hostid.sh --replace "uuidgen" "${utillinux}/bin/uuidgen"
    substituteInPlace $out/scripts/gen-hostid.sh --replace "tr" "${coreutils}/bin/tr"
    substituteInPlace $out/scripts/init-zpools.sh --replace "udevadm" "${systemd}/bin/udevadm"
    substituteInPlace $out/scripts/init-zpools.sh --replace "systemctl" "${systemd}/bin/systemctl"
    substituteInPlace $out/scripts/init-zpools.sh --replace "grep" "${gnugrep}/bin/grep"
    substituteInPlace $out/scripts/init-zpools.sh --replace "awk" "${gawk}/bin/gawk"
    substituteInPlace $out/scripts/init-zpools.sh --replace "zfs" "${zfs}/bin/zfs"
    substituteInPlace $out/scripts/init-zpools.sh --replace "zpool" "${zfs}/bin/zpool"
    substituteInPlace $out/scripts/init-zpools.sh --replace "/bin/bash" "${bash}/bin/bash"
    substituteInPlace $out/scripts/init-zpools.sh --replace "lsblk" "${utillinux}/bin/lsblk"
    substituteInPlace $out/scripts/init-zpools.sh --replace "sgdisk" "${gptfdisk}/sbin/sgdisk"
    substituteInPlace $out/scripts/net-init.sh --replace "grep" "${gnugrep}/bin/grep"
    substituteInPlace $out/scripts/net-init.sh --replace "awk" "${gawk}/bin/gawk"
  '';

  meta = with stdenv.lib; {
    homepage    = http://cerana.org;
    description = "Cerana OS";
    license     = licenses.mit ;
    platforms   = platforms.linux;
  };
}

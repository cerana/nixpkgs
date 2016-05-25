{ stdenv, cerana, utillinux, coreutils }:

stdenv.mkDerivation {
  name = "cerana-scripts-${cerana.rev}";

  src = cerana.src;

  buildPhase = ''
    substituteInPlace $src/boot/scripts/gen-hostid.sh --replace "uuidgen" "${utillinux}/bin/uuidgen"
    substituteInPlace $src/boot/scripts/gen-hostid.sh --replace "tr" "${coreutils}/bin/tr"
  '';

  installPhase = ''
    make DESTDIR=$out -C $src/boot install
  '';

  meta = with stdenv.lib; {
    homepage    = http://cerana.org;
    description = "Cerana OS";
    license     = licenses.mit ;
    platforms   = platforms.linux;
  };
}

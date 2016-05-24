{ stdenv, go16Packages }:

stdenv.mkDerivation {
  name = "cerana-scripts-${go16Packages.cerana.rev}";

  src = go16Packages.cerana.src;

  buildPhase = ''
    true
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

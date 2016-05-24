{ stdenv, cerana }:

stdenv.mkDerivation {
  name = "cerana-scripts-${cerana.rev}";

  src = cerana.src;

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

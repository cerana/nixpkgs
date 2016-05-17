{ stdenv, lib, buildGoPackage, git, glide, fetchFromGitHub }:

buildGoPackage rec {
  name = "cerana-${version}";
  version = "2016-05-17";
  rev = "cb302f42882ad839ddc00a97fc1f07c0c8ac3047";

  goPackagePath = "github.com/cerana/cerana";

  src = fetchFromGitHub {
    owner = "cerana";
    repo = "cerana";
    inherit rev;
    sha256 = "19vl7jclyd44673jlg0g6jjxxzvk4krkh6dgr87l7a8rblgynr82";
  };

  preConfigure = ''
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    glide install
  '';

  buildInputs = [ git glide ];
}

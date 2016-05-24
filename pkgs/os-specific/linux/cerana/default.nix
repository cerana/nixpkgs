{ stdenv, lib, buildGoPackage, git, glide, fetchFromGitHub }:

buildGoPackage rec {
  name = "cerana-${version}";
     version = "2016-05-17";
     owner = "cerana";
     repo = "cerana";
     rev = "630dd7a3a248d4564aae1b1262562b301ad515bc";

  goPackagePath = "github.com/cerana/cerana";

  src = fetchFromGitHub {
    owner = "cerana";
    repo = "cerana";
    inherit rev;
    sha256 = "0ahiib9man9sfwbnarmvmvwv5h80yl98lwmbhh7a7qrcrhm3dr4x";
  };

  preConfigure = ''
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    glide install
  '';
  postBuild = "rm $NIX_BUILD_TOP/go/bin/zfs";

  buildInputs = [ git glide ];
}

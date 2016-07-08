{ stdenv, lib, buildGoPackage, git, glide, fetchFromGitHub }:

buildGoPackage rec {
  name = "cerana-${version}";
     version = "2016-07-08";
     owner = "cerana";
     repo = "cerana";
     rev = "master";

  goPackagePath = "github.com/cerana/cerana";

  src = fetchFromGitHub {
    owner = "cerana";
    repo = "cerana";
    inherit rev;
    sha256 = "0b8yq0klphw928z5zlq0byzn4b827mspaxkihx1b4sxwkn4qh7zc";
  };

  preConfigure = ''
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    glide install
  '';
  postBuild = "rm $NIX_BUILD_TOP/go/bin/zfs";

  buildInputs = [ git glide ];
}

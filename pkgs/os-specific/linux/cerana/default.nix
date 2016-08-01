{ stdenv, lib, buildGoPackage, git, glide, libseccomp, pkgconfig, fetchFromGitHub }:

buildGoPackage rec {
  name = "cerana-${version}";
     version = "2016-07-29";
     owner = "cerana";
     repo = "cerana";
     rev = "fa65ce3c1f7f57ced7839551cbe696425536f8cf";

  goPackagePath = "github.com/cerana/cerana";

  src = fetchFromGitHub {
    owner = "cerana";
    repo = "cerana";
    inherit rev;
    sha256 = "0iaw7m92cymwsb5n8fl6jvg537ddipgmmzchyg14w4zrrgwc05g9";
  };

  preConfigure = ''
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    glide install
  '';
  postBuild = "rm $NIX_BUILD_TOP/go/bin/zfs";

  buildInputs = [ git glide libseccomp pkgconfig ];
}

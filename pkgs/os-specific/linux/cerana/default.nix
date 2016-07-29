{ stdenv, lib, buildGoPackage, git, glide, libseccomp, pkgconfig, fetchFromGitHub }:

buildGoPackage rec {
  name = "cerana-${version}";
     version = "2016-07-29";
     owner = "cerana";
     repo = "cerana";
     rev = "972ab2067bca1f2908b0038e1b7613196b618116";

  goPackagePath = "github.com/cerana/cerana";

  src = fetchFromGitHub {
    owner = "cerana";
    repo = "cerana";
    inherit rev;
    sha256 = "1yand9p96rv042qgzx0j1xrqlcyv56g9v05wrndm4qbxjxm6xr68";
  };

  preConfigure = ''
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    glide install
  '';
  postBuild = "rm $NIX_BUILD_TOP/go/bin/zfs";

  buildInputs = [ git glide libseccomp pkgconfig ];
}

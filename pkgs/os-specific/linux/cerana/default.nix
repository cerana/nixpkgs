{ stdenv, lib, buildGoPackage, git, glide, libseccomp, pkgconfig, fetchFromGitHub }:

buildGoPackage rec {
  name = "cerana-${version}";
     version = "2016-08-24";
     owner = "cerana";
     repo = "cerana";
     rev = "b5856c841f3fa05c9cf64ff1d4137a07d2324548";

  goPackagePath = "github.com/cerana/cerana";

  src = fetchFromGitHub {
    owner = "cerana";
    repo = "cerana";
    inherit rev;
    sha256 = "1nzz6hgvrk3dli1fllpnp7aqzqi1y0q55vk0jmi8cmlyqyblimfx";
  };

  preConfigure = ''
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    glide install
  '';
  postBuild = "rm $NIX_BUILD_TOP/go/bin/zfs";

  buildInputs = [ git glide libseccomp pkgconfig ];
}

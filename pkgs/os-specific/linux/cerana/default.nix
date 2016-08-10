{ stdenv, lib, buildGoPackage, git, glide, libseccomp, pkgconfig, fetchFromGitHub }:

buildGoPackage rec {
  name = "cerana-${version}";
     version = "2016-08-10";
     owner = "cerana";
     repo = "cerana";
     rev = "d4ce56ca6b6667f825670f38d9e21dec84b45144";

  goPackagePath = "github.com/cerana/cerana";

  src = fetchFromGitHub {
    owner = "cerana";
    repo = "cerana";
    inherit rev;
    sha256 = "1l8s0yb1dffynz3wyq68ixk6fz3xdi0hgxg6k0nxip293774nfn3";
  };

  preConfigure = ''
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    glide install
  '';
  postBuild = "rm $NIX_BUILD_TOP/go/bin/zfs";

  buildInputs = [ git glide libseccomp pkgconfig ];
}

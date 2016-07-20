{ stdenv, lib, buildGoPackage, git, glide, libseccomp, pkgconfig, fetchFromGitHub }:

buildGoPackage rec {
  name = "cerana-${version}";
     version = "2016-07-20";
     owner = "cerana";
     repo = "cerana";
     rev = "2da7a31d71bef9445d16400c430e9a0a68fba575";

  goPackagePath = "github.com/cerana/cerana";

  src = fetchFromGitHub {
    owner = "cerana";
    repo = "cerana";
    inherit rev;
    sha256 = "0gg58nyqbi498001f5c1asb5018djpxh5qrwlfzgqh18dkcb8skx";
  };

  preConfigure = ''
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    glide install
  '';
  postBuild = "rm $NIX_BUILD_TOP/go/bin/zfs";

  buildInputs = [ git glide libseccomp pkgconfig ];
}

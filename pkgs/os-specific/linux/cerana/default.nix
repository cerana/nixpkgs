{ stdenv, lib, buildGoPackage, git, glide, fetchFromGitHub }:

buildGoPackage rec {
  name = "cerana-${version}";
     version = "2016-07-07";
     owner = "cerana";
     repo = "cerana";
     rev = "187_boot_time_config";

  goPackagePath = "github.com/cerana/cerana";

  src = fetchFromGitHub {
    owner = "cerana";
    repo = "cerana";
    inherit rev;
    sha256 = "1qgm3ckmnva08d3x7zvwhgmir2qncs329nslr61gvgfl41r7qfj6";
  };

  preConfigure = ''
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    glide install
  '';
  postBuild = "rm $NIX_BUILD_TOP/go/bin/zfs";

  buildInputs = [ git glide ];
}

{ stdenv, lib, buildGoPackage, git, glide, fetchFromGitHub }:

buildGoPackage rec {
  name = "cerana-${version}";
     version = "2016-07-01";
     owner = "cerana";
     repo = "cerana";
     rev = "187_boot_time_config";

  goPackagePath = "github.com/cerana/cerana";

  src = fetchFromGitHub {
    owner = "cerana";
    repo = "cerana";
    inherit rev;
    sha256 = "1rbhrwk9x8rpr8il8znrx9jnmpqd6wbhgdy5mq0b1wl447wpf6rl";
  };

  preConfigure = ''
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    glide install
  '';
  postBuild = "rm $NIX_BUILD_TOP/go/bin/zfs";

  buildInputs = [ git glide ];
}

# This module creates netboot media containing the given NixOS
# configuration.

{ config, lib, pkgs, ... }:

with lib;

{

  config = {

    boot.loader.grub.version = 2;

    # Don't build the GRUB menu builder script, since we don't need it
    # here and it causes a cyclic dependency.
    boot.loader.grub.enable = false;

    # !!! Hack - attributes expected by other modules.
    system.boot.loader.kernelFile = "bzImage";
    environment.systemPackages = [ pkgs.grub2 pkgs.libselinux pkgs.qemu_kvm pkgs.strace pkgs.gdb pkgs.lshw pkgs.consul pkgs.cerana pkgs.cerana-scripts pkgs.dhcpcd ];

    fileSystems."/" =
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
      };

    # Create the initrd
    system.build.netbootRamdisk = pkgs.makeInitrd {
      inherit (config.boot.initrd) compressor;

      contents =
        [ { object = config.system.build.toplevel + "/init";
            symlink = "/init";
          }
        ];
    };

    # Create the docker image
    system.build.netbootDockerImage = pkgs.dockerTools.buildImage {
      name = "netboot";
      contents = config.system.build.toplevel;
    };

    system.build.netbootIpxeScript = pkgs.writeTextDir "netboot.ipxe" "#!ipxe\nkernel bzImage ${toString config.boot.kernelParams}\ninitrd initrd\nboot";

    boot.loader.timeout = 10;

    boot.postBootCommands =
      ''
        ${pkgs.nettools}/bin/hostname cerana
        ${pkgs.findutils}/bin/find ${pkgs.cerana-scripts}/scripts -ls
      '';

  };

}

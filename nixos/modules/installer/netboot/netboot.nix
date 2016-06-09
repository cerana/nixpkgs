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
    environment.systemPackages = [ pkgs.grub2 pkgs.libselinux pkgs.qemu_kvm pkgs.strace pkgs.gdb pkgs.lshw pkgs.consul.bin pkgs.cerana.bin pkgs.cerana-scripts pkgs.dhcpcd pkgs.gptfdisk ];

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

    system.build.netbootIpxeScript = pkgs.writeTextDir "netboot.ipxe" "#!ipxe\nkernel bzImage console=ttyS0 vga=794 cerana.mgmt_mac=\${mac} ${toString config.boot.kernelParams}\ninitrd initrd\nboot";

    system.build.ceranaGrubConfig = pkgs.writeTextDir "menu.lst"
''
default 0
timeout 10
min_mem64 1024

title CeranaOS Rescue Mode
   kernel /bzImage ${toString config.boot.kernelParams} cerana.rescue
   module /initrd

title CeranaOS Cluster Bootstrap
   kernel /bzImage ${toString config.boot.kernelParams} cerana.cluster_bootstrap
   module /initrd
'';

    boot.loader.timeout = 10;

    boot.postBootCommands =
      ''
        ${pkgs.coreutils}/bin/rm /etc/hostid
        ${pkgs.coreutils}/bin/mkdir -p /task-socket/node-coordinator/
        ${pkgs.cerana-scripts}/scripts/parse-cmdline.sh
        ${pkgs.cerana-scripts}/scripts/gen-hostid.sh
      '';

  };

}

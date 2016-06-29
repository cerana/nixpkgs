# This module creates netboot media containing the given NixOS
# configuration.

{ config, lib, pkgs, ... }:

with lib;

{

  config = {

    boot.initrd.compressor = "${pkgs.pigz}/bin/pigz -R -b 1024 ";
    boot.loader.grub.version = 2;

    # Don't build the GRUB menu builder script, since we don't need it
    # here and it causes a cyclic dependency.
    boot.loader.grub.enable = false;

    # !!! Hack - attributes expected by other modules.
    system.boot.loader.kernelFile = "bzImage";
    environment.systemPackages = [ pkgs.grub2 pkgs.libselinux pkgs.qemu_kvm pkgs.strace pkgs.gdb pkgs.lshw pkgs.consul.bin pkgs.cerana.bin pkgs.cerana-scripts pkgs.dhcpcd pkgs.gptfdisk pkgs.glide pkgs.go_1_6 pkgs.git pkgs.vim ];

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
serial
terminal serial

title CeranaOS Standalone Automatic ZFS
   kernel /bzImage ${toString config.boot.kernelParams} cerana.zfs_config=auto console=ttyS0
   module /initrd

title CeranaOS Standalone Pool Prompt
   kernel /bzImage ${toString config.boot.kernelParams} console=ttyS0
   module /initrd

title CeranaOS Rescue Mode
   kernel /bzImage ${toString config.boot.kernelParams} cerana.rescue console=ttyS0
   module /initrd

title CeranaOS Cluster Bootstrap (Automatic ZFS, 192.168.10.10/24)
   kernel /bzImage ${toString config.boot.kernelParams} cerana.cluster_bootstrap cerana.zfs_config=auto cerana.mgmt_ip=192.168.10.10/24 console=ttyS0
   module /initrd

title CeranaOS Cluster Join1 (Automatic ZFS, 192.168.10.11/24)
   kernel /bzImage ${toString config.boot.kernelParams} cerana.cluster_ips=192.168.10.10 cerana.zfs_config=auto cerana.mgmt_ip=192.168.10.11/24 console=ttyS0
   module /initrd

title CeranaOS Cluster Join2 (Automatic ZFS, 192.168.10.12/24)
   kernel /bzImage ${toString config.boot.kernelParams} cerana.cluster_ips=192.168.10.10 cerana.zfs_config=auto cerana.mgmt_ip=192.168.10.12/24 console=ttyS0
   module /initrd

title Boot from first HDD
   rootnoverify (hd0)
   chainloader +1
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

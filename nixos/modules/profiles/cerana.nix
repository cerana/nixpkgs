# This module defines the software packages included in the "minimal"
# cerana image
{ config, lib, pkgs, ... }:

{
  # Include support for ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportAll = false;

  # Configure host id for ZFS to work
  networking.hostId = lib.mkDefault "8425e349";

  boot.kernelParams = [ "console=ttyS0" "cerana.mgmt_mac=\${mac}" "cerana.mgmt_ip=\${ip}" "cerana.zfs_config=auto" ];

  security.apparmor.enable = false;

  # Commented out for development puroposes
  #networking.useDHCP = false;

  services.ceranapool.enable = true;

  # For development puroposes only
  services.sshd.enable = true;
}

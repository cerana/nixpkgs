# This module defines the software packages included in the "minimal"
# cerana image
{ config, lib, pkgs, ... }:

{
  # Include support for ZFS
  boot.supportedFilesystems = [ "zfs" ];

  # Configure host id for ZFS to work
  networking.hostId = lib.mkDefault "8425e349";

  networking.useDHCP = false;

  boot.kernelParams = [ "console=ttyS0" ];

  security.apparmor.enable = false;
}

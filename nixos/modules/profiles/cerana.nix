# This module defines the software packages included in the "minimal"
# cerana image
{ config, lib, pkgs, ... }:

{
  # Include support for ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportAll = false;

  # Configure host id for ZFS to work
  networking.hostId = lib.mkDefault "8425e349";

  security.apparmor.enable = false;

  services.ceranapool.enable = true;
  services.cerananet.enable = true;
  services.ceranaClusterConfProvider.enable = true;
  services.ceranaHealthProvider.enable = true;
  services.ceranaKvProvider.enable = true;
  services.ceranaMetricsProvider.enable = true;
  services.ceranaNodeCoordinator.enable = true;
  services.ceranaL2Coordinator.enable = true;
  services.ceranaStatsPusher.enable = true;
  services.ceranaSystemdProvider.enable = true;
  services.ceranaZfsProvider.enable = true;
  services.ceranaConsul.enable = true;

  systemd.network.enable = true;
  networking.useDHCP = false;

  # For development puroposes only
  services.sshd.enable = true;
}

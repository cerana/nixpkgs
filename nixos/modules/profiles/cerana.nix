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

  services.ceranaClusterConfProvider.enable = true;
  services.ceranaConsul.enable = true;
  services.ceranaDhcpProvider.enable = true;
  services.ceranaHealthProvider.enable = true;
  services.ceranaKvProvider.enable = true;
  services.ceranaL2Coordinator.enable = true;
  services.ceranaMetricsProvider.enable = true;
  services.ceranaNamespaceProvider.enable = true;
  services.cerananet.enable = true;
  services.ceranaNodeCoordinator.enable = true;
  services.ceranaPlatformImport.enable = true;
  services.ceranapool.enable = true;
  services.ceranaMoveLogs.enable = true;
  services.ceranaStatsPusher.enable = true;
  services.ceranaSystemdProvider.enable = true;
  services.ceranaZfsProvider.enable = true;
  targets.cerana.enable = true;
  targets.ceranaLayer2.enable = true;

  nix.nrBuildUsers = 0;
  systemd.network.enable = true;
  networking.useDHCP = false;

  # don't use NixOS firewall
  networking.firewall.enable = false;

  # For development puroposes only
  services.sshd.enable = true;
}

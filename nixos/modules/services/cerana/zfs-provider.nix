{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaZfsProvider;
in
{
  options.services.ceranaZfsProvider.enable = mkEnableOption "ceranaZfsProvider";

  config = mkIf cfg.enable {
    systemd.services.ceranaZfsProvider = {
      description = "Cerana ZFS Provider";
      wantedBy = [ "multi-user.target" ];
      wants = [ "ceranaNodeCoordinator.service" ];
      after = [ "ceranaNodeCoordinator.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.cerana.bin}/bin/zfs-provider -n zfs-provider \
          -s /task-socket/node-coordinator/ \
          -u unix:///task-socket/node-coordinator/coordinator/coordinator.sock
          '';
      };
    };
  };
}

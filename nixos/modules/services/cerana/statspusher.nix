{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaStatsPusher;
in
{
  options.services.ceranaStatsPusher.enable = mkEnableOption "ceranaStatsPusher";

  config = mkIf cfg.enable {
    systemd.services.ceranaStatsPusher = {
      description = "Cerana Statistics Pusher";
      wantedBy = [ "multi-user.target" ];
      wants = [ "ceranaClusterConfProvider.service"
                "ceranaMetricsProvider.service"
                "ceranaSystemdProvider.service"
                "ceranaZfsProvider.service" ];
      after = [ "ceranaNodeCoordinator.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.cerana.bin}/bin/statspusher -n statspusher \
          -s /task-socket/node-coordinator/ \
          -u unix:///task-socket/node-coordinator/coordinator/coordinator.sock
          '';
      };
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaHealthProvider;
in
{
  options.services.ceranaHealthProvider.enable = mkEnableOption "ceranaHealthProvider";

  config = mkIf cfg.enable {
    systemd.services.ceranaHealthProvider = {
      description = "Cerana Health Provider";
      wantedBy = [ "multi-user.target" ];
      wants = [ "ceranaSystemdProvider.service" ];
      after = [ "ceranaNodeCoordinator.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
                ${pkgs.cerana.bin}/bin/health-provider -n health-provider \
                -s /task-socket/node-coordinator/ \
                -u unix:///task-socket/node-coordinator/coordinator/coordinator.sock
                '';
      };
    };
  };
}

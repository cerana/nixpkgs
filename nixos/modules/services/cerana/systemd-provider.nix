{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaSystemdProvider;
in
{
  options.services.ceranaSystemdProvider.enable = mkEnableOption "ceranaSystemdProvider";

  config = mkIf cfg.enable {
    systemd.services.ceranaSystemdProvider = {
      description = "Cerana Systemd Provider";
      wantedBy = [ "multi-user.target" ];
      wants = [ "ceranaNodeCoordinator.service" ];
      after = [ "ceranaNodeCoordinator.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
           ${pkgs.cerana.bin}/bin/systemd-provider -n systemd-provider \
           -s /task-socket/node-coordinator/ \
           -u unix:///task-socket/node-coordinator//coordinator/coordinator.sock \
           -d /data/services
           '';
      };
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaMetricsProvider;
in
{
  options.services.ceranaMetricsProvider.enable = mkEnableOption "ceranaMetricsProvider";

  config = mkIf cfg.enable {
    systemd.services.ceranaMetricsProvider = {
      description = "Cerana Metrics Provider";
      wantedBy = [ "multi-user.target" ];
      after = [ "ceranaNodeCoordinator.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.cerana.bin}/bin/metrics-provider -n metrics-provider -s /task-socket/node-coordinator/ -u unix:///task-socket/node-coordinator/coordinator/coordinator.sock";
      };
    };
  };
}

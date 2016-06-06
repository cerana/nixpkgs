{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaMetricsProvider;
in
{
  options.services.ceranaMetricsProvider.enable = mkEnableOption "ceranaMetricsProvider";

  config = mkIf cfg.enable {
    systemd.services.ceranaMetricsProvider = {
      description = "ceranaMetricsProvider";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.cerana}/bin/metrics-provider -n metrics-provider -s /tmp/cerana -u unix://tmp/cerana/coordinator/coordinator.sock";
      };
    };
  };
}

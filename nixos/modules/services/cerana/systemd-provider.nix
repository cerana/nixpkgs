{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaSystemdProvider;
in
{
  options.services.ceranaSystemdProvider.enable = mkEnableOption "ceranaSystemdProvider";

  config = mkIf cfg.enable {
    systemd.services.ceranaSystemdProvider = {
      description = "ceranaSystemdProvider";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
           ${pkgs.cerana}/bin/systemd-provider -n systemd-provider -s /tmp/cerana \
           -u unix://tmp/cerana/coordinator/coordinator.sock -d /data/services
           '';
      };
    };
  };
}

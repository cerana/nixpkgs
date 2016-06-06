{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaZfsProvider;
in
{
  options.services.ceranaZfsProvider.enable = mkEnableOption "ceranaZfsProvider";

  config = mkIf cfg.enable {
    systemd.services.ceranaZfsProvider = {
      description = "ceranaZfsProvider";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.cerana}/bin/zfs-provider -n zfs-provider -s /tmp/cerana -u unix://tmp/cerana/coordinator/coordinator.sock";
      };
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaConsul;
in
{
  options.services.ceranaConsul.enable = mkEnableOption "ceranaConsul";

  config = mkIf cfg.enable {
    systemd.services.ceranaConsul = {
      description = "Cerana Consul";
      wantedBy = [ "multi-user.target" ];
      wants = [ "consul.service" ];
      after = [ "ceranaNodeCoordinator.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /data/datasets/consul";
        ExecStart = ''
                ${pkgs.consul.bin}/bin/consul agent -server -data-dir /data/datasets/consul
                '';
      };
    };
  };
}

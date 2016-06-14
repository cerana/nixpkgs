{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaKvProvider;
in
{
  options.services.ceranaKvProvider.enable = mkEnableOption "ceranaKvProvider";

  config = mkIf cfg.enable {
    systemd.services.ceranaKvProvider = {
      description = "Cerana Kv Provider";
      wantedBy = [ "multi-user.target" ];
      wants = [ "consul.service" ];
      after = [ "ceranaNodeCoordinator.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
                ${pkgs.cerana.bin}/bin/kv-provider -n kv-provider \
                -s /task-socket/node-coordinator/ \
                -u unix:///task-socket/node-coordinator/coordinator/coordinator.sock
                '';
      };
    };
  };
}

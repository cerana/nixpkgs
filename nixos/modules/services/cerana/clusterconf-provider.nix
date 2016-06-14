{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaClusterConfProvider;
in
{
  options.services.ceranaClusterConfProvider.enable = mkEnableOption "ceranaClusterConfProvider";

  config = mkIf cfg.enable {
    systemd.services.ceranaClusterConfProvider = {
      description = "Cerana Cluster Configuration Provider";
      wantedBy = [ "multi-user.target" ];
      wants = [ "ceranaKvProvider.service" ];
      after = [ "ceranaNodeCoordinator.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
                ${pkgs.cerana.bin}/bin/clusterconfig-provider \
                -n clusterconfig-provider -s /task-socket/node-coordinator/ \
                -u unix:///task-socket/node-coordinator/coordinator/coordinator.sock
                '';
      };
    };
  };
}

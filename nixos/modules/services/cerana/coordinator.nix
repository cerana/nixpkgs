{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaNodeCoordinator;
in
{
  options.services.ceranaNodeCoordinator.enable = mkEnableOption "ceranaNodeCoordinator";

  config = mkIf cfg.enable {
    systemd.services.ceranaNodeCoordinator = {
      description = "Cerana Node Coordinator";
      wantedBy = [ "multi-user.target" ];
      after = [ "cerananet.service" ];
      serviceConfig = {
        Type = "simple";
        PreExec = "${pkgs.coreutils}/bin/mkdir -p /task-socket/node-coordinator/";
        ExecStart = "${pkgs.cerana.bin}/bin/coordinator -n node-coord -t 10 -s /task-socket/node-coordinator/";
      };
    };
  };
}

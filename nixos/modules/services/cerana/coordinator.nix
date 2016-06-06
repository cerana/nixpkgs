{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaCoordinator;
in
{
  options.services.ceranaCoordinator.enable = mkEnableOption "ceranaCoordinator";

  config = mkIf cfg.enable {
    systemd.services.ceranaCoordinator = {
      description = "ceranaCoordinator";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.cerana}/bin/coordinator -n node-coord -t 10 -s /tmp/cerana";
      };
    };
  };
}

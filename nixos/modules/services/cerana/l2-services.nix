{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaStatsPusher;
in
{
  options.targets.ceranaLayer2.enable = mkEnableOption "ceranaLayer2";

  config = mkIf cfg.enable {
    systemd.targets.ceranaLayer2 = {
      description = "Cerana Layer 2";
      requires = [ "ceranaL2Coordinator.service"
                   "ceranaStatsPusher.service"
                   "ceranaClusterConfProvider.service"
                   "ceranaConsul.service"
                   "ceranaKvProvider.service"
                   ];
    };
  };
}

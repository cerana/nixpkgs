{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranapool;
in
{
  options.services.ceranapool.enable = mkEnableOption "CeranaPool";
  
  config = mkIf cfg.enable {
    systemd.services.ceranapool = {
      description = "CeranaPool";
      path = [ pkgs.cerana-scripts ];
      wantedBy = [ "network-pre.target" "multi-user.target" "swap.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.cerana-scripts}/scripts/init-zpools.sh";
        TimeoutStartSec = "5min";
        StandardInput = "tty";
        TTYPath = "/dev/console";
        TTYReset = "yes";
        TTYVHangup = "yes";
        RemainAfterExit = true;
      };
    };
  environment.systemPackages = [ pkgs.cerana-scripts ];
  };
}

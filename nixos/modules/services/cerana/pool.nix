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
      requiredBy = [ "network-pre.target" "multi-user.target" "sysinit.target" "local-fs-pre.target" "zfs-import.target" "systemd-journald.service" "basic.target" "ntpd.service" "sshd.service" "time-sync.service" "getty.target" "ip-up.target" ];
      before = [ "sshd.service" "ntpd.service" "local-fs.target" ];
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

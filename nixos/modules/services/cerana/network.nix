{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cerananet;
in
{
  options.services.cerananet.enable = mkEnableOption "Cerana Network Configuration";

  config = mkIf cfg.enable {
    systemd.services.cerananet = {
      description = "Cerana Network Configuration";
      path = [ pkgs.cerana-scripts ];
      requires = [ "ceranapool.service" ];
      requiredBy = [ "systemd-networkd.service" ];
      before = [ "systemd-networkd.service" "sshd.service" "ntpd.service" ];
      after = [ "ceranapool.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.cerana-scripts}/scripts/net-init.sh";
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

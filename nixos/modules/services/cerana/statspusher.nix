{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaStatsPusher;
  cfgdir = "/data/config/";
  cfgfile = "statspusher.json";
  socketdir = "unix:///task-socket/node-coordinator/coordinator/";
  socket = "node-coord.sock";
  utility = "${pkgs.cerana.bin}/bin/statspusher";
in
{
  options.services.ceranaStatsPusher.enable = mkEnableOption "ceranaStatsPusher";

  config = mkIf cfg.enable {
    systemd.services.ceranaStatsPusher = {
      description = "Cerana Statistics Pusher";
      wantedBy = [ "multi-user.target" ];
      wants = [ "ceranaClusterConfProvider.service"
                "ceranaMetricsProvider.service"
                "ceranaSystemdProvider.service"
                "ceranaZfsProvider.service" ];
      after = [ "ceranaNodeCoordinator.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${utility} -c ${cfgdir}${cfgfile}";
      };
      preStart = ''
        if [ ! -f ${cfgdir}${cfgfile} ]; then
                echo "{" > ${cfgdir}${cfgfile}
                echo '  "coordinatorURL": "${socketdir}${socket}",' >> ${cfgdir}${cfgfile}
                echo '  "requestTimeout": 10' >> ${cfgdir}${cfgfile}
                echo "}" >> ${cfgdir}${cfgfile}
        fi
        '';
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaMoveLogs;
  srcdir = "/var";
  destdir = "/data/logs";
  logfiledir = "log";
  rotatemask = "3";
in
{
  options.services.ceranaMoveLogs.enable = mkEnableOption "ceranaMoveLogs";

  config = mkIf cfg.enable {
    systemd.services.ceranaMoveLogs = {
      description = "Cerana Log File Mover";
      wantedBy = [ "multi-user.target" ];
      requires = [ "ceranapool.service" ];
      after = [ "ceranapool.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl start systemd-journald.service";
      };
      preStart = ''
        ${pkgs.systemd}/bin/systemctl stop systemd-journald.service
        logdir=${destdir}/${logfiledir}
        bootcountfile=$logdir/boots
        if [ -f $bootcountfile ]; then
                n=`cat $bootcountfile`
                rotatedir=$logdir.$n
                if [ -d $rotatedir ]; then
                        rm -rf $rotatedir
                fi
                mv ${destdir}/${logfiledir} $rotatedir
                n=$(( $n + 1 ))
                n=$(( $n & ${rotatemask} ))
        else
                n=0
        fi
        mkdir -p $logdir
        cp -r ${srcdir}/${logfiledir} ${destdir}
        mv ${srcdir}/${logfiledir} ${srcdir}/${logfiledir}.boot
        ln -s ${destdir}/${logfiledir} ${srcdir}/${logfiledir}
        echo $n >$bootcountfile
        exit 0
        '';
    };
  };
}

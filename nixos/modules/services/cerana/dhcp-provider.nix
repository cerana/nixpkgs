{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ceranaDhcpProvider;
  name = "dhcp-provider";
  cfgdir = "/data/config/";
  cfgfile = "dhcp-provider.json";
  socketdir = "/task-socket/l2-coordinator/";
  socket = "coordinator/l2-coord.sock";
  daemon = "${pkgs.cerana.bin}/bin/dhcp-provider";
  net = "172.16.0.0/16";
  gw = "172.16.255.255";
  dns = "172.16.255.255";
in
{
  options.services.ceranaDhcpProvider.enable = mkEnableOption "ceranaDhcpProvider";

  config = mkIf cfg.enable {
    systemd.services.ceranaDhcpProvider = {
      description = "Cerana DHCP Provider";
      wantedBy = [ "ceranaLayer2.target" ];
      after = [ "ceranaL2Coordinator.service" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${daemon} -c ${cfgdir}${cfgfile}";
      };
      preStart = ''
        if [ ! -f ${cfgdir}${cfgfile} ]; then
                dns=`grep nameserver /etc/resolv.conf | cut -d ' ' -f 2`
                gw=`${pkgs.nettools}/bin/route -n | grep UG | tr -s ' ' | cut -d ' ' -f 2`
                echo "{" > ${cfgdir}${cfgfile}
                echo '  "service_name": "${name}",' >> ${cfgdir}${cfgfile}
                echo '  "socket_dir": "${socketdir}",' >> ${cfgdir}${cfgfile}
                echo '  "network": "${net}",' >> ${cfgdir}${cfgfile}
                echo '  "dns_servers": "${dns}",' >> ${cfgdir}${cfgfile}
                echo '  "gateway": "${gw}",' >> ${cfgdir}${cfgfile}
                echo '  "coordinator_url": "unix://${socketdir}${socket}"' >> ${cfgdir}${cfgfile}
                echo "}" >> ${cfgdir}${cfgfile}
        fi
        '';
    };
  };
}

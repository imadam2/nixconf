{ ... }:
let
  service = "speedtest-tracker";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
      port = 80;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [
          80
        ];
        allowedTCPPorts = [
          80
        ];
      };

      services = {
        ${service} = {
          enable = true;
        };
      };
      services.caddy.virtualHosts = {
        "${service}.${hl.domain}" = {
          useACMEHost = "${hl.domain}";
          extraConfig = ''
            reverse_proxy "localhost:${toString port}"
          '';
        };
      };

      homelab.homepage.cfg.Network = [
        {
          "Speedtest Tracker" = {
            description = "Speedtest Tracker";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}

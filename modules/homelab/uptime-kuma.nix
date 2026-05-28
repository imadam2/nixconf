{ ... }:
let
  service = "uptime-kuma";
  port = 3001;
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [
          port
        ];
        allowedTCPPorts = [
          port
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
            reverse_proxy http://localhost:${toString port}
          '';
        };
      };

      homelab.homepage.cfg.Network = [
        {
          "Uptime Kuma" = {
            description = "Unifi Controller";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}

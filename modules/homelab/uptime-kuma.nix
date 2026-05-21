{ ... }:
let
  service = "uptime-kuma";
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
          3001
        ];
        allowedTCPPorts = [
          3001
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
            reverse_proxy http://localhost:3001
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

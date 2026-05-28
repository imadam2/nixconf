{ ... }:
let
  service = "vaultwarden";
  port = 8000;
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
          dbBackend = "sqlite";
          config = {
            DOMAIN = "https://${service}.${hl.domain}";
          };
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

      homelab.homepage.cfg.Cloud = [
        {
          "Vaultwarden" = {
            description = "Password Manager";
            href = "https://${service}.${hl.domain}";
            icon = "sh-${service}.svg";
          };
        }
      ];
    };
}

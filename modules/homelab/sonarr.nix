{ ... }:
let
  service = "sonarr";
  port = 8989;
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
          user = hl.user;
          group = hl.group;
          dataDir = "${hl.appdataDir}/${service}";
        };
      };
    };
}

{ ... }:
let
  service = "sonarr";
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
          8989
        ];
        allowedTCPPorts = [
          8989
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

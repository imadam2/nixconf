{ ... }:
let
  service = "seerr";
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
          5055
        ];
        allowedTCPPorts = [
          5055
        ];
      };

      services = {
        ${service} = {
          enable = true;
        };
      };
    };
}

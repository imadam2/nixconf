{ ... }:
let
  service = "prowlarr";
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
          9696
        ];
        allowedTCPPorts = [
          9696
        ];
      };

      services = {
        ${service} = {
          enable = true;
        };
      };
    };
}

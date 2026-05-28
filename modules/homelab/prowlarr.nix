{ ... }:
let
  service = "prowlarr";
  port = 9696;
in
{
  flake.nixosModules.${service} =
    { ... }:
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
    };
}

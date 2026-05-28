{ ... }:
let
  service = "seerr";
  port = 5055;
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

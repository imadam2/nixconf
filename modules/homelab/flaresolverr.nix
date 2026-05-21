{ ... }:
let
  service = "flaresolverr";
in
{
  flake.nixosModules.${service} =
    { ... }:
    {
      services = {
        ${service} = {
          enable = true;
          openFirewall = true;
        };
      };
    };
}

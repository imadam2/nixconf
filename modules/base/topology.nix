{ inputs, ... }:
{
  imports = [ inputs.nix-topology.nixosModules.default ];
  flake.nixosModules.topology =
    { ... }:
    {
      topology = {
        enable = true;
      };
    };
}

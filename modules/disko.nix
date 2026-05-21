{ inputs, ... }:
{
  flake.nixosModules.disko =
    { ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];
      # shared disko config if you have any
    };
}

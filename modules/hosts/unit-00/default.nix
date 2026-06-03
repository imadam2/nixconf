{ self, inputs, ... }:
{
  flake.nixosConfigurations.unit-00 = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileDesktop
      profileLaptop
      unit-00Configuration
      unit-00Hardware
      unit-00Disko
      inputs.disko.nixosModules.disko
      homeManager
      {
        home-manager.users.ye.imports = [ self.homeModules.profileDesktop ];
      }
    ];
  };

  flake.nixosModules.unit-00Configuration =
    { ... }:
    {
      networking.hostName = "unit-00";
    };
}

{ self, inputs, ... }:
{
  flake.nixosConfigurations.unit-00 = inputs.nixpkgs.lib.nixosSystem {

    modules = with self.nixosModules; [
      mangowm
      profileDesktop
      profileLaptop
      unit-01Configuration
      unit-01Hardware
      unit-01Disko
      inputs.disko.nixosModules.disko
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          mangowm
          profileDesktop
        ];
      }
    ];
  };

  flake.nixosModules.unit-00Configuration =
    { ... }:
    {
      networking.hostName = "unit-00";
    };
}

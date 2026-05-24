{ self, inputs, ... }:
{
  flake.nixosConfigurations.unit-01 = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileDesktop
      profileLaptop
      unit-01Configuration
      unit-01Hardware
      unit-01Disko
      inputs.disko.nixosModules.disko
      homeManager
      {
        home-manager.users.ye.imports = [ self.homeModules.profileDesktop ];
      }
    ];
  };

  flake.nixosModules.unit-01Configuration =
    { ... }:
    {
      my.wallpaper = ../../../assets/wallpapers/flowers-21.png;
      networking.hostName = "unit-01";
    };
}

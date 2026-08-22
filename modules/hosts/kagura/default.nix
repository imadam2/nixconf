{ self, inputs, ... }:
{
  flake.nixosConfigurations.kagura = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      mangowm
      profileDesktop
      profileLaptop
      kaguraConfiguration
      kaguraHardware
      kaguraDisko
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          mangowm
          profileDesktop
        ];
      }
    ];
  };

  flake.nixosModules.kaguraConfiguration =
    { ... }:
    {
      networking.hostName = "kagura";
    };
}

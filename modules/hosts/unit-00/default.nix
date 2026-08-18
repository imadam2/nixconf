{ self, inputs, ... }:
{
  flake.nixosConfigurations.unit-00 = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      mangowm
      audio
      base
      git
      nfs
      services
      shell
      stylix
      syncthing-client
      profileLaptop
      unit-00Configuration
      unit-00Hardware
      unit-00Disko
      inputs.disko.nixosModules.disko
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          mangowm
          browser
          media
          neovim
          noctalia
          packages
          shell
        ];
      }
    ];
  };

  flake.nixosModules.unit-00Configuration =
    { lib, ... }:
    {
      networking.hostName = "unit-00";
      stylix.fonts.sizes.terminal = lib.mkForce 8;
    };
}

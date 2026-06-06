{ self, inputs, ... }:
{
  flake.nixosConfigurations.seedbox = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [

      shareUser

      profileServer
      nfs
      stylix
      seedboxConfiguration
      seedboxHardware
      seedboxDisko
      homeManager

      inputs.nix-topology.nixosModules.default
      {
        home-manager.users.ye.imports = with self.homeModules; [
          neovim
          shell
        ];
      }
    ];
  };

  flake.nixosModules.seedboxConfiguration =
    { ... }:
    {
      networking.hostName = "seedbox";
      hardware.graphics.enable = true;
    };
}

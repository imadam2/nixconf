{ self, inputs, ... }:
{
  flake.nixosConfigurations.beast = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      audio
      base
      desktop
      git
      nfs
      services
      shell
      stylix
      virtualization
      beastConfiguration
      beastHardware
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          browser
          media
          packages
          desktop
          neovim
          noctalia
          shell
        ];
      }
    ];
  };

  flake.nixosModules.beastConfiguration =
    { config, ... }:
    {
      networking.hostName = "beast";

      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        modesetting.enable = true;
        open = false;
      };
    };
}

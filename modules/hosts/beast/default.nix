{ self, inputs, ... }:
{
  flake.nixosConfigurations.beast = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileDesktop
      virtualization
      beastConfiguration
      beastHardware
      homeManager
      {
        home-manager.users.ye.imports = [ self.homeModules.profileDesktop ];
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

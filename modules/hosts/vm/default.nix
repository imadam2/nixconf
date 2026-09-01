{ self, inputs, ... }:
{
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      hyprland
      profileDesktop
      vmConfiguration
      vmHardware
      vmDisko
      homeManager
      inputs.disko.nixosModules.disko
      {
        home-manager.users.ye.imports = with self.homeModules; [
          profileDesktop
          hyprland
        ];
      }
    ];
  };

  flake.nixosModules.vmConfiguration =
    { ... }:
    {
      networking.hostName = "vm";

      hardware.graphics.enable = true;
      services.qemuGuest.enable = true;
      services.openssh.enable = true;
    };
}

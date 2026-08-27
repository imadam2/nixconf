{
  lib,
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.maho = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileServer
      mahoConfiguration
      mahoHardware
      shareUser
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

  flake.nixosModules.mahoConfiguration =
    { pkgs, ... }:
    {
      topology.self = {
        name = "maho";
        hardware.info = "Raspberry Pi 4";
      };

      networking.hostName = "maho";

      boot.loader.generic-extlinux-compatible.enable = lib.mkForce true;
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.loader.grub.enable = lib.mkForce false;
    };
}

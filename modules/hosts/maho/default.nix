{
  inputs,
  self,
  lib,
  ...
}:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosConfigurations."${hostname}" = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileServer
      self.nixosModules."${hostname}Configuration"
      self.nixosModules."${hostname}Hardware"
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

  flake.nixosModules."${hostname}Configuration" =
    { ... }:
    {
      topology.self = {
        name = "${hostname}";
        hardware.info = "Raspberry Pi 4";
      };

      networking.hostName = "${hostname}";

      boot.loader.generic-extlinux-compatible.enable = lib.mkForce true;
      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.loader.grub.enable = lib.mkForce false;
    };
}

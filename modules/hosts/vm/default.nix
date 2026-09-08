{ self, inputs, ... }:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosConfigurations."${hostname}" = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      self.nixosModules."${hostname}Configuration"
      self.nixosModules."${hostname}Hardware"
      self.nixosModules."${hostname}Disko"

      profileDesktop
      preservation
      {
        home-manager.users.ye.imports = with self.homeModules; [
          profileDesktop
        ];
      }
    ];
  };

  flake.nixosModules."${hostname}Configuration" =
    {
      ...
    }:
    {
      networking = {
        hostName = "${hostname}";
        hostId = "778a0f05";
      };

      hardware.graphics.enable = true;

      services = {
        qemuGuest.enable = true;
        openssh.enable = true;
      };

      boot = {
        initrd.systemd.enable = true;
        supportedFilesystems = [ "zfs" ];
        zfs = {
          forceImportRoot = true;
          devNodes = "/dev";
        };
      };
    };
}

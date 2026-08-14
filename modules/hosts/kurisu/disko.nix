{ self, inputs, ... }:
{
  flake.nixosModules.kurisuDisko = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = self.lib.mkDisko "/dev/sda";
  };
}

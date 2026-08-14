{ self, inputs, ... }:
{
  flake.nixosModules.unit-01Disko = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = self.lib.mkDisko "/dev/sda";
  };
}

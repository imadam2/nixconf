{ self, inputs, ... }:
{
  flake.nixosModules.unit-00Disko = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = self.lib.mkDisko "/dev/sda";
  };
}

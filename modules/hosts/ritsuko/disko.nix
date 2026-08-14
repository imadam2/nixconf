{ self, inputs, ... }:
{
  flake.nixosModules.ritsukoDisko = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = self.lib.mkDisko "/dev/nvme0n1";
  };
}

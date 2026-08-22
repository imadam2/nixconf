{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.kaguraDisko = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = self.lib.mkDisko "/dev/nvme0n1";
  };
}

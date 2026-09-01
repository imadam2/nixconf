{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.vmDisko = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = self.lib.mkDisko "/dev/vda";
  };
}

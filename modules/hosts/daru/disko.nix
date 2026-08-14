{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.daruDisko = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = self.lib.mkDisko "/dev/sda";
  };
}

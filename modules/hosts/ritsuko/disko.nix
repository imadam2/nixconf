{ self, inputs, ... }:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosModules."${hostname}Disko" = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = self.lib.mkDisko "/dev/nvme0n1";
  };
}

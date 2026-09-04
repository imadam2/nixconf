{ self, inputs, ... }:
let
  hostName = baseNameOf ./.;
in
{
  flake.nixosModules."${hostName}Disko" = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = self.lib.mkDisko "/dev/nvme0n1";
  };
}

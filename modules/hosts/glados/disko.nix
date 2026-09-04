{ self, inputs, ... }:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosModules."${hostname}Disko" = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = self.lib.mkDisko "/dev/disk/by-id/nvme-Patriot_M.2_P300_256GB_P300IBBB23122503548";
  };
}

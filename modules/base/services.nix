{ ... }:
{
  flake.nixosModules.services =
    { ... }:
    {
      services = {
        gvfs.enable = true;
        fwupd.enable = true;
        dbus.enable = true;
        fstrim.enable = true;
        mullvad-vpn = {
          enable = true;
          gui.enable = true;
        };
      };
    };
}

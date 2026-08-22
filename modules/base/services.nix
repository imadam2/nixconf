{ ... }:
{
  flake.nixosModules.services =
    { ... }:
    {
      services = {
        dbus.enable = true;
        fstrim.enable = true;
        fwupd.enable = true;
        gvfs.enable = true;
        upower.enable = true;
        mullvad-vpn = {
          enable = true;
          gui.enable = true;
        };
      };
    };
}

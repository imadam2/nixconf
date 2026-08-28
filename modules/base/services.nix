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
        udev.extraRules = ''
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="feed", ATTRS{idProduct}=="6536", MODE="0660", GROUP="users"
        '';
      };
    };
}

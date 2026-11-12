{ ... }:
{
  flake.nixosModules.osu =
    { ... }:
    {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
      services.udev.extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="feed", ATTRS{idProduct}=="6536", MODE="0660", GROUP="users"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="152a", ATTRS{idProduct}=="8750", MODE="0660", GROUP="users"
        KERNEL=="usb*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="152a", ATTRS{idProduct}=="8750", MODE="0660", GROUP="users"
        KERNEL=="hidraw*", ATTRS{idVendor}=="056a", TAG+="uaccess", GROUP="users"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0ac3", TAG+="uaccess, "GROUP="users"
      '';

    };

  flake.homeModules.osu =
    { pkgs, ... }:
    {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/x-osu-skin-archive" = "osu!.desktop";
          "application/x-osu-beatmap-archive" = "osu!.desktop";
        };
      };

      home.packages = with pkgs; [
        osu-lazer-bin
      ];
    };
}

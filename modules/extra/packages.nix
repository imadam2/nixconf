{ ... }:
{
  flake.homeModules.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        grim
        slurp
        satty
        orca-slicer
        pavucontrol
        qbittorrent
        signal-desktop
        wl-clipboard
      ];
    };
}

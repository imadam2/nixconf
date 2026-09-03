{ ... }:
{
  flake.homeModules.packages =
    { pkgs, ... }:
    {
      xdg.configFile."Vial/Vial.conf".text = ''
        [General]
        theme=Catppuccin Mocha
      '';

      home.packages = with pkgs; [
        evtest
        grim
        orca-slicer
        pavucontrol
        qbittorrent
        satty
        signal-desktop
        slurp
        thunar
        vial
        wl-clipboard
      ];
    };
}

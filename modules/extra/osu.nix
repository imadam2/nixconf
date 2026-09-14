{ ... }:
{
  flake.nixosModules.osu =
    { ... }:
    {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };

  flake.homeModules.osu =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        osu-lazer-bin
      ];
    };
}

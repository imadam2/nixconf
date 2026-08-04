{ inputs, ... }:
{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      services = {
        sunshine = {
          enable = true;
          openFirewall = true;
        };
      };
      programs = {
        gamemode.enable = true;
        steam = {
          enable = true;
          gamescopeSession.enable = true;
          localNetworkGameTransfers.openFirewall = true;
          package = pkgs.steam.override {
            extraEnv = {
              MANGOHUD = true;
              OBS_VKCAPTURE = true;
            };
          };
        };
      };
      hardware.steam-hardware.enable = true;
      environment.systemPackages = with pkgs; [
        gamemode
        heroic
        lunar-client
        protontricks
        protonup-qt
        steamtinkerlaunch
        waywall
        wineWow64Packages.staging
        winetricks
        zulu
      ];
    };

  flake.homeModules.gaming =
    { pkgs, ... }:
    {
      programs = {
        lutris = {
          enable = true;
        };
      };

      home.packages = with pkgs; [
        mangohud

        (prismlauncher.override {
          textToSpeechSupport = false;
          additionalLibs = [
            libxt
            libxtst
            libxkbcommon
            libxinerama
          ];
          jdks = [
            graalvmPackages.graalvm-ce
            zulu
            zulu8
            zulu17
          ];
        })
      ];
    };
}

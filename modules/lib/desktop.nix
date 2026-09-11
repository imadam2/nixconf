{ self, ... }:
{
  flake.nixosModules.profileDesktop =
    { ... }:
    {
      imports = with self.nixosModules; [
        audio
        base
        desktop
        git
        homeManager
        mangowm
        nfs
        services
        shell
        stylix
        syncthing-client
        userConfig
      ];
    };

  flake.homeModules.profileDesktop =
    { ... }:
    {
      imports = with self.homeModules; [
        desktop
        jellyfin-add-to-playlist
        mangowm
        media
        neovim
        noctalia
        packages
        screenshot
        shell
        toggle-monitor-mode
        zen
      ];
    };
}

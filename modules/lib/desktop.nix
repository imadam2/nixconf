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
        browser
        desktop
        mangowm
        media
        neovim
        noctalia
        packages
        shell
      ];
    };
}

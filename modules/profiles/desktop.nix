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
        nfs
        services
        shell
        stylix
        syncthing-client
      ];
    };

  flake.homeModules.profileDesktop =
    { ... }:
    {
      imports = with self.homeModules; [
        browser
        desktop
        media
        neovim
        noctalia
        packages
        shell
      ];
    };
}

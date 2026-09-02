{ self, ... }:
{
  flake.nixosModules.profileServer =
    { ... }:
    {
      services.openssh.enable = true;

      imports = with self.nixosModules; [
        base
        git
        homeManager
        homelabConfig
        shell
        stylix
        userConfig
      ];
    };

  flake.homeModules.profileServer =
    { ... }:
    {
      imports = with self.homeModules; [
        neovim
        shell
      ];
    };
}

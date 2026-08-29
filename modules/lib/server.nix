{ self, ... }:
{
  flake.nixosModules.profileServer =
    { ... }:
    {
      imports = with self.nixosModules; [
        base
        git
        homeManager
        homelabConfig
        shell
        stylix
        userConfig
      ];

      services.openssh.enable = true;
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

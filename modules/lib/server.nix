{ self, ... }:
{
  flake.nixosModules.profileServer =
    { ... }:
    {
      imports = with self.nixosModules; [
        base
        shell
        git
        homelabConfig
        userConfig
      ];

      services.openssh.enable = true;
    };
}

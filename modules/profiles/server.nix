{ self, ... }:
{
  flake.nixosModules.profileServer =
    { ... }:
    {
      imports = with self.nixosModules; [
        base
        shell
        homelabConfig
      ];

      services.openssh.enable = true;
    };
}

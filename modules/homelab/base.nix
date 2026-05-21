{ self, ... }:
{
  flake.nixosModules.homelabBase =
    { ... }:
    {
      imports = with builtins; [
        self.nixosModules.base
        self.nixosModules.shell
        self.nixosModules.homelabConfig
      ];

      services.openssh.enable = true;
    };
}

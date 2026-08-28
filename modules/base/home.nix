{ inputs, ... }:
{
  flake.nixosModules.homeManager =
    { config, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit (config) my;
        };
        users.${config.my.username} =
          { ... }:
          {
            home.stateVersion = config.my.stateVersion;
          };
      };
    };
}

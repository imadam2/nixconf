{ config, ... }:
{
  flake.nixosModules.syncthing-client =
    { ... }:
    {
      services.syncthing = {
        enable = true;
        user = config.my.username;
        dataDir = config.my.homeDir;
        configDir = "${config.my.homeDir}/.config/syncthing";
        openDefaultPorts = true;
      };
    };
}

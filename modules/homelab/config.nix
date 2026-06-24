{ ... }:
{
  flake.nixosModules.homelabConfig =
    { config, lib, ... }:
    {
      options.homelab = {
        domain = lib.mkOption {
          type = lib.types.str;
          default = "elpsy.moe";
        };
        gladosIP = lib.mkOption {
          type = lib.types.str;
          default = "10.1.10.3";
        };
        rootDir = lib.mkOption {
          type = lib.types.str;
          default = "/mnt/user";
        };
        appdataDir = lib.mkOption {
          type = lib.types.str;
          default = "${config.homelab.rootDir}/appdata";
        };
        mediaDir = lib.mkOption {
          type = lib.types.str;
          default = "${config.homelab.rootDir}/media";
        };
        storageDir = lib.mkOption {
          type = lib.types.str;
          default = "${config.homelab.rootDir}/storage";
        };
        user = lib.mkOption {
          type = lib.types.str;
          default = "share";
        };
        group = lib.mkOption {
          type = lib.types.str;
          default = "share";
        };
        acme.user = lib.mkOption {
          type = lib.types.str;
          default = "acme";
        };
        acme.group = lib.mkOption {
          type = lib.types.str;
          default = "acme";
        };
        homepage.cfg = lib.mkOption {
          type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
          default = { };
        };
        caddy.virtualHosts = lib.mkOption {
          type = lib.types.attrsOf lib.types.attrs;
          default = { };
        };
        mounts = {
          slow = lib.mkOption {
            default = "/mnt/mergerfs_slow";
            type = lib.types.path;
          };
          cache = lib.mkOption {
            default = "/mnt/cache";
            type = lib.types.path;
          };
          merged = lib.mkOption {
            default = "/mnt/user";
            type = lib.types.path;
          };
        };
      };
    };
}

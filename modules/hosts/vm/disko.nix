{
  ...
}:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosModules."${hostname}Disko" = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/vda";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };
      zpool = {
        zroot = {
          type = "zpool";
          options = {
            ashift = "12";
            autotrim = "on";
          };
          rootFsOptions = {
            acltype = "posixacl";
            canmount = "off";
            compression = "lz4";
            dnodesize = "auto";
            normalization = "formD";
            relatime = "on";
            xattr = "sa";
          };
          datasets = {
            "root" = {
              type = "zfs_fs";
              mountpoint = "/";
              postCreateHook = "zfs snapshot zroot/root@blank";
            };
            "nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
            };
            "persist" = {
              type = "zfs_fs";
              mountpoint = "/persist";
            };
          };
        };
      };
    };
  };
}

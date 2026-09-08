{
  ...
}:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosModules."${hostname}Disko" = {
    disko.devices = {
      nodev = {
        "/" = {
          fsType = "tmpfs";
          mountOptions = [
            "size=2G"
            "mode=755"
          ];
        };
      };
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";
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

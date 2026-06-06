{ inputs, ... }:
{
  flake.nixosModules.seedboxDisko = {
    imports = [ inputs.disko.nixosModules.default ];
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/ata-V_Series_SATA_SSD_120GB_213810663701292";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "512M";
                type = "EF00"; # EFI System Partition
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd:2"
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd:2"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd:2"
                      ];
                    };
                    "@.snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd:2"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

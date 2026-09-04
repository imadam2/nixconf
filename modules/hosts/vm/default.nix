{ self, inputs, ... }:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosConfigurations."${hostname}" = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileDesktop
      self.nixosModules."${hostname}Configuration"
      self.nixosModules."${hostname}Hardware"
      self.nixosModules."${hostname}Disko"
      homeManager
      inputs.disko.nixosModules.disko
      {
        home-manager.users.ye.imports = with self.homeModules; [
          profileDesktop
        ];
      }
    ];
  };

  flake.nixosModules."${hostname}Configuration" =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

      networking = {
        hostName = "${hostname}";
        hostId = "778a0f05";
      };

      hardware.graphics.enable = true;
      services.qemuGuest.enable = true;
      services.openssh.enable = true;

      environment.persistence."/persist" = {
        directories = [
          "/var/log"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/etc/NetworkManager/system-connections"
        ];
        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];
      };

      home-manager.users."${config.my.username}".home.persistence."/persist" = {
        directories = [
          "Documents"
          "Games"
          "Pictures"
          "Videos"
          "nixconf"
          ".config"
          ".local"
          ".local/share/Steam"
          ".minecraft"
          {
            directory = ".ssh";
            mode = "0700";
          }
        ];
      };

      fileSystems."/persist".neededForBoot = true;

      boot = {
        initrd.systemd.enable = true;
        supportedFilesystems = [ "zfs" ];
        zfs = {
          forceImportRoot = true;
          devNodes = "/dev";
        };

        initrd.systemd.services.rollback-root = {
          description = "Rollback ZFS root dataset to blank state";
          wantedBy = [ "initrd.target" ];
          after = [ "zfs-import-zroot.service" ];
          before = [ "sysroot.mount" ];
          path = [ pkgs.zfs ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.zfs}/bin/zfs rollback -r zroot/root@blank";
          };
        };
      };
    };
}

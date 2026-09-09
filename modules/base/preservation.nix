{ inputs, ... }:
{
  flake.nixosModules.preservation =
    {
      ...
    }:
    {
      imports = [
        inputs.preservation.nixosModules.default
      ];

      sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
      systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
      fileSystems = {
        "/persist".neededForBoot = true;
        "/nix".neededForBoot = true;
      };

      preservation = {
        enable = true;
        preserveAt."/persist" = {
          directories = [
            "/etc/NetworkManager/system-connections"
            "/etc/mullvad-vpn"
            "/var/lib/NetworkManager"
            "/var/lib/acme"
            "/var/lib/bluetooth"
            "/var/lib/caddy"
            "/var/lib/fwupd"
            "/var/lib/immich"
            "/var/lib/libvirt"
            "/var/lib/postgresql"
            "/var/lib/private/AdGuardHome"
            "/var/lib/private/prowlarr"
            "/var/lib/private/seerr"
            "/var/lib/private/uptime-kuma"
            "/var/lib/prowlarr"
            "/var/lib/redis-immich"
            "/var/lib/seerr"
            "/var/lib/slskd"
            "/var/lib/unifi"
            "/var/lib/uptime-kuma"
            "/var/lib/vaultwarden"
            "/var/log"
          ];
          files = [
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
            {
              file = "/etc/machine-id";
              inInitrd = true;
            }
          ];
          users.ye = {
            directories = [
              ".lunarclient"
              ".minecraft"
              ".steam"
              "Documents"
              "Games"
              "Pictures"
              "Videos"
              "nixconf"
              ".config/Bitwarden CLI"
              ".config/Mullvad VPN"
              ".config/OrcaSlicer"
              ".config/easyeffects"
              ".config/gtk-3.0"
              ".config/obs-studio"
              ".config/qBittorrent"
              ".config/spotify"
              ".config/sunshine"
              ".config/syncthing"
              ".config/vesktop"
              ".config/zen"
              ".local/share/86Box"
              ".local/share/BeamNG"
              ".local/share/PrismLauncher"
              ".local/share/Steam"
              ".local/share/easyeffects"
              ".local/share/fish"
              ".local/share/jellyfin-desktop"
              ".local/share/jellyfin-tui"
              ".local/share/lutris"
              ".local/share/nvim"
              ".local/share/qBittorrent"
              ".local/share/umu"
              ".local/state/zoxide"
              ".local/state/noctalia"
              {
                directory = ".ssh";
                mode = "0700";
              }
            ];
          };
        };
      };
    };
}

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

      security.sudo.extraConfig = ''
        Defaults lecture = never 
      '';
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
            "/var/lib/bluetooth"
            "/var/lib/fwupd"
            "/var/log"
            # "/var/lib/acme"
            # "/var/lib/caddy"
            # "/var/lib/immich"
            # "/var/lib/libvirt"
            # "/var/lib/postgresql"
            # "/var/lib/private/AdGuardHome"
            # "/var/lib/private/prowlarr"
            # "/var/lib/private/seerr"
            # "/var/lib/private/uptime-kuma"
            # "/var/lib/prowlarr"
            # "/var/lib/redis-immich"
            # "/var/lib/seerr"
            # "/var/lib/slskd"
            # "/var/lib/unifi"
            # "/var/lib/uptime-kuma"
            # "/var/lib/vaultwarden"
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
              "Documents"
              "Pictures"
              "Videos"
              "nixconf"
              ".config/Bitwarden CLI"
              ".config/Mullvad VPN"
              ".config/easyeffects"
              ".config/gtk-3.0"
              ".config/qBittorrent"
              ".config/spotify"
              ".config/syncthing"
              ".config/vesktop"
              ".config/zen"
              ".local/share/easyeffects"
              ".local/share/fish"
              ".local/share/jellyfin-desktop"
              ".local/share/jellyfin-tui"
              ".local/share/nvim"
              ".local/share/qBittorrent"
              ".local/state/noctalia"
              ".local/state/zoxide"
              # ".config/OrcaSlicer"
              # ".config/obs-studio"
              # ".config/sunshine"
              # ".local/share/86Box"
              # ".local/share/BeamNG"
              # ".local/share/PrismLauncher"
              # ".local/share/Steam"
              # ".local/share/lutris"
              # ".local/share/umu"
              # ".lunarclient"
              # ".minecraft"
              # ".steam"
              # "Games"
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

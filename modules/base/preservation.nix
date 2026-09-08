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

      fileSystems = {
        "/persist".neededForBoot = true;
        "/nix".neededForBoot = true;
      };

      preservation = {
        enable = true;
        preserveAt."/persist" = {
          directories = [
            "/var/log"
            "/var/lib"
            "/etc/NetworkManager/system-connections"
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
              "Games"
              "Pictures"
              "Videos"
              "nixconf"
              ".lunarclient"
              ".minecraft"
              ".steam"
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
              ".local/share/qBittorrent"
              ".local/share/umu"
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

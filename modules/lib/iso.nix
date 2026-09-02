{ inputs, ... }:
{
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      (
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;
          security.sudo.wheelNeedsPassword = false;

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          services.openssh = {
            enable = true;
            settings.PermitRootLogin = "yes";
          };

          environment.systemPackages = with pkgs; [
            fastfetch
            git
            gptfdisk
            neovim
            rsync
          ];

          users.users = {
            root = {
              initialPassword = "nixos";
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWKYIrwL21t4Q/hbGUmLuVFOb1b77OHjbL0vqSo13kc ye@atlas"
              ];
            };
            nixos = {
              isNormalUser = true;
              initialPassword = "nixos";
              extraGroups = [ "wheel" ];
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWKYIrwL21t4Q/hbGUmLuVFOb1b77OHjbL0vqSo13kc ye@atlas"
              ];
            };
          };

          isoImage.squashfsCompression = "gzip -Xcompression-level 1"; # faster build
        }
      )
    ];
  };
}

{ inputs, ... }:
{
  flake.nixosModules.stylix =
    { pkgs, ... }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        polarity = "dark";
        opacity.terminal = 1.0;
        cursor = {
          package = pkgs.catppuccin-cursors.mochaBlue;
          name = "catppuccin-mocha-blue-cursors";
          size = 24;
        };
        icons = {
          dark = "Papirus-Dark";
          package = pkgs.catppuccin-papirus-folders;
        };
        fonts = {
          sizes.terminal = 11.75;
          monospace = {
            package = pkgs.nerd-fonts.iosevka-term;
            name = "IosevkaTerm NFM Medium";
          };

          serif = {
            package = pkgs.noto-fonts;
            name = "Noto Serif";
          };

          sansSerif = {
            package = pkgs.noto-fonts;
            name = "Noto Sans";
          };

          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
      };
    };
}

{ inputs, ... }:
{
  flake.nixosModules.stylix =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        polarity = "dark";
        opacity.terminal = 1.0;
        #### Commented because it pulls in inkscape, which compiles from source for whatever reason
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

{ inputs, ... }:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {

      hardware.graphics.enable = true;
      services = {
        displayManager = {
          ly = {
            enable = true;
          };
        };
      };

      stylix.cursor = {
        package = pkgs.catppuccin-cursors.mochaBlue;
        name = "catppuccin-mocha-blue-cursors";
        size = 24;
      };

      xdg.portal = {
        enable = true;
      };

      fonts = {
        packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          nerd-fonts.iosevka-term
          dejavu_fonts
          liberation_ttf
        ];
        fontconfig = {
          enable = true;
          defaultFonts = {
            monospace = [ "IosevkaTerm Nerd Font SemiBold" ];
            sansSerif = [ "Noto Sans" ];
            serif = [ "Noto Serif" ];
          };
        };
      };

      environment.etc."libinput/local-overrides.quirks".text = pkgs.lib.mkForce ''
        [Debounce]
        MatchUdevType=mouse
        ModelBouncingKeys=1
      '';
    };

  flake.homeModules.desktop =
    { lib, pkgs, ... }:
    {
      imports = [
        inputs.xdp-termfilepickers.homeManagerModules.default
      ];

      services.xdg-desktop-portal-termfilepickers =
        let
          termfilepickers =
            inputs.xdp-termfilepickers.packages.${pkgs.stdenv.hostPlatform.system}.default.override
              {
                replaceYazi = false;
              };
        in
        {
          enable = true;
          package = termfilepickers;
          config = {
            terminal_command = [ (lib.getExe pkgs.kitty) ];
          };
        };

      systemd.user.services.xdg-desktop-portal-termfilepickers = {
        Unit = {
          After = [ "mango-session.target" ];
          PartOf = [ "mango-session.target" ];
        };
        Install = {
          WantedBy = [ "mango-session.target" ];
        };
      };

      xdg.portal = {
        enable = true;
      };

      home = {
        pointerCursor.enable = true;
      };

      gtk.iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders;
      };

      programs = {
        imv = {
          enable = true;
          settings = {
            options = {
              width = 1920;
              height = 1080;
            };
          };
        };
        foot = {
          enable = true;
          settings = {
            key-bindings = {
              scrollback-down-page = "Mod1+j";
              scrollback-up-page = "Mod1+k";
              clipboard-copy = "Mod1+c";
              clipboard-paste = "Mod1+v";
              font-decrease = "Mod1+Shift+j";
              font-increase = "Mod1+Shift+k";
              font-reset = "Mod1+Shift+l";
              search-start = "Mod1+slash";
            };
            main.pad = "0x0";
          };
        };
        kitty = {
          enable = true;
          settings = {
            "confirm_os_window_close" = "0";
          };
          keybindings = {
            "alt+c" = "copy_to_clipboard";
            "alt+v" = "paste_to_clipboard";
            "alt+j" = "scroll_page_down";
            "alt+k" = "scroll_page_up";
            "alt+shift+j" = "change_font_size all -2.0";
            "alt+shift+k" = "change_font_size all +2.0";
            "alt+shift+l" = "change_font_size all 0";
            "alt+/" = "search_scrollback";
          };
        };
      };
    };
}

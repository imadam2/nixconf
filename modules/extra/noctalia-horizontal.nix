{ inputs, ... }:
{
  flake.homeModules.noctalia-horizontal =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      wallpaperDir = "/media/NAS/storage/Pictures/Wallpapers";
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      home.packages = with pkgs; [
        bitwarden-cli
      ];

      programs.noctalia = {
        enable = true;
        settings = {
          theme = {
            builtin = "stylix";
            colorScheme = "stylix";
          };
          shell = {
            avatar_path = "${config.home.homeDirectory}/nixconf/assets/pfp.jpg";
            corner_radius_scale = 0;
            font_family = lib.mkForce "IosevkaTerm NFM SemiBold";
            screen_time_enabled = true;
            launcher = {
              providers.windows.global = false;
              categories = false;
              compact = true;
              sort_by_usage = false;
            };
          };
          ui = {
            fontDefault = "IosevkaTerm NFM SemiBold";
            fontFixed = "IosevkaTerm NFM SemiBold";
          };
          appLauncher = {
            enableClipboardHistory = true;
            terminalCommand = "kitty -e";
          };
          widget = {
            battery = {
              display_mode = "graphic";
            };
            cat = {
              type = "noctalia/bongocat:cat";
              input_devices = [
                "/dev/input/event1"
                "/dev/input/event2"
              ];
            };
            media = {
              max_length = 800;
            };
            workspaces = {
              anchor = true;
              capsule_padding = 10;
              empty_color = "primary";
              focused_color = "hover";
              max_label_chars = 1;
              occupied_color = "primary";
              style = "minimal";
            };
          };
          nightLight = {
            autoSchedule = true;
            enabled = true;
            manualSunrise = "08:00";
            manualSunset = "23:00";
            nightTemp = "3500";
          };
          plugin_settings."noctalia/bitwarden" = {
            gen_length = 24;
            gen_special = true;
            server_url = "https://vaultwarden.elpsy.moe";
            vault_timeout = "never";
          };
          plugins = {
            enabled = [
              "noctalia/bitwarden"
              "noctalia/bongocat"
            ];
          };
          wallpaper = {
            directory = "${wallpaperDir}";
            default = {
              path = "${wallpaperDir}";
            };
            monitors = {
              DP-1 = {
                path = "${wallpaperDir}/flowers-21_hr.png";
              };
              DP-2 = {
                path = "${wallpaperDir}/nerv_catppuccinn_uw.jpg";
              };
              LVDS-1 = {
                path = "${wallpaperDir}/rei-ii.jpg";
              };
            };
          };
          bar = {
            density = "mini";
            exclusive = true;
            outerCorners = false;
            showCapsule = false;
            monitors = [
              "DP-1"
              "DP-2"
              "DP-3"
              "eDP-1"
              "LVDS-1"
              "HDMI-A-1"
            ];
            bar = {
              border = "primary";
              border_width = "20.0";
              thickness = 25;
              capsule = true;
              font_weight = 700;
              margin_edge = 0;
              margin_ends = 0;
              position = "bottom";
              radius = 0;
              shadow = false;
              widget_spacing = 0;
              start = [
                "workspaces"
                "media"
              ];
              end = [
                "cat"
                "audio_visualizer"
                "temp"
                "cpu"
                "ram"
                "bluetooth"
                "volume"
                "brightness"
                "network"
                "battery"
                "date"
                "clock"
                "tray"
                "control-center"
              ];
              left = [
                {
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
              ];
              right = [
                {
                  id = "Tray";
                  colorizeIcons = true;
                  drawerEnabled = false;
                }
                {
                  id = "Network";
                }
                {
                  id = "Bluetooth";
                }
                {
                  id = "Volume";
                  displayMode = "alwaysShow";
                }
                {
                  id = "Brightness";
                }
                {
                  id = "Battery";
                  alwaysShowPercentage = true;
                  warningThreshold = 30;
                }
                {
                  id = "Clock";
                  formatHorizontal = "HH:mm";
                  formatVertical = "MMM dd - HH mm";
                  useMonospacedFont = true;
                  usePrimaryColor = true;
                }
              ];
            };
          };
        };
      };
    };
}

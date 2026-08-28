{ inputs, ... }:
{
  flake.nixosModules.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

  flake.homeModules.hyprland =
    { config, pkgs, ... }:
    let
      toggle-monitor-mode = pkgs.writeShellApplication {
        name = "toggle-monitor-mode";
        runtimeInputs = with pkgs; [
          hyprland
          libnotify
        ];
        text = ''
          STATE_FILE="''${XDG_RUNTIME_DIR:-/tmp}/monitor-mode.state"

          if [[ -f "$STATE_FILE" ]]; then
            CURRENT=$(cat "$STATE_FILE")
          else
            CURRENT="4k"
          fi

          if [[ "$CURRENT" == "4k" ]]; then
            hyprctl eval 'hl.monitor({ output = "DP-1", mode = "1920x1080@320.0", position = "960x1440",  scale = 1.0, bitdepth = 10 })'
            hyprctl eval 'hl.monitor({ output = "DP-2", mode = "3440x1440@165.0", position = "200x0",   scale = 1.0, })'
            echo "1080p" > "$STATE_FILE"
            notify-send "Monitor" "DP-1 → 1080p @ 320hz"
          else
            hyprctl eval 'hl.monitor({ output = "DP-1", mode = "3840x2160@160.0", position = "0x1440",  scale = 1.0, bitdepth = 10 })'
            hyprctl eval 'hl.monitor({ output = "DP-2", mode = "3440x1440@165.0", position = "200x0",   scale = 1.0, })'
            echo "4k" > "$STATE_FILE"
            notify-send "Monitor" "DP-1 → 4K @ 160hz"
          fi
        '';
      };
    in
    {
      home.packages = [ toggle-monitor-mode ];

      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof noctalia || noctalia msg session lock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "brightnessctl -s set 10";
              on-resume = "brightnessctl -r";
            }
            {
              timeout = 1800;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 2700;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 4500;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };

      stylix.targets.hyprland.enable = false;
      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        settings = { };
        systemd.enable = true;

        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };

      xdg.configFile."hypr/hyprland.lua".text = ''
        -- ==================
        -- MONITORS
        -- ==================
        hl.monitor({ output = "DP-1", mode = "3840x2160@160.0",  position = "0x1440",   scale = 1.0, bitdepth = 10 })
        hl.monitor({ output = "DP-2", mode = "3440x1440@165.0", position = "200x0", scale = 1.0 })
        hl.monitor({ output = "LVDS-1", mode = "1920x1080@60.0",  position = "0x0",   scale = 1.0 })
        hl.monitor({ output = "HDMI-A-1", mode = "1600x1200@60.0",  position = "0x0",   scale = 1.0, transform = 1 })
        hl.monitor({ output = "",     mode = "preferred",        position = "auto",     scale = "auto" })

        for i = 1, 8 do
          hl.workspace_rule({
            workspace = tostring(i),
            monitor   = "DP-1",
            layout    = "dwindle",
            persistent = true,
            default   = (i == 1),
          })
        end

        -- Pin workspaces 10–19 to your second monitor
        for i = 9, 9 do
          hl.workspace_rule({
            workspace  = tostring(i),
            monitor    = "DP-2",
            layout     = "master",
            persistent = true,
            default    = (i == 9),
          })
        end

        local ipc = "noctalia msg"

        -- ==================
        -- GENERAL SETTINGS
        -- ==================
        hl.config({
          master = {
            orientation = center,
            slave_count_for_center_master = 0,
            mfact = 0.4,
          },
          general = {
            layout = "dwindle";
            gaps_in   = 3,
            gaps_out  = 5,
            border_size = 4,
            ["col.active_border"]   = "rgb(${config.lib.stylix.colors.base09})",
            ["col.inactive_border"] = "rgb(${config.lib.stylix.colors.base01})",
          },
          animations = {
            enabled = false,
          },
          decoration = {
            rounding = 0,
            rounding_power = 2,
            blur = {
              enabled = true,
              size = 3,
              passes = 2,
              vibrancy = 0.1696,
            },
            shadow = {
              enabled = true,
              range = 4,
              render_power = 3,
              color   = "rgba(${config.lib.stylix.colors.base00}ff)",
            },
          },
          input = {
            force_no_accel = true,
            accel_profile = "flat",
            kb_layout    = "gb",
            kb_options   = "ctrl:nocaps",
            repeat_delay = 300,
            repeat_rate  = 50,
          },
        })

        -- ==================
        -- AUTOSTART
        -- ==================
        hl.on("hyprland.start", function ()
          hl.exec_cmd("noctalia")

          -- Workspace 1: Terminal
          hl.exec_cmd("kitty",          { workspace = "1" })

          -- Workspace 2: Browser
          hl.exec_cmd("zen-beta",      { workspace = "2" })

          -- Workspace 3: Gaming
          hl.exec_cmd("prismlauncher", { workspace = "3" })
          hl.exec_cmd("steam",         { workspace = "3" })
        end)

        -- ==================
        -- WINDOW RULES
        -- ==================
        hl.window_rule({ match = { class = "mpv"     }, float = true })
        hl.window_rule({ match = { class = "waywall" }, float = true })
        hl.window_rule({ match = { class = "java"    }, float = true })
        hl.window_rule({ match = { title = "Open File"       }, float = true })
        hl.window_rule({ match = { title = "Select a File"   }, float = true })
        hl.window_rule({ match = { title = "Choose Wallpaper" }, float = true })
        hl.window_rule({ match = { title = "Save As"         }, float = true })
        hl.window_rule({ match = { title = "Library"         }, float = true })
        hl.window_rule({ match = { title = "File Upload"     }, float = true })

        hl.window_rule({ match = { class = "^(steam)$" },         workspace = "3" })
        hl.window_rule({ match = { class = "^(org.prismlauncher.PrismLauncher)$" }, workspace = "3" })
        hl.window_rule({ match = { class = "^(OrcaSlicer)$" },    workspace = "4" })

        hl.layer_rule({
          name = "noctalia",
          match = {
            namespace = "^noctalia-(bar-.+|notification|dock|panel)$",
          },
          ignore_alpha = 0.5,
          blur = true,
          blur_popups = true,
        })

        -- ==================
        -- KEYBINDS
        -- ==================
        local mainMod = "SUPER"

        -- Mouse binds
        hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        -- Media / volume / brightness (repeat-on-hold)
        hl.bind("XF86AudioRaiseVolume",    hl.dsp.exec_cmd(ipc .. " volume-up"), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume",    hl.dsp.exec_cmd(ipc .. " volume-down"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessUp",     hl.dsp.exec_cmd(ipc .. " brightness-up"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown",   hl.dsp.exec_cmd(ipc .. " brightness-down"), { locked = true, repeating = true })

        -- Media keys (locked / works on lockscreen)
        hl.bind("XF86AudioMute",  hl.dsp.exec_cmd(ipc .. " volume-mute"), { locked = true })
        hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(ipc .. " media next"), { locked = true })
        hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(ipc .. " media previous"), { locked = true })
        hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(ipc .. " media toggle"), { locked = true })
        hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. " media stop"), { locked = true })

        -- Window management
        hl.bind(mainMod .. " + Q",           hl.dsp.window.close())
        hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
        hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mainMod .. " + S",           hl.dsp.window.pin())
        hl.bind(mainMod .. " + H",           hl.dsp.window.resize({ x = -100, y = 0, relative=true }))
        hl.bind(mainMod .. " + J",           hl.dsp.focus({ direction = "left" }))
        hl.bind(mainMod .. " + K",           hl.dsp.focus({ direction = "right" }))
        hl.bind(mainMod .. " + L",           hl.dsp.window.resize({ x = 100, y = 0, relative=true }))
        hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left" }))
        hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down" }))
        hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up" }))
        hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))
        hl.bind(mainMod .. " + CTRL + J",      hl.dsp.focus({ direction = "down" }))
        hl.bind(mainMod .. " + CTRL + K",      hl.dsp.focus({ direction = "up" }))

        -- App launchers
        hl.bind(mainMod .. " + Return",      hl.dsp.exec_cmd("kitty"))
        hl.bind(mainMod .. " + Backspace",   hl.dsp.exec_cmd(ipc .. " session lock"))
        hl.bind(mainMod .. " + W",           hl.dsp.exec_cmd("zen-beta"))
        hl.bind(mainMod .. " + E",           hl.dsp.exec_cmd(ipc .. " panel-toggle launcher /emo"))
        hl.bind(mainMod .. " + R",           hl.dsp.exec_cmd("kitty -e yazi"))
        hl.bind(mainMod .. " + SHIFT + R",   hl.dsp.exec_cmd("thunar"))
        hl.bind(mainMod .. " + A",           hl.dsp.exec_cmd(ipc .. " bar-toggle"))
        hl.bind(mainMod .. " + D",           hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"))
        hl.bind(mainMod .. " + V",           hl.dsp.exec_cmd(ipc .. " panel-toggle clipboard"))
        hl.bind(mainMod .. " + M",           hl.dsp.exec_cmd("kitty -e jellyfin-tui"))

        -- Monitor mode toggle
        hl.bind(mainMod .. " + SHIFT + M",   hl.dsp.exec_cmd("${toggle-monitor-mode}/bin/toggle-monitor-mode"))

        -- Screenshots (screenshot binary comes from home.packages in desktop.nix)
        hl.bind("Print",                hl.dsp.exec_cmd("screenshot area"))
        hl.bind("SUPER + Print",        hl.dsp.exec_cmd("screenshot display"))
        hl.bind("SHIFT + Print",        hl.dsp.exec_cmd("screenshot window"))
        hl.bind("CTRL + Print",         hl.dsp.exec_cmd("screenshot area-s"))
        hl.bind("CTRL + SUPER + Print", hl.dsp.exec_cmd("screenshot display-s"))
        hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd("screenshot window-s"))

        -- Jellyfin: add current song to playlist "nu"
        -- (jellyfin-add-to-playlist binary comes from home.packages in desktop.nix)
        hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("jellyfin-add-to-playlist"))

        -- Workspace switching + moving (split-monitor-workspaces)
        for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
          hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
        end
      '';
    };
}

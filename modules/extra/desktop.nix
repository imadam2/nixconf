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
    let
      screenshot = pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [
          grim
          hyprland
          mango
          jq
          libnotify
          satty
          slurp
          wl-clipboard
        ];
        text = ''
          if [ $# -lt 1 ]; then
            echo "Usage: screenshot {area|display|window|area-s|display-s|window-s}" >&2
            exit 1
          fi

          NAS=/media/NAS/storage/Pictures/Screenshots/$(date +%Y)/$(date +%m)
          mkdir -p "$NAS" 2>/dev/null && DIR=$NAS || DIR=$HOME/Pictures/Screenshots
          FILE="$DIR/$(date +%Y%m%d_%H%M%S).png"

          if [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
            WM=hypr
          elif [ -n "''${MANGO_INSTANCE_SIGNATURE:-}" ]; then
            WM=mango
          else
            echo "screenshot: could not detect Hyprland or MangoWM" >&2
            exit 1
          fi

          focused_output() {
            case "$WM" in
              hypr)  hyprctl monitors -j | jq -r '.[] | select(.focused) | .name' ;;
              mango) mmsg get all-monitors | jq -r '.monitors[] | select(.active) | .name' ;;
            esac
          }

          focused_window_geometry() {
            case "$WM" in
              hypr)
                hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
                ;;
              mango)
                mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"'
                ;;
            esac
          }

          case "$1" in
            area)
              g=$(slurp) || exit 0
              [ -z "$g" ] && exit 0
              grim -g "$g" - | tee "$FILE" | wl-copy
              notify-send "Screenshot" "Area → $FILE"
              ;;
            display)
              grim -o "$(focused_output)" - | tee "$FILE" | wl-copy
              notify-send "Screenshot" "Display → $FILE"
              ;;
            window)
              grim -g "$(focused_window_geometry)" - | tee "$FILE" | wl-copy
              notify-send "Screenshot" "Window → $FILE"
              ;;
            area-s)
              g=$(slurp) || exit 0
              [ -z "$g" ] && exit 0
              grim -g "$g" - | satty --filename - --output-filename "$FILE" --copy-command wl-copy
              notify-send "Screenshot" "Area (annotated) → $FILE"
              ;;
            display-s)
              grim -o "$(focused_output)" - | satty --filename - --output-filename "$FILE" --copy-command wl-copy
              notify-send "Screenshot" "Display (annotated) → $FILE"
              ;;
            window-s)
              grim -g "$(focused_window_geometry)" - | satty --filename - --output-filename "$FILE" --copy-command wl-copy
              notify-send "Screenshot" "Window (annotated) → $FILE"
              ;;
            *) echo "Usage: screenshot {area|display|window|area-s|display-s|window-s}" >&2; exit 1 ;;
          esac
        '';
      };

      jellyfin-add-to-playlist = pkgs.writeShellApplication {
        name = "jellyfin-add-to-playlist";
        runtimeInputs = with pkgs; [
          curl
          libnotify
          playerctl
          (python3.withPackages (ps: [ ps.pyyaml ]))
        ];
        text = ''
          # Adds the currently playing jellyfin-tui track to a named Jellyfin playlist.
          # Usage: jellyfin-add-to-playlist [playlist-name]   (default: "nu")

          PLAYLIST_NAME="''${1:-nu}"

          CONFIG_FILE="''${XDG_CONFIG_HOME:-$HOME/.config}/jellyfin-tui/config.yaml"

          if [[ ! -f "$CONFIG_FILE" ]]; then
            notify-send -u critical "jellyfin-playlist" "Config not found: $CONFIG_FILE"
            exit 1
          fi

          # Parse the first server entry from config.yaml using python3 + PyYAML.
          # Fields: url, username, password
          read -r SERVER_URL USERNAME PASSWORD < <(python3 -c "
            import sys, yaml
            cfg = yaml.safe_load(open(sys.argv[1]))
            s = cfg[\"servers\"][0]
            print(s[\"url\"], s[\"username\"], s[\"password\"])
            " "$CONFIG_FILE")

          SERVER_URL="''${SERVER_URL%/}"

          if [[ -z "$SERVER_URL" || -z "$USERNAME" || -z "$PASSWORD" ]]; then
            notify-send -u critical "jellyfin-playlist" "Could not parse server config from $CONFIG_FILE"
            exit 1
          fi

          # ── Auth ──────────────────────────────────────────────────────────────
          AUTH_HEADER='MediaBrowser Client="jellyfin-add-to-playlist", Device="hyprland-keybind", DeviceId="jellyfin-add-to-playlist-1", Version="1.0"'

          auth_response=$(curl -sf \
            -X POST \
            -H "Content-Type: application/json" \
            -H "Authorization: ''${AUTH_HEADER}" \
            -d "{\"Username\":\"''${USERNAME}\",\"Pw\":\"''${PASSWORD}\"}" \
            "''${SERVER_URL}/Users/AuthenticateByName")

          TOKEN=$(echo "$auth_response"  | grep -o '"AccessToken":"[^"]*"' | cut -d'"' -f4)
          USER_ID=$(echo "$auth_response" | grep -o '"Id":"[^"]*"'    | head -1 | cut -d'"' -f4)

          if [[ -z "$TOKEN" || -z "$USER_ID" ]]; then
            notify-send -u critical "jellyfin-playlist" "Authentication failed — check credentials in config.toml."
            exit 1
          fi

          AUTH_FULL="MediaBrowser Client=\"jellyfin-add-to-playlist\", Device=\"hyprland-keybind\", DeviceId=\"jellyfin-add-to-playlist-1\", Version=\"1.0\", Token=\"''${TOKEN}\""

          # ── Current track via MPRIS ───────────────────────────────────────────
          if ! playerctl --player=jellyfin-tui status &>/dev/null; then
            notify-send -u normal "jellyfin-playlist" "jellyfin-tui is not running or nothing is playing."
            exit 0
          fi

          TRACK_TITLE=$(playerctl --player=jellyfin-tui metadata title 2>/dev/null || true)

          if [[ -z "$TRACK_TITLE" ]]; then
            notify-send -u critical "jellyfin-playlist" "Could not get track title from MPRIS."
            exit 1
          fi

          # jellyfin-tui sets trackid to '/' so we always search by title+artist.
          # Use env vars to pass title/artist to avoid shell quoting issues with apostrophes.
          ENCODED_QUERY=$(JFTITLE="$TRACK_TITLE" python3 -c "
            import urllib.parse, os
            print(urllib.parse.quote(os.environ[\"JFTITLE\"]))
            ")
          search_response=$(curl -sf \
            -H "Authorization: ''${AUTH_FULL}" \
            "''${SERVER_URL}/Users/''${USER_ID}/Items?searchTerm=''${ENCODED_QUERY}&IncludeItemTypes=Audio&Recursive=true&Limit=5")

          # Pick the result whose artist matches (case-insensitive) to avoid wrong hits
          ITEM_ID=$(echo "$search_response" | JFTITLE="$TRACK_TITLE" python3 -c "
            import sys, json, os
            data = json.load(sys.stdin)
            title = os.environ[\"JFTITLE\"].lower()
            for item in data.get(\"Items\", []):
                if item.get(\"Name\", \"\").lower() == title:
                    print(item[\"Id\"])
                    break
            " 2>/dev/null || true)

          if [[ -z "$ITEM_ID" ]]; then
            notify-send -u critical "jellyfin-playlist" "Could not find in Jellyfin: $TRACK_TITLE"
            exit 1
          fi

          # ── Find playlist ─────────────────────────────────────────────────────
          playlists_response=$(curl -sf \
            -H "Authorization: ''${AUTH_FULL}" \
            "''${SERVER_URL}/Users/''${USER_ID}/Items?IncludeItemTypes=Playlist&Recursive=true&Fields=Id,Name")

          PLAYLIST_ID=$(echo "$playlists_response" | JFPLAYLIST="$PLAYLIST_NAME" python3 -c "
            import sys, json, os
            data = json.load(sys.stdin)
            name = os.environ[\"JFPLAYLIST\"].lower()
            for item in data.get(\"Items\", []):
                if item.get(\"Name\", \"\").lower() == name:
                    print(item[\"Id\"])
                    break
            ")

          if [[ -z "$PLAYLIST_ID" ]]; then
            notify-send -u critical "jellyfin-playlist" "Playlist $PLAYLIST_NAME not found on Jellyfin server."
            exit 1
          fi

          # ── Add to playlist ───────────────────────────────────────────────────
          http_status=$(curl -sf -o /dev/null -w "%{http_code}" \
            -X POST \
            -H "Authorization: ''${AUTH_FULL}" \
            "''${SERVER_URL}/Playlists/''${PLAYLIST_ID}/Items?ids=''${ITEM_ID}&userId=''${USER_ID}")

          if [[ "$http_status" == "204" || "$http_status" == "200" ]]; then
            notify-send -u low "jellyfin-playlist" "Added to $PLAYLIST_NAME" "''${TRACK_TITLE}"
          else
            notify-send -u critical "jellyfin-playlist" "Failed to add track (HTTP ''${http_status})" "''${TRACK_TITLE} → $PLAYLIST_NAME"
            exit 1
          fi
        '';
      };
    in
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
        packages = [
          screenshot
          jellyfin-add-to-playlist
        ];
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
            "alt+shift+j" = "change_font_size all +2.0";
            "alt+shift+k" = "change_font_size all -2.0";
            "alt+shift+l" = "change_font_size all 0";
            "alt+/" = "search_scrollback";
          };
        };
      };
    };
}

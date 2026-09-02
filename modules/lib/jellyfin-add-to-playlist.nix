{ ... }:
{
  flake.homeModules.jellyfin-add-to-playlist =
    { pkgs, ... }:
    let
      jellyfin-add-to-playlist = pkgs.writeShellApplication {
        name = "jellyfin-add-to-playlist";
        runtimeInputs = with pkgs; [
          curl
          libnotify
          playerctl
          (python3.withPackages (ps: [ ps.pyyaml ]))
        ];
        text = ''
          PLAYLIST_NAME="''${1:-nu}"
          CONFIG_FILE="''${XDG_CONFIG_HOME:-$HOME/.config}/jellyfin-tui/config.yaml"
          if [[ ! -f "$CONFIG_FILE" ]]; then
            notify-send -u critical "jellyfin-playlist" "Config not found: $CONFIG_FILE"
            exit 1
          fi
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
          AUTH_HEADER='MediaBrowser Client="jellyfin-add-to-playlist", Device="mango-keybind", DeviceId="jellyfin-add-to-playlist-1", Version="1.0"'
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
          AUTH_FULL="MediaBrowser Client=\"jellyfin-add-to-playlist\", Device=\"mango-keybind\", DeviceId=\"jellyfin-add-to-playlist-1\", Version=\"1.0\", Token=\"''${TOKEN}\""
          if ! playerctl --player=jellyfin-tui status &>/dev/null; then
            notify-send -u normal "jellyfin-playlist" "jellyfin-tui is not running or nothing is playing."
            exit 0
          fi
          TRACK_TITLE=$(playerctl --player=jellyfin-tui metadata title 2>/dev/null || true)
          if [[ -z "$TRACK_TITLE" ]]; then
            notify-send -u critical "jellyfin-playlist" "Could not get track title from MPRIS."
            exit 1
          fi
          ENCODED_QUERY=$(JFTITLE="$TRACK_TITLE" python3 -c "
            import urllib.parse, os
            print(urllib.parse.quote(os.environ[\"JFTITLE\"]))
            ")
          search_response=$(curl -sf \
            -H "Authorization: ''${AUTH_FULL}" \
            "''${SERVER_URL}/Users/''${USER_ID}/Items?searchTerm=''${ENCODED_QUERY}&IncludeItemTypes=Audio&Recursive=true&Limit=5")
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
      home.packages = [ jellyfin-add-to-playlist ];
    };
}

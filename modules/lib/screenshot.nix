{ ... }:
{
  flake.homeModules.screenshot =
    { pkgs, ... }:
    let
      screenshot = pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [
          grim
          mango
          jq
          libnotify
          satty
          slurp
          wayfreeze
          wl-clipboard
        ];
        text = ''
          if [ $# -lt 1 ]; then
            echo "Usage: screenshot {area|display|window|area-s|display-s|window-s}" >&2
            exit 1
          fi

          if [ -z "''${MANGO_INSTANCE_SIGNATURE:-}" ]; then
            echo "screenshot: could not detect MangoWM" >&2
            exit 1
          fi

          NAS=/media/NAS/storage/Pictures/Screenshots/$(date +%Y)/$(date +%m)
          mkdir -p "$NAS" 2>/dev/null && DIR=$NAS || DIR=$HOME/Pictures/Screenshots
          mkdir -p "$DIR"
          FILE="$DIR/$(date +%Y%m%d_%H%M%S).png"

          TMP=$(mktemp -d)
          FREEZE_PID=""
          unfreeze() {
            if [ -n "$FREEZE_PID" ]; then
              kill "$FREEZE_PID" 2>/dev/null || true
              FREEZE_PID=""
            fi
          }
          cleanup() {
            unfreeze
            rm -rf "$TMP"
          }
          trap cleanup EXIT

          # Freeze all outputs and wait until the overlay is actually showing
          freeze() {
            wayfreeze --after-freeze-cmd "touch $TMP/ready" &
            FREEZE_PID=$!
            for _ in $(seq 1 50); do
              [ -e "$TMP/ready" ] && return 0
              sleep 0.02
            done
          }

          focused_output() {
            mmsg get all-monitors | jq -r '.monitors[] | select(.active) | .name'
          }
          focused_window_geometry() {
            mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"'
          }

          # Select an area on a frozen screen and capture it to $TMP/shot.png
          capture_area() {
            freeze
            g=$(slurp) || exit 0
            [ -z "$g" ] && exit 0
            grim -g "$g" "$TMP/shot.png"
            unfreeze
          }

          case "$1" in
            area)
              capture_area
              tee "$FILE" < "$TMP/shot.png" | wl-copy
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
              capture_area
              satty --filename "$TMP/shot.png" --output-filename "$FILE" --copy-command wl-copy
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
            *)
              echo "Usage: screenshot {area|display|window|area-s|display-s|window-s}" >&2
              exit 1
              ;;
          esac
        '';
      };
    in
    {
      home.packages = [ screenshot ];
    };
}

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
          FILE="$DIR/$(date +%Y%m%d_%H%M%S).png"

          focused_output() {
            mmsg get all-monitors | jq -r '.monitors[] | select(.active) | .name'
          }
          focused_window_geometry() {
            mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"'
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

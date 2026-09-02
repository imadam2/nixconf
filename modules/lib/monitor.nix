{ ... }:
{
  flake.homeModules.toggle-monitor-mode =
    { pkgs, ... }:
    let
      toggle-monitor-mode = pkgs.writeShellApplication {
        name = "toggle-monitor-mode";
        runtimeInputs = with pkgs; [
          mango
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
            mangoctl monitor "DP-1" "1920x1080@320" "960x1440" "1.0"
            mangoctl monitor "DP-2" "3440x1440@165" "200x0" "1.0"
            echo "1080p" > "$STATE_FILE"
            notify-send "Monitor" "DP-1 → 1080p @ 320hz"
          else
            mangoctl monitor "DP-1" "3840x2160@160" "0x1440" "1.0"
            mangoctl monitor "DP-2" "3440x1440@165" "200x0" "1.0"
            echo "4k" > "$STATE_FILE"
            notify-send "Monitor" "DP-1 → 4K @ 160hz"
          fi
        '';
      };
    in
    {
      home.packages = [ toggle-monitor-mode ];
    };
}

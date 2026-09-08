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
          wlr-randr
        ];
        text = ''
          STATE_FILE="''${XDG_RUNTIME_DIR:-/tmp}/monitor-mode.state"

          if [[ -f "$STATE_FILE" ]]; then
            CURRENT=$(cat "$STATE_FILE")
          else
            CURRENT="4k"
          fi

          if [[ "$CURRENT" == "4k" ]]; then
            wlr-randr --output DP-1 --mode 1920x1080@320 --pos 960,1440 
            wlr-randr --output DP-2 --mode 3440x1440@165 --pos 200,0
            echo "1080p" > "$STATE_FILE"
            notify-send "Monitor" "DP-1 → 1080p @ 320hz"
          else
            wlr-randr --output DP-1 --mode 3840x2160@160 --pos 0,1440
            wlr-randr --output DP-2 --mode 3440x1440@165 200,0
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

{ pkgs, ... }:
let
  terminal = "alacritty";
  runner = "wofi --show drun";

  cursor_size = 30;
in
{
  exec-once = [
    "systemctl --user start dunst.service"
    "systemctl --user start hyprpolkitagent.service"
    "systemctl --user start hypridle.service"
    "${pkgs.wluma}/bin/wluma &"
  ];

  monitor = ",preferred,auto,auto";

  env = [
    "XCURSOR_SIZE,${toString cursor_size}"
    "HYPRCURSOR_SIZE,${toString cursor_size}"
  ];

  general = {
    gaps_in = 5;
    gaps_out = 20;

    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";

    resize_on_border = true;

    allow_tearing = false;

    layout = "dwindle";
  };

  bindel = [
    ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%+"
    ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
  ];
}

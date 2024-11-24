{ pkgs, ... }:
let
  terminal = "alacritty";
  runner = "wofi --show drun";

  cursor_size = 30;
in
{
  exec-once = builtins.concatStringsSep ";" [
    "systemctl --user start dunst.service"
    "systemctl --user start hyprpolkitagent.service"
    "systemctl --user start hypridle.service"
    "(${pkgs.wluma}/bin/wluma &)"
  ];

  monitor = ",preferred,auto,auto";

  env = [
    "XCURSOR_SIZE,${toString cursor_size}"
    "HYPRCURSOR_SIZE,${toString cursor_size}"
  ];

  bindel = [
    ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%+"
    ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
  ];
}

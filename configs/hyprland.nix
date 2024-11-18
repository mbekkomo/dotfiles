{ pkgs, ... }:
let
  terminal = "alacritty";
in
{
  exec-once = builtins.concatStringsSep ";" [
    "systemctl --user start dunst.service"
    "systemctl --user start hyprpolkitagent.service"
    "systemctl --user start hypridle.service"
    "eww open bar"
    "${pkgs.wluma}/bin/wluma"
  ];

  bindel = [
    ",XF86KbdBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%+"
    ",XF86KbdBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
  ];
}

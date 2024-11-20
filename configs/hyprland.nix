{ pkgs, ... }:
let
  terminal = "alacritty";
in
{
  exec-once = builtins.concatStringsSep ";" [
    "systemctl --user start dunst.service"
    "systemctl --user start hyprpolkitagent.service"
    "systemctl --user start hypridle.service"
    "(${pkgs.wluma}/bin/wluma &)"
  ];

  bindel = [
    ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%+"
    ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
  ];
}

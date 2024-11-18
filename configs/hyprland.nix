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
}

_:
let
  terminal = "alacritty";
in
{
  exec-once = builtins.concatStringsSep ";" [
    "systemctl --user start dunst.service"
    "systemctl --user start hyprpolkitagent.service"
    "eww open bar"
  ];
}

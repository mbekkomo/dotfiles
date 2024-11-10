_:
let
  terminal = "alacritty";
in
{
  exec-once = builtins.concatStringsSep ";" [
    "systemctl --user start dunst.service"
    "systemctl --user start plasma-polkit-agent.service"
    "eww open bar"
  ];
}

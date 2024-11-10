_:
let
  terminal = "alacritty";
in
{
  exec-once = builtins.concatStringsSep " & " [
    "dunst"

  ];
}

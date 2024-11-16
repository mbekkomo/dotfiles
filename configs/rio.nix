{ vendor, pkgs, ... }:
{
  theme = "catppuccin";

  fonts.size = 18;
  fonts.family = "DepartureMono Nerd Font";
  fonts.emoji.family = "Noto Color Emoji";

  renderer.performance = "High";
  renderer.backend = "Vulkan";

  shell.program = "${pkgs.fish}/bin/fish";
  shell.args = [ "--login" ];

  hide-mouse-cursor-when-typing = true;

  editor.program = "${pkgs.helix}/bin/hx";
  editor.args = [];

  cursor.blinking = true;

  window.opacity = 0.5;
  window.blur = true;

  padding.x = 5;
  padding.y = [
    3
    0
  ];
}

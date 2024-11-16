{ vendor, pkgs, ... }:
{
  theme = "catppuccin";

  fonts.size = 10;
  fonts.family = "DepartureMono Nerd Font";
  fonts.emoji = "Noto Color Emoji";

  renderer.performance = "High";
  renderer.backend = "Vulkan";

  shell.program = "${pkgs.fish}/bin/fish";
  shell.args = [ "--login" ];

  hide-mouse-cursor-when-typing = true;

  editor.program = "${pkgs.helix}/bin/hx";

  cursor.blinking = true;

  window.opacity = 0.5;
  window.blur = true;

  padding.x = 5;
  padding.y = [
    3
    0
  ];
}

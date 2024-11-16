{ vendor, pkgs, ... }:
{
  fonts.size = 10;
  fonts.family = "DepartureMono Nerd Font";
  fonts.emoji = "Noto Color Emoji";

  renderer.performance = "High";
  renderer.backend = "Vulkan";

  shell.program = "${pkgs.fish}/bin/fish";
}

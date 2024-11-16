{ vendor, ... }: {
  general.import = [ (toString (vendor.catppuccin-alacritty + /catppuccin-mocha.toml)) ];

  font.normal = {
    family = "DepartureMono Nerd Font";
    style = "Regular";
  };
  font.size = 11.23;
  font.offset = {
    y = 1;
  };

  windows.padding = {
    x = 3;
    y = 2;
  };

  terminal = {
    shell.program = "/usr/bin/env";
    shell.args = [ "fish" ];
  };
}

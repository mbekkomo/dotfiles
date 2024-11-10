{
  config,
  lib,
  pkgs,
  etcpkgs,
  ...
}:
let
  username = "komo"; # change to your username
  homeDir = "/home/${username}";
  wrapGL = config.lib.nixGL.wrap;
  # https://github.com/NixOS/nixpkgs/pull/313760#issuecomment-2365160954
  bun = pkgs.bun.overrideAttrs rec {
    passthru.sources."x86_64-linux" = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${pkgs.bun.version}/bun-linux-x64-baseline.zip";
      hash = "sha256-WNmOGBrDDrW+8D/iMJjv10BUz0yjUEK+BY7aqBG9R9o=";
    };
    src = passthru.sources."x86_64-linux";
  };
  departure-nf = pkgs.departure-mono.overrideAttrs {
    pname = "departure-nerd-font";
    nativeBuildInputs = [ pkgs.nerd-font-patcher ];
    installPhase = ''
      runHook preInstall

      nerd-font-patcher -c *.otf -out $out/share/fonts/otf
      nerd-font-patcher -c *.woff -out $out/share/woff || true
      nerd-font-patcher -c *.woff2 -out $out/share/woff2 || true

      runHook postInstall
    '';
  };
in
{
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "24.05"; # do not change

  home.packages = with pkgs; [
    etcpkgs.nix-search
    departure-nf
    nixfmt-rfc-style
    shellcheck
    moar
    glow
    fzf
    ripgrep
    fd
    sd
    zoxide
    bat
    sigi
    dolphin
  ];

  home.file = {
    ".config/alacritty/themes/tokyonight.toml".source = ./configs/alacritty/tokyonight.toml;
    ".config/zls.json".text = builtins.toJSON (import ./configs/zls.nix { });
    ".local/share/fonts".source = ./fonts/DepartureMonoNerdFont-Regular.otf;
    ".config/fish/lscolors.fish".source = ./etc/lscolors.fish;
    ".config/fish/functions/nixs.fish".source = ./shells/nixs.fish;
    ".config/fish/functions/nixd.fish".source = ./shells/nixd.fish;
  };

  home.sessionVariables = {
    "SUDO_PROMPT" = "[sudo 🐺] %p: ";
    "PAGER" = "${pkgs.moar}/bin/moar";
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [ username ];
    };
    gc.automatic = true;
  };

  nixGL = {
    packages = etcpkgs.nixGLPackages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  services.git-sync = {
    enable = true;
    repositories."nix" = {
      path = "${homeDir}/nix";
      uri = "https://github.com/mbekkomo/nix.git";
    };
  };

  services.arrpc = {
    enable = true;
    # systemdTarget = "default.target";
  };

  fonts.fontconfig.enable = true;

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      lua-language-server
      nil
      bash-language-server
      emmet-language-server
      zls
    ];
    settings = import ./configs/helix.nix { };
    languages = import ./configs/hx-langs.nix { };
  };

  programs.alacritty = {
    enable = true;
    package = wrapGL pkgs.alacritty;
    settings = import ./configs/alacritty.nix { themeDir = "${homeDir}/.config/alacritty/themes"; };
  };

  programs.zellij = {
    enable = true;
    settings = import ./configs/zellij.nix { };
  };

  programs.bun = {
    enable = true;
    package = bun;
  };

  programs.starship = {
    enable = true;
    settings = import ./configs/starship.nix { };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      zoxide init fish | source
      source ~/.config/fish/lscolors.fish

      set -Ux fifc_editor hx

      fish_vi_key_bindings
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_replace underscore
      set fish_cursor_visual block
    '';
    plugins =
      let
        plugin = x: {
          name = x.name;
          src = x.src;
        };
      in
      with pkgs.fishPlugins;
      [
        (plugin done)
        (plugin colored-man-pages)
        (plugin fifc)
        (plugin autopair)
        (plugin git-abbr)
      ];
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    extraOptions = [
      "--color=auto"
    ];
  };

  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;
    userName = "Komo";
    userEmail = "71205197+mbekkomo@users.noreply.github.com";
    extraConfig = {
      color.ui = true;
      color.diff-highlight = rec {
        oldNormal = [
          "red"
          "bold"
        ];
        oldHighlight = oldNormal ++ [ "52" ];
        newNormal = [
          "green"
          "bold"
        ];
        newHighlight = newNormal ++ [ "22" ];
      };
      color.diff = {
        meta = [ "11" ];
        frag = [
          "magenta"
          "bold"
        ];
        func = [
          "146"
          "bold"
        ];
        commit = [
          "yellow"
          "bold"
        ];
        old = [
          "red"
          "bold"
        ];
        new = [
          "green"
          "bold"
        ];
        whitespace = [
          "red"
          "bold"
        ];
      };
    };
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-poi
      gh-eco
      gh-screensaver
      gh-s
      gh-f
      gh-notify
      gh-markdown-preview
    ];
    settings.aliases = {
      rcl = "repo clone";
      rfk = "repo fork";
      rmv = "repo rename";
      rdl = "repo delete --yes";
    };
  };

  programs.wofi = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # TODO: Migrate to Nix expression
    settings = {
      "$terminal" = "alacritty";
    };
    importantPrefixes = [ "source" "$" "beizer" "name" ];
        extraConfig = ''            
          # This is an example Hyprland config file.
          # Refer to the wiki for more information.
          # https://wiki.hyprland.org/Configuring/Configuring-Hyprland/

          # Please note not all available settings / options are set here.
          # For a full list, see the wiki

          # You can split this configuration into multiple files
          # Create your files separately and then link them to this file like this:
          # source = ~/.config/hypr/myColors.conf

          ################
          ### MONITORS ###
          ################

          # See https://wiki.hyprland.org/Configuring/Monitors/
          monitor=,preferred,auto,auto

          ###################
          ### MY PROGRAMS ###
          ###################

          # See https://wiki.hyprland.org/Configuring/Keywords/

          # Set programs that you use
          $terminal = alacritty
          $fileManager = dolphin
          $menu = wofi --show drun

          #################
          ### AUTOSTART ###
          #################

          # Autostart necessary processes (like notifications daemons, status bars, etc.)
          # Or execute your favorite apps at launch like this:

          # exec-once = $terminal
          # exec-once = nm-applet &
          # exec-once = waybar & hyprpaper & firefox

          #############################
          ### ENVIRONMENT VARIABLES ###
          #############################

          # See https://wiki.hyprland.org/Configuring/Environment-variables/

          env = XCURSOR_SIZE,24
          env = HYPRCURSOR_SIZE,24

          #####################
          ### LOOK AND FEEL ###
          #####################

          # Refer to https://wiki.hyprland.org/Configuring/Variables/

          # https://wiki.hyprland.org/Configuring/Variables/#general
          general {
              gaps_in = 5
              gaps_out = 20

              border_size = 2

              # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
              col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
              col.inactive_border = rgba(595959aa)

              # Set to true enable resizing windows by clicking and dragging on borders and gaps
              resize_on_border = false

              # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
              allow_tearing = false

              layout = dwindle
          }

          # https://wiki.hyprland.org/Configuring/Variables/#decoration
          decoration {
              rounding = 10

              # Change transparency of focused and unfocused windows
              active_opacity = 1.0
              inactive_opacity = 1.0

              drop_shadow = true
              shadow_range = 4
              shadow_render_power = 3
              col.shadow = rgba(1a1a1aee)

              # https://wiki.hyprland.org/Configuring/Variables/#blur
              blur {
                  enabled = true
                  size = 3
                  passes = 1

                  vibrancy = 0.1696
              }
          }

          # https://wiki.hyprland.org/Configuring/Variables/#animations
          animations {
              enabled = true

              # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

              bezier = myBezier, 0.05, 0.9, 0.1, 1.05

              animation = windows, 1, 7, myBezier
              animation = windowsOut, 1, 7, default, popin 80%
              animation = border, 1, 10, default
              animation = borderangle, 1, 8, default
              animation = fade, 1, 7, default
              animation = workspaces, 1, 6, default
          }

          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          dwindle {
              pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
              preserve_split = true # You probably want this
          }

          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          master {
              new_status = master
          }

          # https://wiki.hyprland.org/Configuring/Variables/#misc
          misc {
              force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
              disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
          }

          #############
          ### INPUT ###
          #############

          # https://wiki.hyprland.org/Configuring/Variables/#input
          input {
              kb_layout = us
              kb_variant =
              kb_model =
              kb_options =
              kb_rules =

              follow_mouse = 1

              sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

              touchpad {
                  natural_scroll = false
              }
          }

          # https://wiki.hyprland.org/Configuring/Variables/#gestures
          gestures {
              workspace_swipe = false
          }

          # Example per-device config
          # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
          device {
              name = epic-mouse-v1
              sensitivity = -0.5
          }

          ###################
          ### KEYBINDINGS ###
          ###################

          # See https://wiki.hyprland.org/Configuring/Keywords/
          $mainMod = SUPER # Sets "Windows" key as main modifier

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          bind = $mainMod, Q, exec, $terminal
          bind = $mainMod, C, killactive,
          bind = $mainMod, M, exit,
          bind = $mainMod, E, exec, $fileManager
          bind = $mainMod, V, togglefloating,
          bind = $mainMod, R, exec, $menu
          bind = $mainMod, P, pseudo, # dwindle
          bind = $mainMod, J, togglesplit, # dwindle

          # Move focus with mainMod + arrow keys
          bind = $mainMod, left, movefocus, l
          bind = $mainMod, right, movefocus, r
          bind = $mainMod, up, movefocus, u
          bind = $mainMod, down, movefocus, d

          # Switch workspaces with mainMod + [0-9]
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, workspace, 6
          bind = $mainMod, 7, workspace, 7
          bind = $mainMod, 8, workspace, 8
          bind = $mainMod, 9, workspace, 9
          bind = $mainMod, 0, workspace, 10

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6
          bind = $mainMod SHIFT, 7, movetoworkspace, 7
          bind = $mainMod SHIFT, 8, movetoworkspace, 8
          bind = $mainMod SHIFT, 9, movetoworkspace, 9
          bind = $mainMod SHIFT, 0, movetoworkspace, 10

          # Example special workspace (scratchpad)
          bind = $mainMod, S, togglespecialworkspace, magic
          bind = $mainMod SHIFT, S, movetoworkspace, special:magic

          # Scroll through existing workspaces with mainMod + scroll
          bind = $mainMod, mouse_down, workspace, e+1
          bind = $mainMod, mouse_up, workspace, e-1

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          # Laptop multimedia keys for volume and LCD brightness
          bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
          bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
          bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
          bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

          # Requires playerctl
          bindl = , XF86AudioNext, exec, playerctl next
          bindl = , XF86AudioPause, exec, playerctl play-pause
          bindl = , XF86AudioPlay, exec, playerctl play-pause
          bindl = , XF86AudioPrev, exec, playerctl previous

          ##############################
          ### WINDOWS AND WORKSPACES ###
          ##############################

          # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
          # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

          # Example windowrule v1
          # windowrule = float, ^(kitty)$

          # Example windowrule v2
          # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

          # Ignore maximize requests from apps. You'll probably like this.
          windowrulev2 = suppressevent maximize, class:.*

          # Fix some dragging issues with XWayland
          windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
        '';
  };
}

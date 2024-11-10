{
  config,
  pkgs,
  lib,
  ...
}:
let
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
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.05";

  boot.loader.systemd-boot.enable = lib.mkDefault false;
  boot.loader.refind.enable = true;
  boot.loader.refind.extraConfig = ''
    enable_touch true
    include themes/rEFInd-minimal-dark/theme.conf
  '';
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    refind
    gptfdisk
    efibootmgr
  ];

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Makassar";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;

  services.greetd.enable = true;
  programs.regreet.enable = true;
  programs.regreet = {
    iconTheme = "Adwaita-Dark";
    theme = "Adwaita-Dark";
  };

  services.kmscon.enable = true;
  services.kmscon.hwRender = true;
  services.kmscon.fonts = [
    { name = "Departure Mono Nerd Font"; package = departure-nf; }
  ];

  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.openssh.enable = true;

  services.flatpak.enable = true;
  services.flatpak.packages = [
    "io.github.zen_browser.zen" # Browser
    "io.github.equicord.equibop" # Discord
    "im.fluffychat.Fluffychat" # Matrix
    "dev.toastbits.spmp"
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];

  users.users.komo = {
    isNormalUser = true;
    description = "Komo";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages =
      with pkgs;
      [
      ];
  };

  fonts.packages = with pkgs; [
    departure-nf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}

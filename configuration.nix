{ config, pkgs, lib, ... }:
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
  
  services.xserver.desktopManager.xfce.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
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
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}

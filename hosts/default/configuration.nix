# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# NOTE: If this is a fresh install, run these:
# sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
# sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# sudo nix-channel --update
# sudo nixos-rebuild switch --upgrade
# nix run home-manager/master -- init && sudo cp ~/.config/home-manager/home.nix /etc/nixos

{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  # Overwriting the login config so that Kmscon won't timeout the login after 60 seconds
  loginDefsContent = builtins.readFile ../../modules/system/login.defs;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/main-user.nix
    ../../modules/system/aliases.nix
    ../../modules/system/env-vars.nix
    ../../modules/system/packages.nix
    ../../modules/system/programs.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Preventing the laptop from sleeping on lid close
  services.logind.lidSwitchExternalPower = "ignore";

  environment.etc."login.defs".source = lib.mkForce (pkgs.writeText "login.defs" loginDefsContent);

  ### Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lab";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  ### Enable networking
  networking.networkmanager.enable = true;

  ### Locale
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_BE.UTF-8";
    LC_IDENTIFICATION = "fr_BE.UTF-8";
    LC_MEASUREMENT = "fr_BE.UTF-8";
    LC_MONETARY = "fr_BE.UTF-8";
    LC_NAME = "fr_BE.UTF-8";
    LC_NUMERIC = "fr_BE.UTF-8";
    LC_PAPER = "fr_BE.UTF-8";
    LC_TELEPHONE = "fr_BE.UTF-8";
    LC_TIME = "fr_BE.UTF-8";
  };

  ### Keymaps
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh_iso";
    model = "pc104";
    options = "caps:swapescape";
  };

  ### Users 
  main-user.enable = true;
  main-user.username = "zyr";

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      zyr = import ./home.nix;
    };
  };

  ### Fonts
  fonts.packages = with pkgs; [
    fira
    (nerdfonts.override { fonts = [ "FiraMono" ]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  ### SSH
  programs.ssh.startAgent = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.LogLevel = "DEBUG";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

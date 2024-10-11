# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# NOTE: If this is a fresh install, run these:
# sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
# sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# sudo nix-channel --update
# sudo nixos-rebuild switch --upgrade
# nix run home-manager/master -- init && sudo cp ~/.config/home-manager/home.nix /etc/nixos

{ config, pkgs, inputs, ... }:

let
    yy = import ../../scripts/yazi.nix { inherit pkgs; };
in
{
    imports = [
        ./hardware-configuration.nix
        ../../modules/nixos/main-user.nix
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Preventing the laptop from sleeping on lid close
    services.logind.lidSwitchExternalPower = "ignore";

    ### Aliases
    environment.shellAliases = {
        nrb = "sudo nixos-rebuild switch --flake ~/.config/nixos/#default";
        ned = "nvim ~/.config/nixos/hosts/default/configuration.nix";
        hed = "nvim ~/.config/nixos/hosts/default/home.nix";
        ll = "ls -l";
        lg = "lazygit";
        nst = "npm start";
        got = "go test ./...";
        qc = "qmk compile -e CONVERT_TO=promicro_rp2040 -km colemak-v1";
        brs = "browsh --startup-url https://search.nixos.org";
    };

    ### Env vars
    environment.variables = {
        EDITOR = "nvim";
        TERM = "screen-256color";
    };

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
        options = "caps:swapescape";
    };

    # TODO: remove this if it became useless
    # Configuring for TTy
    # console.useXkbConfig = true;

    ### Users 
    main-user.enable = true;
    main-user.username = "zyr";

    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = { zyr = import ./home.nix; };
    };
    
    # security.sudo.extraRules = [{
    #     users = [ "zyr" ];
    #     commands = [{
    #         command = "ALL";
    #         options = [ "NOPASSWD" "SETENV" ];
    #     }];
    # }];

    ### Fonts
    fonts.packages = with pkgs; [ 
        fira
        (nerdfonts.override { fonts = [ "FiraMono" ]; })
    ];

    ### Packages
    nixpkgs.config = {
        allowUnfree = true;
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        # Custom
        yy

        # Repo
        curl
        wget
        nix-search-cli
        gh
        go
        ripgrep
        golangci-lint
        imagemagick
        lua
        luarocks
        fzf
        ngrok
        jq
        stylua
        cargo
        clang
        gcc
        gnumake
        nodejs
        zip
        unzip
        libconfig
        neofetch
        qmk
        browsh
        bat
        sword
        ruby
    ];

    # Global Configuration
    programs = {
        nix-ld = {
            enable = true;
        };

        tmux = {
            enable = true;
            escapeTime = 10;
            keyMode = "vi";
            terminal = "screen-256color";
            historyLimit = 50000;

            extraConfig = 
            ''
                set -g default-terminal "''${TERM}"
                set -g terminal-overrides "''${TERM}"
                set -ga terminal-overrides ",screen-256color:Tc"
                set -as terminal-overrides ",*:Smulx=\E[4::%p1%dm" # undercurl support
                set -as terminal-overrides ",*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m" # underscore colors - needs tmux-3.0

            '';
        };

        neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
        };


        lazygit = {
            enable = true;
            settings = {
                os = {
                    editPreset = "nvim";
                };
                gui = {
                    nerdFontsVersion = "3";
                    showFileTree = false;
                    theme = {
                        selectedBgColor = "1e4273";
                    };
                };
            };
        };

        yazi = {
            enable = true;
            settings = {
                theme = {
                    status = {
                        separator_open = "";
                        separator_close = "";
                        separator_style = { 
                            fg = "#45475a";
                            bg = "#45475a";
                        };
                    };

                    mode_normal = { 
                        fg = "#0d1117";
                        bg = "#58a6ff";
                        bold = false;
                    };
                    mode_select = { 
                        fg = "#0d1117";
                        bg = "#1e4273";
                        bold = false;
                    };
                    mode_unset = { 
                        fg = "#0d1117";
                        bg = "#c9d1d9";
                        bold = false;
                    };
                };
            };
        };

        firefox = {
            enable = true;
            languagePacks = [ "en-US" "fr" "es-ES" ];
        };
    };

    services.kmscon = {
        enable = true;
        useXkbConfig = true;
        fonts = [{ name = "Fira Mono"; package = pkgs.fira; }];
    };

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

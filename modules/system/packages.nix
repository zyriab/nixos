{ pkgs, ... }:

let
    yy = import ../../scripts/yazi.nix { inherit pkgs; };
in
{
    config = {
        nixpkgs.config = {
            allowUnfree = true;
        };


        # List packages installed in system profile. To search, run:
        # $ nix search wget
        environment.systemPackages = with pkgs; [
            # Custom
            yy

            # Repo
            bat
            browsh
            cargo
            curl
            fd
            gh
            imagemagick
            jq
            neofetch
            nix-search-cli
            nodejs
            qmk
            redshift
            ungoogled-chromium
            wget
            zip

            # Dev tools
            air
            go
            harlequin
            lua
            postman
            ruby
            templ

            # Neovim deps
            clang
            clang-tools
            delve
            fzf
            gcc
            gnumake
            go-tools
            golangci-lint
            libconfig
            luarocks
            nixd
            nixpkgs-fmt
            prettierd
            ripgrep
            stylua
            sword
            unzip

            # AVR
            arduino-cli
            avrdude
            pkgsCross.avr.buildPackages.gcc # avr-gcc

            # yazi deps
            ffmpegthumbnailer
            poppler
            unar
        ];
    };

}

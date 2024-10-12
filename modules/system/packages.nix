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
            nixd
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
            clang-tools
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
            ungoogled-chromium
            postman
            redshift
            fd

            # yazi deps
            ffmpegthumbnailer
            unar
            poppler
        ];
    };
}

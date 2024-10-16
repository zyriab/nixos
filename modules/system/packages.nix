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
      lsof
      neofetch
      nix-search-cli
      nodejs
      qmk
      redshift
      ungoogled-chromium
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
      nixfmt-rfc-style
      prettierd
      ripgrep
      stylua
      sword
      unzip
      icu
      wget

      # AVR
      avrdude
      pkgsCross.avr.buildPackages.gcc # avr-gcc

      # yazi deps
      ffmpegthumbnailer
      poppler
      unar
    ];
  };

}

{ config, pkgs, ... }:

{
    config={
        # Better tty
        services.kmscon = {
            enable = true;
            useXkbConfig = true;
            fonts = [{ name = "Fira Mono"; package = pkgs.fira; }];
        };

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
    };
}

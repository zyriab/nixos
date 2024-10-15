{ ... }:

{
  config = {
    environment.shellAliases = {
      brs = "browsh";
      got = "go test ./...";
      hed = "nvim ~/.config/nixos/hosts/default/home.nix";
      lg = "lazygit";
      ll = "ls -l";
      ncg = "nvim ~/.config/nixos/";
      ned = "nvim ~/.config/nixos/hosts/default/configuration.nix";
      nrb = "sudo nixos-rebuild switch --flake ~/.config/nixos/#default";
      nst = "npm start";
      qc = "qmk compile -e CONVERT_TO=promicro_rp2040 -km colemak-v1";
      tmx = "tmux new -A -s lab";
    };
  };
}

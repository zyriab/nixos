{ ... }:

{
  config = {
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
  };
}

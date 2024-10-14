{ ... }:

{
  config = {
    environment.variables = {
      EDITOR = "nvim";
      TERM = "screen-256color";

      # Using Neovim as manpager
      MANPAGER = "nvim +Man!";
      MANWIDTH = 999;
    };
  };
}

{ pkgs }:

pkgs.writeShellApplication {
  name = "yy-function";
  runtimeInputs = [ pkgs.yazi ];
  text = ''
    #!/bin/sh

    # Define the yy function
    function yy() {
        local tmp
        tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }

    # Export the function to make it available in subshells
    export -f yy
  '';
}

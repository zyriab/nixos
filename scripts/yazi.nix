{ pkgs }:

# See https://yazi-rs.github.io/docs/quick-start#shell-wrapper
pkgs.writeShellApplication {
    name = "yy";
    runtimeInputs = [];
    text =  ''
        tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"

        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi

        rm -f -- "$tmp"
    '';
}

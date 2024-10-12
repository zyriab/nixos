{ pkgs }:

pkgs.writeTextFile {
    name = "yy-function";
    destination = "/share/yy-function";
    text = ''
        function yy() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
            ${pkgs.yazi}/bin/yazi "$@" --cwd-file="$tmp"
            if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                cd -- "$cwd"
            fi
            rm -f -- "$tmp"
        }
    '';
}

{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in
    {
      devShells."x86_64-linux".default = pkgs.mkShell {

        # dependencies
        packages = [
          pkgs.nodejs
          pkgs.go
          pkgs.gotools
        ];

        # pulls the deps from the specified packages
        inputsFrom = [ pkgs.bat ];

        shellHook = # bash
          ''
            echo "Welcome to the shell"
          '';

        # Anything not recognize as a shell option will become an env var
        test = "this is an env var";
        MY_VAR = 42;
      };
    };
}

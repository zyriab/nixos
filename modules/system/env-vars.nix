
{ lib, config,  ... }:

{
    config = {
        environment.variables = {
            EDITOR = "nvim";
            TERM = "screen-256color";
        };
    };
}
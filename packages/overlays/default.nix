{ ... }:
let
  entries = builtins.readDir ./.;
  overlayFiles = builtins.filter (
    name:
    name != "default.nix" && entries.${name} == "regular" && builtins.match ".*\\.nix" name != null
  ) (builtins.attrNames entries);
in
{
  nixpkgs.overlays = builtins.map (name: import (./. + "/${name}")) overlayFiles;
}

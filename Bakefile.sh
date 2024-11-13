#!/usr/bin/env bash

nix() {
  command nix --extra-experimental-features "nix-command flakes" "$@"
}
export -f nix

task.switch() {
  local locked_hm
  locked_hm="$(nix eval --impure --raw --expr '(builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.home-manager.locked.rev')"
  nix run github:nix-community/home-manager/"${locked_hm}" -- switch --impure --flake .#goat
}

## TODO: Use Nix formatters to reduce bottlenecks
task.fmt() {
  nix run nixpkgs#fd -- -e nix -X nix run nixpkgs#nixfmt-rfc-style {}
}

{
  description = "HP 240 G5 Notebook NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-flatpak.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, nix-flatpak, ... }@inputs:
    let
      system = "x86_64-linux";
      refindCommit = "5a690248b9072ab5ebb5200cfc8a76361d720a89";
    in
    {
      nixosConfigurations.goat = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          (builtins.fetch)
          ./configuration.nix
        ];
      };
    };
}

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
      refindCommit = "8f539dc72d1a1d56adb8d434b4ba85bd3e63cf6d";
    in
    {
      nixosConfigurations.goat = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          (builtins.fetchTarball { url = refindCommit; } + /refind.nix)
          ./configuration.nix
        ];
      };
    };
}

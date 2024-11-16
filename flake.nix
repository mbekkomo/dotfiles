{
  description = "-goat noises and yaps about home-manager-";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-search-cli = {
      url = "github:peterldowns/nix-search-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-search-cli,
      nixGL,
      declarative-cachix,
      nix-index-database,
      catppuccin-alacritty,
      ...
    }:
    let
      system =
        let
          x = (builtins.getEnv "NIXPKGS_SYSTEM");
        in
        if x == "" then "x86_64-linux" else x;
      pkgs = import nixpkgs { inherit system; };
    in
    {
      homeConfigurations.goat = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          declarative-cachix.homeManagerModules.declarative-cachix
          nix-index-database.hmModules.nix-index
          ./home.nix
        ];
        extraSpecialArgs.etcpkgs = {
          nix-search = nix-search-cli.outputs.packages.${system}.nix-search;
          nixGLPackages = nixGL.outputs.packages.${system};
        };
        extraSpecialArgs.vendor = {
          inherit
            catppuccin-alacritty
            ;
        };
      };
    };
}

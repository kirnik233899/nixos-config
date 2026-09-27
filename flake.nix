{
  description = "kirnik233899's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      niri,
      disko,
      stylix,
      sops-nix,
      treefmt-nix,
      git-hooks,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.nixfmt.strict = true;
        programs.statix.enable = true;
        programs.deadnix.enable = true;
      };

      mkHost =
        host:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            disko.nixosModules.disko
            niri.nixosModules.niri
            stylix.nixosModules.stylix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            ./hosts/${host}/configuration.nix
            ./hosts/${host}/disko.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [ inputs.zen-browser.homeModules.beta ];
              home-manager.users.kirnik233899 = import ./home/${host}.nix;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        pc = mkHost "pc";
        laptop = mkHost "laptop";
      };

      formatter.${system} = treefmtEval.config.build.wrapper;

      checks.${system}.formatting = treefmtEval.config.build.check self;

      devShells.${system}.default =
        let
          pre-commit = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
              statix.enable = true;
              deadnix.enable = true;
            };
          };
        in
        pkgs.mkShell {
          inherit (pre-commit) shellHook;
          buildInputs =
            pre-commit.enabledPackages
            ++ (with pkgs; [
              nixd
              sops
              ssh-to-age
              age
            ]);
        };
    };
}

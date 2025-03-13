{
    description = "Nixos config flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
	unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        Neve = {
            url = "github:redyf/Neve";
        };

        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        zen-browser.url = "github:0xc000022070/zen-browser-flake";

        minimal-tmux = {
            url = "github:niksingh710/minimal-tmux-status";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, ... }@inputs: {
        nixosConfigurations = {
            littlebox = nixpkgs.lib.nixosSystem {
                specialArgs = {inherit inputs;};
                modules = [
                    ./hosts/littlebox/configuration.nix
                    ./modules/networking.nix
                    inputs.home-manager.nixosModules.default
                    inputs.nixvim.nixosModules.nixvim
                ];
            };
	   bigbox = nixpkgs.lib.nixosSystem {
               specialArgs = {inherit inputs;};
               modules = [
                    ./hosts/bigbox/configuration.nix
                    ./modules/networking.nix
                    inputs.home-manager.nixosModules.default
                    inputs.nixvim.nixosModules.nixvim
	       ];   
        };
	};
    };
}

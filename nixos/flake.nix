{
	description = "NixOS WSL config";
	inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

	nixos-wsl = {
      		url = "github:nix-community/NixOS-WSL";
      		inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = {nixpkgs, nixos-wsl, ... }: {
	nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        nixos-wsl.nixosModules.default
        ./configuration.nix
      ];
    };
};
}

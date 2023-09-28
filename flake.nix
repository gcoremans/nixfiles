{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
	};

	outputs = { self, nixpkgs, ... } @ inputs: let
		inherit (self) outputs;
		systems = [
			"x86_64-linux"
			"aarch64-linux"
		];
		forAllSystems = nixpkgs.lib.genAttrs systems;
		authorizedKeys = import ./authorized_keys.nix;
	in {
		nixosConfigurations = {
			# Pending:
			nyave = nixpkgs.lib.nixosSystem {
				specialArgs = {inherit inputs outputs authorizedKeys;};
				modules = [
					./nixos/common.nix
					./nixos/nyave.nix
				];
			};
		};
	};
}

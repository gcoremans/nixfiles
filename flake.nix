{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
	};

	outputs = { self, nixpkgs, nixpkgs-unstable, ... } @ inputs: let
		inherit (self) outputs;
		systems = [
			"x86_64-linux"
			"aarch64-linux"
		];
		forAllSystems = nixpkgs.lib.genAttrs systems;
		authorizedKeys = import ./authorized_keys.nix;
	in {
		nixosConfigurations = {
			nyave = nixpkgs-unstable.lib.nixosSystem {
				specialArgs = {inherit inputs outputs authorizedKeys;};
				modules = [
					./hosts/common.nix
					./hosts/nyave.nix

					./sites/altijdmoe.nix
				];
			};
			aesma = nixpkgs-unstable.lib.nixosSystem {
				specialArgs = {inherit inputs outputs authorizedKeys;};
				modules = [
					./hosts/common.nix
					./hosts/nyave.nix

					#./sites/operandbe.nix
					#./sites/altijdmoe.nix

					./modules/haproxy/default.nix
					./modules/kanidm/default.nix
				];
			};
		};
	};
}

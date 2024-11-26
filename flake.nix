{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
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
		myArgs = {inherit inputs outputs authorizedKeys nixpkgs-unstable;};
	in {
		nixosConfigurations = {
			# VPS
			aesma = nixpkgs.lib.nixosSystem {
				specialArgs = myArgs;
				modules = [
					./hosts/common.nix
					./hosts/aesma.nix

					./sites/operandbe.nix
					./sites/altijdmoe.nix

					./modules/haproxy/default.nix
					./modules/kanidm/server.nix
					./modules/actualbudget/default.nix
				];
			};
			# NAS
			voya = nixpkgs.lib.nixosSystem {
				specialArgs = myArgs;
				modules = [
					./hosts/common.nix
				];
			};
			# Raspberry pi/media center
			gog = nixpkgs.lib.nixosSystem {
				specialArgs = myArgs;
				modules = [
					./hosts/common.nix
				];
			};
			# Staging/testing
			nyave = nixpkgs.lib.nixosSystem {
				specialArgs = myArgs;
				modules = [
					./hosts/common.nix
					./hosts/nyave.nix
				];
			};
		};
	};
}

{
	inputs = {
		nixpkgs-2411.url = "github:NixOS/nixpkgs/nixos-24.11";
		nixpkgs-2405.url = "github:NixOS/nixpkgs/nixos-24.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-local.url = "path:/home/gilles/stuff/nixpkgs-local";

		colmena.url = "github:zhaofengli/colmena";
	};

	outputs = { self, nixpkgs-2411, nixpkgs-2405, nixpkgs-unstable, nixpkgs-local, colmena, ... } @ inputs: let
		inherit (self) outputs;

		lib = nixpkgs-2411.lib;

		authorizedKeys = import ./authorized_keys.nix;
		myArgs = {inherit inputs outputs authorizedKeys nixpkgs-2411 nixpkgs-unstable nixpkgs-local;};

		conf = self.nixosConfigurations;

		colmenaNodesDefault = builtins.mapAttrs (name: value: {
			imports = value._module.args.modules;
			deployment.targetHost = "${name}.intern.altijd.moe";
		}) conf;

	in {
		nixosConfigurations = {
			# VPS
			aesma = lib.nixosSystem {
				system = "aarch64-linux";
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
			#voya = lib.nixosSystem {
			#	system = "x86_64-linux";
			#	specialArgs = myArgs;
			#	modules = [
			#		./hosts/common.nix
			#	];
			#};
			# Raspberry pi/media center
			gog = nixpkgs-2405.lib.nixosSystem {
				system = "armv7l-linux";

				specialArgs = myArgs;
				modules = [
					# No common because it's small and no cache
					./hosts/gog.nix
					./modules/kodi/configuration.nix
				];
			};
			# Staging/testing
			nyave = lib.nixosSystem {
				system = "aarch64-linux";
				specialArgs = myArgs;
				modules = [
					./hosts/common.nix
					./hosts/nyave.nix
				];
			};
		};

		colmenaHive = colmena.lib.makeHive self.outputs.colmena;

		colmena = {
			meta = {
				nixpkgs = import inputs.nixpkgs-2411 { system = "x86_64-linux"; };
				nodeNixpkgs = builtins.mapAttrs (name: value: value.pkgs) conf; # Beware: https://github.com/zhaofengli/colmena/issues/60#issuecomment-1849931304
				nodeSpecialArgs = builtins.mapAttrs (name: value: value._module.specialArgs) conf;
			};

			defaults.deployment = {
				buildOnTarget = lib.mkDefault true;
				targetUser = lib.mkDefault "root";
			};
		} // lib.attrsets.recursiveUpdate colmenaNodesDefault {
			gog = {
				deployment = {
					buildOnTarget = lib.mkForce false;
					targetHost = "192.168.1.172";
				};
			};
		};
	};
}

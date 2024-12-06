{
	inputs = {
		nixpkgs-2411.url = "github:NixOS/nixpkgs/nixos-24.11";
		nixpkgs-2405.url = "github:NixOS/nixpkgs/nixos-24.05";

		colmena.url = "github:zhaofengli/colmena";
	};

	outputs = { self, nixpkgs-2411, nixpkgs-2405, colmena, ... } @ inputs: let
		inherit (self) outputs;

		lib = nixpkgs-2411.lib;

		myArgs = {inherit inputs outputs nixpkgs-2411;};

		conf = self.nixosConfigurations;

		colmenaNodesDefault = builtins.mapAttrs (name: value: {
			imports = value._module.args.modules;
		}) conf;

	in {
		nixosConfigurations = {
			# Raspberry pi/media center
			gog = nixpkgs-2405.lib.nixosSystem {
				system = "armv7l-linux";

				specialArgs = myArgs;
				modules = [
					./gog.nix
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
				};
			};
		};
	};
}

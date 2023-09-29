{ inputs, outputs, authorizedKeys, lib, config, pkgs, ... }:
{
  imports = [ ./fish ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    dig
    exa
    fish
    git
    iputils
    neovim
    nslookup
    ripgrep
  ];

  users = {
    defaultUserShell = pkgs.fish;

    users = {
      gilles = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = authorizedKeys;
      };
    };
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}

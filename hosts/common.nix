{ inputs, outputs, authorizedKeys, lib, config, pkgs, ... }:
{
  imports = [
    ../modules/fish
  ];

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

  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
  };
}

{ inputs, outputs, authorizedKeys, lib, config, pkgs, ... }:
{
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

  evironment.shells = [ pkgs.fish ];

  programs.fish = {
    enable = true;

    vendor.completions.enable = true;
    vendor.config.enable = true;

    shellAbbrs = {
      dd = "dd bs=256K status=progress";
      py = "python3";
      ss = "ss -ptua";
    };
  };

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

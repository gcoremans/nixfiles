{ inputs, outputs, authorizedKeys, lib, config, pkgs, ... }:
{
  imports = [
    ../modules/fish
    ../modules/neovim
    ../modules/ssh
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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # SSH
      80 443 # HTTP(S)
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    dig
    fish
    git
    iputils
    neovim
    ripgrep
    bind
    python3
    openssl_3_1
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

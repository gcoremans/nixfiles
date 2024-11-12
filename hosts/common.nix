{ inputs, outputs, authorizedKeys, nixpkgs-unstable, lib, config, pkgs, ... }:
{
  imports = [
    ../modules/fish
    ../modules/neovim
    ../modules/ssh
    ../modules/kanidm/client.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
        };
      })
    ];
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
    # Basic tools
    coreutils-full
    fish
    git
    neovim

    # Networking
    dig
    bind
    iputils
    curl
    wget

    # Programming environments
    python3

    # Database clients
    mariadb
    sqlite
    postgresql

    # File manipulation
    ## Compression
    gnutar
    zip
    unzip
    gzip
    xz
    zstd
    ## Search/replace
    ripgrep
    gnused

    # Misc
    openssl_3_3
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

{ inputs, outputs, authorizedKeys, nixpkgs-unstable, lib, config, pkgs, ... }:
{
  imports = [
    ../modules/fish
    ../modules/ssh
  ];

  networking.hostName = "gog";
  system.stateVersion = "24.05";

  networking.wireless = {
    enable = true;

    environmentFile = "/var/psk.env";
    networks."Aperture Science" = {
      psk = "@PSK_WIFI@";
    };
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.timeout = 1;
  system.activationScripts.patchBootScript = "${pkgs.gnused}/bin/sed -i 's/TIMEOUT [0-9]*/PROMPT 0/g' /boot/extlinux/extlinux.conf";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };

  networking.useDHCP = true;

  nixpkgs = {
    hostPlatform.system = "armv7l-linux";
    buildPlatform.system = "x86_64-linux";
    config = {
      allowUnsupportedSystem = true;
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
    ];
  };

  environment.systemPackages = with pkgs; [
    # Basic tools
    coreutils-full
    fish
    git
    vim

    # Networking
    dig
    bind
    iputils
    curl
    wget

    # Programming environments
    python3

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

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  programs.vim = {
    defaultEditor = true;
  };

  users = {
    defaultUserShell = pkgs.fish;

    users = {
      root = {
        openssh.authorizedKeys.keys = authorizedKeys;
      };
    };
  };

  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "prohibit-password";
  };
}

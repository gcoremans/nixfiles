{ inputs, outputs, authorizedKeys, nixpkgs-2411, nixpkgs-unstable, lib, config, pkgs, ... }:
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

  # Dont prompt on boot
  boot.loader.timeout = 1;
  system.activationScripts.patchBootScript = "${pkgs.gnused}/bin/sed -i 's/TIMEOUT [0-9]*/PROMPT 0/g' /boot/extlinux/extlinux.conf";

  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems.zfs = lib.mkForce false; # Doesn't compile on armv7l
  boot.kernelParams = ["console=ttyS0,115200n8" "console=ttymxc0,115200n8" "console=ttyAMA0,115200n8" "console=ttyO0,115200n8" "console=ttySAC2,115200n8" "console=tty0"];

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
      #(final: prev: {
      #  unstable = import nixpkgs-unstable {
      #    localSystem = "x86_64-linux";
      #    crossSystem = "armv7l-linux";
      #    config = {
      #      allowUnsupportedSystem = true;
      #      allowUnfree = true;
      #    };
      #  };
      #})
      (final: prev: {
        inherit (import nixpkgs-2411 {
          localSystem = "x86_64-linux";
          crossSystem = "armv7l-linux";
          config = {
            allowUnsupportedSystem = true;
            allowUnfree = true;
          };
        }) kodi;
      })
      (final: prev: {
        openjdk11_headless = ((prev.openjdk11_headless.override {
          # libIDL does not compile in cross-compile scenarios.
          enableGnome2 = false;
        }).overrideAttrs (old: with prev; {
          # This might work if `autoconf` is put into `depsBuildBuild`? Didn’t test.
          AUTOCONF = "${autoconf}/bin/autoconf";
          strictDeps = true;
          nativeBuildInputs = old.nativeBuildInputs ++ [ which buildPackages.zip zlib perl ];
          buildInputs = with xorg; [
            cpio file perl zlib cups freetype harfbuzz alsa-lib libjpeg giflib
            libpng zlib lcms2 libX11 libICE libXrender libXext libXtst libXt libXtst
            libXi libXinerama libXcursor libXrandr fontconfig
          ];
          # Required by autoconf even though this isn't actually getting used AFAIK.
          depsBuildBuild = with buildPackages; [ stdenv.cc ];
          configureFlags = let
            jdk-bootstrap = buildPackages.openjdk11-bootstrap.override {
              # when building a headless jdk, also bootstrap it with a headless jdk
              gtkSupport = false;
            };
          in
            old.configureFlags
            ++ [ # Not sure if these are necessary, just makes builds take less time I think
              "--with-jtreg=no"
              "--disable-hotspot-gtest"
            ]
            # The important part, this avoids building a jdk for --build target.
            ++ lib.optional (buildPlatform != hostPlatform) [
              "--with-build-jdk=${buildPackages.openjdk11_headless}"
              "--with-boot-jdk=${jdk-bootstrap.home}"
            ];
        }));
        jdk11_headless = final.openjdk11_headless;
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
    (pkgs.vim.customize {
      name = "vim";
      vimrcConfig.packages.default = {
        start = [ pkgs.vimPlugins.vim-nix ];
      };
      vimrcConfig.customRC = ''
        set number
        set hidden
        set mouse=a

        set tabstop=4 shiftwidth=4 noexpandtab
        set listchars=tab:»\
        highlight Whitespace ctermfg=grey
        set list

        set undofile undodir=~/.config/nvim/tmp/undo//
      '';
    })

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
        password = "";
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

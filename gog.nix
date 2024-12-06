{ inputs, outputs, nixpkgs-2411, lib, config, pkgs, ... }:
{
  networking.hostName = "gog";
  system.stateVersion = "24.05";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems.zfs = lib.mkForce false; # Doesn't compile on armv7l

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };


  environment.systemPackages = [ pkgs.kodi-wayland ];

  nixpkgs = {
    hostPlatform.system = "armv7l-linux";
    buildPlatform.system = "x86_64-linux";
    config = {
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
    overlays = [
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
      (final: prev: {
        kodi-wayland = prev.kodi-wayland.overrideAttrs (old: {
          preConfigure = ''
            echo "fail"; exit 1
          '';
        });
      })
    ];
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };
}

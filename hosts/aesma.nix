{ inputs, outputs, authorizedKeys, modulesPath, lib, config, pkgs, ... }:
{
  networking.hostName = "aesma";
  system.stateVersion = "24.05";

  users.users = {
    root = {
      openssh.authorizedKeys.keys = authorizedKeys;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.settings.PermitRootLogin = "prohibit-password";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_scsi" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e80f9ae3-a39e-474d-b5f1-050bf15d917f";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9152-1F73";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  networking = {
    useDHCP = true;
    interfaces.enp1s0 = {
      ipv6.addresses = [{
        address = "2a01:4f8:c013:833f::1";
        prefixLength = 64;
      }];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };
}

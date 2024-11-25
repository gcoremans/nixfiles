{ inputs, outputs, authorizedKeys, modulesPath, lib, config, pkgs, ... }:
{
  networking.hostName = "nyave";
  system.stateVersion = "23.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.settings.PermitRootLogin = "prohibit-password";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b012e766-7cab-4a2c-9031-fc24946e05fa";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7D28-308C";
      fsType = "vfat";
    };

  networking.useDHCP = lib.mkDefault true;
}

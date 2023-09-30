{ inputs, outputs, authorizedKeys, lib, config, pkgs, ... }:
{
  networking.hostName = "nyave";
  system.stateVersion = "23.05";

  users.users = {
    root = {
      openssh.authorizedKeys.keys = authorizedKeys;
    };
  };

  services.openssh.permitRootLogin = "yes";

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

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}

# Declarative partitioning for the EMPTY 1TB SSD.
# Windows on the 2TB SSD is NOT touched.
#
# Layout:
#   1) ESP  1 GiB    vfat   /boot     (NixOS bootloader, separate from Windows ESP)
#   2) swap 8 GiB
#   3) root 100%     btrfs   (compress=zstd:3, subvols @, @home, @nix, @log, @snapshots)
#
# REPLACE the placeholder device path before installing.
# Get the real by-id symlink from the live ISO:
#   ls -l /dev/disk/by-id/ | grep -i samsung
# and pick the 1TB drive (size ~931G).
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # CHANGE ME: replace with the real by-id path of the empty 1TB SSD.
        # Example: "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S7DXNJ0XB12345A"
        device = "/dev/disk/by-id/REPLACE_ME";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              size = "8G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = false;
              };
            };

            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-L" "nixos" "-f" ];
                subvolumes = {
                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [ "subvol=@" "compress=zstd:3" "noatime" "ssd" "discard=async" "space_cache=v2" ];
                  };
                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "subvol=@home" "compress=zstd:3" "noatime" "ssd" "discard=async" "space_cache=v2" ];
                  };
                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "subvol=@nix" "compress=zstd:3" "noatime" "ssd" "discard=async" "space_cache=v2" ];
                  };
                  "/@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "subvol=@log" "compress=zstd:3" "noatime" "ssd" "discard=async" "space_cache=v2" ];
                  };
                  "/@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [ "subvol=@snapshots" "compress=zstd:3" "noatime" "ssd" "discard=async" "space_cache=v2" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

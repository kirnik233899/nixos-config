#   1) ESP  1 GiB    vfat   /boot
#   2) swap 8 GiB
#   3) root 100%     btrfs   (compress=zstd:3, subvols @, @home, @nix, @log, @snapshots)
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SKHynix_HFS001TFM9X178N_BIE2N008711702M5J";
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

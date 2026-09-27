{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S6Z1NJ0W327090L";
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
            extraArgs = [
              "-L"
              "nixos"
              "-f"
            ];
            subvolumes = {
              "/@" = {
                mountpoint = "/";
                mountOptions = [
                  "subvol=@"
                  "compress=zstd:3"
                  "noatime"
                ];
              };
              "/@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "subvol=@nix"
                  "compress=zstd:3"
                  "noatime"
                ];
              };
              "/@home" = {
                mountpoint = "/home";
                mountOptions = [
                  "subvol=@home"
                  "compress=zstd:3"
                  "noatime"
                ];
              };
              "/@home/.snapshots" = { };
              "/@log" = {
                mountpoint = "/var/log";
                mountOptions = [
                  "subvol=@log"
                  "compress=zstd:3"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
  disko.devices.disk.games = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S6Z2NF0W716039H";
    content = {
      type = "gpt";
      partitions.games = {
        size = "100%";
        content = {
          type = "btrfs";
          extraArgs = [
            "-L"
            "games"
            "-f"
          ];
          subvolumes."/@games" = {
            mountpoint = "/home/kirnik233899/Games";
            mountOptions = [
              "subvol=@games"
              "compress=zstd:3"
              "noatime"
              "nofail"
            ];
          };
        };
      };
    };
  };
}

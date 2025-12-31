{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n0";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G"; # Adjust based on how many kernel images you want
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ]; # To ensure only root user can read/write
              };
            };
            Swap = {
              size = "24G"; # Adjust based on installed RAM
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true; # Enables Hibernation
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                  keyFile = "~/secret.key";
                };
                content = {
                  type = "filesystem";
                  format = "btrfs";
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ]; # Disk compression and writing access time prevention
                };
              };
            };
          };
        };
      };
    };
  };
}

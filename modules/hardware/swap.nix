{...}: {
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 48 * 1024; # 24 GB
    }
  ];
}

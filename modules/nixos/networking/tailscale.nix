{ ... }:
{
  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--no-logs-no-support" ];
}

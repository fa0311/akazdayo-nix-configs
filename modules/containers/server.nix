{ ... }:
{
  imports = [
    ./adguard-home.nix
    ./immich.nix
    ./nextcloud.nix
    ./yomiage.nix
  ];

  virtualisation.oci-containers.backend = "docker";
}

{ inputs, ... }:
{
  imports = [
    inputs.minecraft-nix.nixosModules.default
  ];

  services.minecraft-servers.survival = {
    enable = true;
    eula = true;
    lockFile = ./minecraft-server-lock.json;

    software = {
      type = "fabric";
      minecraftVersion = "1.21.4";
      fabric = {
        loaderVersion = "0.19.2";
        launcherVersion = "1.1.1";
      };
    };

    mods.modrinth = [
      {
        project = "lithium";
      }
    ];

    port = 25565;
    openFirewall = true;
  };
}

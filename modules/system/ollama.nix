{ pkgs-unstable, ... }:
{

  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama;
    loadModels = ["gemma4:26b"];
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };
  };
}

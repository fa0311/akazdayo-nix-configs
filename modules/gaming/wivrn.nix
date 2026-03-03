{pkgs, ...}: {
  services.wivrn = {
    enable = true;
    openFirewall = true;
    defaultRuntime = true;
    autoStart = true;
    steam.importOXRRuntimes = true;
    package = pkgs.wivrn.override {cudaSupport = true;};
  };
}

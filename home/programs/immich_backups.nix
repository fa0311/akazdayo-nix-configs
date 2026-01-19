{pkgs, ...}: let 
  linuxVRChatFolder = "/home/akazdayo/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat";
  windowsVRChatFolder = "/mnt/windows/Users/keenb/OneDrive/画像/VRChat";

  backupsFolder = pkgs.linkFarm "immichBackups" [
    { name = "linuxVRChatFolder"; path=linuxVRChatFolder; }
    { name = "windowsVRChatFolder"; path=windowsVRChatFolder; }
  ];
in {

}

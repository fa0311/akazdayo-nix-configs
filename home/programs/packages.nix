{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages =
    (with pkgs; [
      devenv
      vim
      nixd
      nil
      alejandra
      nixfmt
      starship
      fastfetch
      tree
      xdg-utils
      wl-clipboard
      slack
      ghostty
      libreoffice
      signal-desktop
      termius
      jq
      wget
      lmstudio
      wlx-overlay-s
      tor-browser
      alcom
      _1password-gui
      google-chrome
      osu-lazer-bin
      nautilus
      code-cursor
      unar
      kooha
      yt-dlp
      ffmpeg
      btop-cuda
      tailscale
      lazygit

      # Hyprlandエコシステム
      fuzzel # アプリランチャー
      swww # 壁紙(アニメーション対応)
      grim # スクリーンショット
      slurp # 領域選択
      swappy # スクリーンショット編集
      cliphist # クリップボード履歴
      swaylock-effects # スクリーンロック
      swayidle # アイドル管理
      brightnessctl # 輝度調整
      playerctl # メディアコントロール
      pavucontrol # 音量設定GUI
      networkmanagerapplet # ネットワーク管理
      blueman # Bluetooth管理
      wlogout # ログアウトメニュー
      hyprpicker # カラーピッカー
      hyprcursor # カーソルテーマ
      nwg-look # GTKテーマ設定
      libsForQt5.qt5ct # Qtテーマ設定
      kdePackages.qt6ct
      polkit_gnome # 認証エージェント
      vlc
      wineWowPackages.stable # 64bit + 32bit対応
      winetricks
      vesktop
      obsidian
      vrcx
      gh
      unityhub
      nvtopPackages.nvidia
      protonup-qt
    ])
    ++ (with pkgs.cudaPackages_12_8; [
      # CUDA 12.8 (機械学習用)
      cudatoolkit
    ])
    ++ (with pkgs-unstable; [
      # unstable 26.05
      opencode
    ]);

  programs.vscode = {
    enable = true;
  };
}

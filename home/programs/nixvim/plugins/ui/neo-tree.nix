{ ... }:
{
  programs.nixvim = {
    # ファイルツリー
    plugins.neo-tree.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = ":Neotree toggle<CR>";
        options = {
          silent = true;
          desc = "Toggle file tree";
        };
      }
    ];
  };
}

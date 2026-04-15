---
name: nixvim-add-plugin
description: Add or update Neovim plugins in this repo's NixVim configuration. Use when asked to install, enable, configure, or migrate a Vim or Neovim plugin under `home/programs/nixvim`, especially when deciding between `programs.nixvim.plugins.<name>` and `extraPlugins` plus Lua setup.
---

# NixVim Add Plugin

Add plugins in the repo's existing NixVim module structure instead of placing ad-hoc config in unrelated files.

## Workflow

1. Inspect the existing NixVim layout under `home/programs/nixvim/`.
2. Place the plugin in the closest concern directory:
   - UI plugins: `home/programs/nixvim/plugins/ui/`
   - Editing and coding plugins: `home/programs/nixvim/plugins/editor/`
   - Everything else: `home/programs/nixvim/plugins/other/`
3. Create one dedicated `kebab-case` module per plugin.
4. Register that module from the parent `default.nix` in the same directory.
5. Keep the module focused on one plugin only.

## Preferred Configuration Order

Prefer these approaches in order:

1. Use the dedicated NixVim plugin module when available.
2. Use `extraPlugins` plus `extraConfigLua` only when NixVim does not expose that plugin yet.

Check the official NixVim plugin docs first. For a plugin named `smear-cursor`, the canonical page is usually:

```text
https://nix-community.github.io/nixvim/plugins/<plugin-name>/index.html
```

If the docs show `programs.nixvim.plugins.<name>`, use that API instead of manual Lua wiring.

## Module Patterns

### Preferred: dedicated NixVim plugin module

```nix
{ ... }:
{
  programs.nixvim.plugins.smear-cursor = {
    enable = true;
    settings = { };
  };
}
```

Add only the options you need. Leave `settings = { };` empty when defaults are sufficient.

### Fallback: plugin package plus Lua setup

Use this only if the plugin is packaged in Nixpkgs but does not have a NixVim module.

```nix
{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [
      pkgs.vimPlugins.some-plugin
    ];

    extraConfigLua = ''
      require("some_plugin").setup({})
    '';
  };
}
```

If the plugin package name or Lua module name is unclear, verify both before editing.

## Repo Conventions

- Do not edit `home/programs/nixvim/default.nix` unless the top-level import structure itself changes.
- Prefer adding new plugin modules through:
  - `home/programs/nixvim/plugins/ui/default.nix`
  - `home/programs/nixvim/plugins/editor/default.nix`
  - `home/programs/nixvim/plugins/other/default.nix`
- Match the filename to the plugin, for example `smear-cursor.nix`.
- Keep comments short and only where they add real value.

## Verification

After editing, validate the touched Nix files at minimum:

```bash
nix-instantiate --parse home/programs/nixvim/plugins/ui/example-plugin.nix
nix-instantiate --parse home/programs/nixvim/plugins/ui/default.nix
```

If the environment allows fuller evaluation, prefer:

```bash
nix flake check
```

If a full build is needed, use the repo's standard commands from `AGENTS.md`.

## Typical Request Shapes

- "NixVim で `xxx.nvim` を入れて"
- "このプラグインを NixVim 方式に直して"
- "extraPlugins じゃなくて NixVim の plugins API を使って"
- "Neovim plugin をこの repo の流儀で追加して"

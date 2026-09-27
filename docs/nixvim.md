# Neovim (nixvim) Cheat Sheet

A reference for the Neovim configuration in `home/programs/nvim.nix/`.
Leader is `<Space>`.

## File Map

| File | Covers |
|---|---|
| `default.nix` | Entry point, imports, `nixpkgs.source`/`allowUnfree` |
| `options.nix` | Core vim `opts`/`globals` (indent, clipboard, folding-adjacent basics) |
| `keymaps.nix` | Plain always-on keymaps (files, buffers, save/quit) |
| `editing.nix` | Treesitter, cmp sources (basic), conform (formatting), comment/autopairs/flash |
| `lsp.nix` | All LSP servers, typescript-tools, lspsaga, lspkind, trouble, cmp (full) |
| `git.nix` | Neogit, gitsigns, git-conflict, telescope-github |
| `navigations.nix` | Telescope find/grep/buffers, hop, window split/resize |
| `ui.nix` | Colorscheme, statusline (lualine), nvim-tree, indent-blankline, cord, wakatime, etc. |
| `writing.nix` | Neorg, markdown-preview, render-markdown, zen-mode, venn.nvim |
| `ai.nix` | Avante (Claude) + claudecode-nvim |
| `dashboard.nix` | Startup dashboard (hyper theme) |
| `secrets.nix` | nvim-sops (in-editor SOPS decrypt/encrypt) |
| `plugin-managers.nix` | mason.nvim + a hand-rolled lazy.nvim bootstrap for ad-hoc plugins |

## Files, Buffers & Windows

| Action | Binding |
|---|---|
| Save file | `<leader>w` |
| Quit | `<leader>q` |
| Clear search highlight | `<Esc>` or `//` |
| Colorscheme picker | `<leader>uC` |
| Go to definition (mouse) | `<C-LeftMouse>` |
| New buffer, horizontal | `<leader>nn` |
| New buffer, vertical | `<leader>ns` |
| Split horizontal | `<C-a>` |
| Split vertical | `<C-s>` |
| Move window left/down/up/right | `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` |
| Resize window (up/down/left/right) | `<Up>` / `<Down>` / `<Left>` / `<Right>` |
| Copy to system clipboard | `Y` |
| Paste from system clipboard | `<leader>p` |
| Next / prev buffer | `<leader>bn` / `<leader>bp` |
| Delete buffer | `<leader>bd` |
| Move line up/down (visual mode) | `K` / `J` |

## File Explorer & Finding

| Action | Binding |
|---|---|
| Toggle file tree (nvim-tree) | `<C-n>` |
| Open Telescope | `<leader>ft` |
| Find files | `<leader>ff` |
| Live grep (find words) | `<leader>fF` |
| Grep string under cursor | `<leader>f'` |
| Find buffers | `<leader>fb` |
| Fuzzy find in current buffer | `<leader>fB` |
| Help tags | `<leader>fh` |
| Colorscheme picker (telescope) | `<leader>fc` |
| Highlights picker | `<leader>fC` |
| Hop to word | `<leader>fw` |
| Hop to pattern | `<leader>fhh` |

## Git

| Action | Binding |
|---|---|
| Open Neogit | `<leader>g` |
| Open LazyGit | `<leader>gg` |
| Git commits (telescope) | `fgc` |
| Buffer's git commits | `fgf` |
| Buffer's git commits (range) | `fgr` |
| Git branches | `fgb` |
| Git status | `fgs` |
| Git stash | `fgw` |
| GitHub issues | `fGi` |
| GitHub pull requests | `fGo` |
| GitHub Actions runs | `fGr` |
| GitHub gists | `fGs` |
| Toggle gitsigns: sign column | `tgs` |
| Toggle gitsigns: number highlight | `tgn` |
| Toggle gitsigns: line highlight | `tgl` |
| Toggle gitsigns: word diff | `tgw` |
| Toggle gitsigns: deleted | `tgd` |
| Toggle gitsigns: current-line blame | `tgb` |

> Note: the `fg*`/`fG*`/`tg*` bindings are bare (no `<leader>`) — they come straight from the
> upstream telescope/which-key config, ported as-is.

## LSP & Diagnostics

| Action | Binding |
|---|---|
| Hover doc | `K` |
| Format buffer | `F` (overrides the native "find char backward" motion — a deliberate upstream trade-off) |
| Go to definition (native) | `gD` |
| Peek definition (Lspsaga) | `gd` |
| Code action | `ga` |
| Rename | `gr` |
| Incoming / outgoing calls | `gi` / `go` |
| Code outline | `gt` |
| Code finder | `gF` |
| Search diagnostic with Google (wtf.nvim) | `gs` |
| Show LSP info | `gl` |
| Next / previous diagnostic | `[e` / `]e` |
| Show diagnostics (Trouble) | `ge` or `<leader>xx` |
| Toggle inlay hints | `tI` |
| Open terminal (Lspsaga) | `<leader><space>` |
| Open REPL (codi/neorepl) | `<leader>r` |
| Find references | `flr` |
| Find incoming/outgoing calls | `fic` / `foc` |
| Find document symbols | `fds` |
| Find workspace symbols | `fws` |
| Find dynamic workspace symbols | `fdws` |
| Find diagnostics | `fld` |
| Find implementations | `fli` |
| Find definitions | `flD` |
| Find type definitions | `flt` |

Configured LSP servers: `bashls`, `dockerls`, `biome`, `eslint`, `gopls` (with inlay hints),
`jsonls` (with schemas for nixd/turbo/tsconfig/rescript), `lua_ls`, `nixd`, `yamlls`, `pyright`,
`marksman`, plus disabled-by-default `ts_ls`/`hls`, and language extras `ccls` (C++),
`ocamllsp` (OCaml), `rust_analyzer`+`rustaceanvim`+`crates` (Rust), `htmx` (non-Darwin only).

## UI Toggles

| Action | Binding |
|---|---|
| Toggle statusline | `<leader>ts` |
| Toggle indent-blankline | `<leader>ti` |
| Toggle colorizer | `<leader>tc` |
| Toggle animated cursor (smear-cursor) | `<leader>tsc` |
| Toggle dark/light background | `<leader>tb` |

## Writing / Notes

| Action | Binding |
|---|---|
| Preview markdown | `<leader>mp` |
| Toggle Venn (ASCII diagram drawing) | `<leader>tv` |
| Neorg: journal today | `<leader>oj` |
| Neorg: open home workspace | `<leader>oh` |
| Zen mode | `<leader>zm` |
| Neorg: switch workspace | `<leader>nw` |
| Neorg: insert link / file link | `<leader>ni` / `<leader>nI` |
| Neorg: find files / headings / linkable | `<leader>ns` / `<leader>nh` / `<leader>nl` |
| Neorg: find backlinks / header backlinks | `<leader>nb` / `<leader>nB` |
| Neorg: find project/context tasks | `<leader>nt` / `<leader>nc` |
| Comment line/block (Comment.nvim) | `gcc` / `gco` / `gcO` / `gcA` |

## AI

| Action | Binding |
|---|---|
| Toggle Avante | `<leader>ta` |
| Avante: ask | `<leader>ca` |
| Avante: chat | `<leader>cc` |
| Avante: edit with instruction | `<leader>ce` |

Avante's provider is `claude` (model `claude-3-7-sonnet-20250219`) — **you need to set your own
API key** (e.g. `claude.api_key_name` in `ai.nix`, or the `ANTHROPIC_API_KEY` env var). The
upstream config's `pass`-based key lookup and extra providers (Groq/Grok/local models) were
dropped since they were personal to the source repo.

Claude Code's own terminal integration (`claudecode.nvim`) is also installed — commands
`:ClaudeCode`, `:ClaudeCodeFocus`, `:ClaudeCodeDiffDeny`, `:ClaudeCodeDiffAccept`.

## Colorscheme

Active: **edge** (`edge_style = "neon"`). Also installed (switchable via `<leader>fc` or
`<leader>uC`): `gruvbox` (previously the default here), `lackluster`, `midnight`, `dracula`.

## Dashboard

Shown on startup (hyper theme) with shortcuts for find files/recent files/grep/new file/bookmarks
under the `<S>` prefix shown in the dashboard UI itself.

## Deviations From the Source Config

These were deliberate changes made while porting, not 1:1 copies:

- **File explorer**: this repo previously used **neo-tree** (`<leader>e`); switched to
  **nvim-tree** (`<C-n>`) to match upstream, and neo-tree was removed.
- **Colorscheme**: switched from `gruvbox` to `edge` to match upstream's active choice.
- **`navigations.nix`** telescope/window keymaps were prefixed with `<leader>` instead of
  upstream's bare `f`/`z` scheme, to avoid silently overriding native vim motions (`f{char}`,
  `z{char}`). `lsp.nix`'s bare `g*`/`f*` which-key bindings were kept as in upstream, since `g` is
  already a multi-key vim prefix (not a standalone motion).
- **Neorg workspace paths** point at `~/notes`
- **`icons.*`** references and `helpers.mkLuaFun` (both from upstream's custom Nix framework)
  were inlined as literal glyphs/Lua functions — no dependency on that framework remains.
- Not portable at all without adopting the whole upstream flake: `den.lib.aspects`,
  `mkNvimConfiguration`, the `hud-colorschemes` overlay, and upstream's own
  `neovimConfigurations` flake outputs.

## Known Gotcha: Unfree Plugins

`programs.nixvim.nixpkgs.source` re-imports nixpkgs independently of the host's
`nixpkgs.config`, so `nixpkgs.config.allowUnfree = true;` is set explicitly in `default.nix` to
allow plugins like `cmp-nvim-lsp-document-symbol` (unfree-licensed) to build.

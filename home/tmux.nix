{ pkgs, ... }:

let
  # Script to copy to WSL clipboard with proper UTF-8 encoding
  wsl-copy = pkgs.writeShellScriptBin "wsl-copy" ''
    #!/bin/sh
    # Convert UTF-8 and copy to Windows clipboard
    iconv -f UTF-8 -t UTF-16LE | clip.exe
  '';
in

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
    sensibleOnTop = true;
    terminal = "tmux-256color";
    shell = "${pkgs.fish}/bin/fish";

    extraConfig = ''
      # Enable true color and UTF-8
      set -as terminal-overrides ',*:Tc'
      set -g default-terminal "tmux-256color"
      set -g pane-base-index 1

      # Mouse support
      set -g mouse on
      # Double click to copy word (using tmux-yank)
      bind-key -T root DoubleClick1Pane select-pane \; send-keys -X select-word \; run-shell -d 0.3 \; send-keys -X copy-pipe
      # Triple click to copy line (using tmux-yank)
      bind-key -T root TripleClick1Pane select-pane \; send-keys -X select-line \; run-shell -d 0.3 \; send-keys -X copy-pipe

      # Better pane splitting
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Vim-like pane switching
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane resizing
      bind H resize-pane -L 10
      bind J resize-pane -D 10
      bind K resize-pane -U 10
      bind L resize-pane -R 10

      # Copy mode (let tmux-yank handle the copying)
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe
      # Mouse bindings for copy mode (handled by tmux-yank)
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe
      bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe

      # Position status bar at top
      set -g status-position top
      set -g status-style bg=default

      # Pane divider color (should be before tpm to override catppuccin)
      set -g pane-border-status top
      set -g pane-border-format ""

      set -g pane-border-style "fg=#45475a"   # Subtle gray border
      set -g pane-active-border-style "fg=#45475a"  # Same color for active border


    '';

    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = yank;
        extraConfig = ''
          # Configure yank for WSL with proper UTF-8 support
          set -g @yank_selection 'clipboard'
          set -g @yank_action 'copy-pipe-no-clear'
          set -g @yank_selection_mouse 'clipboard'
          # Use custom script that handles UTF-8 correctly for WSL
          set -g @yank_shell "${wsl-copy}/bin/wsl-copy"
        '';
      }
      resurrect
      continuum
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'macchiato'
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_left_separator ""
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_connect_separator "no"
          set -g status-right-length 100
          set -g status-left-length 100

          # Enhanced left status
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_session}"
        '';
      }
    ];
  };
}

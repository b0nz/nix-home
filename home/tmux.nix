{ pkgs, ... }:

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

      # Copy mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

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
      yank
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

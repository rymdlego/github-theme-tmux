#!/usr/bin/env bash
#
# GitHub Tmux Theme
#
export TMUX_GITHUB_THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get_tmux_option() {
  local option value default
  option="$1"
  default="$2"
  value="$(tmux show-option -gqv "$option")"

  if [ -n "$value" ]; then
    echo "$value"
  else
    echo "$default"
  fi
}

set() {
  local option=$1
  local value=$2
  tmux_commands+=(set-option -gq "$option" "$value" ";")
}

setw() {
  local option=$1
  local value=$2
  tmux_commands+=(set-window-option -gq "$option" "$value" ";")
}

unset_option() {
  local option=$1
  local value=$2
  tmux_commands+=(set-option -gu "$option" ";")
}

main() {
  local theme
  theme="$(get_tmux_option "@github_theme_variant" "")"

  # INFO: Not removing the thm_hl_low and thm_hl_med colors for posible features
  # INFO: If some variables appear unused, they are being used either externally
  # or in the plugin's features

  thm_grey="#545d68"
  thm_red="#f47067"
  thm_green="#57ab5a"
  thm_yellow="#c69026"
  thm_blue="#539bf5"
  thm_blue_bright="#6cb6ff"
  thm_magenta="#b083f0"
  thm_cyan="#39c5cf"
  thm_sky=#909dab
  thm_bg="#22272e"
  thm_fg="#adbac7"
  thm_panel="#2d333a"

  # Aggregating all commands into a single array
  local tmux_commands=()

  # Status bar
  set "status" "on"
  set status-style "fg=$thm_grey,bg=$thm_bg"
  # set monitor-activity "on"
  # Leave justify option to user
  # set status-justify "left"
  set status-left-length "900"
  set status-right-length "900"

  set status-left ""
  set status-right "#($TMUX_GITHUB_THEME_DIR/scripts/kubernetes_context.sh \"$thm_bg\" \"$thm_panel\" \"$thm_blue\")#($TMUX_GITHUB_THEME_DIR/scripts/azure_subscription.sh \"$thm_bg\" \"$thm_panel\" \"$thm_blue_bright\")"

  # Panel Layout
  local window_layout="#[fg=$thm_panel,bg=$thm_bg]#[fg=$thm_grey,bg=$thm_panel] #I #W #[fg=$thm_panel,bg=$thm_bg]"
  local window_layout_current="#[bg=$thm_bg]#{?client_prefix,#[fg=$thm_blue],#[fg=$thm_grey]}#{?client_prefix,#[bg=$thm_blue],#[bg=$thm_grey]}#{?client_prefix,#[fg=$thm_bg],#[fg=$thm_fg]} #I #W #{?client_prefix,#[fg=$thm_blue],#[fg=$thm_grey]}#[bg=$thm_bg]"

  # border colours
  set pane-border-style "fg=black"
  set pane-active-border-style "bg=default fg=black"

  setw window-status-format "$window_layout"
  setw window-status-current-format "$window_layout_current"

  # Call everything to action
  tmux "${tmux_commands[@]}"

}

main "$@"

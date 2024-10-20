#!/usr/bin/env bash
#
# GitHub Tmux Theme
#
# export TMUX_GITHUB_THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
  if [[ $theme == main ]]; then

    thm_grey="#545d68"
    thm_red="#f47067"
    thm_green="#57ab5a"
    thm_yellow="#c69026"
    thm_blue="#539bf5"
    thm_magenta="#b083f0"
    thm_cyan="#39c5cf"
    thm_sky=#909dab
    thm_bg="#22272e"
    thm_fg="#adbac7"
    thm_panel="#2d333a"

    # elif [[ $theme == moon ]]; then

    # thm_base="#232136"
    # thm_surface="#2a273f"
    # thm_overlay="#393552"
    # thm_muted="#6e6a86"
    # thm_subtle="#908caa"
    # thm_text="#e0def4"
    # thm_love="#eb6f92"
    # thm_gold="#f6c177"
    # thm_rose="#ea9a97"
    # thm_pine="#3e8fb0"
    # thm_foam="#9ccfd8"
    # thm_iris="#c4a7e7"
    # thm_hl_low="#2a283e"
    # thm_hl_med="#44415a"
    # thm_hl_high="#56526e"

  fi

  # Aggregating all commands into a single array
  local tmux_commands=()

  # Status bar
  set "status" "on"
  # set status-style "fg=$thm_pine,bg=$thm_base"
  set status-style "fg=$thm_grey,bg=$thm_bg"
  # set monitor-activity "on"
  # Leave justify option to user
  # set status-justify "left"
  set status-left-length "900"
  set status-right-length "900"

  local azure_subscription
  azure_subscription="(jq -r '.subscriptions[] | select(.isDefault == true) | .name' ~/.azure/azureProfile.json)"
  local azure_subscription_short
  azure_subscription_short="#($azure_subscription | sed -n 's/.*(\(.*\)).*/\1/p')"
  local kubernetes_context
  kubernetes_context="#(grep 'current-context' ~/.kube/config | awk '{print \$2}')"

  local azure_panel
  local kubernetes_panel

  if [ "$azure_subscription_short" != "" ]; then
    azure_panel=" #[fg=$thm_panel,bg=$thm_bg]#[fg=$thm_blue,bg=$thm_panel] 󰠅 $azure_subscription_short #[fg=$thm_panel,bg=$thm_bg]"
  fi

  if [ "$kubernetes_context" == "" ]; then
    kubernetes_panel=""
  else
    kubernetes_panel=" #[fg=$thm_panel,bg=$thm_bg]#[fg=$thm_magenta,bg=$thm_panel] ☸ $kubernetes_context #[fg=$thm_panel,bg=$thm_bg]"
  fi

  set status-left ""
  set status-right "$kubernetes_panel$azure_panel"

  # Panel Layout
  local window_layout="#[fg=$thm_panel,bg=$thm_bg]#[fg=$thm_grey,bg=$thm_panel] #I #W #[fg=$thm_panel,bg=$thm_bg]"
  local window_layout_current="#[fg=$thm_panel,bg=$thm_bg]#[fg=$thm_fg,bg=$thm_panel] #I #W #[fg=$thm_panel,bg=$thm_bg]"

  setw window-status-format "$window_layout"
  setw window-status-current-format "$window_layout_current"

  # Call everything to action

  tmux "${tmux_commands[@]}"

}

main "$@"

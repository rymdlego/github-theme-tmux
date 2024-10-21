#!/usr/bin/env bash

kubernetes_panel() {
  # Fetch the current Kubernetes context
  local context
  context=$(kubectl config current-context 2>/dev/null)

  # Check if the context exists
  if [ -n "$context" ]; then
    # Return the decorated context if it exists
    echo "#[fg=$2,bg=$1]#[fg=$3,bg=$2] ☸ $context #[fg=$2,bg=$1]"
  else
    # Return nothing if no context is set
    echo ""
  fi
}

kubernetes_panel "$@"

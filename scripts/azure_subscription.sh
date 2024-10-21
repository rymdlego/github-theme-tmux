#!/usr/bin/env bash

azure_subscription() {
  # Fetch the current Azure subscription
  local subscription
  subscription="$(jq -r '.subscriptions[] | select(.isDefault == true) | .name' ~/.azure/azureProfile.json 2>/dev/null)"

  # Check if the subscription exists
  if [ -n "$subscription" ]; then
    # Return the decorated subscription if it exists
    echo "#[fg=$2,bg=$1]#[fg=$3,bg=$2] 󰠅 $subscription #[fg=$2,bg=$1]"
  else
    # Return nothing if no subscription is set
    echo ""
  fi
}

azure_subscription "$@"

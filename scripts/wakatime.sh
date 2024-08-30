#!/bin/bash

# Function to get API key from ~/.wakatime.cfg
get_api_key() {
    local api_key=$(grep -E "api_key\s*=" ~/.wakatime.cfg | sed -E 's/api_key\s*=\s*//' | tr -d '[:space:]')
    echo "$api_key"
}

# Function to fetch data from Wakatime endpoint
get_wakatime_data() {
    curl -s "https://wakatime.com/api/v1/users/current/status_bar/today?api_key=$(get_api_key)"
}

# Function to extract the current coding time
extract_coding_time() {
    local data="$1"
    local coding_time=$(echo "$data" | jq -r '.data.grand_total.text // empty')
    echo "$coding_time"
}

# Main function
main() {
    while true; do
        local wakatime_data=$(get_wakatime_data)
        local coding_time=$(extract_coding_time "$wakatime_data")
        if [ -n "$coding_time" ]; then
            echo " $coding_time"
        else
          echo " None yet :)"
        fi
        sleep 300  # Sleep for 5 minutes (300 seconds)
    done
}

# Execute the main function
main

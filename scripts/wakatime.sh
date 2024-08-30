#!/bin/bash

# Function to get API key from ~/.wakatime.cfg
get_api_key() {
    grep -oE 'waka_[a-zA-Z0-9\-]+' ~/.wakatime.cfg
}

# Function to fetch data from Wakatime endpoint
get_wakatime_data() {
    local api_key="$1"
    curl -s "https://wakatime.com/api/v1/users/current/status_bar/today?api_key=$api_key"
}

# Function to extract the current coding time
extract_coding_time() {
    local data="$1"
    echo "$data" | jq -r '.data.grand_total.text'
}

# Main function
main() {
    local api_key
    api_key=$(get_api_key)
    if [ -z "$api_key" ]; then
        echo "API key not found in configuration file." >&2
        exit 1
    fi

    while true; do
        local wakatime_data
        wakatime_data=$(get_wakatime_data "$api_key")
        local coding_time
        coding_time=$(extract_coding_time "$wakatime_data")
        if [ -n "$coding_time" ]; then
            echo "$coding_time"
        else
            echo "None yet :)"
        fi
        sleep 300  # Sleep for 5 minutes (300 seconds)
    done
}

# Execute the main function
main

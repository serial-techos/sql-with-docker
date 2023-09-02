#!/bin/bash

# Function to retrieve configuration from a yaml file
get_config() {
    local section="$1"
    local key="$2"
    local file="$3"

    # Extract the value using yq for the older Python-based version
    value=$(yq ".$section.$key" "$file")
    echo $value
}
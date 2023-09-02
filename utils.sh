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

# Replaces the {PATH} placeholder in the SQL_CMD with the provided path
replace_path() {
    local cmd="$1"
    local file_path="$2"

    echo "${cmd//\{PATH\}/$file_path}"
}

# Function to fetch configuration details from db.yaml for a given section
fetch_config() {
    local SECTION=$1
    SQL_CMD=$(get_config $SECTION "SQL_CMD" "db.yaml")
    DOCKER_ENV=$(get_config $SECTION "DOCKER_ENV" "db.yaml")
    VERSION=$(get_config $SECTION "VERSION" "db.yaml")
    IMAGE_NAME=$SECTION:$VERSION
}

# Check arguments and define mode
if [ "$1" == "client" ]; then
    MODE="client"
    CLIENT=$1
    DIR=$2
    SECTION=$3
elif [ -f "$1" ]; then
    MODE="file"
    SQL_FILE=$1
    SECTION=$2
else
    echo "Usage:"
    echo "1. Interactive Mode: $0 client /path/to/queries/ sql-db-keyword"
    echo "2. File Execution Mode: $0 /path/to/query.sql sql-db-keyword"
    exit 1
fi
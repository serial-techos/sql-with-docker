#!/bin/bash

# Check for SQL file and image version arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/query.sql sql-db-keyword"
    exit 1
fi

get_config() {
    local section="$1"
    local key="$2"
    local file="$3"

    # Extract the value using yq for the older Python-based version
    value=$(yq ".$section.$key" "$file")
    echo $value
}
# Define a constant for the container name
CONTAINER_NAME="sql_container"

# Assign arguments to variables
SQL_FILE=$1
SECTION=$2

# Fetch configuration details from db.yaml for the given section
SQL_CMD=$(get_config $SECTION "SQL_CMD" "db.yaml")
DOCKER_ENV=$(get_config $SECTION "DOCKER_ENV" "db.yaml")
VERSION=$(get_config $SECTION "VERSION" "db.yaml")

# Construct image name from section and version
IMAGE_NAME=$SECTION:$VERSION

# Check if essential variables are set, if not exit with an error
if [ -z "$SQL_CMD" ] ; then
    echo "Please specify a SQL command to run on db.yaml"
    exit 1
fi

# Run SQL server in Docker container
docker run --name $CONTAINER_NAME -e $DOCKER_ENV -d $IMAGE_NAME

# Wait for SQL server to initialize
sleep 5

# Copy the SQL file into the container
docker cp $SQL_FILE $CONTAINER_NAME:/query.sql

# Execute SQL script in SQL server inside the Docker container
docker exec $CONTAINER_NAME sh -c "$SQL_CMD"

# Cleanup: Stop and remove the container
docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME

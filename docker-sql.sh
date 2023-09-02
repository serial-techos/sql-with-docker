#!/bin/bash

# Define constants
CONTAINER_NAME="sql_container"

# Source utility functions
source utils.sh

# Fetch configuration details
fetch_config $SECTION

# Check if SQL command is provided
if [ -z "$SQL_CMD" ]; then
    echo "Please specify a SQL command to run on db.yaml"
    exit 1
fi

# Run SQL server in Docker container
if [ "$MODE" == "client" ]; then
    SQL_CMD=$(replace_path "$SQL_CMD" " ")
    docker run --name $CONTAINER_NAME -e SQL_CMD="$SQL_CMD" -e $DOCKER_ENV -v $DIR:/data -d $IMAGE_NAME
    
    # Add alias to bashrc inside the container
    alias="alias run-query='$SQL_CMD'"
    docker exec $CONTAINER_NAME /bin/bash -c "echo \"$alias\" >> ~/.bashrc"
    
    sleep 10
    docker exec -it $CONTAINER_NAME bash
else
    SQL_PATH="/query.sql"
    SQL_CMD=$(replace_path "$SQL_CMD" "$SQL_PATH")
    
    docker run --name $CONTAINER_NAME -e $DOCKER_ENV -d $IMAGE_NAME
    
    # Wait for SQL server to initialize
    sleep 10

    # Copy the SQL file into the container and execute it
    docker cp $SQL_FILE $CONTAINER_NAME:/query.sql
    docker exec $CONTAINER_NAME sh -c "$SQL_CMD"

    # Cleanup: Stop and remove the container
    docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
fi

-- Drop the users table if it already exists
DROP TABLE IF EXISTS users;

-- Create a new table named users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Insert a few records into the users table
INSERT INTO users (name, email) VALUES ('John Doe', 'john.doe@example.com');
INSERT INTO users (name, email) VALUES ('Jane Smith', 'jane.smith@example.com');
INSERT INTO users (name, email) VALUES ('Samuel Jackson', 'samuel.jackson@example.com');

-- Retrieve all records from the users table
SELECT * FROM users;

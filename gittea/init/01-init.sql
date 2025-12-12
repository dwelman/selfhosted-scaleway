-- Example initialization script
-- This file will be executed when the MySQL container starts for the first time
-- You can add your database schema, initial data, or user setup here

-- Example: Create additional databases or users
-- CREATE DATABASE IF NOT EXISTS app_db;
-- GRANT ALL PRIVILEGES ON app_db.* TO 'selfhosted_user'@'%';

-- Example: Create tables
-- USE selfhosted;
-- CREATE TABLE IF NOT EXISTS example_table (
--     id INT AUTO_INCREMENT PRIMARY KEY,
--     name VARCHAR(255) NOT NULL,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

-- Flush privileges to ensure all changes take effect
FLUSH PRIVILEGES;
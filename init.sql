-- init.sql

-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS hibernate;

-- Use the hibernate database
USE hibernate;

-- Create the Users table with the specified columns
CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

-- Create a user for hibernate
CREATE USER IF NOT EXISTS 'hibernate-user'@'%' IDENTIFIED BY 'Dharan@123';

-- Grant all privileges on the hibernate database to the user
GRANT ALL PRIVILEGES ON hibernate.* TO 'hibernate-user'@'%';

-- Flush the privileges to ensure the changes take effect
FLUSH PRIVILEGES;

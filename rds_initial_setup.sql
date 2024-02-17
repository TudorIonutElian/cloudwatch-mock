-- Create the database
CREATE DATABASE IF NOT EXISTS logs;

-- Use the database
USE logs;

-- Create the table
CREATE TABLE api_requests (
  id INT PRIMARY KEY AUTO_INCREMENT,
  request_time DATETIME,
  request_method VARCHAR(50),
  request_path VARCHAR(255),
  response_code INT
  request_payload VARCHAR(255)
  request_time_ms INT
);

-- Create the table
CREATE TABLE api_requests_details (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_id DATETIME,
  product_price Number(10,2)
  product_count INT(4)
  product_discount Number(10,2)
  promotion_code VARCHAR(255)
);


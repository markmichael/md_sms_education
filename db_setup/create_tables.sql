-- create restricted schema
CREATE SCHEMA IF NOT EXISTS restricted;

-- Create login table

CREATE TABLE IF NOT EXISTS restricted.login (
uuid CHAR(36) PRIMARY KEY NOT NULL,
user_access_hash CHAR(128) NOT NULL
);

-- create user table
CREATE TABLE IF NOT EXISTS restricted.user (
uuid CHAR(36) PRIMARY KEY NOT NULL,
email VARCHAR(255) NOT NULL,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
admin BOOLEAN NOT NULL
);

-- create session table
CREATE TABLE IF NOT EXISTS restricted.session (
uuid CHAR(36) PRIMARY KEY NOT NULL,
session_token CHAR(64) NOT NULL,
session_create_time TIMESTAMP NOT NULL
);

-- create video_library table
CREATE TABLE IF NOT EXISTS video_library (
video_id CHAR(16) PRIMARY KEY NOT NULL,
video_title VARCHAR(255) NOT NULL,
video_link VARCHAR(255) NOT NULL,
owner_uuid CHAR(36) NOT NULL
);

-- create templates table
CREATE TABLE IF NOT EXISTS templates (
template_id CHAR(16) PRIMARY KEY NOT NULL,
uuid_owner CHAR(36) NOT NULL,
template_name VARCHAR(255) NOT NULL
);

-- create messages table
CREATE TABLE IF NOT EXISTS messages (
message_id CHAR(34) PRIMARY KEY NOT NULL,
time_stamp TIMESTAMP NOT NULL,
uuid CHAR(36) NOT NULL,
origin_number CHAR(12) NOT NULL,
destination_number CHAR(12) NOT NULL,
message_text TEXT ,
asset_type VARCHAR(24),
asset_id CHAR(16)
);

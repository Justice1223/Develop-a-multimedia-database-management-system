CREATE DATABASE IF NOT EXISTS MultimediaContentDB;
USE MultimediaContentDB;

-- Rating
CREATE TABLE Rating (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(10) UNIQUE NOT NULL
);

-- Content
CREATE TABLE Content (
    id INT AUTO_INCREMENT PRIMARY KEY,
    show_id VARCHAR(10) UNIQUE,
    title VARCHAR(255) NOT NULL,
    type VARCHAR(50),
    release_year INT,
    duration VARCHAR(50),
    rating_id INT,
    description TEXT,
    FOREIGN KEY (rating_id) REFERENCES Rating(id)
);

-- Director
CREATE TABLE Director (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

-- Actor
CREATE TABLE Actor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

-- Country
CREATE TABLE Country (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Genre
CREATE TABLE Genre (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Join Tables
CREATE TABLE Content_Director (
    content_id INT,
    director_id INT,
    PRIMARY KEY (content_id, director_id),
    FOREIGN KEY (content_id) REFERENCES Content(id),
    FOREIGN KEY (director_id) REFERENCES Director(id)
);

CREATE TABLE Content_Cast (
    content_id INT,
    actor_id INT,
    PRIMARY KEY (content_id, actor_id),
    FOREIGN KEY (content_id) REFERENCES Content(id),
    FOREIGN KEY (actor_id) REFERENCES Actor(id)
);

CREATE TABLE Content_Country (
    content_id INT,
    country_id INT,
    PRIMARY KEY (content_id, country_id),
    FOREIGN KEY (content_id) REFERENCES Content(id),
    FOREIGN KEY (country_id) REFERENCES Country(id)
);

CREATE TABLE Content_Genre (
    content_id INT,
    genre_id INT,
    PRIMARY KEY (content_id, genre_id),
    FOREIGN KEY (content_id) REFERENCES Content(id),
    FOREIGN KEY (genre_id) REFERENCES Genre(id)
);

-- Content Availability
CREATE TABLE Content_Availability (
    content_id INT PRIMARY KEY,
    status VARCHAR(20),
    FOREIGN KEY (content_id) REFERENCES Content(id)
);

-- User
CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- Watchlist
CREATE TABLE Watchlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content_id INT,
    added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (content_id) REFERENCES Content(id)
);

-- Review
CREATE TABLE Review (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content_id INT,
    rating DECIMAL(3,2),
    review_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (content_id) REFERENCES Content(id)
);

-- User Subscription
CREATE TABLE User_Subscription (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    plan_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (user_id) REFERENCES User(id)
);

-- Payment Method
CREATE TABLE Payment_Method (
    id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100)
);

-- Transactions
CREATE TABLE Transaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    method_id INT,
    amount DECIMAL(10,2),
    transaction_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (method_id) REFERENCES Payment_Method(id)
);

-- Watch History
CREATE TABLE Content_WatchHistory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content_id INT,
    watch_time DATETIME,
    watch_hours DECIMAL(5,2),
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (content_id) REFERENCES Content(id)
);

-- Notifications
CREATE TABLE Notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id)
);

-- Error Logging
CREATE TABLE Director_Assignment_Errors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content_id INT,
    director_id INT,
    error_time DATETIME,
    FOREIGN KEY (content_id) REFERENCES Content(id),
    FOREIGN KEY (director_id) REFERENCES Director(id)
);

CREATE TABLE Payment_Errors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    method_id INT,
    reason TEXT,
    error_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (method_id) REFERENCES Payment_Method(id)
);

-- Top Content Table for Daily Ranking
CREATE TABLE Top_Content (
    genre_id INT,
    content_id INT,
    views INT,
    PRIMARY KEY (genre_id, content_id),
    FOREIGN KEY (genre_id) REFERENCES Genre(id),
    FOREIGN KEY (content_id) REFERENCES Content(id)
);

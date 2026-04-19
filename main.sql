CREATE TABLE Users (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE Posts (
    id INT PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    userId INT,
    FOREIGN KEY (userId) REFERENCES Users(id)
);

CREATE TABLE Comments (
    id INT PRIMARY KEY,
    content TEXT,
    postId INT,
    userId INT,
    FOREIGN KEY (postId) REFERENCES Posts(id),
    FOREIGN KEY (userId) REFERENCES Users(id)
);

CREATE TABLE Likes (
    id INT PRIMARY KEY,
    postId INT,
    userId INT,
    FOREIGN KEY (postId) REFERENCES Posts(id),
    FOREIGN KEY (userId) REFERENCES Users(id)
);

INSERT INTO Users (id, name, email) VALUES
(1, 'John Doe', 'john@example.com'),
(2, 'Jane Doe', 'jane@example.com'),
(3, 'Bob Smith', 'bob@example.com');

INSERT INTO Posts (id, title, content, userId) VALUES
(1, 'My first post', 'This is my first post', 1),
(2, 'My second post', 'This is my second post', 1),
(3, 'My third post', 'This is my third post', 2);

INSERT INTO Comments (id, content, postId, userId) VALUES
(1, 'Great post!', 1, 2),
(2, 'Nice job!', 1, 3),
(3, 'Thanks for sharing!', 2, 2);

INSERT INTO Likes (id, postId, userId) VALUES
(1, 1, 2),
(2, 1, 3),
(3, 2, 2);

SELECT * FROM Users;
SELECT * FROM Posts;
SELECT * FROM Comments;
SELECT * FROM Likes;

SELECT p.id, p.title, p.content, u.name AS author
FROM Posts p
JOIN Users u ON p.userId = u.id;

SELECT p.id, p.title, p.content, COUNT(c.id) AS commentCount
FROM Posts p
LEFT JOIN Comments c ON p.id = c.postId
GROUP BY p.id, p.title, p.content;

SELECT p.id, p.title, p.content, COUNT(l.id) AS likeCount
FROM Posts p
LEFT JOIN Likes l ON p.id = l.postId
GROUP BY p.id, p.title, p.content;

SELECT u.id, u.name, COUNT(p.id) AS postCount
FROM Users u
LEFT JOIN Posts p ON u.id = p.userId
GROUP BY u.id, u.name;

SELECT u.id, u.name, COUNT(c.id) AS commentCount
FROM Users u
LEFT JOIN Comments c ON u.id = c.userId
GROUP BY u.id, u.name;

SELECT u.id, u.name, COUNT(l.id) AS likeCount
FROM Users u
LEFT JOIN Likes l ON u.id = l.userId
GROUP BY u.id, u.name;
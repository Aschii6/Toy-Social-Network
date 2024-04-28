-- Database: socialnetwork

-- DROP DATABASE IF EXISTS socialnetwork;

CREATE DATABASE socialnetwork
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United Kingdom.1252'
    LC_CTYPE = 'English_United Kingdom.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
	
CREATE TABLE users(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	firstName CHARACTER VARYING NOT NULL,
	lastName CHARACTER VARYING NOT NULL,
	tag CHARACTER VARYING UNIQUE NOT NULL
);
	
SELECT * FROM users

CREATE TABLE passwords(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	userId BIGINT,
	hashedPassword CHARACTER VARYING NOT NULL,
	FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);

SELECT * FROM passwords

CREATE TABLE friendships(
	id1 BIGINT,
	id2 BIGINT,
	status SMALLINT DEFAULT 0 CHECK (status >= 0 AND status <= 2),
	friendsFrom TIMESTAMP NOT NULL DEFAULT DATE_TRUNC('second', CURRENT_TIMESTAMP),
	PRIMARY KEY (id1, id2),
    FOREIGN KEY (id1) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (id2) REFERENCES users(id) ON DELETE CASCADE
);

SELECT * FROM friendships


CREATE TABLE messages(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	idFrom BIGINT,
	messageText CHARACTER VARYING NOT NULL,
	timeSent TIMESTAMP NOT NULL DEFAULT DATE_TRUNC('second', CURRENT_TIMESTAMP),
	idMessageThisRepliedTo BIGINT DEFAULT NULL,
    FOREIGN KEY (idTo) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (idFrom) REFERENCES users(id) ON DELETE CASCADE
);

SELECT * FROM messages

CREATE TABLE toUsers(
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	idMessage BIGINT REFERENCES messages(id) ON DELETE CASCADE,
	idTo BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

SELECT * FROM toUsers

SELECT M.id, M.idFrom, T.idTo, M.messageText, M.timeSent, M.idMessageThisRepliedTo 
FROM toUsers T INNER JOIN messages M on M.id = T.idMessage
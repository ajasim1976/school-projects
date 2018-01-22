-- CREAT TABLE/ALTER TABLE commands --
CREATE TABLE Album (
album_id DECIMAL(12) PRIMARY KEY,
album_name VARCHAR(255) NOT NULL,
suggested_price DECIMAL (12),
musical_genre_id DECIMAL (12),
recording_artist_id DECIMAL (12)
);

CREATE TABLE Song (
song_id DECIMAL(12)   PRIMARY KEY,
song_name VARCHAR(255) NOT NULL,
song_length_minutes VARCHAR(64) NOT NULL,
song_length_seconds VARCHAR(64) NOT NULL,
album_id DECIMAL(12) 
);

CREATE TABLE Recording_artist (
recording_artist_id DECIMAL(12)   PRIMARY KEY,
artist_name VARCHAR(255) NOT NULL,
);

CREATE TABLE Musical_genre (
musical_genre_id DECIMAL(12)   PRIMARY KEY,
musical_genre VARCHAR(255) NOT NULL,
);

ALTER TABLE Song
ADD CONSTRAINT album_fk
FOREIGN KEY(album_id) 
REFERENCES Album (album_id);

ALTER TABLE Album
ADD CONSTRAINT musical_genre_fk
FOREIGN KEY(musical_genre_id) 
REFERENCES Musical_genre (musical_genre_id);

ALTER TABLE Album
ADD CONSTRAINT recording_artist_fk
FOREIGN KEY(recording_artist_id) 
REFERENCES Recording_artist (recording_artist_id);

-- Insert data into the tables --
INSERT INTO Recording_artist (recording_artist_id, artist_name)
VALUES (01, 'April Wine'),(02,'Enya'),(03,'Elvis Costello');

INSERT INTO Musical_genre (musical_genre_id, musical_genre)
VALUES (04, 'Big Band'),
	   (05, 'Rock'),
	   (06, 'World'),
	   (07, 'Country'),
	   (08,'New Age'),
	   (09, 'Heavy Metal');

INSERT INTO Album (album_id, album_name, suggested_price, musical_genre_id, recording_artist_id)
VALUES (10, 'Power Play', 15.99, 05, 01),
	   (11, 'A Day Without Rain', 13.75, 08, 02),
	   (12, 'Armed Forces', 12.99, 05, 03),
	   (13, 'Nature of the Beast', NULL, 05, 01);

INSERT INTO Song (song_id, song_name, song_length_minutes, song_length_seconds, album_id)
VALUES (14, 'Doin'' It Right', '3','42', 10),
	   (15, 'Ain''t Got Your Love ', '4','33', 10),
	   (16, 'If You See Kay', '3','59', 10),
	   (17, 'Tell Me Why', '3','39', 10),
	   (18, 'Fairytail', '3','03', 11),
	   (19, 'Sun Stream', '2','55', 11),
	   (20, 'Deireadh An Tuath', '1','43', 11),
	   (21, 'Oliver''s Army', '2','58', 12),
	   (22, 'Peace, Love, and Understanding', '3','31', 12),
	   (23, 'Moods For Moderns', '2','48', 12),
	   (24, 'All Over Town', '3','00', 13),
	   (25, 'Tellin'' Me lies', '2','59', 13);

-- 5: Total number of songs --
SELECT COUNT(*) AS 'Total Number of Songs' FROM Song

-- 7: The highest and the lowest suggested price --
SELECT MAX(suggested_price) AS 'The Highest Suggested Price' 
FROM Album

SELECT MIN(suggested_price) AS 'The Lowest Suggested Price' 
FROM Album

-- 10: Names of the albums --
SELECT album_name AS 'Names of Albums',
	(SELECT COUNT(song_id) FROM Song
	 WHERE Song.album_id = Album.album_id) AS 'Number of Songs'
FROM Album

-- 12: Names of all genres  
SELECT Musical_genre.musical_genre AS 'Genres',
		COUNT(Song.song_id) AS 'Number of Songs'
FROM Musical_genre
JOIN Album ON Musical_genre.musical_genre_id = Album.musical_genre_id
JOIN Song ON Song.album_id = Album.album_id
GROUP BY Musical_genre.musical_genre, Album.album_id
HAVING COUNT(Song.song_id) < 4

-- 14: Names of all recordings --
SELECT A.artist_name, MG.musical_genre
FROM Song S, Recording_artist A, Album AL,  Musical_genre MG
WHERE A.recording_artist_id = AL.recording_artist_id
AND S.album_id = AL.album_id
AND AL.musical_genre_id = MG.musical_genre_id
GROUP BY a.artist_name, MG.musical_genre
ORDER BY count(*) ASC





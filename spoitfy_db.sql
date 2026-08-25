-- SQL Project -- Spotify Datasets

-- Create Table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
	artist VARCHAR(255),
	track VARCHAR(255),
	album VARCHAR(255),
	album_type VARCHAR(50),
	danceability FLOAT,
	energy FLOAT,
	loudness FLOAT,
	speechiness FLOAT,
	acousticness FLOAT,
	instrumentalness FLOAT,
	liveness FLOAT,
	valence FLOAT,
	tempo FLOAT,
	duration_min FLOAT,
	title VARCHAR(255),
	channel VARCHAR(255),
	views FLOAT,
	likes BIGINT,
	comments BIGINT,
	licensed BOOLEAN,
	official_video BOOLEAN,
	stream BIGINT,
	energy_liveness FLOAT,
	most_played_on VARCHAR(50)
	);


----- EDA -----

SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT COUNT(track) FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;

SELECT * FROM spotify
WHERE duration_min = 0;

SELECT MAX(views) FROM spotify;

SELECT MAX(likes) FROM spotify;

SELECT MAX(comments) FROM spotify;

SELECT MIN(views) FROM spotify;

SELECT MIN(likes) FROM spotify;

SELECT MIN(comments) FROM spotify;

SELECT * FROM spotify
WHERE views = 0;

SELECT DISTINCT most_played_on FROM spotify;


/*
--- ------------------------------
---	DATA ANALYSIS - EASY CATEGORY
--- ------------------------------
Q1 : Retrieve the names of all tracks that have more than 1 billion streams.
Q2 : List all albums along with their respective artists.
Q3 : Get the total number of comments for tracks where licensed = TRUE.
Q4 : Find all tracks that belong to the album type single.
Q5 : Count the total number of tracks by each artist.
*/


-- Q1 : Retrieve the names of all tracks that have more than 1 billion streams.

SELECT track, stream
FROM spotify
WHERE stream > 1000000000;



-- Q2 : List all albums along with their respective artists.

SELECT DISTINCT album, artist albums
FROM spotify
ORDER BY album;


-- Q3 : Get the total number of comments for tracks where licensed = TRUE.

SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = TRUE
GROUP BY licensed;



-- Q4 : Find all tracks that belong to the album type single.

SELECT track, album_type FROM spotify
WHERE album_type = 'single';



-- Q5 : Count the total number of tracks by each artist.

SELECT artist, COUNT(track) AS total_tracks FROM spotify
GROUP BY artist;


/*
--- ------------------------------
---	DATA ANALYSIS - MEDIUM CATEGORY
--- ------------------------------
Q6 : Calculate the average danceability of tracks in each album.
Q7 : Find the top 5 tracks with the highest energy values.
Q8 : List all tracks along with their views and likes where official_video = TRUE.
Q9 : For each album, calculate the total views of all associated tracks.
Q10 : Retrieve the track names that have been streamed on Spotify more than YouTube.
*/


-- Q6 : Calculate the average danceability of tracks in each album.

SELECT album, AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;



-- Q7 : Find the top 5 tracks with the highest energy values.

SELECT track, MAX(energy) AS highest_energy
FROM spotify
GROUP BY track
ORDER BY highest_energy DESC
LIMIT 5;



-- Q8 : List all tracks along with their views and likes where official_video = TRUE.

SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes FROM spotify
WHERE official_video = TRUE
GROUP BY track
ORDER BY 2 DESC;



-- Q9 : For each album, calculate the total views of all associated tracks.

SELECT album, track, SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY 3 DESC;


-- Q10 : Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM
	(SELECT track, 
		COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS most_played_on_youtube,
		COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS most_played_on_spotify
	FROM spotify
	GROUP BY 1)
WHERE (most_played_on_youtube < most_played_on_spotify)
	AND
	(most_played_on_youtube <> 0);




/*
--- ------------------------------
---	DATA ANALYSIS - ADVANCED CATEGORY
--- ------------------------------
Q11 : Find the top 3 most-viewed tracks for each artist using window functions.
Q12 : Write a query to find tracks where the liveness score is above the average.
Q13 : Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
Q14 : Find tracks where the energy-to-liveness ratio is greater than 1.2.
Q15 : Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
*/


-- Q11 : Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist AS (
SELECT
	artist,
	track,
	SUM(views) AS total_views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS ranking
FROM spotify
GROUP BY 1,2
)
SELECT * FROM ranking_artist
WHERE ranking <= 3;



-- Q12 : Write a query to find tracks where the liveness score is above the average.

SELECT artist,
	track,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);



-- Q13 : Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH energy_rank AS
(SELECT 
	album,
	MAX(energy) AS highest_energy,
	MIN(energy) AS lowest_energy
FROM spotify
GROUP BY 1
)
SELECT
	album,
	(highest_energy - lowest_energy) AS energy_diff
FROM energy_rank
ORDER BY energy_diff DESC;



-- Q14 : Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT 
	artist,
	track,
	energy_liveness
FROM spotify
WHERE energy_liveness > 1.2;



-- Q15 : Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.	

SELECT 
	artist,
	track,
	album,
	likes,
	SUM(likes) OVER(ORDER BY views DESC) AS cumulative_likes,
	views
FROM spotify;


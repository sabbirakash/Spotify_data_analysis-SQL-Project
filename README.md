# Spotify Advanced SQL Project and Query Optimization P-6
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
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
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 2. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

---

## 15 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.

	```sql
		SELECT track, stream
		FROM spotify
		WHERE stream > 1000000000;
	```
 
2. List all albums along with their respective artists.

   ```sql
		SELECT DISTINCT album, artist albums
		FROM spotify
		ORDER BY album;
   ```
   
4. Get the total number of comments for tracks where `licensed = TRUE`.
	
	```sql
		SELECT SUM(comments) AS total_comments
		FROM spotify
		WHERE licensed = TRUE
		GROUP BY licensed;
 	```
 
5. Find all tracks that belong to the album type `single`.

   ```sql
		SELECT track, album_type FROM spotify
		WHERE album_type = 'single';
   ```
   
7. Count the total number of tracks by each artist.

    ```sql
		SELECT artist, COUNT(track) AS total_tracks FROM spotify
		GROUP BY artist;
   ```
   
### Medium Level
6. Calculate the average danceability of tracks in each album.
	
	```sql
		SELECT album, AVG(danceability) AS avg_danceability
		FROM spotify
		GROUP BY album
		ORDER BY avg_danceability DESC;
	```
 
7. Find the top 5 tracks with the highest energy values.
	
	```sql
		SELECT track, MAX(energy) AS highest_energy
		FROM spotify
		GROUP BY track
		ORDER BY highest_energy DESC
		LIMIT 5;
	```
 
8. List all tracks along with their views and likes where `official_video = TRUE`.
	
	```sql
		SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes FROM spotify
		WHERE official_video = TRUE
		GROUP BY track
		ORDER BY 2 DESC;
	```
 
9. For each album, calculate the total views of all associated tracks.
	
	```sql
		SELECT album, track, SUM(views) AS total_views
		FROM spotify
		GROUP BY album, track
		ORDER BY 3 DESC;
	```
 
10. Retrieve the track names that have been streamed on Spotify more than YouTube.
	
	```sql
		SELECT * FROM
			(SELECT track, 
				COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS most_played_on_youtube,
				COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS most_played_on_spotify
			FROM spotify
			GROUP BY 1)
		WHERE (most_played_on_youtube < most_played_on_spotify)
			AND
			(most_played_on_youtube <> 0);
	```
 
### Advanced Level
11. Find the top 3 most-viewed tracks for each artist using window functions.
	
	```sql
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
	```
 
12. Write a query to find tracks where the liveness score is above the average.
	
	```sql
		SELECT artist,
			track,
			liveness
		FROM spotify
		WHERE liveness > (SELECT AVG(liveness) FROM spotify);
	```
 
13. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
	
	```sql
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
	```
   
14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
	
	```sql
		SELECT 
			artist,
			track,
			energy_liveness
		FROM spotify
		WHERE energy_liveness > 1.2;
	```
 
15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
	
	```sql
		SELECT 
			artist,
			track,
			album,
			likes,
			SUM(likes) OVER(ORDER BY views DESC) AS cumulative_likes,
			views
		FROM spotify;
	```
 
## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.


## Contributing
If you would like to contribute to this project, feel free to fork the repository, submit pull requests, or raise issues.

---

## License
This project is licensed under the MIT License.

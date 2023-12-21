/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;


	SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
	FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	Join track on album.album_id=track.album_id
	Join album on artist.artist_id=album.artist_id
	where genre.name like 'Rock'
	GROUP BY artist.artist_id
	ORDER BY number_of_songs DESC
	LIMIT 10;
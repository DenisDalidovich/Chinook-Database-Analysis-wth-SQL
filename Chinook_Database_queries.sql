/* Q1. There are 25 genres in total. How much revenue does each genre bring? (from the highest to the lowest) */

SELECT g.name AS genre, 
SUM(i.unit_price* i.quantity) AS revenue_by_genre
FROM genre g
JOIN track t
USING(genre_id)
JOIN invoice_line i
USING(track_id)
GROUP BY genre
ORDER BY 2 DESC



/* Q2. There are 24 countries where songs are sold. 
Which countries bring the highest revenue? */

SELECT i.billing_country AS country, 
SUM(il.unit_price* il.quantity) AS revenue_by_country_top
FROM invoice_line il
JOIN invoice i
USING(invoice_id)
GROUP BY country
ORDER BY 2 DESC;



/* Q3. There are 5 different types of media files containing songs. 
How is the revenue distributed among these types of media? */

SELECT mt.name AS type_of_media, 
SUM(i.unit_price* i.quantity) AS revenue_by_media_type
FROM media_type mt
JOIN track t
USING(media_type_id)
JOIN invoice_line i
USING(track_id)
GROUP BY type_of_media
ORDER BY 2 DESC;



/* Q4a. How many songs were sold each year (2009-2013)
and which year brought most profit? */

SELECT DATE_PART('year', i.invoice_date) AS year,
COUNT(i.invoice_id) AS songs_sold,
SUM(il.unit_price* il.quantity) AS revenue_by_year
FROM invoice i
JOIN invoice_line il
USING(invoice_id)
GROUP BY year
ORDER BY 1 ASC;



/* Q4b. Is there a monthly (seasonal) dependence of the number
of songs sold as well as profit? */

SELECT TO_CHAR(i.invoice_date, 'Month') AS month,
COUNT(i.invoice_id) AS songs_sold,
SUM(il.unit_price* il.quantity) AS revenue_by_month
FROM invoice i
JOIN invoice_line il
USING(invoice_id)
GROUP BY month
ORDER BY 3  DESC;



/* Q5a. There are 18 different playlists. How much revenue does each playlist bring? */

SELECT p.name AS playlist, 
SUM(i.unit_price* i.quantity) AS revenue_by_playlist
FROM playlist p
JOIN playlist_track pt
USING(playlist_id)
JOIN track t
USING(track_id)
JOIN invoice_line i
USING(track_id)
GROUP BY playlist
ORDER BY 2 DESC;



/* Q5b People of which countries listen classical music? */

SELECT i.billing_country as country_class,
COUNT(i.invoice_id) AS orders_class
FROM playlist p
JOIN playlist_track pt
USING(playlist_id)
JOIN track t
USING(track_id)
JOIN invoice_line il
USING(track_id)
JOIN invoice i
USING(invoice_id)
WHERE p.name LIKE 'Classical%'
GROUP BY country_class
ORDER BY 2 DESC;




/* Q6a. There are 275 different artists. What are the top 10 best selling artists in terms of the number of songs sold 
and revenue? */

SELECT a.name AS artist, 
COUNT(il.invoice_id) AS number_of_songs,
SUM(il.unit_price* il.quantity) AS revenue_by_artist
FROM artist a
JOIN album al
USING(artist_id)
JOIN track t 
USING(album_id)
JOIN invoice_line il
USING(track_id)
GROUP BY artist
ORDER BY 2 DESC
LIMIT 10;



/* Q6b. There are 347 different albums presented in the database. 
What are the top 10 best selling albums in terms of revenue
and whom they belong to? */

SELECT al.title AS album,
a.name AS playing_artist, 
SUM(il.unit_price* il.quantity) AS revenue_by_album
FROM artist a
JOIN album al
USING(artist_id)
JOIN track t 
USING(album_id)
JOIN invoice_line il
USING(track_id)
GROUP BY album, playing_artist
ORDER BY 3 DESC
LIMIT 10;



/* Q6c How many artists have more than three albums? */

SELECT a.name AS artist_name,
COUNT(al.album_id) AS total_albums
FROM artist a
JOIN album al
USING(artist_id)
GROUP BY artist_name
HAVING COUNT(al.album_id) >3
ORDER BY total_albums DESC;



/* Q6d What is the fraction of the revenue brought by top 10 
best selling artists? */

WITH cte1 AS (
SELECT SUM(revenue_by_artist) AS sum1
FROM (
SELECT a.name AS artist, 
COUNT(il.invoice_id) AS number_of_songs,
SUM(il.unit_price* il.quantity) AS revenue_by_artist
FROM artist a
JOIN album al
USING(artist_id)
JOIN track t 
USING(album_id)
JOIN invoice_line il
USING(track_id)
GROUP BY artist
ORDER BY 2 DESC
LIMIT 10) a ),

cte2 AS (
SELECT SUM(unit_price *quantity) AS sum2 FROM invoice_line )

SELECT CAST(cte1.sum1/cte2.sum2 AS DEC(5,2) ) 
AS frac_of_revenue_by_top_10_artists
FROM cte1, cte2;



/* Q6e What are the top 10 artists with the highest number of
distinct customers? */

SELECT a.name AS name_of_artist,
COUNT(DISTINCT i.customer_id) AS total_customers
FROM artist a
JOIN album al
USING(artist_id)
JOIN track t
USING(album_id)
JOIN invoice_line il
USING(track_id)
JOIN invoice i
USING(invoice_id)
GROUP BY name_of_artist 
ORDER BY 2 DESC
LIMIT 10;




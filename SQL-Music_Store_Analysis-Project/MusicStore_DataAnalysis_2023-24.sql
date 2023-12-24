-- LEVEL 1

-- Q1. Who is the senior most employee based on job title?

select * from employee
order by levels desc
limit 1


-- Q2. Who is the newest employee?
select * from employee
order by hire_date desc
limit 1


-- Q3. What are top 3 values of total invoice with the customer id and country name?
select customer_id,total, billing_country from invoice
order by total desc 
limit 3


-- 	Q4. Which city has the best customers? We would like to throw a promotional Music
-- Festival in the city we made the most money. Write a query that returns one city that
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice
-- totals

select billing_city, sum(total) as invoice_total
from invoice
group by billing_city
order by invoice_total desc
limit 1


-- Q5. Who is the best customer? The customer who has spent the most money will be
-- declared the best customer. Write a query that returns the person who has spent the
-- most money

select c.customer_id,concat(c.first_name, c.last_name) as Full_Name, sum(total) as total_invoice
from invoice i
join customer c on i.customer_id=c.customer_id
group by c.customer_id
order by total_invoice desc
limit 1



-- LEVEL 2

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/* Method 1 */

select distinct c.email, c.first_name,c.last_name
from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
where track_id in(
select t.track_id from track t
	join genre g on t.genre_id=g.genre_id
	where g.name like '%Rock%'
)
order by c.email



/* Method 2 */

SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;


/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select a.artist_id,a.name, count(a.artist_id) as Total_Track_Count
from artist a
join album alb on a.artist_id=alb.artist_id
join track t on alb.album_id=t.album_id
join genre g on t.genre_id=g.genre_id
where g.name like '%Rock%'
group by a.artist_id
order by Total_Track_Count desc
limit 10


/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select t.name, t.milliseconds
from track t
where t.milliseconds > (select avg(t.milliseconds) as Avg_Length
								  from track t)
order by t.milliseconds desc 



-- LEVEL 3

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */

with best_artist as (
	select a.artist_id as Artist_id, a.name as Name, sum(il.unit_price*il.quantity) as Total_sales
	from invoice_line il
	join track t on il.track_id=t.track_id
	join album alb on t.album_id=alb.album_id
	join artist a on alb.artist_id=a.artist_id
	group by 1
	order by 3 DESC
	limit 1
)

select c.customer_id, c.first_name, c.last_name, ba.name, SUM(il.unit_price*il.quantity) AS amount_spent
from invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
join album alb on t.album_id=alb.album_id
join best_artist ba on alb.artist_id=ba.artist_id
group by 1,2,3,4
ORDER BY 5 DESC;



/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

/* Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level. */

with most_popular_genre as (
SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
select mpg.purchases, mpg.country, mpg.name, mpg.genre_id
from most_popular_genre mpg
where RowNo <=1;



/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */

with cte as(select i.customer_id, c.first_name, c.last_name, i.billing_country, sum(i.total) as Total,
		row_number() over(Partition by i.billing_country order by sum(i.total) desc) as RowNo
from invoice i
join customer c on i.customer_id=c.customer_id
-- join invoiceline il on i.invoice_id=il.invoice_id
group by 1,2,3,4
order by 4 asc, 5 desc
)
select cte.customer_id, cte.first_name, cte.last_name, cte.billing_country, cte.total
from cte
where cte.RowNo<=1;





-- Q3. What are top 3 values of total invoice?

select total from invoice
order by total desc
limit 3
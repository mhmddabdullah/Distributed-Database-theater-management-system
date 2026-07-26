USE Sub_Theater;
SELECT theater_id, theater_name, location
FROM dbo.Theater;


USE Sub_Theater;
SELECT hall_id, theater_id, hall_name, total_capacity
FROM dbo.Hall;



USE Sub_Theater;
SELECT customer_id, first_name, last_name, loyalty_points
FROM dbo.Customer;



USE Sub_Theater;
SELECT location, COUNT(*) AS theater_count
FROM dbo.Theater
GROUP BY location;
SELECT c.CustomerId,
	   c.FirstName || ' ' ||c.LastName AS full_name, 
	   SUM(i.Total) total
FROM Customer c NATURAL JOIN Invoice i
GROUP BY 1, 2
ORDER BY 3 DESC;
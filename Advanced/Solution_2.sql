WITH customer_per_country AS(
    SELECT c.Country, c.CustomerId,
			c.FirstName || " " || c.LastName Customer_Name,
			SUM(i.Total) Total_Spent
    FROM Customer c NATURAL JOIN Invoice i
    GROUP BY 1, 2, 3)

SELECT * from customer_per_country main
WHERE main.Total_spent = (
	SELECT MAX(Total_spent)
	FROM customer_per_country sub
	WHERE main.Country = sub.Country
	)
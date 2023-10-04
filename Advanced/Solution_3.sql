/* Calculate the purchase count for each music genre in each country */
WITH genre_per_country AS (
    SELECT c.Country, g.Name Genre,
        count(*) Purchase_Count
    FROM Customer c JOIN Invoice i
      ON c.CustomerId = i.CustomerId
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId  = g.GenreId
    GROUP BY 1, 2
    ORDER BY 1, 3 DESC)

/* Select all columns from the genre_per_country CTE and alias it as "main" */
SELECT *
FROM genre_per_country main
WHERE main.Purchase_Count = (
    /* Find the maximum purchase count within each country */
    SELECT MAX(Purchase_Count)
    FROM genre_per_country sub
    WHERE main.Country = sub.Country);
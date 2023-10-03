SELECT DISTINCT(c.Email), c.FirstName, c.LastName, g.Name genre
FROM Customer c NATURAL JOIN Invoice i
NATURAL JOIN InvoiceLine il
NATURAL JOIN Track t
JOIN Genre g ON t.GenreId = g.GenreId
WHERE genre == 'Rock'
ORDER BY 1;
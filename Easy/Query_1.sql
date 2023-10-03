SELECT c.Country, COUNT(i.InvoiceId) Invoices
FROM Customer c NATURAL JOIN Invoice i 
GROUP BY 1
ORDER BY 2 DESC;
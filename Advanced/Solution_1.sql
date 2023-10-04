/* Getting amount of earnings per each Artist in descending
   order to get the most earning one */
WITH earns_of_artists AS(
	SELECT a.ArtistId, a.Name Artist_Name, SUM(il.UnitPrice * il.Quantity) Total_Earnings
	FROM Artist a JOIN Album al
	  ON a.ArtistId = al.ArtistId
	JOIN Track t ON al.AlbumId = t.AlbumId
	JOIN InvoiceLine il ON t.TrackId = il.TrackId
	GROUP BY 1, 2
	ORDER By 3 DESC),

/* Getting all tracks of the most earning artist, this help 
us getting all invoice lines customers did for only him tracks */
tracks_of_most_earning_artist AS(	
	SELECT a.Name, t.TrackId
	FROM Artist a JOIN Album al
	  ON a.ArtistId = al.ArtistId
	JOIN Track t ON al.AlbumId = t.AlbumId
	WHERE a.ArtistId = (
		SELECT ArtistId FROM earns_of_artists
		LIMIT 1)
	)

/* Getting the customers that spent most money on this artist's tracks */
select c.CustomerId, c.FirstName || ' ' || c.LastName Customer_Name,
	   SUM(il.UnitPrice * il.Quantity) Total_Spending
FROM Customer c JOIN Invoice i
  ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
WHERE il.TrackId IN (
	SELECT TrackId from tracks_of_most_earning_artist)
GROUP BY 1, 2
ORDER BY 3 DESC;
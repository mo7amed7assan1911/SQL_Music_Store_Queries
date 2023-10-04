SELECT a.ArtistId, a.Name Artist_name, 
       g.Name genre_name, COUNT(*) Number_of_songs
FROM Artist a NATURAL JOIN Album al
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE g.Name == 'Rock'
GROUP BY 1, 2
ORDER BY 4 DESC;
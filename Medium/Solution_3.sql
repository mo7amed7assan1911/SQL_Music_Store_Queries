SELECT Name Track_name, Milliseconds FROM Track
WHERE Milliseconds > (
	/* Getting the average duration of all tracks*/
    SELECT AVG(Milliseconds)
    FROM Track
)
ORDER BY 2 DESC;
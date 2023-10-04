# Advanced-Level SQL Questions
💡 **Reminder**: The database schema provided at the end of the md file. 

---

## Question 1:  Who is the artist that has earned the most, and which customer has spent the most on this artist's tracks?

> **Brief Explanation:**
> This SQL query achieves two significant tasks through the utilization of two Common Table Expressions (CTEs).
> * In the first CTE, named `earns_of_artists`, it calculates the earnings for each artist by summing the unit prices of tracks multiplied by their quantities. This CTE effectively identifies the artist who has earned the most from sales, listing them in descending order of earnings.
> * The second CTE, `tracks_of_most_earning_artist`, is based on the artist identified in the first CTE. It retrieves all tracks associated with the top-earning artist, enabling us to pinpoint the specific tracks related to their earnings.
> * The main query then delves into finding the customer who spent the most on the tracks of this top-earning artist. It joins the Customer, Invoice, and InvoiceLine tables to determine customer spending on these tracks, aggregating the results by customer and presenting them in descending order of spending.

### SQL Query

```sql
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
```

### Results

**Top Earning Artists:**

|ArtistId|Artist_Name|Total_Earnings|
|---|---|---|
|90|Iron Maiden|138.6|
|150|U2|105.93|
|50|Metallica|90.09|
|22|Led Zeppelin|86.13|
|149|Lost|81.59|

**Top Spending Customers on the Iron Maiden Top Artist's Tracks:** 

|CustomerId|Customer_Name|Total_Spending|
|---|---|---|
|55|Mark Taylor|17.82|
|35|Madalena Sampaio|15.84|
|16|Frank Harris|13.86|
|36|Hannah Schneider|13.86|
|5|František Wichterlová|8.91|

---

## Question 2: Find the top-spending customer for each country and display their spending amount.

> **Brief Explanation:**
> - Initiated the process by creating a Common Table Expression (CTE) named `customer_per_country`. This CTE aggregates customer spending data by country, combining their first and last names for clarity.
> - Then crafted a main query that utilizes a nested subquery. The subquery identifies the maximum total spending within each country, allowing me to pinpoint the customers who spent the most.
> - The outcome is a list that highlights the top-spending customers in each country, making it easy to identify the highest spenders.

### SQL Query

```sql
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

```

### Results

|Country|CustomerId|Customer_Name|Total_Spent|
|---|---|---|---|
|Brazil|1|Luís Gonçalves|39.62|
|Canada|3|François Tremblay|39.62|
|Norway|4|Bjørn Hansen|39.62|
|Czech Republic|6|Helena Holý|49.62|
|Austria|7|Astrid Gruber|42.62|

---

## Question 3: _Find the most popular music genre for each country, considering the genre with the highest purchase count. If multiple genres tie for the top spot in a country, list them all._

> **Brief Explanation:** 
> * I started by calculating the purchase count for each genre in every country. Using a Common Table Expression (CTE) called `genre_per_country`.
> * Then made a nested subquery to find the maximum purchase count within each country, making it easy to determine the most popular genre(s) in those countries.
> * The end result is list that reveals the top music genre(s) in each country.

### SQL Query

```sql
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
```

### Results

|Country|Genre|Purchase_Count|
|---|---|---|
|Argentina|Rock|9|
|Argentina|Alternative & Punk|9|
|Australia|Rock|22|
|Austria|Rock|15|
|Belgium|Rock|21|

---

### Shema
![schema](../schema.png)

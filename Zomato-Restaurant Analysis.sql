--- 1. Descriptive Analysis
--- a. Calculate the total number of restaurants by city or locality.


--- a)	For City 

SELECT 
    "City", 
    COUNT(DISTINCT "Restaurant ID") AS total_restaurants
FROM 
    zomato
GROUP BY 
    "City"
ORDER BY 
    total_restaurants DESC;

--- b) For Locality

SELECT 
    "Locality", 
    COUNT(DISTINCT "Restaurant ID") AS total_restaurants
FROM 
    zomato
GROUP BY 
    "Locality"
ORDER BY 
    total_restaurants DESC;


--- b. Find the average rating of restaurants by city or locality.

--- a) For City

SELECT 
    "City", 
    AVG("Aggregate rating") AS avg_rating
FROM 
    zomato
GROUP BY 
    "City"
ORDER BY 
    avg_rating DESC;

--- b) For Locality

SELECT 
    "Locality", 
    AVG("Aggregate rating") AS avg_rating
FROM 
    zomato
GROUP BY 
    "Locality"
ORDER BY 
    avg_rating DESC;

--- c)	Calculate the count of cuisines and analyze most popular cuisines

SELECT 
    unnest(string_to_array("Cuisines", ', ')) AS cuisine,
    COUNT(*) AS cuisine_count
FROM 
    "zomato"
GROUP BY 
    cuisine
ORDER BY 
    cuisine_count DESC;


--- 2. Comparative Analysis
--- a) Compare the average cost for two across different cities.

SELECT 
    "City", 
    "Locality", 
    AVG("Average Cost for two") AS average_cost_for_two
FROM 
    "zomato"
GROUP BY 
    "City", "Locality"
ORDER BY 
    average_cost_for_two DESC;

--- b) Compare the average votes received by restaurants offering different cuisines.
--- Since the cuisines are present in a single row, separated by commas, there is a need to use the UNNEST() function to split the cuisines:

SELECT 
    cuisine,
    AVG("Votes") AS average_votes
FROM (
    SELECT 
        unnest(string_to_array("Cuisines", ', ')) AS cuisine,
        "Votes"
    FROM 
        "zomato"
) AS cuisine_data
GROUP BY 
    cuisine
ORDER BY 
    average_votes DESC;

--- 3. Aggregation and Grouping
--- a) Group restaurants by Price range and find the average aggregate rating for each range.

SELECT 
    "Price range", 
	AVG("Aggregate rating") as avg_aggregate_rating
FROM 
    "zomato"
GROUP BY 
    "Price range"
ORDER BY 
     avg_aggregate_rating DESC,"Price range" DESC;

--- b) Group by cuisines to find the total votes and average votes.

SELECT 
    unnest(string_to_array("Cuisines", ', ')) AS cuisine, -- Splits cuisines into individual values
    "Price range" AS price_range,
    AVG("Aggregate rating") AS average_rating
FROM 
    "zomato"
WHERE 
    "Cuisines" IS NOT NULL -- Exclude rows with null cuisines
GROUP BY 
    cuisine, "Price range"
ORDER BY 
    price_range DESC, average_rating DESC;

--- 4. Filtering and Segmentation
--- a) Identify the top-rated restaurants with the maximum aggregate rating.

SELECT 
    "Restaurant Name", 
    "City", 
    "Locality", 
    "Cuisines", 
    "Aggregate rating"
FROM 
    "zomato"
WHERE 
    "Aggregate rating" = (SELECT MAX("Aggregate rating") FROM "zomato")
ORDER BY 
    "Restaurant Name";

--- b) Filter for restaurants that have table booking but no online delivery.

SELECT 
    "Restaurant Name", 
    "City",  
    "Aggregate rating"
FROM 
    "zomato"
WHERE 
    "Has Table booking" = 'Yes' 
    AND "Has Online delivery" = 'No'
ORDER BY 
    "Aggregate rating" DESC;

--- c) Find restaurants with the most votes in each city.

SELECT 
    "City", 
    "Restaurant Name", 
    "Votes"
FROM 
    "zomato" z1
WHERE 
    "Votes" = (
        SELECT MAX("Votes")
        FROM "zomato" z2
        WHERE z1."City" = z2."City"
    )
ORDER BY 
    "City";


--- 5. Trend Analysis
--- a) Study how Average Cost for Two affects the number of votes.

SELECT 
    "Average Cost for two", 
    AVG("Votes") AS average_votes
FROM 
    zomato
GROUP BY 
    "Average Cost for two"
ORDER BY 
	"Average Cost for two" DESC, average_votes;


--- 6. Geographical Insights
--- a) Determine which cities/localities have the most number of restaurants.

SELECT 
    "City", 
    Count("Restaurant ID") AS count_of_restaurants
FROM 
    zomato
GROUP BY 
    "City"
ORDER BY 
	count_of_restaurants DESC;


--- 7. Outlier Detection
--- a) Detect restaurants with unusually high or low average costs.

WITH CostStats AS (
    SELECT 
        AVG("Average Cost for two") AS avg_cost,
        STDDEV("Average Cost for two") AS std_dev
    FROM 
        zomato
)
SELECT 
    "Restaurant Name", 
    "Average Cost for two",
    "City", 
    "Locality"
FROM 
    zomato,
    CostStats
WHERE 
    "Average Cost for two" > avg_cost + 2 * std_dev
    OR "Average Cost for two" < avg_cost - 2 * std_dev
ORDER BY 
    "Average Cost for two" DESC;


--- 8. Textual Insights
--- a) Identify the most common cuisines offered across restaurants in a city.

WITH CuisineExploded AS (
    SELECT 
        "City", 
        UNNEST(STRING_TO_ARRAY("Cuisines", ', ')) AS Cuisine
    FROM 
        zomato
)
SELECT DISTINCT ON ("City")
    "City", 
    Cuisine, 
    COUNT(*) OVER (PARTITION BY "City", Cuisine) AS CuisineCount
FROM 
    CuisineExploded
ORDER BY 
    "City", CuisineCount DESC;

--- b) Analyze Rating text distribution (e.g., "Excellent," "Very Good") by cuisine and city.

WITH CuisineExploded AS (
    SELECT 
        "City", 
        UNNEST(STRING_TO_ARRAY("Cuisines", ', ')) AS Cuisine, 
        "Rating text"
    FROM 
        zomato
)
SELECT 
    "City", 
    Cuisine, 
    COUNT(*) AS RatingTextCount
FROM 
    CuisineExploded
GROUP BY 
    "City", Cuisine, "Rating text"
HAVING 
    "Rating text" = 'Excellent'
ORDER BY 
    "City", Cuisine, RatingTextCount DESC;
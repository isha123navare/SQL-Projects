# SQL-Projects

1. Descriptive Analysis
a. Calculate the total number of restaurants by city and locality.

SELECT 
    "City", 
    COUNT(DISTINCT "Restaurant ID") AS total_restaurants
FROM 
    zomato
GROUP BY 
    "City"
ORDER BY 
    total_restaurants DESC;

b. Find the average rating of restaurants by city and locality.

SELECT 
    "City", 
    AVG("Aggregate rating") as "Average Rating"
FROM
    zomato
GROUP BY 
    "City"
ORDER BY
    "Average Rating" Desc


3. Comparative Analysis
Compare the average cost for two across different cities or cuisines.
Analyze the distribution of "Has Table Booking" and "Has Online Delivery" for various cuisines.
Compare the average votes received by restaurants offering different cuisines.

5. Aggregation and Grouping
Group restaurants by Price range and find the average aggregate rating for each range.
Aggregate the total number of votes for restaurants by rating color (e.g., Green, Dark Green).
Group by Locality to find the total votes or average cost for two.

7. Filtering and Segmentation
Identify the top-rated restaurants (e.g., Aggregate rating > 4.5).
Filter for restaurants that have table booking but no online delivery.
Find restaurants with the most votes in each city.

9. Trend Analysis
Analyze the relationship between price range and aggregate ratings.
Study how Average Cost for Two affects the number of votes.

11. Geographical Insights
Identify restaurants with the highest rating within a specific Longitude and Latitude range.
Determine which cities/localities have the most number of restaurants.

13. Customer Preferences
Analyze the most popular cuisines based on votes and aggregate ratings.
Find out which price range receives the highest votes.

15. Outlier Detection
Detect restaurants with unusually high or low average costs.
Identify restaurants with a significantly higher number of votes compared to the average.

17. Textual Insights
Identify the most common cuisines offered across restaurants in a city.
Analyze Rating text distribution (e.g., "Excellent," "Very Good") by cuisine or city.

19. Performance Ranking
Rank restaurants by aggregate rating within each city or locality.
Create a ranking of the most voted restaurants.

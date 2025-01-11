# Project 1: Analysis of Zomato Affiliated Restaurants

## Dataset Link:
https://drive.google.com/file/d/1J9zO8LxROxIyHCEwrxkxPVMrnf1BgCxD/view?usp=sharing

## Dataset Contains: 
Restaurant ID,Restaurant Name,Country Code,City,Address,Locality,Locality Verbose,Longitude,Latitude,Cuisines,Average Cost for two,Currency,Has Table booking,Has Online delivery,Is delivering now,Switch to order menu,Price range,Aggregate rating,Rating color,Rating text,Votes

## Worked On:
**Descriptive Analysis:**

1. Calculated the total number of restaurants grouped by city and locality.
   
2. Found the average ratings of restaurants grouped by city and locality.

3. Analyzed the count of cuisines and identified the most popular cuisines using the UNNEST() function.

**Comparative Analysis:**

1. Compared the average cost for two across different cities and localities.

2. Compared the average votes received by restaurants offering different cuisines using UNNEST() to split cuisines for analysis.

**Aggregation and Grouping:**
1. Grouped restaurants by price range and calculated the average aggregate rating for each range.

2. Grouped by cuisines to find the total votes and average aggregate ratings for each cuisine and price range.

**Filtering and Segmentation:**
1. Identified top-rated restaurants with the maximum aggregate rating.

2. Filtered for restaurants that offer table booking but no online delivery.

3. Found restaurants with the most votes in each city.

**Trend Analysis:**

1. Studied the relationship between Average Cost for Two and number of votes, identifying trends in customer spending and engagement.

**Geographical Insights:**

1. Determined cities and localities with the highest number of restaurants.

**Outlier Detection:**

1. Detected restaurants with unusually high or low average costs using statistical methods such as AVG and STDDEV.

**Textual Insights:**

1. Identified the most common cuisines offered across restaurants in a city by leveraging the UNNEST() function.

2. Analyzed the distribution of Rating Text (e.g., "Excellent," "Very Good") by cuisine and city.

## Key Observations & Insights:
1. Number of Restaurants: New Delhi, Gurgaon, Noida have the highest number of restaurants. Locality-wise, Connaught Palace, Rajouri Garden, Shahdara have the highest number of restaurants.
2. Average Rating: Restaurants in Inner City, Quezon City, Makati City (Cities) and West Park, Old Dutch Hospital Port, Setor de clubes Esportivos Sul(Localities) have the highest average aggragate ratings.
3. Popular Cuisines: North Indian, Chinese, Fast Food are the most popular cuisines.
4. Average Cost for Two: In Jakarta, Tangerang, Bogor average cost for two is the highest.
5. Restaurants with the highest votes in each city was analyzed. For instance, in Abu Dhabi, The Cheesecake Factory has highest votes.
6. The most famous cuisine in each city was analyzed. For instance, in Ahmedabad continental food is widely preferred.

# Project 2: Optimizing Online Sports Retail Revenue

## Dataset Link:
https://drive.google.com/drive/folders/15NiN1BuWoZqYjZUruC--9ydPGTjCZTVu?usp=sharing

## Dataset Contains:
brands: product_id, brand
Finance: product_id, listing_price, sale_price, discount, revenue 
info: product_name, product_id, description
reviews: product_id, rating, reviews
traffic: product_id, last_visited

## Worked On:
**Product Performance Analysis**

1. Top-performing Products: Ranked products and brands by revenue.

2. Revenue Share: Calculated each product’s and brand’s percentage contribution to total revenue.

3. Low-performing Products: Identified products with low revenue.

4. Sales vs. Listing Price: Analyzed average discount percentages across brands.

5. High-revenue, Low-review Products: Found high-earning products with poor ratings.

6. Discounts vs. Sales Volume: Explored the relationship between discounts and revenue.

**Customer Ratings and Reviews**

1. Highly-rated Products: Percentage of products with ratings > 4.

2. High Engagement, Low Revenue: Identified well-reviewed but low-earning products.

3. Review-to-Revenue Ratio: Analyzed how reviews correlate with revenue ranges.

**Traffic and Engagement**

1. Most Visited Products: Ranked products based on recent visits.

2. Brand Engagement: Compared brands by traffic and visits.

**Revenue and Pricing Trends**

1. Price Sensitivity: Analyzed products whose revenue was impacted by price changes.

2. Revenue by Discount Tier: Compared revenue across different discount ranges.

3. Brand Discounts: Ranked brands by average discounts offered.

## Key Insights & Observations
1. One of Nike's products was the highest revenue generating product amongst all. But overall revenue of Adidas far surpasses that of Nike.
2. In the dataset, Adidas products contributed almost 93% of revenue.
3. Certain products such as product "310805-137" had only 0.5% revenue share but a high rating of 5(out of 5) & could benefit from targeted quality improvements to sustain sales.
4. Conducted brand performance analysis, identifying that Nike had a higher percentage (32.29%) of customer ratings above 4 compared to Adidas (19.73%), showcasing stronger customer satisfaction.
5. About 20% of Adidas products have high engagement but poor financial performance. 
   
   

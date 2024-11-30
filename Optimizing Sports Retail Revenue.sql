-- Product Performance Analysis
-- 1. Top-performing products by revenue – Identify products generating the highest revenue.
-- ORDER BY REVENUE(Product_id)
SELECT 
    f.product_id, 
    b.brand, 
    f.revenue
FROM 
    finance AS f
JOIN 
    brands AS b
ON 
    f.product_id = b.product_id
ORDER BY 
    f.revenue DESC;

-- GROUP BY BRAND

SELECT 
    b.brand, 
    SUM(f.revenue) AS total_revenue
FROM 
    finance AS f
JOIN 
    brands AS b
ON 
    f.product_id = b.product_id
GROUP BY 
    b.brand
ORDER BY 
    total_revenue DESC;


-- 2. Revenue share by product (Quantitative) – Calculate the percentage contribution of each product to total revenue.


--- ORDER THE PERCENTAGES BY REVENUE(Product_id)
SELECT 
    f.product_id, 
    b.brand, 
    f.revenue, 
    ROUND((f.revenue / SUM(f.revenue) OVER ()) * 100, 2) AS percentage_contribution
FROM 
    finance AS f
JOIN 
    brands AS b
ON 
    f.product_id = b.product_id
ORDER BY 
   percentage_contribution DESC;


--- GROUP BY BRAND

SELECT 
    b.brand, 
    SUM(f.revenue) AS total_revenue,
    ROUND((SUM(f.revenue) / SUM(SUM(f.revenue)) OVER ()) * 100, 2) AS percentage_contribution
FROM 
    finance AS f
JOIN 
    brands AS b
ON 
    f.product_id = b.product_id
GROUP BY 
    b.brand
ORDER BY 
    total_revenue DESC;


--- 3. Low-performing products – Identify products with low revenue and suggest areas for improvement.
SELECT 
    f.product_id, 
    b.brand, 
    f.revenue
FROM 
    finance AS f
JOIN 
    brands AS b
ON 
    f.product_id = b.product_id
ORDER BY 
    f.revenue ASC;

-- 4. Sales price vs. listing price (Quantitative) – Calculate the average percentage difference between sale and listing prices.
SELECT 
    b.brand,
    AVG(
        ((f.listing_price - f.sale_price) / NULLIF(f.listing_price, 0)) * 100
    ) AS avg_percentage_difference
FROM 
    finance AS f
JOIN 
    brands AS b
ON 
    f.product_id = b.product_id
WHERE 
    f.listing_price > 0  -- Additional safeguard to filter out zero prices
GROUP BY 
    b.brand
ORDER BY 
    avg_percentage_difference;

-- 5. High-revenue products with low customer reviews – Products earning significant revenue despite low ratings or reviews.
-- QUERY 1:
SELECT 
    f.product_id,
    b.brand,
    f.revenue,
    r.rating
FROM 
    finance AS f
JOIN 
    brands AS b
ON 
    f.product_id = b.product_id
JOIN 
    reviews AS r
ON 
    f.product_id = r.product_id
WHERE 
    f.revenue > (SELECT AVG(revenue) FROM finance)  -- High revenue: Above average
    AND r.rating < 1                          -- Low reviews: Below 20
ORDER BY 
    f.revenue DESC;

-- QUERY 2:
WITH TotalRevenue AS (
    SELECT SUM(revenue) AS total_revenue
    FROM finance
)
SELECT 
    f.product_id,
    b.brand,
    f.revenue,
    r.rating,
    (f.revenue / tr.total_revenue) * 100 AS revenue_percentage
FROM 
    finance AS f
JOIN 
    brands AS b
ON 
    f.product_id = b.product_id
JOIN 
    reviews AS r
ON 
    f.product_id = r.product_id
CROSS JOIN 
    TotalRevenue AS tr
WHERE 
    f.revenue > (SELECT AVG(revenue) FROM finance)  -- High revenue: Above average
ORDER BY 
    f.revenue DESC;



--6. Correlation between discounts and sales volume – Explore whether higher discounts lead to increased revenue.
SELECT 
    f.product_id,
    b.brand,
    f.revenue,
    f.listing_price,
    f.sale_price,
    ((f.listing_price - f.sale_price) / f.listing_price) * 100 AS discount_percentage
FROM 
    finance AS f
JOIN 
    brands AS b
ON 
    f.product_id = b.product_id
WHERE 
    f.listing_price > 0 -- Avoid division by zero
ORDER BY 
    discount_percentage DESC;


-- Customer Ratings and Reviews
-- 7. Percentage of highly-rated products (Quantitative) – Determine the percentage of products with ratings above 4.
SELECT 
   b.brand,
   COUNT(CASE WHEN rating > 4 THEN 1 END) * 100.0 / COUNT(*) AS percentage_above_4
FROM 
    reviews AS r
JOIN 
    brands AS b
ON 
    r.product_id = b.product_id
GROUP BY
    b.brand;

-- 8. Products with high reviews but low revenue – Identify products with good engagement but poor financial performance.
WITH AvgValues AS (
    SELECT 
        AVG(r.reviews) AS avg_reviews, 
        AVG(f.revenue) AS avg_revenue
    FROM 
        reviews AS r
    JOIN 
        finance AS f
    ON 
        r.product_id = f.product_id
)
SELECT 
    f.product_id, 
    b.brand, 
    r.reviews AS engagement, 
    f.revenue AS financial_performance
FROM 
    reviews AS r
JOIN 
    brands AS b
ON 
    r.product_id = b.product_id
JOIN 
    finance AS f
ON 
    r.product_id = f.product_id
CROSS JOIN 
    AvgValues
WHERE 
    r.reviews > AvgValues.avg_reviews -- Good engagement
    AND f.revenue < AvgValues.avg_revenue -- Poor financial performance
ORDER BY 
    engagement DESC, financial_performance ASC;

-- Percentage of products with good engagement and poor financial performance:

WITH AvgValues AS (
    SELECT 
        AVG(r.reviews) AS avg_reviews, 
        AVG(f.revenue) AS avg_revenue
    FROM 
        reviews AS r
    JOIN 
        finance AS f
    ON 
        r.product_id = f.product_id
),
FilteredProducts AS (
    SELECT 
        b.brand, 
        COUNT(*) AS filtered_count
    FROM 
        reviews AS r
    JOIN 
        brands AS b
    ON 
        r.product_id = b.product_id
    JOIN 
        finance AS f
    ON 
        r.product_id = f.product_id
    CROSS JOIN 
        AvgValues
    WHERE 
        r.reviews > AvgValues.avg_reviews   -- Good engagement
        AND f.revenue < AvgValues.avg_revenue -- Poor financial performance
        AND b.brand IN ('Adidas', 'Nike')  -- Filter for Adidas and Nike
    GROUP BY 
        b.brand
),
TotalProducts AS (
    SELECT 
        b.brand, 
        COUNT(*) AS total_count
    FROM 
        brands AS b
    WHERE 
        b.brand IN ('Adidas', 'Nike')      -- Filter for Adidas and Nike
    GROUP BY 
        b.brand
)
SELECT 
    t.brand, 
    f.filtered_count, 
    t.total_count,
    (f.filtered_count * 100.0 / t.total_count) AS percentage
FROM 
    FilteredProducts AS f
JOIN 
    TotalProducts AS t
ON 
    f.brand = t.brand;


-- 9. Review-to-revenue ratio (Quantitative) – Analyze how many reviews correspond to a certain level of revenue.
WITH RevenueRanges AS (
    SELECT 
        CASE 
            WHEN f.revenue < 1000 THEN 'Below 1,000'
            WHEN f.revenue BETWEEN 1000 AND 5000 THEN '1,000 - 5,000'
            WHEN f.revenue BETWEEN 5001 AND 10000 THEN '5,001 - 10,000'
            WHEN f.revenue > 10000 THEN 'Above 10,000'
        END AS revenue_range,
        SUM(r.reviews) AS total_reviews,
        COUNT(r.product_id) AS product_count
    FROM 
        finance AS f
    JOIN 
        reviews AS r
    ON 
        f.product_id = r.product_id
    GROUP BY 
        revenue_range
    ORDER BY 
        revenue_range
)
SELECT 
    revenue_range, 
    total_reviews, 
    product_count, 
    (total_reviews * 1.0 / product_count) AS avg_reviews_per_product
FROM 
    RevenueRanges;



-- Traffic and Engagement
-- 10. Most frequently visited products – Identify products with the most recent or frequent traffic.
SELECT 
    t.product_id, 
    b.brand, 
    t.last_visited
FROM 
    traffic AS t
JOIN 
    brands AS b
ON 
    t.product_id = b.product_id
ORDER BY 
    t.last_visited DESC
LIMIT 10; 

-- Brand-Level Insights
-- 11. Average discount offered by brand (Quantitative) – Compare the average discount levels for each brand.
SELECT 
    b.brand, 
    AVG(f.listing_price * f.discount) AS avg_discount_amount
FROM 
    finance AS f
JOIN 
    brands AS b
ON 
    f.product_id = b.product_id
GROUP BY 
    b.brand
ORDER BY 
    avg_discount_amount DESC;

-- 12. Brand engagement comparison – Measure and rank brands by traffic or visits to their products.
SELECT 
    b.brand, 
    COUNT(t.product_id) AS visits_count
FROM 
    traffic AS t
JOIN 
    brands AS b
ON 
    t.product_id = b.product_id
GROUP BY 
    b.brand
ORDER BY 
    visits_count DESC;



-- Revenue and Pricing Trends
-- 13. Price sensitivity analysis – Identify products whose sales were strongly impacted by changes in price.
WITH PriceRevenueImpact AS (
    SELECT 
        f.product_id,
        f.listing_price,
        f.revenue,
        f.listing_price * (1 - f.discount) AS discounted_price,  -- Calculate the final price after discount
        CASE 
            WHEN f.listing_price != 0 THEN f.revenue / f.listing_price  -- Prevent division by zero
            ELSE NULL  -- Set to NULL if listing_price is zero
        END AS price_revenue_ratio
    FROM 
        finance AS f
)
SELECT 
    b.brand,
    pr.product_id,
    pr.listing_price,
    pr.discounted_price,
    pr.revenue,
    pr.price_revenue_ratio
FROM 
    PriceRevenueImpact AS pr
JOIN 
    brands AS b 
ON 
    pr.product_id = b.product_id
WHERE 
    pr.price_revenue_ratio IS NOT NULL  -- Eliminate rows with NULL price_revenue_ratio
ORDER BY 
    pr.price_revenue_ratio DESC;

--- 14.  Revenue by discount tier (Quantitative) – Compare revenue generated by products in different discount ranges (e.g., 10%, 20%, 50%).
WITH DiscountCategories AS (
    -- Categorize products into discount ranges and include brand information
    SELECT 
        f.product_id, 
        b.brand, 
        f.listing_price,
        f.listing_price * (1 - f.discount) AS discounted_price,  -- Calculate discounted price
        f.revenue,
        -- Calculate discount percentage
        f.discount * 100 AS discount_percentage
    FROM 
        finance f
    JOIN 
        brands b ON f.product_id = b.product_id
    WHERE 
        f.listing_price IS NOT NULL AND f.discount IS NOT NULL AND f.revenue IS NOT NULL
)
-- Main SELECT to compare revenue by discount categories
SELECT
    -- Define discount categories: 10%, 20%, 50% ranges
    CASE 
        WHEN discount_percentage <= 10 THEN '0-10%'
        WHEN discount_percentage > 10 AND discount_percentage <= 20 THEN '11-20%'
        WHEN discount_percentage > 20 AND discount_percentage <= 50 THEN '21-50%'
        ELSE 'Above 50%'
    END AS discount_range,
    
    -- Calculate total revenue for each discount range
    SUM(revenue) AS total_revenue,
    
    -- Calculate average revenue for each discount range
    AVG(revenue) AS avg_revenue
FROM 
    DiscountCategories
GROUP BY 
    discount_range
ORDER BY 
    discount_range;

-- 15. Top 10 products with the highest profit margins – Identify products with the largest gap between sale price and listing price.
-- Identify products with the largest price gap
SELECT
    f.product_id,
    b.brand,
    f.listing_price * (1 - f.discount) AS discounted_price, -- Calculate discounted price
    (f.listing_price - f.listing_price * (1 - f.discount)) AS price_gap -- Calculate price gap
FROM 
    finance f
JOIN 
    brands b ON f.product_id = b.product_id
WHERE 
    f.listing_price IS NOT NULL AND f.discount IS NOT NULL
ORDER BY 
    price_gap DESC -- Rank products by the largest price gap
LIMIT 10; -- Show top 10 products with the largest gap


-- Time-Based Analysis
-- 16. Monthly revenue trends (Quantitative) – Examine how revenue changes month over month.
SELECT 
    TO_CHAR(last_visited, 'YYYY-MM') AS month,         -- Extracts month and year in 'YYYY-MM' format
    SUM(f.revenue) AS total_revenue,                  -- Calculates total revenue for each month
    SUM(f.revenue) - LAG(SUM(f.revenue)) OVER (ORDER BY TO_CHAR(last_visited, 'YYYY-MM')) AS revenue_change
FROM traffic AS t
JOIN finance AS f
ON t.product_id = f.product_id
GROUP BY TO_CHAR(last_visited, 'YYYY-MM')
ORDER BY month DESC, revenue_change DESC; 

-- 17. Seasonality in product visits – Determine whether products are bought more frequently during specific months.
-- Calculate the percentage of products sold each month
WITH MonthlyCounts AS (
    SELECT 
        TO_CHAR(last_visited, 'Month') AS month,
        COUNT(product_id) AS count_of_products
    FROM
        traffic
    GROUP BY 
        TO_CHAR(last_visited, 'Month')
),
TotalCount AS (
    SELECT 
        SUM(count_of_products) AS total_products_sold
    FROM 
        MonthlyCounts
)
SELECT 
    mc.month,
    mc.count_of_products,
    ROUND((mc.count_of_products::NUMERIC / tc.total_products_sold) * 100, 2) AS percentage_of_products
FROM 
    MonthlyCounts mc
CROSS JOIN 
    TotalCount tc
ORDER BY 
    mc.count_of_products DESC;

-- Segmentation and Targeting
-- 18. Segmentation by price range – Group products into low, medium, and high price categories and analyze performance.

WITH PriceCategories AS (
    -- Group products into price categories
    SELECT
        f.product_id,
        b.brand,
        f.listing_price,
        f.revenue,
        -- Define price categories based on listing_price
        CASE
            WHEN f.listing_price < 75 THEN 'Low Price'
            WHEN f.listing_price BETWEEN 75 AND 150 THEN 'Medium Price'
            ELSE 'High Price'
        END AS price_category
    FROM 
        finance f
    JOIN 
        brands b ON f.product_id = b.product_id
    WHERE 
        f.listing_price IS NOT NULL AND f.revenue IS NOT NULL
)
-- Analyze performance for each price category
SELECT
    price_category,
    COUNT(product_id) AS total_products,
    SUM(revenue) AS total_revenue,
    AVG(revenue) AS avg_revenue
FROM 
    PriceCategories
GROUP BY 
    price_category
ORDER BY 
   total_revenue DESC, price_category;

-- 19. Revenue segmentation by ratings (Quantitative) – Calculate the total revenue for products grouped by ratings (e.g., <3, 3-4, >4).
SELECT 
    AVG(f.revenue) AS avg_revenue, 
    r.rating
FROM 
    finance AS f
JOIN 
    reviews AS r 
ON 
    r.product_id = f.product_id
GROUP BY 
    r.rating
ORDER BY 
   avg_revenue DESC, r.rating DESC;

--- Operational and Strategic Insights
-- 20. Inventory prioritization – Highlight products with low sales and ratings for potential discontinuation.
WITH AvgValues AS (
    -- Calculate the average revenue and average rating for products
    SELECT 
        AVG(f.revenue) AS avg_revenue, 
        AVG(r.rating) AS avg_rating
    FROM 
        finance AS f
    JOIN 
        reviews AS r 
    ON 
        f.product_id = r.product_id
)
SELECT 
    f.product_id,
    b.brand,
    f.revenue,
    r.rating
FROM 
    finance AS f
JOIN 
    reviews AS r 
ON 
    f.product_id = r.product_id
JOIN 
    brands AS b 
ON 
    f.product_id = b.product_id
CROSS JOIN 
    AvgValues
WHERE 
    f.revenue < AvgValues.avg_revenue   -- Low sales: below average revenue
    AND r.rating < AvgValues.avg_rating -- Low rating: below average rating
ORDER BY 
    f.revenue ASC, r.rating ASC;

-- 21. Marketing focus products – Identify products that need promotional effort due to low traffic or reviews.
WITH AvgReviews AS (
    -- Calculate the average number of reviews for all products
    SELECT 
        AVG(r.reviews) AS avg_reviews
    FROM 
        reviews AS r
)
SELECT 
    r.product_id,
    b.brand,
    r.reviews,      -- Number of reviews for the product
    r.rating        -- Product rating (optional, to understand performance)
FROM 
    reviews AS r
JOIN 
    brands AS b 
ON 
    r.product_id = b.product_id
CROSS JOIN 
    AvgReviews
WHERE 
    r.reviews < AvgReviews.avg_reviews  -- Products with fewer reviews than the average
ORDER BY 
    r.reviews ASC;  -- Sort by the lowest number of reviews













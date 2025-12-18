USE Project2;

--Sales Performance Analysis.
--Total Revenue: What is the total revenue generated across all transactions?

SELECT
    SUM(UNIT_PRICE) AS TOTAL_REVENUE
FROM SALES_DATA;

--Monthly Sales Trend: Calculate the total revenue generated per month to see seasonal trends.

SELECT 
      MONTH(ORDER_DATE)AS MONTH_NO,
      DATENAME(MONTH, ORDER_DATE) AS MONTH,
      SUM(UNIT_PRICE) AS MONTHLY_REVENUE
FROM SALES_DATA 
        GROUP BY MONTH(ORDER_DATE) , DATENAME(MONTH, ORDER_DATE)
      ORDER BY  MONTH(ORDER_DATE);

--Quarterly Revenue Growth: What is the total revenue per quarter?

SELECT 
         DATEPART(QUARTER,order_date) AS QUARTER, 
         SUM(UNIT_PRICE) 
  FROM SALES_DATA 
        GROUP BY  DATEPART(QUARTER,order_date)
        ORDER BY  DATEPART(QUARTER,order_date);


--Sales by Region: Which region has generated the highest total sales revenue?

SELECT 
   REGION, 
    SUM(UNIT_PRICE) AS Regional_Revenue 
 FROM SALES_DATA
     GROUP BY REGION
     ORDER BY SUM(UNIT_PRICE) DESC ;

-- Customer Insights
--Customer Distribution by Region: How many unique customers are there in each region?
SELECT
     REGION,
     COUNT(DISTINCT CUSTOMER_ID) AS No_of_Customer  
 FROM CUSTOMER_INFO
       GROUP BY REGION
       ORDER BY COUNT(DISTINCT CUSTOMER_ID) DESC ;


--Top 5 Customers by Revenue: Who are the top 5 customers who have spent the most money?

SELECT TOP 5 
        C.customer_id, EMAIL,C.GENDER,C.REGION,C.LOYALTY_TIER,
        SUM(S.UNIT_PRICE)  AS TOTAL_SPEND
FROM customer_info C 
    JOIN 
         SALES_DATA S
   ON C.CUSTOMER_ID = S.CUSTOMER_ID
        GROUP BY C.EMAIL,C.GENDER,C.REGION,C.LOYALTY_TIER,C.customer_id
        ORDER BY SUM(S.UNIT_PRICE) DESC  ; 

--Purchase Frequency: What is the average number of transactions per customer?
 
 WITH CUSTOMER_TRANSACTION_COUNT 
      AS (
           SELECT CUSTOMER_ID, COUNT(DISTINCT ORDER_ID) AS TRANSACTIONS
 FROM SALES_DATA
           GROUP BY CUSTOMER_ID
                                )
  SELECT 
          CUSTOMER_ID, 
          AVG(TRANSACTIONS) AS Avg_Transactions_Per_Customer 
 FROM CUSTOMER_TRANSACTION_COUNT
      GROUP BY CUSTOMER_ID;


--Revenue by Loyalty Tier: Which loyalty tier contributes the most to total revenue? 

SELECT 
     C.LOYALTY_TIER, 
      SUM(S.UNIT_PRICE) AS REVENUE 
FROM customer_info C
        JOIN 
     SALES_DATA S 
       ON
 C.CUSTOMER_ID = S.CUSTOMER_ID 
    GROUP BY C.LOYALTY_TIER
    ORDER BY SUM(S.UNIT_PRICE)
                 DESC ;

--Gender-Based Spending: What is the average spend per transaction for each gender group?

SELECT
      C.GENDER,
       ROUND(AVG(S.unit_price),2) AS AVG_TRANSACTION
FROM CUSTOMER_INFO C
         JOIN 
     SALES_DATA S 
          ON 
C.customer_id = S.customer_id 
        GROUP BY C.GENDER 
        ORDER BY ROUND(AVG(S.unit_price),2)
               DESC ;


-- Product Analysis
--Top Selling Products (Quantity): Which are the top 10 products based on the total quantity sold?

select TOP 10 
     p.product_id,
     p.product_name,
     sum(s.quantity) AS QUANTITY_SOLD
from product_info p
     join 
sales_data s 
      on 
p.product_id = s.product_id
         group by p.product_id,p.product_name
         ORDER BY sum(s.quantity) DESC;


--Least Popular Products: Which products have been sold less than least times in total?
select top 1 
     p.product_id,
     p.product_name,
     sum(s.quantitY)  AS QUANTITY_SOLD
from product_info p
     join 
sales_data s 
      on 
p.product_id = s.product_id
     group by  p.product_id, p.product_name
     order by sum(s.quantity);


--Revenue by Product Category: Which product category generates the highest revenue?

select 
    p.category,
    sum(s.unit_price) AS Revenue
from product_info p
       join
sales_data s 
      on 
p.product_id = s.product_id
         group by p.category
      order by sum(s.unit_price) desc;


--Product Pricing Strategy: What is the average price of products in each category?
SELECT 
    category, 
    ROUND(AVG(base_price),2) AS Avg_Price
FROM product_info
GROUP BY category
ORDER BY Avg_Price DESC;


---Cross-Selling Potential: (Advanced) Which products are most frequently bought together in the same transaction? (Self-join on transaction_id).


SELECT TOP 10
    s1.product_id AS Product_A,
    s2.product_id AS Product_B,
    COUNT(*) AS Times_Bought_Together
FROM sales_data s1
JOIN sales_data s2 
    ON s1.customer_id = s2.customer_id      -- Same Customer
    AND s1.order_date = s2.order_date -- Same Day
    AND s1.product_id < s2.product_id       -- Different Products
GROUP BY s1.product_id, s2.product_id
ORDER BY Times_Bought_Together DESC;

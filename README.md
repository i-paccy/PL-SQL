# Online Customer management system PL-SQL (Phase 1)
## Problem statement
Our e-commerce platform lacks sophisticated customer behavior analysis. We cannot effectively identify top-performing customers, track purchasing trends over time, or segment customers for targeted marketing campaigns. Manual reporting is time-consuming and doesn't provide the real-time insights needed for strategic decision-making.

## Project Goals

Implement PL/SQL window functions to automatically identify top customers by region, analyze sales trends, segment customers by spending behavior, and provide actionable insights for marketing optimization and inventory planning.

## Success criteria

Top 5 customers per region by total spending → RANK()
Running monthly sales totals → SUM() OVER()
Month-over-month sales growth percentage → LAG()
Customer spending quartiles → NTILE(4)
3-month moving average of sales → AVG() OVER()

## DataBase schema

customers: Customer master data (customer_id (Primary Key), name, email, region)
products: Product catalog	(product_id (Primary Key), name, category, price)
transactions: Sales records	(transaction_id (Primary Key), customer_id (Foreign Key), product_id (Foreign Key), sale_date, amount, quantity)

## ER Diagram
![ER Diagram scheme](https://github.com/i-paccy/PL-SQL/blob/main/ER%20DIAGRAM.jpg?raw=true)

## SQL Codes

-- Customers Table
CREATE TABLE customer (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    region VARCHAR2(50),
    registration_date DATE
);

-- Products Table  
CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    category VARCHAR2(50),
    price NUMBER(10,2)
);

-- Transactions Table
CREATE TABLE transaction (
    transaction_id NUMBER PRIMARY KEY,
    customer_id NUMBER REFERENCES customers(customer_id),
    product_id NUMBER REFERENCES products(product_id),
    sale_date DATE,
    amount NUMBER(10,2),
    quantity NUMBER
);

-- Insert Customer

INSERT INTO customer VALUES (1001, 'Alice Uwase', 'alice.uwase@email.com', 'Kigali', DATE '2023-01-15');
INSERT INTO customer VALUES (1002, 'Jean Bosco', 'jean.bosco@email.com', 'Kigali', DATE '2023-02-20');
INSERT INTO customer VALUES (1003, 'Marie Claire', 'marie.claire@email.com', 'Northern', DATE '2023-03-10');
INSERT INTO customer VALUES (1004, 'Paul Kagabo', 'paul.kagabo@email.com', 'Southern', DATE '2023-04-05');
INSERT INTO customer VALUES (1005, 'Grace Imani', 'grace.imani@email.com', 'Eastern', DATE '2023-05-12');
INSERT INTO customer VALUES (1006, 'David Nshuti', 'david.nshuti@email.com', 'Western', DATE '2023-06-18');


-- Insert Products

INSERT INTO products VALUES (2001, 'Samsung Galaxy A14', 'Electronics', 250000);
INSERT INTO products VALUES (2002, 'HP Laptop 15s', 'Electronics', 850000);
INSERT INTO products VALUES (2003, 'Wireless Mouse', 'Accessories', 15000);
INSERT INTO products VALUES (2004, 'Laptop Bag', 'Accessories', 35000);
INSERT INTO products VALUES (2005, 'USB-C Cable', 'Accessories', 8000);
INSERT INTO products VALUES (2006, 'Phone Case', 'Accessories', 12000);


-- Insert Transaction
INSERT INTO transaction VALUES (3001, 1001, 2001, DATE '2024-01-15', 250000, 1);
INSERT INTO transaction VALUES (3002, 1002, 2002, DATE '2024-01-20', 850000, 1);
INSERT INTO transaction VALUES (3003, 1001, 2003, DATE '2024-02-05', 30000, 2);
INSERT INTO transaction VALUES (3004, 1003, 2001, DATE '2024-02-10', 250000, 1);
INSERT INTO transaction VALUES (3005, 1004, 2004, DATE '2024-02-15', 35000, 1);
INSERT INTO transaction VALUES (3006, 1002, 2005, DATE '2024-03-01', 24000, 3);
INSERT INTO transaction VALUES (3007, 1005, 2002, DATE '2024-03-10', 850000, 1);
INSERT INTO transaction VALUES (3008, 1006, 2006, DATE '2024-03-15', 24000, 2);
INSERT INTO transaction VALUES (3009, 1001, 2004, DATE '2024-03-20', 35000, 1);
INSERT INTO transaction VALUES (3010, 1003, 2003, DATE '2024-03-25', 15000, 1);


-- Verify data

-- Display all customers
SELECT * FROM customer 
ORDER BY customer_id;

-- Display all products
SELECT * FROM product 
ORDER BY product_id;

-- Display all transactions with customer and product names
SELECT 
    t.transaction_id,
    c.name as customer_name,
    p.name as product_name,
    t.sale_date,
    t.amount,
    t.quantity
FROM transaction 
JOIN customers c ON t.customer_id = c.customer_id
JOIN products p ON t.product_id = p.product_id
ORDER BY t.sale_date;

## Graphs of commands 

![Table before adding Values inside](https://github.com/i-paccy/PL-SQL/blob/main/1.jpg?raw=true)
![Table before adding Values inside](https://github.com/i-paccy/PL-SQL/blob/main/3.jpg?raw=true)
![Table before adding Values inside](https://github.com/i-paccy/PL-SQL/blob/main/2.jpg?raw=true)

Here I'm using Images from cmd prompt(or what i can call terminal)
![table after adding values in it](https://github.com/i-paccy/PL-SQL/blob/main/customer%20table.jpg?raw=true)
![table after adding values in it](https://github.com/i-paccy/PL-SQL/blob/main/product%20table.jpg?raw=true)
![table after adding values in it](https://github.com/i-paccy/PL-SQL/blob/main/transaction%20table.jpg?raw=true)

## WINDOW FUNCTIONS OUTPUTS:

# 1. RANKING FUNCTIONS - Top Customers by Region
SELECT region, customer_id, name, total_spending,
       ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_spending DESC) as row_num,
       RANK() OVER (PARTITION BY region ORDER BY total_spending DESC) as region_rank,
       DENSE_RANK() OVER (ORDER BY total_spending DESC) as global_rank
FROM (
    SELECT c.region, c.customer_id, c.name, SUM(t.amount) as total_spending
    FROM customers c JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.region, c.customer_id, c.name
)
ORDER BY region, region_rank;
![table after adding values in it](https://github.com/i-paccy/PL-SQL/blob/main/11.jpg?raw=true)
Interpretation: Grace Imani and Jean Bosco are tied for #1 globally, but Alice Uwase is #2 in Kigali region.

##2. AGGREGATE FUNCTIONS - Running Totals & Moving Averages //
SELECT TO_CHAR(sale_date, 'YYYY-MM') as sales_month,
       monthly_sales,
       SUM(monthly_sales) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM')) as running_total,
       AVG(monthly_sales) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg
FROM (
    SELECT TRUNC(sale_date, 'MONTH') as sale_date, SUM(amount) as monthly_sales
    FROM transactions GROUP BY TRUNC(sale_date, 'MONTH')
)
ORDER BY sales_month;
![table after adding values in it](https://github.com/i-paccy/PL-SQL/blob/main/12.jpg?raw=true)
Interpretation: Sales started strong in January, dipped in February, then recovered in March. The 3-month average shows overall positive trend.



## 3.NAVIGATION FUNCTIONS - Month-over-Month Growth


WITH monthly_sales AS (
    SELECT TO_CHAR(sale_date, 'YYYY-MM') as sales_month, SUM(amount) as monthly_sales
    FROM transactions GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT sales_month, monthly_sales,
       LAG(monthly_sales, 1) OVER (ORDER BY sales_month) as prev_month,
       monthly_sales - LAG(monthly_sales, 1) OVER (ORDER BY sales_month) as difference,
       ROUND(((monthly_sales - LAG(monthly_sales, 1) OVER (ORDER BY sales_month)) / 
              LAG(monthly_sales, 1) OVER (ORDER BY sales_month)) * 100, 2) as growth_pct
FROM monthly_sales
ORDER BY sales_month;
![table after adding values in it](https://github.com/i-paccy/PL-SQL/blob/main/13.jpg?raw=true)
Interpretation: February had a significant sales drop (-71.36%), but March showed strong recovery with 205.71% growth from February.

## 4.DISTRIBUTION FUNCTIONS - Customer Segmentation

SELECT customer_id, name, region, total_spending,
       NTILE(4) OVER (ORDER BY total_spending DESC) as quartile,
       ROUND(CUME_DIST() OVER (ORDER BY total_spending DESC) * 100, 2) as cume_dist_pct,
       CASE 
           WHEN NTILE(4) OVER (ORDER BY total_spending DESC) = 1 THEN 'Platinum'
           WHEN NTILE(4) OVER (ORDER BY total_spending DESC) = 2 THEN 'Gold' 
           ELSE 'Silver'
       END as customer_tier
FROM (
    SELECT c.customer_id, c.name, c.region, SUM(t.amount) as total_spending
    FROM customers c JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.region
)
ORDER BY total_spending DESC;
![table after adding values in it](https://github.com/i-paccy/PL-SQL/blob/main/14.jpg?raw=true)
Interpretation: Customers are divided into 4 equal groups. Top 2 customers (33%) are Platinum tier, next 2 are Gold, and bottom 2 are Silver. 100% of customers spend more than or equal to David Nshuti.



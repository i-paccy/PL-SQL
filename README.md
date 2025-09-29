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
ER Diagram scheme https://github.com/i-paccy/PL-SQL/blob/main/ER%20DIAGRAM.jpg

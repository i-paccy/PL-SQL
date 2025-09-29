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

CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    region VARCHAR2(50),
    registration_date DATE
);

CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    category VARCHAR2(50),
    price NUMBER(10,2)
);

CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    customer_id NUMBER REFERENCES customers(customer_id),
    product_id NUMBER REFERENCES products(product_id),
    sale_date DATE,
    amount NUMBER(10,2),
    quantity NUMBER
);


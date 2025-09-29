-- Customers Table
CREATE TABLE customers (
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
CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    customer_id NUMBER REFERENCES customers(customer_id),
    product_id NUMBER REFERENCES products(product_id),
    sale_date DATE,
    amount NUMBER(10,2),
    quantity NUMBER
);

-- Insert Customers
INSERT ALL
INTO customers VALUES (1001, 'Alice Uwase', 'alice.uwase@email.com', 'Kigali', DATE '2023-01-15')
INTO customers VALUES (1002, 'Jean Bosco', 'jean.bosco@email.com', 'Kigali', DATE '2023-02-20')
INTO customers VALUES (1003, 'Marie Claire', 'marie.claire@email.com', 'Northern', DATE '2023-03-10')
INTO customers VALUES (1004, 'Paul Kagabo', 'paul.kagabo@email.com', 'Southern', DATE '2023-04-05')
INTO customers VALUES (1005, 'Grace Imani', 'grace.imani@email.com', 'Eastern', DATE '2023-05-12')
INTO customers VALUES (1006, 'David Nshuti', 'david.nshuti@email.com', 'Western', DATE '2023-06-18')
SELECT 1 FROM DUAL;

-- Insert Products
INSERT ALL
INTO products VALUES (2001, 'Samsung Galaxy A14', 'Electronics', 250000)
INTO products VALUES (2002, 'HP Laptop 15s', 'Electronics', 850000)
INTO products VALUES (2003, 'Wireless Mouse', 'Accessories', 15000)
INTO products VALUES (2004, 'Laptop Bag', 'Accessories', 35000)
INTO products VALUES (2005, 'USB-C Cable', 'Accessories', 8000)
INTO products VALUES (2006, 'Phone Case', 'Accessories', 12000)
SELECT 1 FROM DUAL;

-- Insert Transactions
INSERT ALL
INTO transactions VALUES (3001, 1001, 2001, DATE '2024-01-15', 250000, 1)
INTO transactions VALUES (3002, 1002, 2002, DATE '2024-01-20', 850000, 1)
INTO transactions VALUES (3003, 1001, 2003, DATE '2024-02-05', 30000, 2)
INTO transactions VALUES (3004, 1003, 2001, DATE '2024-02-10', 250000, 1)
INTO transactions VALUES (3005, 1004, 2004, DATE '2024-02-15', 35000, 1)
INTO transactions VALUES (3006, 1002, 2005, DATE '2024-03-01', 24000, 3)
INTO transactions VALUES (3007, 1005, 2002, DATE '2024-03-10', 850000, 1)
INTO transactions VALUES (3008, 1006, 2006, DATE '2024-03-15', 24000, 2)
INTO transactions VALUES (3009, 1001, 2004, DATE '2024-03-20', 35000, 1)
INTO transactions VALUES (3010, 1003, 2003, DATE '2024-03-25', 15000, 1)
SELECT 1 FROM DUAL;

COMMIT;

-- Verify data
SELECT 'Customers: ' || COUNT(*) FROM customers
UNION ALL
SELECT 'Products: ' || COUNT(*) FROM products
UNION ALL
SELECT 'Transactions: ' || COUNT(*) FROM transactions;

-- Display all customers
SELECT * FROM customers 
ORDER BY customer_id;

-- Display all products
SELECT * FROM products 
ORDER BY product_id;

-- Display all transactions with customer and product names
SELECT 
    t.transaction_id,
    c.name as customer_name,
    p.name as product_name,
    t.sale_date,
    t.amount,
    t.quantity
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN products p ON t.product_id = p.product_id
ORDER BY t.sale_date;


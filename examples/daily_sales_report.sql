-- Create products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Create sales table
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    sale_date DATE NOT NULL
);

-- Insert products
INSERT INTO products (name, price) VALUES ('Laptop', 1200.50);
INSERT INTO products (name, price) VALUES ('Smartphone', 800.99);
INSERT INTO products (name, price) VALUES ('Headphones', 150.75);

-- Insert sales data for today
INSERT INTO sales (product_id, quantity, sale_date) VALUES (1, 5, CURRENT_DATE); -- 5 Laptops sold today
INSERT INTO sales (product_id, quantity, sale_date) VALUES (2, 10, CURRENT_DATE); -- 10 Smartphones sold today
INSERT INTO sales (product_id, quantity, sale_date) VALUES (3, 20, CURRENT_DATE); -- 20 Headphones sold today

-- Insert some sales data for previous days for variety
INSERT INTO sales (product_id, quantity, sale_date) VALUES (1, 4, CURRENT_DATE - INTERVAL '1 day');
INSERT INTO sales (product_id, quantity, sale_date) VALUES (2, 8, CURRENT_DATE - INTERVAL '2 days');
INSERT INTO sales (product_id, quantity, sale_date) VALUES (3, 15, CURRENT_DATE - INTERVAL '3 days');

-- Fetch sales report for the current date
WITH DailySales AS (
    SELECT
        product_id,
        SUM(quantity) as total_sold
    FROM
        sales
    WHERE
        sale_date = CURRENT_DATE
    GROUP BY
        product_id
)

SELECT
    p.name AS product_name,
    ds.total_sold
FROM
    DailySales ds
JOIN
    products p ON ds.product_id = p.id
ORDER BY
    ds.total_sold DESC;

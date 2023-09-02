-- Create products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Create orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    order_date DATE NOT NULL
);

-- Create order_details table
CREATE TABLE order_details (
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL
);

-- User 5 places an order for Laptop, Smartphone, and Headphones
INSERT INTO orders (user_id, order_date) VALUES (5, '2023-08-25');
INSERT INTO order_details (order_id, product_id, quantity) VALUES 
((SELECT max(id) FROM orders), 1, 1),  -- Laptop
((SELECT max(id) FROM orders), 2, 1),  -- Smartphone
((SELECT max(id) FROM orders), 3, 1);  -- Headphones

-- User 6 places an order for Laptop, Keyboard, and Mouse
INSERT INTO orders (user_id, order_date) VALUES (6, '2023-08-26');
INSERT INTO order_details (order_id, product_id, quantity) VALUES 
((SELECT max(id) FROM orders), 1, 1),  -- Laptop
((SELECT max(id) FROM orders), 4, 1),  -- Keyboard
((SELECT max(id) FROM orders), 5, 1);  -- Mouse

-- User 7 places an order for Smartphone, Charger, and Earbuds
INSERT INTO orders (user_id, order_date) VALUES (7, '2023-08-27');
INSERT INTO order_details (order_id, product_id, quantity) VALUES 
((SELECT max(id) FROM orders), 2, 1),  -- Smartphone
((SELECT max(id) FROM orders), 6, 1),  -- Charger
((SELECT max(id) FROM orders), 8, 1);  -- Earbuds

-- User 8 places an order for Monitor, Speaker, and Earbuds
INSERT INTO orders (user_id, order_date) VALUES (8, '2023-08-28');
INSERT INTO order_details (order_id, product_id, quantity) VALUES 
((SELECT max(id) FROM orders), 9, 1),  -- Monitor
((SELECT max(id) FROM orders), 10, 1), -- Speaker
((SELECT max(id) FROM orders), 8, 1);  -- Earbuds

-- Given user_id (let's say user_id = 5 as an example)

WITH UserProducts AS (
    SELECT product_id
    FROM orders o
    JOIN order_details od ON o.id = od.order_id
    WHERE o.user_id = 5
)

, CoUsers AS (
    SELECT DISTINCT o.user_id
    FROM orders o
    JOIN order_details od ON o.id = od.order_id
    WHERE od.product_id IN (SELECT product_id FROM UserProducts) AND o.user_id <> 5
)

SELECT p.id, p.name
FROM products p
WHERE p.id NOT IN (SELECT product_id FROM UserProducts)
AND p.id IN (
    SELECT od.product_id
    FROM order_details od
    JOIN orders o ON o.id = od.order_id
    WHERE o.user_id IN (SELECT user_id FROM CoUsers)
    GROUP BY od.product_id
    ORDER BY COUNT(DISTINCT o.user_id) DESC
    LIMIT 5
);

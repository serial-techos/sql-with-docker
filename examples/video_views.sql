-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Create video_views table
CREATE TABLE video_views (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    video_id INTEGER,
    view_time_seconds INTEGER NOT NULL,
    view_timestamp TIMESTAMP NOT NULL
);

-- Insert users
INSERT INTO users (name) VALUES ('Alice'), ('Bob'), ('Charlie');

-- Insert video views (assuming today's date is 2023-09-02)
INSERT INTO video_views (user_id, video_id, view_time_seconds, view_timestamp) VALUES
(1, 101, 120, '2023-07-15'),
(1, 102, 240, '2023-07-20'),
(1, 103, 300, '2023-08-01'),
(1, 104, 360, '2023-08-15'),
(1, 105, 480, '2023-09-01'),
(2, 101, 100, '2023-07-10'),
(2, 103, 150, '2023-08-01'),
(2, 105, 100, '2023-09-01'),
(3, 102, 200, '2023-07-05'),
(3, 104, 210, '2023-08-10'),
(3, 105, 220, '2023-09-01');

---

WITH MonthlyViews AS (
    SELECT
        user_id,
        EXTRACT(MONTH FROM view_timestamp) AS month,
        SUM(view_time_seconds) AS total_time
    FROM
        video_views
    WHERE
        view_timestamp BETWEEN NOW() - INTERVAL '3 months' AND NOW()
    GROUP BY
        user_id, month
)

SELECT
    m1.user_id,
    u.name,
    m1.total_time AS July_time,
    m2.total_time AS August_time,
    m3.total_time AS September_time
FROM
    MonthlyViews m1
JOIN
    MonthlyViews m2 ON m1.user_id = m2.user_id AND m2.month = 8
JOIN
    MonthlyViews m3 ON m1.user_id = m3.user_id AND m3.month = 9
JOIN
    users u ON u.id = m1.user_id
WHERE
    m1.month = 7 AND m1.total_time < m2.total_time AND m2.total_time < m3.total_time
ORDER BY
    u.name;

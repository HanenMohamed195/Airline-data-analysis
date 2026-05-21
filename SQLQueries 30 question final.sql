use airlines_flights

---1)which airline has the widest price range ?
--Wide price ranges indicate flexible pricing strategies.
--solution :
--Segment customers more effectively.
--Improve demand-based pricing.
SELECT 
    a.airline_name,
    MAX(f.price) AS max_price,
    MIN(f.price) AS min_price,
    (MAX(f.price) - MIN(f.price)) AS price_range
FROM airlines a
JOIN flights f 
    ON a.airline_id = f.airline_id
GROUP BY a.airline_name
ORDER BY price_range DESC;

---2) Which airline generates the highest total revenue?


SELECT
    [origin],
    [destination],
    SUM(price) AS total_revenue,
    COUNT(*) AS tickets_sold
FROM flights
GROUP BY [origin], [destination]
ORDER BY total_revenue DESC;

---3)Which routes are the most 8888;profitable?

SELECT
    [origin],
    [destination],
    ROUND(AVG(price),2) AS avg_price,
    COUNT(*) AS total_bookings
FROM flights
GROUP BY     [origin],[destination]
ORDER BY avg_price DESC;

---4)Which routes have the highest price volatility?

SELECT
    [origin],
    [destination],
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    MAX(price) - MIN(price) AS price_difference
FROM flights
GROUP BY [origin], [destination]
ORDER BY price_difference DESC; 

---5)Which class type is more expensive on average?

SELECT 
    class,
    ROUND(AVG(price),2) AS avg_price
FROM flights
GROUP BY class;

---6)Which class generates the most revenue?

SELECT 
    class,
    SUM(price) AS total_revenue
FROM flights
GROUP BY class
ORDER BY total_revenue DESC;

---7)What is the average flight duration for each airline?

SELECT 
    a.airline_name,
    ROUND(AVG(f.duration_minutes),2) AS avg_duration_minutes
FROM flights f
JOIN airlines a
ON f.airline_id = a.airline_id
GROUP BY a.airline_name
ORDER BY avg_duration_minutes DESC;

---8)Which cities have the highest number of departures?
---Insight:-
--These are high-demand travel corridors.
---Business Solution:-
--Increase flight frequency.
--Use larger aircraft.
--Improve airport infrastructure on these routes.

SELECT 
    origin,
    COUNT(*) AS departures
FROM flights
GROUP BY origin
ORDER BY departures DESC;

---9)Which airline operates the largest number of flights?

SELECT 
    a.airline_name,
    COUNT(*) AS total_flights
FROM flights f
JOIN airlines a
ON f.airline_id = a.airline_id
GROUP BY a.airline_name
ORDER BY total_flights DESC;

---10)Which routes are the most expensive?

SELECT 
    origin,
    destination,
    ROUND(AVG(price),2) AS avg_route_price
FROM flights
GROUP BY origin, destination
ORDER BY avg_route_price DESC;

---11)Which destinations receive the most flights?

SELECT 
    destination,
    COUNT(*) AS total_flights
FROM flights
GROUP BY destination
ORDER BY total_flights DESC;

---12)Which flights are the longest?

SELECT TOP 10
    origin,
    destination,
    duration_minutes
FROM flights
ORDER BY duration_minutes DESC;

---13)Which flights are the cheapest?

SELECT TOP 10
    origin,
    destination,
    price
FROM flights
ORDER BY price ASC;

---14)Which flights are the most expensive?

SELECT TOP 10
    origin,
    destination,
    price
FROM flights
ORDER BY price DESC;

---15)Do direct flights cost more than stopped flights?

SELECT 
    stop,
    ROUND(AVG(price),2) AS avg_price
FROM flights
GROUP BY stop;

---16)Which airline has the cheapest average ticket price?
--Insight
--This airline likely follows a low-cost carrier strategy.
---solution:-
--Introduce optional paid services.

SELECT TOP 1
    a.airline_name,
    ROUND(AVG(f.price),2) AS avg_price
FROM flights f
JOIN airlines a
ON f.airline_id = a.airline_id
GROUP BY a.airline_name
ORDER BY avg_price ASC;

---17)Which destination has the highest average ticket price?
---Insight
--Premium or distant destinations generate higher yields.
---Business Solution:-
--Target luxury tourism.
--Create exclusive destination packages.
--Partner with hotels and resorts.

SELECT TOP 10
    destination,
    ROUND(AVG(price),2) AS avg_price
FROM flights
GROUP BY destination
ORDER BY avg_price DESC;

---18)Which day had the highest number of flights?

SELECT 
    [Date],
    COUNT(*) AS total_flights
FROM flights
GROUP BY [Date]
ORDER BY total_flights DESC;

---19)Monthly revenue analysis
---Insight:-
--Revenue trends reveal seasonal travel behavior.
---Business Solution:-
--Increase flights during high seasons.
--Launch seasonal marketing campaigns.
--Reduce costs during low seasons.

SELECT 
    MONTH([Date]) AS month_number,
    SUM(price) AS total_revenue
FROM flights
GROUP BY MONTH([Date])
ORDER BY month_number;

---20)Top 3 most expensive flights for each airline
---insight:-
--Certain routes are exceptionally profitable.
---Business Solution:-
--Prioritize premium customer experience.
--Expand profitable routes.
--Offer loyalty rewards for frequent travelers.

WITH ranked_flights AS
(
    SELECT 
        a.airline_name,
        f.origin,
        f.destination,
        f.price,
        ROW_NUMBER() OVER
        (
            PARTITION BY a.airline_name
            ORDER BY f.price DESC
        ) AS rn
    FROM flights f
    JOIN airlines a
    ON f.airline_id = a.airline_id
)

SELECT *
FROM ranked_flights
WHERE rn <= 3;

---21)Revenue by origin and destination using ROLLUP
---Insight:-
--Some regions contribute disproportionately to total revenue.
---Business Solution:-
--Focus investments on profitable regions.
--Reevaluate weak-performing routes.

SELECT 
    origin,
    destination,
    SUM(price) AS total_revenue
FROM flights
GROUP BY ROLLUP(origin, destination);

---22)Average pricing analysis using CUBE
---Insight:-
--Ticket pricing depends on both class and stop type.
---Business Solution:-
--Create smarter pricing combinations.
--Optimize premium pricing for direct flights.
--Develop segmented marketing campaigns.

SELECT 
    class,
    stop,
    ROUND(AVG(price),2) AS avg_price
FROM flights
GROUP BY CUBE(class, stop);

---23)Which airline has the highest average duration for Business class?
---Insight:-
--Business travelers are heavily present on long-haul routes.
---Business Solution:-
--Improve luxury services on long flights.
--Enhance seating comfort and Wi-Fi.
--Offer premium corporate memberships.

SELECT 
    a.airline_name,
    ROUND(AVG(f.duration_minutes),2) AS avg_duration
FROM flights f
JOIN airlines a
ON f.airline_id = a.airline_id
WHERE class = 'Business'
GROUP BY a.airline_name
ORDER BY avg_duration DESC;

---24)Find flights priced above the market average price
---Insight:-
--These flights represent premium market opportunities.
---Business Solution:-
--Maintain high-quality service standards.
--Use targeted advertising for high-income travelers.

SELECT 
    origin,
    destination,
    class,
    price
FROM flights
WHERE price >
(
    SELECT AVG(price)
    FROM flights
)
ORDER BY price DESC;

---25)How do stop types affect ticket pricing?
---Business Insight:-
--Non-stop flights are generally more expensive but provide shorter travel times.
---Business Solution:-
--Promote non-stop flights for business travelers.
--Use stop flights for budget-conscious customers.
--Optimize operational scheduling.
SELECT 
    stop, 
    COUNT(*) AS total_flights,
    ROUND(AVG(price),2) AS avg_ticket_price,
   MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    ROUND(AVG(duration_minutes),2) AS avg_duration_minutes,
     ROUND(
        SUM(price) * 1.0 / COUNT(*),
    2) AS revenue_per_flight
FROM flights
GROUP BY stop
ORDER BY avg_ticket_price DESC;

---26)Which routes have the highest demand for non-stop flights?

SELECT
    origin,
    destination,
    COUNT(*) AS nonstop_flights
FROM flights
WHERE stop = 'non-stop'
GROUP BY origin, destination
ORDER BY nonstop_flights DESC;

27)Which airlines improved revenue over time?

WITH monthly_revenue AS (
    SELECT
        a.airline_name,
        MONTH(f.[Date]) AS month_num,
        SUM(f.price) AS revenue
    FROM flights f
    JOIN airlines a
        ON a.airline_id = f.airline_id
    GROUP BY a.airline_name, MONTH(f.[Date])
)
SELECT
    airline_name,
    month_num,
    revenue,
    LAG(revenue) OVER(
        PARTITION BY airline_name
        ORDER BY month_num
    ) AS previous_month_revenue,
    revenue - LAG(revenue) OVER(
        PARTITION BY airline_name
        ORDER BY month_num
    ) AS revenue_growth
FROM monthly_revenue;
        
---28)Which airlines have the highest operational efficiency?

SELECT
    a.airline_name,
    ROUND(SUM(f.price) / SUM(f.duration_minutes),2) AS revenue_per_minute
FROM flights f
JOIN airlines a
    ON a.airline_id = f.airline_id
GROUP BY a.airline_name
ORDER BY revenue_per_minute DESC;

---29)Compare airline pricing against route averages

WITH route_avg AS (
    SELECT 
        origin,
        destination,
        AVG(price) AS route_average_price
    FROM flights
    GROUP BY 
        origin,
        destination
)
SELECT
    a.airline_name,
    f.origin,
    f.destination,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.price),2) AS airline_avg_price,
    ROUND(r.route_average_price,2) AS route_market_average,
    ROUND(
        AVG(f.price) - r.route_average_price,
    2) AS price_difference,
    CASE 
        WHEN AVG(f.price) > r.route_average_price 
            THEN 'Above Market Average'
        WHEN AVG(f.price) < r.route_average_price 
            THEN 'Below Market Average'
        ELSE 'Equal To Market'
    END AS pricing_position
FROM flights f
JOIN airlines a
    ON a.airline_id = f.airline_id
JOIN route_avg r
    ON f.origin = r.origin
   AND f.destination = r.destination
GROUP BY 
    a.airline_name,
    f.origin,
    f.destination,
    r.route_average_price
ORDER BY price_difference DESC;


---30)  Executive KPI Dashboard Query

SELECT
    COUNT(*) AS total_flights,
    COUNT(DISTINCT airline_id) AS total_airlines,
    COUNT(DISTINCT origin) AS origin_cities,
    COUNT(DISTINCT destination) AS destination_cities,
    ROUND(AVG(price),2) AS average_ticket_price,
    ROUND(AVG(duration_minutes),2) AS av
    from flights





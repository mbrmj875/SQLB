-- =========================================
-- Exercise 00: Move to the LEFT, move to the RIGHT
-- =========================================
-- day02_ex00.sql
-- Find pizzerias NOT visited by anyone
-- DENIED: NOT IN, IN, NOT EXISTS, EXISTS, UNION, EXCEPT, INTERSECT

SELECT 
    pz.name,
    pz.rating
FROM pizzeria pz
LEFT JOIN person_visits pv ON pz.id = pv.pizzeria_id
WHERE pv.pizzeria_id IS NULL
ORDER BY pz.name;

-- =========================================
-- Exercise 01: Find data gaps
-- =========================================
-- day02_ex01.sql
-- Find missing days (Jan 1-10, 2022) for persons 1 or 2
-- DENIED: NOT IN, IN, NOT EXISTS, EXISTS, UNION, EXCEPT, INTERSECT

SELECT gs.date AS missing_date
FROM generate_series('2022-01-01'::date, '2022-01-10'::date, '1 day'::interval) AS gs(date)
LEFT JOIN (
    SELECT visit_date
    FROM person_visits
    WHERE person_id = 1 OR person_id = 2
) AS visits ON gs.date = visits.visit_date
WHERE visits.visit_date IS NULL
ORDER BY missing_date;

-- =========================================
-- Exercise 02: FULL means 'completely filled'
-- =========================================
-- day02_ex02.sql
-- FULL JOIN between person visits and pizzeria (Jan 1-3, 2022)
-- DENIED: NOT IN, IN, NOT EXISTS, EXISTS, UNION, EXCEPT, INTERSECT

SELECT 
    COALESCE(p.name, '-') AS person_name,
    pv.visit_date,
    COALESCE(pz.name, '-') AS pizzeria_name
FROM person_visits pv
FULL JOIN person p ON pv.person_id = p.id
FULL JOIN pizzeria pz ON pv.pizzeria_id = pz.id
WHERE pv.visit_date BETWEEN '2022-01-01' AND '2022-01-03' 
   OR pv.visit_date IS NULL
ORDER BY person_name, visit_date, pizzeria_name;

-- =========================================
-- Exercise 03: Reformat to CTE
-- =========================================
-- day02_ex03.sql
-- Rewrite Exercise 01 using CTE (Common Table Expression)
-- DENIED: NOT IN, IN, NOT EXISTS, EXISTS, UNION, EXCEPT, INTERSECT

WITH date_series AS (
    SELECT generate_series('2022-01-01'::date, '2022-01-10'::date, '1 day'::interval)::date AS date
),
visits_filtered AS (
    SELECT visit_date
    FROM person_visits
    WHERE person_id = 1 OR person_id = 2
)
SELECT ds.date AS missing_date
FROM date_series ds
LEFT JOIN visits_filtered vf ON ds.date = vf.visit_date
WHERE vf.visit_date IS NULL
ORDER BY missing_date;

-- =========================================
-- Exercise 04: Find favorite pizzas
-- =========================================
-- day02_ex04.sql
-- Find all mushroom or pepperoni pizzas with pizzeria names and prices

SELECT 
    m.pizza_name,
    pz.name AS pizzeria_name,
    m.price
FROM menu m
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE m.pizza_name = 'mushroom pizza' OR m.pizza_name = 'pepperoni pizza'
ORDER BY m.pizza_name, pz.name;

-- Alternative using IN (if not denied in this exercise):
-- WHERE m.pizza_name IN ('mushroom pizza', 'pepperoni pizza')

-- =========================================
-- Exercise 05: Investigate Person Data
-- =========================================
-- day02_ex05.sql
-- Find all females over 25 years old

SELECT name
FROM person
WHERE gender = 'female' AND age > 25
ORDER BY name;

-- =========================================
-- Exercise 06: Favorite pizzas for Denis and Anna
-- =========================================
-- day02_ex06.sql
-- Find pizzas ordered by Denis or Anna

SELECT 
    m.pizza_name,
    pz.name AS pizzeria_name
FROM person_order po
JOIN person p ON po.person_id = p.id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE p.name = 'Denis' OR p.name = 'Anna'
ORDER BY m.pizza_name, pz.name;

-- Alternative using IN:
-- WHERE p.name IN ('Denis', 'Anna')

-- =========================================
-- Exercise 07: Cheapest pizzeria for Dmitriy
-- =========================================
-- day02_ex07.sql
-- Find pizzeria Dmitriy visited on Jan 8, 2022 with pizza < 800 rubles

SELECT 
    pz.name AS pizzeria_name
FROM person_visits pv
JOIN person p ON pv.person_id = p.id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
JOIN menu m ON pz.id = m.pizzeria_id
WHERE p.name = 'Dmitriy' 
  AND pv.visit_date = '2022-01-08'
  AND m.price < 800;

-- =========================================
-- Exercise 08: Continuing to research data
-- =========================================
-- day02_ex08.sql
-- Find men from Moscow or Samara who ordered pepperoni or mushroom pizza

SELECT DISTINCT p.name
FROM person p
JOIN person_order po ON p.id = po.person_id
JOIN menu m ON po.menu_id = m.id
WHERE p.gender = 'male'
  AND (p.address = 'Moscow' OR p.address = 'Samara')
  AND (m.pizza_name = 'pepperoni pizza' OR m.pizza_name = 'mushroom pizza')
ORDER BY p.name DESC;

-- =========================================
-- Exercise 09: Who loves cheese and pepperoni?
-- =========================================
-- day02_ex09.sql
-- Find women who ordered BOTH pepperoni AND cheese pizzas

SELECT p.name
FROM person p
JOIN person_order po1 ON p.id = po1.person_id
JOIN menu m1 ON po1.menu_id = m1.id
JOIN person_order po2 ON p.id = po2.person_id
JOIN menu m2 ON po2.menu_id = m2.id
WHERE p.gender = 'female'
  AND m1.pizza_name = 'pepperoni pizza'
  AND m2.pizza_name = 'cheese pizza'
ORDER BY p.name;

-- Alternative using subqueries (if needed):
/*
SELECT DISTINCT p.name
FROM person p
WHERE p.gender = 'female'
  AND p.id IN (
      SELECT person_id FROM person_order po
      JOIN menu m ON po.menu_id = m.id
      WHERE m.pizza_name = 'pepperoni pizza'
  )
  AND p.id IN (
      SELECT person_id FROM person_order po
      JOIN menu m ON po.menu_id = m.id
      WHERE m.pizza_name = 'cheese pizza'
  )
ORDER BY p.name;
*/

-- =========================================
-- Exercise 10: Find persons from one city
-- =========================================
-- day02_ex10.sql
-- Find people living at the same address

SELECT 
    p1.name AS person_name1,
    p2.name AS person_name2,
    p1.address AS common_address
FROM person p1
JOIN person p2 ON p1.address = p2.address AND p1.id < p2.id
ORDER BY person_name1, person_name2, common_address;
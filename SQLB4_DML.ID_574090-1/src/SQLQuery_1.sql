-- =========================================
-- Exercise 00: Find appropriate prices for Kate
-- =========================================
-- day03_ex00.sql
-- Find pizzas Kate visited with prices 800-1000

-- Exercise 00: Find prices for Kate (800-1000 rubles)
SELECT 
    m.pizza_name,
    m.price,
    pz.name AS pizzeria_name,
    pv.visit_date
FROM person_visits pv
JOIN person p ON pv.person_id = p.id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
JOIN menu m ON pv.pizzeria_id = m.pizzeria_id
WHERE p.name = 'Kate' 
    AND m.price BETWEEN 800 AND 1000
ORDER BY m.pizza_name, m.price, pz.name;

-- =========================================
-- Exercise 01: Find forgotten menus
-- =========================================
-- day03_ex01.sql
-- Find menu items that were never ordered
-- DENIED: any type of JOINs

SELECT m.id AS menu_id
FROM menu m
WHERE NOT EXISTS (
    SELECT 1
    FROM person_order po
    WHERE po.menu_id = m.id
)
ORDER BY menu_id;

-- =========================================
-- Exercise 02: Find forgotten pizza and pizzerias
-- =========================================
-- day03_ex02.sql
-- Display names and prices of unordered pizzas

SELECT 
    m.pizza_name,
    m.price,
    pz.name AS pizzeria_name
FROM menu m
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE NOT EXISTS (
    SELECT 1
    FROM person_order po
    WHERE po.menu_id = m.id
)
ORDER BY m.pizza_name, m.price;

-- =========================================
-- Exercise 03: Compare visits by gender
-- =========================================
-- day03_ex03.sql
-- Pizzerias visited more by one gender than the other

(SELECT pz.name AS pizzeria_name
FROM person_visits pv
JOIN person p ON pv.person_id = p.id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
WHERE p.gender = 'female'
EXCEPT ALL
SELECT pz.name
FROM person_visits pv
JOIN person p ON pv.person_id = p.id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
WHERE p.gender = 'male')
UNION ALL
(SELECT pz.name AS pizzeria_name
FROM person_visits pv
JOIN person p ON pv.person_id = p.id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
WHERE p.gender = 'male'
EXCEPT ALL
SELECT pz.name
FROM person_visits pv
JOIN person p ON pv.person_id = p.id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
WHERE p.gender = 'female')
ORDER BY pizzeria_name;

-- =========================================
-- Exercise 04: Compare orders by gender
-- =========================================
-- day03_ex04.sql
-- Pizzerias ordered ONLY by one gender

(SELECT pz.name AS pizzeria_name
FROM person_order po
JOIN person p ON po.person_id = p.id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE p.gender = 'female'
EXCEPT
SELECT pz.name
FROM person_order po
JOIN person p ON po.person_id = p.id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE p.gender = 'male')
UNION
(SELECT pz.name AS pizzeria_name
FROM person_order po
JOIN person p ON po.person_id = p.id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE p.gender = 'male'
EXCEPT
SELECT pz.name
FROM person_order po
JOIN person p ON po.person_id = p.id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
WHERE p.gender = 'female')
ORDER BY pizzeria_name;

-- =========================================
-- Exercise 05: Visited but did not order
-- =========================================
-- day03_ex05.sql
-- Pizzerias Andrey visited but didn't order from

SELECT DISTINCT pz.name AS pizzeria_name
FROM person_visits pv
JOIN person p ON pv.person_id = p.id
JOIN pizzeria pz ON pv.pizzeria_id = pz.id
WHERE p.name = 'Andrey'
  AND NOT EXISTS (
      SELECT 1
      FROM person_order po
      JOIN menu m ON po.menu_id = m.id
      WHERE po.person_id = p.id
        AND m.pizzeria_id = pz.id
  )
ORDER BY pizzeria_name;

-- =========================================
-- Exercise 06: Find price-similarity pizzas
-- =========================================
-- day03_ex06.sql
-- Find same pizzas with same price from different pizzerias

SELECT 
    m1.pizza_name,
    pz1.name AS pizzeria_name_1,
    pz2.name AS pizzeria_name_2,
    m1.price
FROM menu m1
JOIN pizzeria pz1 ON m1.pizzeria_id = pz1.id
JOIN menu m2 ON m1.pizza_name = m2.pizza_name 
            AND m1.price = m2.price 
            AND m1.pizzeria_id < m2.pizzeria_id
JOIN pizzeria pz2 ON m2.pizzeria_id = pz2.id
ORDER BY m1.pizza_name;

-- =========================================
-- Exercise 07: Add new pizza (greek pizza)
-- =========================================
-- day03_ex07.sql
-- INSERT greek pizza to Dominos

INSERT INTO menu (id, pizzeria_id, pizza_name, price)
VALUES (22, 2, 'greek pizza', 800);

-- =========================================
-- Exercise 08: Add Sicilian pizza dynamically
-- =========================================
-- day03_ex08.sql
-- INSERT Sicilian pizza with dynamic ID

INSERT INTO menu (id, pizzeria_id, pizza_name, price)
VALUES (
    (SELECT MAX(id) + 1 FROM menu),
    (SELECT id FROM pizzeria WHERE name = 'Dominos'),
    'sicilian pizza',
    900
);

-- =========================================
-- Exercise 09: New visits for Denis and Irina
-- =========================================
-- day03_ex09.sql
-- INSERT visits for Denis and Irina to Dominos

INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
VALUES 
    (
        (SELECT MAX(id) + 1 FROM person_visits),
        (SELECT id FROM person WHERE name = 'Denis'),
        (SELECT id FROM pizzeria WHERE name = 'Dominos'),
        '2022-02-24'
    ),
    (
        (SELECT MAX(id) + 2 FROM person_visits),
        (SELECT id FROM person WHERE name = 'Irina'),
        (SELECT id FROM pizzeria WHERE name = 'Dominos'),
        '2022-02-24'
    );

-- =========================================
-- Exercise 10: New orders for Denis and Irina
-- =========================================
-- day03_ex10.sql
-- INSERT orders for Sicilian pizza

INSERT INTO person_order (id, person_id, menu_id, order_date)
VALUES
    (
        (SELECT MAX(id) + 1 FROM person_order),
        (SELECT id FROM person WHERE name = 'Denis'),
        (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'),
        '2022-02-24'
    ),
    (
        (SELECT MAX(id) + 2 FROM person_order),
        (SELECT id FROM person WHERE name = 'Irina'),
        (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'),
        '2022-02-24'
    );

-- =========================================
-- Exercise 11: Update price for greek pizza
-- =========================================
-- day03_ex11.sql
-- Reduce greek pizza price by 10%

UPDATE menu
SET price = price * 0.9
WHERE pizza_name = 'greek pizza';

-- =========================================
-- Exercise 12: Orders for all persons
-- =========================================
-- day03_ex12.sql
-- INSERT orders for all persons for greek pizza using generate_series

INSERT INTO person_order (id, person_id, menu_id, order_date)
SELECT 
    (SELECT MAX(id) FROM person_order) + ROW_NUMBER() OVER () AS id,
    p.id AS person_id,
    (SELECT id FROM menu WHERE pizza_name = 'greek pizza') AS menu_id,
    '2022-02-25' AS order_date
FROM person p
ORDER BY p.id;

-- Alternative without ROW_NUMBER (if denied):
INSERT INTO person_order (id, person_id, menu_id, order_date)
SELECT 
    gs.id + (SELECT MAX(id) FROM person_order) AS id,
    p.id AS person_id,
    (SELECT id FROM menu WHERE pizza_name = 'greek pizza') AS menu_id,
    '2022-02-25' AS order_date
FROM (
    SELECT ROW_NUMBER() OVER () AS id, person.id AS person_id
    FROM person
) AS numbered
JOIN person p ON numbered.person_id = p.id
ORDER BY p.id;

-- Simpler version using sequence:
INSERT INTO person_order (id, person_id, menu_id, order_date)
SELECT 
    generate_series(
        (SELECT MAX(id) + 1 FROM person_order),
        (SELECT MAX(id) FROM person_order) + (SELECT COUNT(*) FROM person),
        1
    ) AS id,
    p.id AS person_id,
    (SELECT id FROM menu WHERE pizza_name = 'greek pizza') AS menu_id,
    '2022-02-25' AS order_date
FROM (SELECT ROW_NUMBER() OVER () AS rn, id FROM person ORDER BY id) p
WHERE p.rn <= (SELECT COUNT(*) FROM person);

-- Most straightforward approach:
INSERT INTO person_order (id, person_id, menu_id, order_date)
SELECT 
    (SELECT MAX(id) FROM person_order) + p.id AS id,
    p.id AS person_id,
    (SELECT id FROM menu WHERE pizza_name = 'greek pizza') AS menu_id,
    '2022-02-25' AS order_date
FROM person p;

-- =========================================
-- Exercise 13: Delete orders and menu item
-- =========================================
-- day03_ex13.sql
-- DELETE orders from 2022-02-25 and greek pizza from menu

-- Delete orders from Exercise 12
DELETE FROM person_order
WHERE order_date = '2022-02-25';

-- Delete greek pizza from menu
DELETE FROM menu
WHERE pizza_name = 'greek pizza';



SELECT MAX(id) FROM menu;
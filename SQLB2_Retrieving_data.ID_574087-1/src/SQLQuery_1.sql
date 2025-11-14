CREATE DATABASE Restaurant;

-- =========================================
-- Pizza Database Schema
-- Complete database structure with sample data
-- =========================================

-- Drop tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS person_order CASCADE;
DROP TABLE IF EXISTS person_visits CASCADE;
DROP TABLE IF EXISTS menu CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS pizzeria CASCADE;

-- =========================================
-- 1. PIZZERIA TABLE (Dictionary)
-- =========================================
CREATE TABLE pizzeria (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    rating NUMERIC(3,2) CHECK (rating >= 0 AND rating <= 5)
);

-- Sample data for pizzeria
INSERT INTO pizzeria (id, name, rating) VALUES
(1, 'Pizza Hut', 4.6),
(2, 'Dominos', 4.3),
(3, 'DoDo Pizza', 3.9),
(4, 'Papa Johns', 4.5),
(5, 'Best Pizza', 2.3),
(6, 'DinoPizza', 4.2);

-- =========================================
-- 2. PERSON TABLE (Dictionary)
-- =========================================
CREATE TABLE person (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INTEGER CHECK (age > 0),
    gender VARCHAR(10),
    address VARCHAR(255)
);

-- Sample data for person
INSERT INTO person (id, name, age, gender, address) VALUES
(1, 'Anna', 16, 'female', 'Moscow'),
(2, 'Andrey', 21, 'male', 'Moscow'),
(3, 'Kate', 33, 'female', 'Kazan'),
(4, 'Denis', 13, 'male', 'Kazan'),
(5, 'Elvira', 45, 'female', 'Kazan'),
(6, 'Irina', 21, 'female', 'Saint-Petersburg'),
(7, 'Peter', 24, 'male', 'Moscow'),
(8, 'Nataly', 30, 'female', 'Novosibirsk'),
(9, 'Dmitriy', 18, 'male', 'Samara');

-- =========================================
-- 3. MENU TABLE (Dictionary)
-- =========================================
CREATE TABLE menu (
    id BIGINT PRIMARY KEY,
    pizzeria_id BIGINT NOT NULL,
    pizza_name VARCHAR(255) NOT NULL,
    price NUMERIC(10,2) CHECK (price > 0),
    FOREIGN KEY (pizzeria_id) REFERENCES pizzeria(id)
);

-- Sample data for menu
INSERT INTO menu (id, pizzeria_id, pizza_name, price) VALUES
(1, 1, 'Pepperoni Pizza', 800),
(2, 1, 'Cheese Pizza', 750),
(3, 1, 'Margherita', 700),
(4, 2, 'Pepperoni Pizza', 850),
(5, 2, 'Four Cheese', 900),
(6, 2, 'Hawaiian Pizza', 950),
(7, 3, 'Pepperoni Pizza', 780),
(8, 3, 'Meat Pizza', 1100),
(9, 3, 'Margherita', 690),
(10, 4, 'Pepperoni Pizza', 920),
(11, 4, 'Vegetarian Pizza', 850),
(12, 4, 'BBQ Chicken', 980),
(13, 5, 'Pepperoni Pizza', 550),
(14, 5, 'Cheese Pizza', 500),
(15, 5, 'Supreme Pizza', 650),
(16, 6, 'Pepperoni Pizza', 800),
(17, 6, 'Seafood Pizza', 1200),
(18, 6, 'Margherita', 700);

-- =========================================
-- 4. PERSON_VISITS TABLE (Operational)
-- =========================================
CREATE TABLE person_visits (
    id BIGINT PRIMARY KEY,
    person_id BIGINT NOT NULL,
    pizzeria_id BIGINT NOT NULL,
    visit_date DATE NOT NULL,
    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (pizzeria_id) REFERENCES pizzeria(id)
);

-- Sample data for person_visits
INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date) VALUES
(1, 1, 1, '2022-01-01'),
(2, 2, 2, '2022-01-01'),
(3, 2, 1, '2022-01-02'),
(4, 3, 5, '2022-01-03'),
(5, 3, 6, '2022-01-04'),
(6, 4, 5, '2022-01-07'),
(7, 4, 6, '2022-01-08'),
(8, 5, 2, '2022-01-08'),
(9, 5, 6, '2022-01-09'),
(10, 6, 3, '2022-01-09'),
(11, 6, 4, '2022-01-10'),
(12, 7, 1, '2022-01-11'),
(13, 7, 2, '2022-01-12'),
(14, 8, 3, '2022-01-13'),
(15, 8, 4, '2022-01-14'),
(16, 9, 5, '2022-01-15'),
(17, 9, 6, '2022-01-16'),
(18, 1, 2, '2022-01-07'),
(19, 2, 3, '2022-01-08'),
(20, 3, 1, '2022-01-09');

-- =========================================
-- 5. PERSON_ORDER TABLE (Operational)
-- =========================================
CREATE TABLE person_order (
    id BIGINT PRIMARY KEY,
    person_id BIGINT NOT NULL,
    menu_id BIGINT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (menu_id) REFERENCES menu(id)
);

-- Sample data for person_order
INSERT INTO person_order (id, person_id, menu_id, order_date) VALUES
(1, 1, 1, '2022-01-01'),
(2, 1, 2, '2022-01-01'),
(3, 2, 4, '2022-01-01'),
(4, 3, 5, '2022-01-03'),
(5, 4, 13, '2022-01-07'),
(6, 4, 14, '2022-01-07'),
(7, 4, 18, '2022-01-07'),
(8, 5, 6, '2022-01-08'),
(9, 6, 7, '2022-01-09'),
(10, 6, 8, '2022-01-09'),
(11, 7, 9, '2022-01-11'),
(12, 7, 10, '2022-01-12'),
(13, 8, 11, '2022-01-13'),
(14, 8, 12, '2022-01-14'),
(15, 9, 15, '2022-01-15'),
(16, 9, 16, '2022-01-16'),
(17, 1, 3, '2022-01-07'),
(18, 2, 5, '2022-01-08');

-- =========================================
-- INDEXES for better performance
-- =========================================
CREATE INDEX idx_menu_pizzeria ON menu(pizzeria_id);
CREATE INDEX idx_person_visits_person ON person_visits(person_id);
CREATE INDEX idx_person_visits_pizzeria ON person_visits(pizzeria_id);
CREATE INDEX idx_person_visits_date ON person_visits(visit_date);
CREATE INDEX idx_person_order_person ON person_order(person_id);
CREATE INDEX idx_person_order_menu ON person_order(menu_id);
CREATE INDEX idx_person_order_date ON person_order(order_date);










-- =========================================
-- Exercise 00: Let's make UNION dance
-- =========================================
-- day01_ex00.sql
-- Return menu and person data in one list, ordered by object_id then object_name

SELECT id AS object_id, pizza_name AS object_name
FROM menu
UNION ALL
SELECT id AS object_id, name AS object_name
FROM person
ORDER BY object_id, object_name;

-- =========================================
-- Exercise 01: UNION dance with subquery
-- =========================================
-- day01_ex01.sql
-- Remove object_id, order by object_name (person first, then menu), keep duplicates

SELECT name AS object_name
FROM person
UNION ALL
SELECT pizza_name AS object_name
FROM menu
ORDER BY object_name;

-- =========================================
-- Exercise 02: Duplicates or not duplicates
-- =========================================
-- day01_ex02.sql
-- Return unique pizza names in descending order
-- WITHOUT using DISTINCT, GROUP BY, HAVING, or JOINs

SELECT pizza_name
FROM menu
UNION
SELECT pizza_name
FROM menu
ORDER BY pizza_name DESC;

-- Note: UNION automatically removes duplicates (unlike UNION ALL)

-- =========================================
-- Exercise 03: "Hidden" Insights
-- =========================================
-- day01_ex03.sql
-- Find person_id who visited AND ordered on the same day
-- WITHOUT using JOINs

SELECT order_date AS action_date, person_id
FROM person_order
INTERSECT
SELECT visit_date AS action_date, person_id
FROM person_visits
ORDER BY action_date ASC, person_id DESC;

-- =========================================
-- Exercise 04: Difference between multisets
-- =========================================
-- day01_ex04.sql
-- Return person_id from person_order that are NOT in person_visits
-- for January 7, 2022, keeping duplicates

SELECT person_id
FROM person_order
WHERE order_date = '2022-01-07'
EXCEPT ALL
SELECT person_id
FROM person_visits
WHERE visit_date = '2022-01-07';

-- Note: EXCEPT ALL keeps duplicates, EXCEPT removes them

-- =========================================
-- Exercise 05: Cartesian Product
-- =========================================
-- day01_ex05.sql
-- All possible combinations between person and pizzeria

SELECT 
    p.id,
    p.name,
    p.age,
    p.gender,
    p.address,
    pz.id,
    pz.name,
    pz.rating
FROM person p
CROSS JOIN pizzeria pz
ORDER BY p.id, pz.id;

-- =========================================
-- Exercise 06: "Hidden" Insights with names
-- =========================================
-- day01_ex06.sql
-- Same as Exercise 03 but return person names instead of IDs

SELECT 
    action_date,
    p.name AS person_name
FROM (
    SELECT order_date AS action_date, person_id
    FROM person_order
    INTERSECT
    SELECT visit_date AS action_date, person_id
    FROM person_visits
) AS common_actions
JOIN person p ON common_actions.person_id = p.id
ORDER BY action_date ASC, person_name DESC;

-- =========================================
-- Exercise 07: Just make a JOIN
-- =========================================
-- day01_ex07.sql
-- Return order_date and person information (name and age)

SELECT 
    po.order_date,
    p.name || ' (age:' || p.age || ')' AS person_information
FROM person_order po
JOIN person p ON po.person_id = p.id
ORDER BY po.order_date, person_information;

-- =========================================
-- Exercise 08: Migrate JOIN to NATURAL JOIN
-- =========================================
-- day01_ex08.sql
-- Rewrite Exercise 07 using NATURAL JOIN

SELECT 
    order_date,
    name || ' (age:' || age || ')' AS person_information
FROM person_order
NATURAL JOIN person
ORDER BY order_date, person_information;

-- Note: NATURAL JOIN works in PostgreSQL because it automatically 
-- joins on columns with the same name (person_id in this case)

-- =========================================
-- Exercise 09: IN versus EXISTS
-- =========================================
-- day01_ex09.sql
-- Return pizzerias NOT visited by any person

-- Method 1: Using NOT IN
SELECT name
FROM pizzeria
WHERE id NOT IN (
    SELECT pizzeria_id
    FROM person_visits
)
ORDER BY name;

-- Method 2: Using NOT EXISTS
SELECT pz.name
FROM pizzeria pz
WHERE NOT EXISTS (
    SELECT 1
    FROM person_visits pv
    WHERE pv.pizzeria_id = pz.id
)
ORDER BY pz.name;

-- =========================================
-- Exercise 10: Global JOIN
-- =========================================
-- day01_ex10.sql
-- Return person names, pizza names, and pizzeria names for all orders

SELECT 
    p.name AS person_name,
    m.pizza_name,
    pz.name AS pizzeria_name
FROM person_order po
JOIN person p ON po.person_id = p.id
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria pz ON m.pizzeria_id = pz.id
ORDER BY p.name, m.pizza_name, pz.name;
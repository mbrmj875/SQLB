CREATE DATABASE Restaurant; 

Go

-- =========================================
-- 1. PIZZERIA TABLE (Dictionary)
-- =========================================
CREATE TABLE pizzeria (
    id BIGINT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    rating NUMERIC(3,2) CHECK (rating >= 0 AND rating <= 5)
);


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
-- 00: Basic 
-- =========================================
SELECT name, age
FROM person
WHERE address = 'Kazan';




-- =========================================
--  01: Multiple Conditions with Sorting 
-- =========================================

SELECT name, age
FROM person
WHERE address = 'Kazan' AND gender = 'female'
ORDER BY name;





-- =========================================
-- 02: Two Syntax Approaches for Range Filtering
-- =========================================

SELECT name, rating
FROM pizzeria
WHERE rating >= 3.5 AND rating <= 5
ORDER BY rating;


-- =========================================

SELECT name, rating
FROM pizzeria
WHERE rating BETWEEN 3.5 AND 5
ORDER BY rating;

-- =========================================
-- 03: DISTINCT with Complex Conditions
-- =========================================


SELECT DISTINCT person_id
FROM person_visits
WHERE (visit_date BETWEEN '2022-01-06' AND '2022-01-09') 
   OR pizzeria_id = 2
ORDER BY person_id DESC;





-- =========================================
-- 04: String Concatenation
-- =========================================




SELECT 
    name + ' (age:' + CAST(age AS VARCHAR) + ',gender:''' + gender + ''',address:''' + address + ''')' AS person_information
FROM person
ORDER BY person_information;



-- =========================================
-- 05: Subquery in SELECT Clause
-- =========================================
SELECT 
    (SELECT name FROM person WHERE person.id = person_order.person_id) AS name
FROM person_order
WHERE menu_id IN (13, 14, 18) AND order_date = '2022-01-07';




-- =========================================
-- 06: Conditional Logic with CASE
-- =========================================

SELECT 
    (SELECT name FROM person WHERE person.id = person_order.person_id) AS name,
    CASE 
        WHEN (SELECT name FROM person WHERE person.id = person_order.person_id) = 'Denis' THEN 'true'
        ELSE 'false'
    END AS check_name
FROM person_order
WHERE menu_id IN (13, 14, 18) AND order_date = '2022-01-07';

-- =========================================
-- 07: Age Interval Classification
-- =========================================

SELECT 
    id,
    name,
    CASE 
        WHEN age >= 10 AND age <= 20 THEN 'interval #1'
        WHEN age > 20 AND age < 24 THEN 'interval #2'
        ELSE 'interval #3'
    END AS interval_info
FROM person
ORDER BY interval_info;

-- =========================================
-- 08: Modulo Operator for Even Numbers
-- =========================================

SELECT *
FROM person_order
WHERE id % 2 = 0
ORDER BY id;

-- =========================================
-- 009: Complex Subqueries in SELECT and FROM
-- =========================================

SELECT 
    (SELECT name FROM person WHERE person.id = pv.person_id) AS person_name,
    (SELECT name FROM pizzeria WHERE pizzeria.id = pv.pizzeria_id) AS pizzeria_name
FROM (
    SELECT person_id, pizzeria_id
    FROM person_visits
    WHERE visit_date BETWEEN '2022-01-07' AND '2022-01-09'
) AS pv
ORDER BY person_name, pizzeria_name DESC;
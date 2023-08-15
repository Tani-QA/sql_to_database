SHOW DATABASES;
USE hogwarts;
SHOW tables;

SELECT * FROM characters;
SELECT * FROM library;

-- Выведите имя, фамилию, патронуса всех персонажей, у которых есть patronus и он известен
SELECT fname, lname,  patronus
FROM characters
WHERE patronus IS NOT NULL;

-- Выведите фамилию персонажей, у которых последняя буква в фамилии ‘e’ 
SELECT lname
FROM characters
WHERE lname LIKE '%e';

-- Посчитайте общий возраст всех персонажей и выведите это на экран
SELECT SUM(age) 
FROM characters;

-- Выведите имя, фамилию и возраст персонажей по убыванию их возраста
SELECT fname, lname,  age
FROM characters
ORDER BY age DESC;

-- Выведите имя персонажа и возраст, у которых последний находится в диапазоне от 50 до 100 лет
SELECT fname,  age
FROM characters
WHERE age BETWEEN 50 AND 100
ORDER BY age DESC;

-- Выведите возраст всех персонажей так, чтобы среди них не было тех, у кого он одинаковый
SELECT DISTINCT(age)
FROM characters;

-- Выведите всю информацию о персонажах, у которых faculty = Gryffindor и чей возраст больше 30 лет
SELECT fname, lname, age, faculty,  patronus
FROM characters
WHERE faculty='Gryffindor' AND  age >30;

-- Выведите имена первых трех факультетов из таблицы, так чтобы факультеты не повторялись 
SELECT distinct (faculty)
FROM characters
LIMIT 3;

-- Выведите имена всех персонажей, у которых имя начинается с ‘H’ и состоит из 5 букв, или чье имя начинается с ‘L’ 
SELECT fname
FROM characters
WHERE fname LIKE 'H____' OR fname LIKE 'L%';

-- Посчитайте средний возраст всех персонажей
SELECT AVG(age) 
FROM characters;

-- Удалите персонажа с ID = 11
SELECT * 
FROM characters
WHERE char_id=11;

DELETE
FROM characters
WHERE char_id=11;

SELECT * FROM characters;

-- Выведите фамилию всех персонажей, которые содержат в ней букву ‘a’ 
SELECT lname
FROM characters
WHERE lname LIKE '%a%';

-- Используйте псевдоним для того, чтобы временно замените название столбца fname на Half-Blood Prince для реального принца-полукровки
SELECT fname AS 'Half-Blood Prince'
FROM characters
WHERE fname='Harry' AND lname='Potter';

-- Выведите id и имена всех патронусов в алфавитном порядки, при условии что они есть или известны 
SELECT char_id, patronus
FROM characters
WHERE patronus IS NOT NULL AND NOT patronus="Unknown"
ORDER BY patronus;

-- Используя оператор IN, выведите имя и фамилию тех персонажей, у которых фамилия Crabbe, Granger или Diggory 
SELECT fname, lname
FROM characters
WHERE lname IN ('Crabbe', 'Granger','Diggory');

-- Выведите минимальный возраст персонажа 
SELECT MIN(age)
FROM characters;

-- Используя оператор UNION выберите имена из таблицы characters и названия книг из таблицы library 
SELECT fname
FROM characters
UNION ALL
SELECT book_name
FROM library;

-- Используя оператор HAVING посчитайте количество персонажей на каждом факультете, оставив только те факультеты, где количество студентов больше 1 
SELECT faculty, COUNT(faculty)
FROM characters
GROUP BY faculty
HAVING COUNT(faculty)>1;

-- Используя оператор CASE опишите следующую логику:
-- Выведите имя и фамилию персонажа, а также следующий текстовое сообщение:
-- Если факультет Gryffindor, то в консоли должно вывестись Godric
-- Если факультет Slytherin, то в консоли должно вывестись Salazar
-- Если факультет Ravenclaw, то в консоли должно вывестись Rowena
-- Если факультет Hufflepuff, то в консоли должно вывестись Helga
-- Если другая информация, то выводится Muggle
-- Для сообщения используйте псевдоним Founders
SELECT fname, lname,
CASE
    WHEN faculty='Gryffindor' THEN 'Godric' 
    WHEN faculty='Slytherin' THEN 'Salazar' 
    WHEN faculty='Ravenclaw' THEN 'Rowena'
    WHEN faculty='Hufflepuff' THEN 'Helga' 
    ELSE 'Muggle' 
END AS Founders
FROM characters;

-- Используя регулярное выражение найдите фамилии персонажей, которые не начинаются с букв H, L или S и выведите их
SELECT lname
FROM characters
WHERE lname NOT RLIKE '^[HLS]';

-- Выведите имя, фамилию персонажей и название книги, которая на них числится
SELECT fname, lname, book_name
FROM characters
JOIN library ON characters.book_id=library.book_id AND characters.char_id=library.char_id
ORDER BY fname;

-- Выведите имя, фамилию персонажей и название книги, вне зависимости от того, есть ли у них книги или нет
SELECT fname, lname, book_name
FROM characters
JOIN library ON characters.char_id=library.char_id
ORDER BY fname;

-- Выведите название книги и имя патронуса, вне зависимости от того, есть ли информация о держателе книги в таблице или нет
SELECT book_name, patronus
FROM characters
LEFT JOIN library ON characters.book_id=library.book_id AND characters.char_id=library.char_id
ORDER BY fname;

-- Выведите имя, фамилию, возраст персонажей и название книги, которая на них числится, при условии, что все владельцы книг должны быть старше 15 лет
SELECT fname, lname, age,book_name
FROM characters
JOIN library ON characters.book_id=library.book_id AND characters.char_id=library.char_id
WHERE age>15
ORDER BY fname;

-- Выведите имя персонажа, название книги, дату выдачи и дату завершения, при условии, что он младше 15 лет и его патронус неизвестен
SELECT fname, book_name, start_date,end_date
FROM characters
JOIN library ON characters.book_id=library.book_id AND characters.char_id=library.char_id
WHERE age<15 AND patronus IS NULL AND NOT patronus="Unknown"
ORDER BY fname;

-- Используя вложенный запрос количество книг, у которых end_date больше, чем end_date у Hermione
SELECT *
FROM library
WHERE end_date > (
SELECT end_date FROM library
JOIN characters ON characters.book_id=library.book_id AND characters.char_id=library.char_id 
WHERE fname='Hermione');

-- С помощью вложенного запроса выведите имена всех патронусов, у которых владельцы старше возраста персонажа, у которого патронус Unknown
SELECT SUM(age) As age
FROM characters
WHERE patronus IS NULL AND NOT patronus="Unknown";

SELECT patronus, SUM(age) AS age FROM characters GROUP BY patronus HAVING patronus IS NULL AND NOT patronus="Unknown";

SELECT patronus, age
FROM characters
WHERE age > 
(SELECT SUM(age) AS age 
FROM characters 
GROUP BY patronus 
HAVING patronus IS NULL AND NOT patronus="Unknown");



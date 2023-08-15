-- вставить запись в таблицу
INSERT INTO book (title,author,price,amount)
            VALUES ('Мастер и Маргарита','Булгаков М.А.',670.99,3);
            
-- Занесите в таблицу supply четыре записи, чтобы получилась следующая таблица:
INSERT INTO supply(title, author, price, amount) 
VALUES 
    ('Лирика','Пастернак Б.Л.',518.99,2),
    ('Черный человек','Есенин С.А.',570.20,6),
    ('Белая гвардия','Булгаков М.А.',540.50,7),
    ('Идиот','Достоевский Ф.М.',360.80,3);
SELECT * FROM supply;           


-- Занести все книги из таблицы supply в таблицу book.
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply;
SELECT * FROM book;

-- Добавить из таблицы supply в таблицу book, все книги, кроме книг, написанных Булгаковым М.А. и Достоевским Ф.М.
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE (author<>'Булгаков М.А.' AND author<>'Достоевский Ф.М.');

SELECT * FROM book;

INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE author NOT IN('Булгаков М.А.','Достоевский Ф.М.');

-- Занести из таблицы supply в таблицу book только те книги, названия которых отсутствуют в таблице book.
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE title NOT IN (
        SELECT title 
        FROM book
      );

SELECT * FROM book;

-- Занести из таблицы supply в таблицу book только те книги, авторов которых нет в  book.
INSERT INTO book (title, author, price, amount) 
SELECT title, author, price, amount 
FROM supply
WHERE author NOT IN (
        SELECT author 
        FROM book
      );

SELECT * FROM book;

-- В таблицу fine первые 5 строк уже занесены. Добавить в таблицу записи с ключевыми значениями 6, 7, 8.
INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment) 
VALUES 
    ('Баранов П.Е.','Р523ВТ','Превышение скорости(от 40 до 60)',NULL,'2020-02-14',NULL),
    ('Абрамова К.А.','О111АВ','Проезд на запрещающий сигнал',NULL,'2020-02-23',NULL),
    ('Яковлев Г.Р.','Т330ТТ','Проезд на запрещающий сигнал',NULL,'2020-03-03',NULL);

SELECT * FROM fine;
SELECT * FROM book;

-- Заполнить таблицу author. В нее включить следующих авторов:
-- Булгаков М.А.
-- Достоевский Ф.М.
-- Есенин С.А.
-- Пастернак Б.Л.
INSERT INTO author (name_author)
VALUES
 ('Булгаков М.А.'),
 ('Достоевский Ф.М.'),
 ('Есенин С.А.'),
 ('Пастернак Б.Л.');
 
 SELECT * from author;
 
-- Добавьте три последние записи (с ключевыми значениями 6, 7, 8) в таблицу book, первые 5 записей уже добавлены:
SELECT * FROM book;

INSERT INTO book (title, author_id, genre_id, price, amount)
VALUES
 ('Стихотворения и поэмы',3,2,650.00,15),
 ('Черный человек',3,2,570.20,6),
 ('Лирика',4,2,518.99,2);

SELECT * FROM book;

-- Запросы на добавление, связанные таблицы
-- В таблице supply  есть новые книги, которых на складе еще не было. Прежде чем добавлять их в таблицу book,  необходимо из таблицы supplyотобрать новых авторов, если таковые имеются.
SELECT name_author, supply.author
FROM 
    author 
    RIGHT JOIN supply ON author.name_author = supply.author;

SELECT supply.author
FROM 
    author 
    RIGHT JOIN supply on author.name_author = supply.author
WHERE name_author IS Null;

-- Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести все данные из таблицы author.  Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author.
INSERT INTO author (name_author)
SELECT supply.author
FROM 
    author 
    RIGHT JOIN supply on author.name_author = supply.author
WHERE name_author IS Null;

SELECT * FROM author;

-- добавить новые записи о книгах, которые есть в таблице supply и нет в таблице book. (В таблицах supply и book сохранены изменения предыдущих шагов). Поскольку в таблице supply не указан жанр книги, оставить его пока пустым (занести значение Null).
SELECT title, author_id, price, amount
FROM 
    author 
    INNER JOIN supply ON author.name_author = supply.author;

SELECT title, author_id, price, amount
FROM 
    author 
    INNER JOIN supply ON author.name_author = supply.author
WHERE amount <> 0;


-- Добавить новые книги из таблицы supply в таблицу book на основе сформированного выше запроса. Затем вывести для просмотра таблицу book.
INSERT INTO book (title,author_id,price,amount)
SELECT title, author_id, price, amount
FROM 
    author 
    INNER JOIN supply ON author.name_author = supply.author
WHERE amount <> 0;

SELECT * FROM book;

-- Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.
INSERT INTO client (name_client, city_id, email) 
SELECT 'Попов Илья', city_id, 'popov@test'
FROM city
WHERE city_id=1;

SELECT * FROM client;


-- Создать новый заказ для Попова Ильи. Его комментарий для заказа: «Связаться со мной по вопросу доставки».
INSERT INTO buy (buy_description,client_id) 
SELECT 'Связаться со мной по вопросу доставки', client_id
FROM client
WHERE name_client LIKE 'Попов Илья';

SELECT * FROM buy;

-- В таблицу buy_book добавить заказ с номером 5. Этот заказ должен содержать книгу Пастернака «Лирика» в количестве двух экземпляров и книгу Булгакова «Белая гвардия» в одном экземпляре.
INSERT INTO buy_book (buy_id,book_id,amount) 
SELECT 5, (SELECT book_id FROM book JOIN author ON book.author_id=author.author_id WHERE title LIKE 'Лирика' AND name_author LIKE 'Пастернак%'), 2;
INSERT INTO buy_book (buy_id,book_id,amount) 
SELECT 5, (SELECT book_id FROM book JOIN author ON book.author_id=author.author_id WHERE title LIKE 'Белая гвардия' AND name_author LIKE 'Булгаков%'), 1;

SELECT * FROM buy_book;
-- or
INSERT INTO buy_book (buy_id, book_id, amount)
VALUES (5, (SELECT book_id FROM book WHERE title = 'Лирика' AND author_id = 4), 2),
       (5, (SELECT book_id FROM book WHERE title = 'Белая гвардия' AND author_id = 1), 1);
       

-- В таблицу buy_step для заказа с номером 5 включить все этапы из таблицы step, которые должен пройти этот заказ. В столбцы date_step_beg и date_step_end всех записей занести Null.
INSERT INTO buy_step (buy_id, step_id, date_step_beg, date_step_end)
SELECT buy_id, step_id, Null, Null
FROM buy
CROSS JOIN step
WHERE buy_id = 5;

SELECT * FROM buy_step;    

-- В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы баз данных». Установить текущую дату в качестве даты выполнения попытки.
INSERT INTO attempt(student_id, subject_id, date_attempt)
SELECT 
    (SELECT student_id FROM student WHERE name_student = 'Баранов Павел'), 
    (SELECT subject_id FROM subject WHERE name_subject = 'Основы баз данных'), 
    NOW();

SELECT * FROM attempt;   

-- Случайным образом выбрать три вопроса (запрос) по дисциплине, тестирование по которой собирается проходить студент, занесенный в таблицу attempt последним, и добавить их в таблицу testing. id последней попытки получить как максимальное значение id из таблицы attempt.
INSERT INTO testing(attempt_id, question_id)
SELECT attempt_id, question_id
FROM question
JOIN attempt USING (subject_id)
WHERE attempt_id=(SELECT MAX(attempt_id) from attempt)
ORDER BY RAND()
LIMIT 3;

SELECT * FROM testing;


-- создать таблицу book
CREATE TABLE book(
   book_id	INT PRIMARY KEY AUTO_INCREMENT,
   title	VARCHAR(50),
   author	VARCHAR(30),
   price	DECIMAL(8, 2),
   amount	INT
);

-- Создать таблицу поставка (supply), которая имеет ту же структуру, что и таблиц book.
CREATE TABLE supply(
    supply_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50),
    author VARCHAR(30),
    price DECIMAL(8,2),
    amount INT
);

-- Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше 4. Для всех книг указать одинаковое количество экземпляров 5.
CREATE TABLE ordering AS
SELECT author, title, 5 AS amount
FROM book
WHERE amount < 4;

SELECT * FROM ordering;


-- Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше 4. Для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.
CREATE TABLE ordering AS
SELECT author, title, 
   (
    SELECT ROUND(AVG(amount)) 
    FROM book
   ) AS amount
FROM book
WHERE amount < 4;

SELECT * FROM ordering;

-- Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше среднего количества экземпляров книг в таблице book. В таблицу включить столбец   amount, в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.
CREATE TABLE ordering AS
SELECT author, title, 
   (
    SELECT ROUND(AVG(amount)) 
    FROM book
   ) AS amount
FROM book
WHERE amount < (SELECT AVG(amount) FROM book);

SELECT * FROM ordering;


-- Создать таблицу поставка (fine), которая имеет же структуру..
CREATE TABLE fine(
    fine_id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8,2),
    date_violation DATE,
    date_payment DATE
);


-- Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа  и  дату нарушения) из таблицы fine.
CREATE TABLE back_payment AS 
SELECT name, number_plate, violation, sum_fine, date_violation 
FROM fine
WHERE fine.date_payment IS NULL;

SELECT * FROM back_payment;

-- СВЯЗИ МЕЖДУ ТАБЛИЦАМИ
-- Создать таблицу author следующей структуры:
-- Поле	Тип, описание
-- author_id	INT PRIMARY KEY AUTO_INCREMENT
-- name_author	VARCHAR(50)
CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT, 
    name_author VARCHAR(50)
);

SELECT * FROM author;


-- Создать таблицу book следующей структуры:
-- Поле	Тип, описание	Связи
-- book_id	INT PRIMARY KEY AUTO_INCREMENT	 
-- title	VARCHAR(50)	 
-- author_id	INT 	внешний ключ:
-- главная таблица author,
-- связанный столбец author.author_id,
-- пустое значение не допускается
-- price	DECIMAL(8, 2)	 
-- amount	INT
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL, 
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id) 
);

-- Перепишите запрос на создание таблицы book , чтобы ее структура соответствовала структуре, показанной на логической схеме (таблица genre уже создана, порядок следования столбцов - как на логической схеме в таблице book, genre_id  - внешний ключ) . Для genre_id ограничение о недопустимости пустых значений не задавать. В качестве главной таблицы для описания поля  genre_idиспользовать таблицу genre следующей структуры:
-- Поле	Тип, описание
-- genre_id	INT PRIMARY KEY AUTO_INCREMENT
-- name_genre	VARCHAR(30)
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL, 
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id),
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) 
);

-- Будем считать, что при удалении автора из таблицы author, необходимо удалить все записи о книгах из таблицы book, написанные этим автором. Данное действие необходимо прописать при создании таблицы.
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL, 
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE
);

-- Создать таблицу book той же структуры, что и на предыдущем шаге. Будем считать, что при удалении автора из таблицы author, должны удаляться все записи о книгах из таблицы book, написанные этим автором. А при удалении жанра из таблицы genre для соответствующей записи book установить значение Null в столбце genre_id. 
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL, 
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) ON DELETE SET NULL
);

-- Магазин по ошибке купил излишнее количество экземпляров книг, поэтому ему требуется сделать распродажу этих книг. Требуется, чтобы в магазине стало одинаковое количество экземпляров каждой из книг, равное 8. Ваша задача: создать две таблицы (supply, sale). В supply вам нужно внести количество экземпляров каждой из книг, которые нужно докупить, чтобы их стало 8. В sale вам нужно внести количество экземпляров каждой из книг, которые нужно продать, чтобы в магазине осталось 8. В supply и sale будут столбцы название книги, фамилия и инициалы автора, жанр, цена, количество экземпляров. Цена в таблице supply на 20 процентов меньше той, что в таблице book, а в sale - на 50 процентов меньше. Отсортируйте обе таблицы сначала по авторам в алфавитном порядке, а затем по убыванию цен.
CREATE TABLE sale AS
SELECT title, name_author, name_genre, ROUND(0.5*price,2) AS price,amount - 8 AS amount
FROM author INNER JOIN book USING(author_id)
     INNER JOIN genre USING(genre_id)
WHERE amount > 8
ORDER BY name_author, price DESC;

CREATE TABLE supply AS
SELECT title, name_author, name_genre, ROUND(0.8*price,2) AS price,8 - amount AS amount
FROM author INNER JOIN book USING(author_id)
     INNER JOIN genre USING(genre_id)
WHERE amount < 8
ORDER BY name_author, price DESC;

-- Создать счет (таблицу buy_pay) на оплату заказа с номером 5, в который включить название книг, их автора, цену, количество заказанных книг и  стоимость. Последний столбец назвать Стоимость. Информацию в таблицу занести в отсортированном по названиям книг виде.
CREATE TABLE buy_pay AS
SELECT title, name_author, book.price, buy_book.amount, book.price*buy_book.amount AS Стоимость
FROM buy_book INNER JOIN book USING(book_id)
                INNER JOIN author USING(author_id) 
WHERE buy_book.buy_id = 5
ORDER BY title;

SELECT * FROM buy_pay;

-- Создать общий счет (таблицу buy_pay) на оплату заказа с номером 5. Куда включить номер заказа, количество книг в заказе (название столбца Количество) и его общую стоимость (название столбца Итого). Для решения используйте ОДИН запрос.
CREATE TABLE buy_pay AS
SELECT buy_id, SUM(buy_book.amount) AS Количество , SUM(book.price*buy_book.amount) AS Итого   
FROM buy_book INNER JOIN book USING(book_id)
                INNER JOIN author USING(author_id) 
WHERE buy_book.buy_id = 5
ORDER BY title;

SELECT * FROM buy_pay;

-- По каждому клиенту вывести сумму выручки и прибыль компании при наценке на книги 30%, выручку округлить до 2 знаков после запятой.
CREATE TABLE buys AS 
SELECT name_client, SUM(buy_book.amount * book.price) AS sum_amount, ROUND(SUM(buy_book.amount * book.price / 130 * 30), 2) AS profit
       FROM client
       JOIN buy USING(client_id)
       JOIN buy_book USING(buy_id)
       JOIN book USING(book_id)
GROUP BY name_client;
SELECT * FROM buys; 

-- Создать вспомогательную таблицу applicant,  куда включить id образовательной программы, id абитуриента, сумму баллов абитуриентов (столбец itog) в отсортированном сначала по id образовательной программы, а потом по убыванию суммы баллов виде (использовать запрос из предыдущего урока).
CREATE TABLE applicant
select program_id,enrollee.enrollee_id, SUM(result) itog   
from enrollee
 join program_enrollee USING(enrollee_id)
 join program USING(program_id) 
 join program_subject USING(program_id)
 join subject USING(subject_id)
 join enrollee_subject ON subject.subject_id = enrollee_subject.subject_id  and enrollee_subject.enrollee_id = enrollee.enrollee_id
group by program_id,enrollee_id
order by program_id ASC, itog DESC;

select * from applicant;

-- Поскольку при добавлении дополнительных баллов, абитуриенты по каждой образовательной программе могут следовать не в порядке убывания суммарных баллов, необходимо создать новую таблицу applicant_order на основе таблицы applicant. При создании таблицы данные нужно отсортировать сначала по id образовательной программы, потом по убыванию итогового балла. А таблицу applicant, которая была создана как вспомогательная, необходимо удалить.
select * from applicant;

CREATE TABLE applicant_order
select program_id, ,nrollee_id,itog 
from applicant
order by program_id, itog DESC;

select * from applicant_order;
select * from applicant;

DROP table applicant;
select * from applicant;

-- Создать таблицу student,  в которую включить абитуриентов, которые могут быть рекомендованы к зачислению  в соответствии с планом набора. Информацию отсортировать сначала в алфавитном порядке по названию программ, а потом по убыванию итогового балла.
CREATE TABLE student
select name_program,name_enrollee,itog 
from program
join applicant_order USING(program_id)
join enrollee USING(enrollee_id)
WHERE applicant_order.str_id<=program.plan
order by name_program, itog DESC;

select * from student;


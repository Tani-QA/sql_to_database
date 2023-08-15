-- После того, как информация о книгах из таблицы supply перенесена в book , необходимо очистить таблицу  supply.
DELETE FROM supply;

SELECT * FROM supply;

-- Удалить из таблицы supply все книги, названия которых есть в таблице book
DELETE FROM supply 
WHERE title IN (
        SELECT title 
        FROM book
      );

SELECT * FROM supply;

-- Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.
DELETE FROM supply 
WHERE author IN (
        SELECT  author
        FROM book
        GROUP BY author 
        HAVING SUM(amount)>10
      );

SELECT * FROM supply;

-- Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года. 
DELETE FROM fine 
WHERE date_violation<'2020-02-01';

SELECT * FROM fine;

-- Удалим из таблицы author всех авторов, фамилия которых начинается на «Д», а из таблицы book  - все книги этих авторов.
-- В частности, ON DELETE CASCADE автоматически удаляет строки из зависимой таблицы при удалении  связанных строк в главной таблице.
-- В таблице book эта опция установлена для поля author_id.
DELETE FROM author
WHERE name_author LIKE "Д%";

SELECT * FROM author;
SELECT * FROM book;
-- Одним запросом удаляются связанные записи из главной и зависимой таблицы. В нашем случае удалился автор Достоевский и все его книги.

-- Удалить всех авторов и все их книги, общее количество книг которых меньше 20.
DELETE FROM author 
WHERE author.author_id IN (
SELECT book.author_id
FROM book 
    GROUP BY book.author_id
    HAVING SUM(book.amount)<20 
    );
    
-- Удалим из таблицы genre все  жанры, название которых заканчиваются на «я» , а в таблице book  -  для этих жанров установим значение Null.
DELETE FROM genre
WHERE name_genre LIKE "%я";

SELECT * FROM genre;
SELECT * FROM book;    

-- Удалить все жанры, к которым относится меньше 4-х наименований книг. В таблице book для этих жанров установить значение Null.
DELETE FROM genre
WHERE genre.genre_id IN (
SELECT book.genre_id
FROM book 
    GROUP BY book.genre_id
    HAVING COUNT(book.genre_id)<4 or HAVING COUNT(book.title)<4
    );

SELECT * FROM genre;
SELECT * FROM book;

-- Удалить всех авторов из таблицы author, у которых есть книги, количество экземпляров которых меньше 3. Из таблицы book удалить все книги этих авторов.
DELETE FROM author
USING 
    author 
    INNER JOIN book ON author.author_id = book.author_id
WHERE book.amount < 3;

SELECT * FROM author;
SELECT * FROM book;

-- Удалить всех авторов, которые пишут в жанре "Поэзия". Из таблицы book удалить все книги этих авторов. В запросе для отбора авторов использовать полное название жанра, а не его id.
DELETE FROM author
USING 
    author 
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON book.genre_id = genre.genre_id
    WHERE genre.name_genre LIKE "Поэзия";

SELECT * FROM author;
SELECT * FROM book;
-- or
DELETE FROM author
USING 
    author 
    INNER JOIN book ON author.author_id = book.author_id
WHERE genre_id = 
(SELECT genre_id
FROM genre
WHERE name_genre LIKE 'Поэзия');

SELECT * FROM author;
SELECT * FROM book;
-- or
DELETE FROM author 
WHERE author_id IN (SELECT author_id FROM book
                    JOIN genre USING(genre_id)
                    WHERE name_genre = "Поэзия"
                   );

-- Удалить из таблицы attempt все попытки, выполненные раньше 1 мая 2020 года. Также удалить и все соответствующие этим попыткам вопросы из таблицы testing, которая создавалась следующим запросом:
-- CREATE TABLE testing (
--     testing_id INT PRIMARY KEY AUTO_INCREMENT, 
--     attempt_id INT, 
--     question_id INT, 
--     answer_id INT,
--     FOREIGN KEY (attempt_id)  REFERENCES attempt (attempt_id) ON DELETE CASCADE
-- );
-- ON DELETE CASCADE - удалит в главной, и удалит в связанной

DELETE FROM attempt
WHERE date_attempt < '2020-05-01';

SELECT * FROM attempt;
SELECT * FROM testing;


-- Удалить из таблицы attempt все попытки студентов, касающиеся предмета "Основы SQL". В таблице  testing оставить только те вопросы, которые касаются предмета 'Основы SQL'. После удаления запрашиваемых строк - вывести на экран таблицы attempt и testing. 
DELETE 
FROM attempt
 -- в подзапросе определяем id предмета 'Основы SQL'
 WHERE subject_id = (SELECT subject_id
                     FROM subject
                     WHERE name_subject = 'Основы SQL');                  
SELECT * FROM attempt;
SELECT * FROM testing;

-- Из таблицы applicant, созданной на предыдущем шаге, удалить записи, если абитуриент на выбранную образовательную программу не набрал минимального балла хотя бы по одному предмету (использовать запрос из предыдущего урока).
select * from applicant;

-- //проверка выборки
select distinct program_id,enrollee.enrollee_id
from enrollee
 join program_enrollee USING(enrollee_id)
 join program USING(program_id) 
 join program_subject USING(program_id)
 join subject USING(subject_id)
 join enrollee_subject ON subject.subject_id = enrollee_subject.subject_id  and enrollee_subject.enrollee_id = enrollee.enrollee_id
 WHERE result < min_result
order by program_id ASC;

DELETE from applicant
WHERE (applicant.program_id,applicant.enrollee_id) IN
(
select distinct program_id,enrollee.enrollee_id
from enrollee
 join program_enrollee USING(enrollee_id)
 join program USING(program_id) 
 join program_subject USING(program_id)
 join subject USING(subject_id)
 join enrollee_subject ON subject.subject_id = enrollee_subject.subject_id  and enrollee_subject.enrollee_id = enrollee.enrollee_id
 WHERE result < min_result
order by program_id ASC
    );
select * from applicant;
-- OR
DELETE FROM applicant
USING
  applicant
  JOIN (
    SELECT program_enrollee.program_id, program_enrollee.enrollee_id 
    FROM program
    JOIN program_subject  USING(program_id)
    JOIN program_enrollee USING(program_id)
    JOIN enrollee_subject ON 
    enrollee_subject.enrollee_id = program_enrollee.enrollee_id AND
    enrollee_subject.subject_id = program_subject.subject_id
    WHERE result < min_result
 ) AS t
 ON applicant.program_id = t.program_id AND
    applicant.enrollee_id = t.enrollee_id;\
    

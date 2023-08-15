-- Уменьшить на 30% цену книг в таблице book
UPDATE book 
SET price = 0.7 * price;

SELECT * FROM book;

-- Уменьшить на 30% цену тех книг в таблице book, количество которых меньше 5.
UPDATE book 
SET price = 0.7 * price 
WHERE amount < 5;

SELECT * FROM book;

-- Уменьшить на 10% цену тех книг в таблице book, количество которых принадлежит интервалу от 5 до 10, включая границы.
UPDATE book 
SET price = 0.9 * price 
WHERE amount IN(5,10);

SELECT * FROM book;

-- В столбце buy покупатель указывает количество книг, которые он хочет приобрести. Для каждой книги, выбранной покупателем, необходимо уменьшить ее количество на складе на указанное в столбцеbuy количество, а в столбец buy занести 0.
UPDATE book 
SET amount = amount - buy,
    buy = 0;

SELECT * FROM book;

-- В таблице book необходимо скорректировать значение для покупателя в столбце buy таким образом, чтобы оно не превышало количество экземпляров книг, указанных в столбце amount. А цену тех книг, которые покупатель не заказывал, снизить на 10%.
UPDATE book 
SET buy = IF(buy>amount, amount, buy),
    price = IF(buy=0, price*0.9, price);

SELECT * FROM book;

-- Если в таблице supply  есть те же книги, что и в таблице book, добавлять эти книги в таблицу book не имеет смысла. Необходимо увеличить их количество на значение столбца amountтаблицы supply.
UPDATE book, supply 
SET book.amount = book.amount + supply.amount
WHERE book.title = supply.title AND book.author = supply.author;

SELECT * FROM book;


-- Для тех книг в таблице book , которые есть в таблице supply, не только увеличить их количество в таблице book ( увеличить их количество на значение столбца amountтаблицы supply), но и пересчитать их цену (для каждой книги найти сумму цен из таблиц book и supply и разделить на 2).
UPDATE book, supply 
SET book.amount = book.amount + supply.amount,
    book.price=(book.price+supply.price)/2
WHERE book.title = supply.title AND book.author = supply.author;

SELECT * FROM book;

-- Делаем скидку 5% на самое большое количество экземпляров книг (Стихи Есенина), чтобы поскорее расходились.
UPDATE book SET price = round(price*0.95,2)
WHERE author = 'Есенин С.А.' AND amount IN (SELECT * FROM (SELECT max(amount) FROM book WHERE author = 'Есенин С.А.') AS p);

-- Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. При этом суммы заносить только в пустые поля столбца  sum_fine.
UPDATE fine f, traffic_violation tv
SET f.sum_fine=tv.sum_fine
WHERE  f.violation=tv.violation and f.sum_fine IS Null;

SELECT * FROM fine;


-- В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей. 
UPDATE fine, 
(SELECT query_in.name, query_in.number_plate, query_in.violation
FROM fine AS query_in
GROUP BY query_in.name, query_in.number_plate, query_in.violation
HAVING COUNT(query_in.violation) >=2
ORDER BY query_in.name,query_in.number_plate,query_in.violation) query_in
SET sum_fine = sum_fine*2
WHERE date_payment is null AND fine.name=query_in.name AND  fine.number_plate=query_in.number_plate AND fine.violation=query_in.violation;

SELECT * FROM fine;

-- Водители оплачивают свои штрафы. В таблице payment занесены даты их оплаты:
-- Необходимо:
-- в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
-- уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в таблицу payment) , если оплата произведена не позднее 20 дней со дня нарушения.
UPDATE fine f, payment p
SET 
f.date_payment = p.date_payment,
f.sum_fine = IF(DATEDIFF(p.date_payment,p.date_violation)<=20, f.sum_fine/2, f.sum_fine)
WHERE (f.name, f.number_plate, f.violation) =  (p.name, p.number_plate, p.violation) AND f.date_payment IS NULL;

SELECT * FROM fine;

-- Запросы на обновление, связанные таблицы
-- Для книг, которые уже есть на складе (в таблице book) по той же цене, что и в поставке (supply), увеличить количество на значение, указанное в поставке, а также обнулить количество этих книг в поставке.
UPDATE book 
     INNER JOIN author ON author.author_id = book.author_id
     INNER JOIN supply ON book.title = supply.title 
                         and supply.author = author.name_author
SET book.amount = book.amount + supply.amount,
    supply.amount = 0   
WHERE book.price = supply.price;

SELECT * FROM book;
SELECT * FROM supply;


-- Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке (supply),  необходимо в таблице book увеличить количество на значение, указанное в поставке,  и пересчитать цену. А в таблице  supply обнулить количество этих книг. Формула для пересчета цены:
-- price= (p1*k1+p2*k2)/k1+k2
-- где  p1, p2 - цена книги в таблицах book и supply;
--        k1, k2 - количество книг в таблицах book и supply.
-- Пересчитываться должна цена только одной книги Достоевского «Идиот», для этой же книги увеличится количество в таблице book и обнулится количество в таблице supply.
UPDATE book 
     INNER JOIN author ON author.author_id = book.author_id
     INNER JOIN supply ON book.title = supply.title 
                         and supply.author = author.name_author
SET book.price = (((book.price*book.amount)+(supply.price*supply.amount))/(book.amount+supply.amount)),
    book.amount = book.amount + supply.amount,
    supply.amount = 0   
WHERE book.price != supply.price;

SELECT * FROM book;
SELECT * FROM supply;

-- После того, как новые книги добавлены в таблицу book, нужно указать к какому жанру они относятся. Для этого используется запрос на обновление, в котором можно указать значения столбцов из других таблиц, либо использовать вложенные запросы для получения этих значений.
UPDATE book
SET genre_id = 1
WHERE book_id = 9;

SELECT * FROM book;

-- Более сложным будет запрос, если известно только название жанра (результат будет точно таким же):
UPDATE book
SET genre_id = 
      (
       SELECT genre_id 
       FROM genre 
       WHERE name_genre = 'Роман'
      )
WHERE book_id = 9;

SELECT * FROM book;

-- Занести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия», а для книги «Остров сокровищ» Стивенсона - «Приключения». (Использовать два запроса).
UPDATE book
SET genre_id = 
      (
       SELECT genre_id 
       FROM genre 
       WHERE name_genre = 'Поэзия'
      )
WHERE title='Стихотворения и поэмы' AND author_id=5;

UPDATE book
SET genre_id = 
      (
       SELECT genre_id 
       FROM genre 
       WHERE name_genre = 'Приключения'
      )
WHERE title='Остров сокровищ' AND author_id=6;

SELECT * FROM book;
-- or
UPDATE book
SET genre_id = (SELECT genre_id FROM genre
                WHERE name_genre = 'Поэзия')
WHERE title = 'Стихотворения и поэмы' AND author_id = (SELECT author_id FROM author 
                                                       WHERE name_author LIKE 'Лермонтов%');

UPDATE book
SET genre_id = (SELECT genre_id FROM genre
                WHERE name_genre = 'Приключения')
WHERE title = 'Остров сокровищ' AND author_id = (SELECT author_id FROM author 
                                                 WHERE name_author LIKE 'Стивенсон%');

SELECT * FROM book;

-- Количество тех книг на складе, которые были включены в заказ с номером 5, уменьшить на то количество, которое в заказе с номером 5  указано.
UPDATE book, buy_book
SET    book.amount = book.amount - buy_book.amount
WHERE  buy_book.buy_id = 5 AND book.book_id = buy_book.book_id;
SELECT * FROM book;
-- Через INNER JOIN
UPDATE book b INNER JOIN buy_book bb ON b.book_id = bb.book_id
SET b.amount = b.amount - bb.amount
WHERE bb.buy_id = 5;

-- В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5.
-- Правильнее было бы занести не конкретную, а текущую дату. Это можно сделать с помощью функции Now(). Но при этом в разные дни будут вставляться разная дата, и задание нельзя будет проверить, поэтому  вставим дату 12.04.2020.
UPDATE  buy_step,step
SET    date_step_beg='2020-04-12'
WHERE  buy_step.buy_id = 5 AND step.step_id=buy_step.step_id AND step.name_step='Оплата';
SELECT * FROM buy_step;

-- Завершить этап «Оплата» для заказа с номером 5, вставив в столбец date_step_end дату 13.04.2020, и начать следующий этап («Упаковка»), задав в столбце date_step_beg для этого этапа ту же дату.
-- Реализовать два запроса для завершения этапа и начала следующего. Они должны быть записаны в общем виде, чтобы его можно было применять для любых этапов, изменив только текущий этап. Для примера пусть это будет этап «Оплата».
UPDATE  buy_step,step
SET    date_step_end='2020-04-13'
WHERE  buy_step.buy_id = 5 AND step.step_id=buy_step.step_id AND step.name_step='Оплата' AND date_step_beg IS NOT NULL;

SELECT * FROM buy_step;

UPDATE  buy_step,step
SET    date_step_beg='2020-04-13'
WHERE  buy_step.buy_id = 5 AND buy_step.step_id=
(SELECT step.step_id + 1 
FROM step
WHERE step.name_step = 'Оплата'
);

SELECT * FROM buy_step;

-- Студент прошел тестирование (то есть все его ответы занесены в таблицу testing), далее необходимо вычислить результат(запрос) и занести его в таблицу attempt для соответствующей попытки.  Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до целого.
-- Будем считать, что мы знаем id попытки,  для которой вычисляется результат, в нашем случае это 8. В таблицу testing занесены следующие ответы пользователя:
UPDATE attempt
    SET result = (SELECT ROUND((SUM(is_correct)/3)*100, 2)
        FROM answer INNER JOIN testing ON answer.answer_id = testing.answer_id
        WHERE testing.attempt_id = 8)
    WHERE attempt.attempt_id = 8;

SELECT * FROM attempt;

-- Повысить итоговые баллы абитуриентов в таблице applicant на значения дополнительных баллов (использовать запрос из предыдущего урока).
select enrollee_id , IF(SUM(bonus) IS NULL, 0,SUM(bonus)) AS Бонус                    
from enrollee
left join enrollee_achievement USING(enrollee_id)
left join achievement USING(achievement_id)
GROUP BY enrollee_id
order by enrollee_id ;

select * from applicant;

UPDATE applicant JOIN (
    SELECT enrollee_id, IFNULL(SUM(bonus), 0) AS Бонус FROM enrollee_achievement
    LEFT JOIN achievement USING(achievement_id)
    GROUP BY enrollee_id 
    ) AS t USING(enrollee_id)
SET itog = itog + Бонус;
    
select * from applicant;
-- or
UPDATE applicant
JOIN
-- собрали и сджойнили вложенный запрос query_in с суммой бонусов с группировкой по абитуриентам
  (SELECT enrollee_id,
          SUM(bonus) AS sum_bonus
   FROM achievement
   JOIN enrollee_achievement USING(achievement_id)
   GROUP BY enrollee_id) AS query_in 
-- изменили строку итог на сумму итог + результат вложенного запроса
SET itog = itog + query_in.sum_bonus
-- с условием равности по абитуриентам 
WHERE applicant.enrollee_id = query_in.enrollee_id;

SELECT * FROM applicant;
-- or
UPDATE applicant
       INNER JOIN enrollee_achievement USING(enrollee_id)
SET itog = itog + (SELECT SUM(bonus)
                   FROM achievement
                        INNER JOIN enrollee_achievement ON achievement.achievement_id = enrollee_achievement.achievement_id AND applicant.enrollee_id = enrollee_achievement.enrollee_id);

SELECT * FROM applicant;
-- or
UPDATE applicant
       INNER JOIN (SELECT enrollee_id,SUM(IF(achievement_id IS NULL,0,bonus)) AS super_um FROM enrollee    LEFT JOIN enrollee_achievement USING (enrollee_id)      LEFT JOIN achievement USING (achievement_id) GROUP BY enrollee_id) AS Bonus
USING (enrollee_id)
SET itog=itog+super_um;
SELECT *FROM applicant;


-- выбрать все поля
SELECT * FROM book;

-- выбрать определенные столбцы
SELECT author,title, price FROM book;

-- присвоить полям новые имена
SELECT title AS Название, author AS Автор 
FROM book;

-- вычисление в столбце
SELECT title, amount, amount*1.65 AS pack
FROM book;

-- вычислить цену с учетом скидки 30%
SELECT title, author, amount,
ROUND (price-(price*30/100),2) AS new_price //классическое округление до 2х знаков
FROM book;
-- or
SELECT title, author, amount,
ROUND (price *0.7, 2) AS new_price
FROM book;

-- вычислить ндс с цены
SELECT title, price, 
    (price*18/100)/(1+18/100) AS tax, 
    price/(1+18/100) AS price_tax 
FROM book;

-- Для каждой книги из таблицы book установим скидку следующим образом: если количество книг меньше 4, то скидка будет составлять 50% от цены, в противном случае 30%.
SELECT title, amount, price, 
    IF(amount<4, price*0.5, price*0.7) AS sale
FROM book;

-- Если количество книг меньше 4 – то скидка 50%, меньше 11 – 30%, в остальных случаях – 10%. И еще укажем какая именно скидка на каждую книгу.
SELECT title, amount, price,
    ROUND(IF(amount < 4, price * 0.5, IF(amount < 11, price * 0.7, price * 0.9)), 2) AS sale,
    IF(amount < 4, 'скидка 50%', IF(amount < 11, 'скидка 30%', 'скидка 10%')) AS Ваша_скидка
FROM book;


-- Исходя из этого решили поднять цену книг Булгакова на 10%, а цену книг Есенина - на 5%. Написать запрос, куда включить автора, название книги и новую цену, последний столбец назвать new_price. Значение округлить до двух знаков после запятой.
SELECT author,title,
    ROUND(IF(author = "Булгаков М.А.", price * 1.1, IF(author = "Есенин С.А.", price * 1.05, price)), 2) AS new_price
FROM book;

-- Вывести название и цену тех книг, цены которых меньше 600 рублей.
SELECT title, price 
FROM book
WHERE price < 600;

-- Вывести название, автора  и стоимость (цена умножить на количество) тех книг, стоимость которых больше 4000 рублей
SELECT title, author, price * amount AS total
FROM book
WHERE price * amount > 4000;

-- Вывести автора, название  и цены тех книг, количество которых меньше 10.
SELECT author,title,  price
FROM book
WHERE amount < 10;

-- Вывести название, автора и цену тех книг, которые написал Булгаков, ценой больше 600 рублей
SELECT title, author, price 
FROM book
WHERE price > 600 AND author = 'Булгаков М.А.';

-- Вывести название, цену  тех книг, которые написал Булгаков или Есенин, ценой больше 600 рублей
SELECT title, author, price 
FROM book
WHERE (author = 'Булгаков М.А.' OR author = 'Есенин С.А.') AND price > 600;

-- В данном запросе обязательно нужно поставить скобки, так как без них сначала вычисляется  author = 'Есенин С.А.' and price > 600, а потом уже выражение через or. Без скобок были бы отобраны все книги Булгакова и те книги Есенина, цена которых больше 600.
SELECT title, author, price 
FROM book
WHERE author = 'Булгаков М.А.' OR author = 'Есенин С.А.' AND price > 600;

-- Вывести название, автора,  цену  и количество всех книг, цена которых меньше 500 или больше 600, а стоимость всех экземпляров этих книг больше или равна 5000.
SELECT title, author, price, amount 
FROM book
WHERE (price<500 OR price>600) AND price*amount >= 5000;

-- Выбрать названия и количества тех книг, количество которых от 5 до 14 включительно.
SELECT title, amount 
FROM book
WHERE amount BETWEEN 5 AND 14;

SELECT title, amount 
FROM book
WHERE amount >= 5 AND amount <=14;

-- Выбрать названия и цены книг, написанных Булгаковым или Достоевским.
SELECT title, price 
FROM book
WHERE author IN ('Булгаков М.А.', 'Достоевский Ф.М.');

SELECT title, price 
FROM book
WHERE author = 'Булгаков М.А.' OR author = 'Достоевский Ф.М.';

-- Вывести название и авторов тех книг, цены которых принадлежат интервалу от 540.50 до 800 (включая границы),  а количество или 2, или 3, или 5, или 7 .
SELECT title, author 
FROM book
WHERE (price BETWEEN 540.50 AND 800) AND amount IN(2,3,5,7);

-- Вывести название, автора и цены книг. Информацию  отсортировать по названиям книг в алфавитном порядке.
SELECT title, author, price
FROM book
ORDER BY title;


-- Вывести автора, название и количество книг, в отсортированном в алфавитном порядке по автору и по убыванию количества, для тех книг, цены которых меньше 750 рублей.
SELECT author, title, amount AS Количество
FROM book
WHERE price < 750
ORDER BY author, amount DESC;

SELECT author, title, amount AS Количество
FROM book
WHERE price < 750
ORDER BY author, Количество DESC;

SELECT author, title, amount AS Количество
FROM book
WHERE price < 750
ORDER BY 1, 3 DESC;

-- Вывести  автора и название  книг, количество которых принадлежит интервалу от 2 до 14 (включая границы). Информацию  отсортировать сначала по авторам (в обратном алфавитном порядке), а затем по названиям книг (по алфавиту).
SELECT author, title
FROM book
WHERE amount BETWEEN 2 AND 14
ORDER BY author DESC, title;


-- Вывести названия книг, начинающихся с буквы «Б».
SELECT title 
FROM book
WHERE title LIKE 'Б%';
/* эквивалентное условие 
title LIKE 'б%'
*/

-- Вывести название книг, состоящих ровно из 5 букв.
SELECT title FROM book 
WHERE title LIKE "_____";


-- Вывести книги, название которых длиннее 5 символов:
SELECT title FROM book 
WHERE title LIKE "______%";
/* эквивалентные условия 
title LIKE "%______"
title LIKE "%______%"
*/

-- Вывести названия книг, которые содержат букву "и" как отдельное слово, если считать, что слова в названии отделяются друг от друга пробелами и не содержат знаков препинания.
SELECT title FROM book 
WHERE   title LIKE "_% и _%" /*отбирает слово И внутри названия */
    OR title LIKE "и _%" /*отбирает слово И в начале названия */
    OR title LIKE "_% и" /*отбирает слово И в конце названия */
    OR title LIKE "и"; /* отбирает название, состоящее из одного слова И */
    
-- Вывести названия книг, которые состоят ровно из одного слова, если считать, что слова в названии отделяются друг от друга пробелами .
SELECT title FROM book 
WHERE title NOT LIKE "% %";

-- Вывести название и автора тех книг, название которых состоит из двух и более слов, а инициалы автора содержат букву «С». Считать, что в названии слова отделяются друг от друга пробелами и не содержат знаков препинания, между фамилией автора и инициалами обязателен пробел, инициалы записываются без пробела в формате: буква, точка, буква, точка. Информацию отсортировать по названию книги в алфавитном порядке.
SELECT title,author      
FROM book 
WHERE (title LIKE "_% %" OR title LIKE "_% % %") AND (author LIKE "%С.%" OR author LIKE "%.С%")
ORDER BY title; 


-- Магазин счёл, что классика уже не пользуется популярностью, поэтому необходимо в выборке:
-- 1. Сменить всех авторов на "Донцова Дарья".
-- 2. К названию каждой книги в начале дописать "Евлампия Романова и".
-- 3. Цену поднять на 42%.
-- 4. Отсортировать по убыванию цены и убыванию названия.
SELECT 
    "Донцова Дарья" AS author, 
    CONCAT("Евлампия Романова и ", title) AS title, 
    round((price * 1.42),2) AS price
FROM book
ORDER BY 3 DESC, 2 DESC;

SELECT author, 'Донцова Дарья'AS author, CONCAT_WS(' ', 'Евлампия романова и', title) AS title, ROUND(price*1.42,2) AS price
FROM book
ORDER BY author DESC, price DESC;

-- В магазине книг решили организовать акцию: при заказе одной книги любого из трех авторов покупатель получает подарок:
-- If это Булгаков М.А. - спички
-- If это Достоевский Ф.М. - топор
-- If это Есенин С.А. - веревка и мыло
-- Данные о подарках отражены в колонке gift.
SELECT Title,author,price,amount,
IF(author = 'Булгаков М.А.','Опиум', IF(author='Достоевский Ф.М.','Топор','Мыло и веревка')) as Gift
from book;

-- В связи с повышенным спросом на классическую литературу школьниками в формате "А есть то же самое, но покороче, чтобы читать поменьше?" была выпущена серия "Графоман и. Краткое содержание".
-- В выборке 
-- к имени автора добавить "Графоман и "
-- к названию книги дописать ". Краткое содержание."
-- цену на новый опус установить 40% от цены оригинала, но не более 250. (Если 40% больше 250, то цена должна быть 250)
-- в зависимости от остатка на складе вывести "Спрос": до 3 - высокий, до 10 - средний, иначе низкий.
-- добавить колонку "Наличие" в зависимости от кол-ва: 1-2 шт - очень мало, 3-14 - в наличии, 15 и больше - много
-- отсортировать по цене по возрастанию, затем по Спросу от низкого к высокому
SELECT CONCAT ('Графоман и ', author) AS Автор, 
       CONCAT (title, '. Краткое содержание') AS Название, 
       ROUND (IF (price*0.4>250, 250, price*0.4),2) AS Цена,
       IF (amount<3, 'Высокий', IF (amount<10, 'Средний', 'Низкий')) AS Спрос,
       IF (amount BETWEEN 1 AND 2, 'очень мало', IF (amount BETWEEN 3 AND 14, 'в наличии', 'много')) AS Наличие 
from book 
ORDER BY Цена, Спрос DESC;

-- Выбрать различных (уник) авторов, книги которых хранятся в таблице book.
SELECT DISTINCT author
FROM book;

SELECT  author
FROM book
GROUP BY author;

-- Выборка данных, групповые функции SUM и COUNT
SELECT author, sum(amount), count(amount)
FROM book
GROUP BY author;

-- Посчитать, сколько экземпляров книг каждого автора хранится на складе.
SELECT author, SUM(amount)
FROM book
GROUP BY author;

-- Посчитать, сколько различных книг каждого автора хранится на складе.
/* чтобы проверить запрос, добавьте в таблицу строку */
INSERT INTO book (title, author, price, amount) VALUES ('Черный человек','Есенин С.А.', Null, Null);

SELECT author, COUNT(author), COUNT(amount), COUNT(*)
FROM book
GROUP BY author;

-- Посчитать, количество различных книг и количество экземпляров книг каждого автора , хранящихся на складе.  Столбцы назвать Автор, Различных_книг и Количество_экземпляров соответственно.
SELECT author As Автор, COUNT(title) As Различных_книг, SUM(amount) AS Количество_экземпляров
FROM book
GROUP BY Автор;

-- Вывести минимальную цену книги каждого автора
SELECT author, MIN(price) AS min_price
FROM book
GROUP BY author;

-- Вывести фамилию и инициалы автора, минимальную, максимальную и среднюю цену книг каждого автора . Вычисляемые столбцы назвать Минимальная_цена, Максимальная_цена и Средняя_цена соответственно.
SELECT author, MIN(price) AS Минимальная_цена, MAX(price) AS Максимальная_цена,AVG(price) AS Средняя_цена
FROM book
GROUP BY author;

-- Вывести суммарную стоимость книг каждого автора.
SELECT author, SUM(price * amount) AS Стоимость
FROM book
GROUP BY author;

-- Найти среднюю цену книг каждого автора.
SELECT author, ROUND(AVG(price),2) AS Средняя_цена
FROM book
GROUP BY author;

-- Для каждого автора вычислить суммарную стоимость книг S (имя столбца Стоимость), а также вычислить налог на добавленную стоимость  для полученных сумм (имя столбца НДС ) , который включен в стоимость и составляет k = 18%,  а также стоимость книг  (Стоимость_без_НДС) без него. Значения округлить до двух знаков после запятой. В запросе для расчета НДС(tax)  и Стоимости без НДС(S_without_tax) использовать следующие формулы:
SELECT author, 
SUM(price*amount) AS Стоимость, 
ROUND(((SUM(price*amount)*18/100)/(1+18/100)),2) AS НДС, 
ROUND((SUM(price*amount)/(1+18/100)),2) AS Стоимость_без_НДС
FROM book
GROUP BY author;

SELECT author, 
SUM(price*amount) AS Стоимость, 
ROUND((SUM(price*amount)-(SUM(price*amount)/1.18)),2) AS НДС, 
ROUND((SUM(price*amount)-(SUM(price*amount)-(SUM(price*amount)/1.18))),2) AS Стоимость_без_НДС
FROM book
GROUP BY author;

-- Посчитать количество экземпляров книг на складе.
SELECT SUM(amount) AS Количество
FROM book;

-- Посчитать общее количество экземпляров книг на складе и их стоимость .
SELECT SUM(amount) AS Количество, 
    SUM(price * amount) AS Стоимость
FROM book;

-- Вывести  цену самой дешевой книги, цену самой дорогой и среднюю цену уникальных книг на складе. Названия столбцов Минимальная_цена, Максимальная_цена, Средняя_цена соответственно. Среднюю цену округлить до двух знаков после запятой.
SELECT MIN(price) AS Минимальная_цена, Max(price) AS Максимальная_цена, 
ROUND(AVG(DISTINCT(price)),2) AS Средняя_цена 
FROM book;

-- Найти минимальную и максимальную цену книг всех авторов, общая стоимость книг которых больше 5000.
SELECT author,
    MIN(price) AS Минимальная_цена, 
    MAX(price) AS Максимальная_цена
FROM book
GROUP BY author
HAVING SUM(price * amount) > 5000; 

-- Найти минимальную и максимальную цену книг всех авторов, общая стоимость книг которых больше 5000. Результат вывести по убыванию минимальной цены.
SELECT author,
    MIN(price) AS Минимальная_цена, 
    MAX(price) AS Максимальная_цена
FROM book
GROUP BY author
HAVING SUM(price * amount) > 5000 
ORDER BY Минимальная_цена DESC;

-- Вычислить среднюю цену и суммарную стоимость тех книг, количество экземпляров которых принадлежит интервалу от 5 до 14, включительно. Столбцы назвать Средняя_цена и Стоимость, значения округлить до 2-х знаков после запятой.
SELECT 
    ROUND(AVG(price),2) AS Средняя_цена, 
    ROUND((SUM(price*amount)),2) AS Стоимость
FROM book
WHERE amount BETWEEN 5 AND 14;

-- Вывести максимальную и минимальную цену книг каждого автора, кроме Есенина, количество экземпляров книг которого больше 10. 
SELECT author,MIN(price) AS Минимальная_цена,MAX(price) AS Максимальная_цена
FROM book
WHERE author NOT LIKE "%Есенин С.А.%"
GROUP BY author
HAVING SUM(amount)>10;

SELECT author,
    MIN(price) AS Минимальная_цена,
    MAX(price) AS Максимальная_цена
FROM book
WHERE author <> 'Есенин С.А.'
GROUP BY author
HAVING SUM(amount) > 10;

-- Не смотря на то что результат будет одинаковым, так делать не рекомендуется:
SELECT author,MIN(price) AS Минимальная_цена,MAX(price) AS Максимальная_цена
FROM book
GROUP BY author
HAVING SUM(amount)>10 AND author NOT LIKE "%Есенин С.А.%";

SELECT author,
    MIN(price) AS Минимальная_цена,
    MAX(price) AS Максимальная_цена
FROM book
GROUP BY author
HAVING SUM(amount) > 10 AND author <> 'Есенин С.А.';


-- Посчитать стоимость всех экземпляров каждого автора без учета книг «Идиот» и «Белая гвардия». В результат включить только тех авторов, у которых суммарная стоимость книг (без учета книг «Идиот» и «Белая гвардия») более 5000 руб. Вычисляемый столбец назвать Стоимость. Результат отсортировать по убыванию стоимости.
SELECT author, SUM(price*amount) AS Стоимость
FROM book
WHERE title <> 'Идиот' AND title <> 'Белая гвардия'
GROUP BY author
HAVING SUM(price*amount)>5000
ORDER BY Стоимость DESC;

-- Узнать сколько авторов, у которых есть книги со стоимостью более 500 и количеством более 1 шт на складе, при количестве различных названий произведений не менее 2-х. Вывести автора, количество различных произведений автора, минимальную цену и количество книг на складе.
SELECT author,
        COUNT(title) AS Количество_произведений,
        MIN(price) AS Минимальная_цена,
        SUM(amount) AS Число_книг
FROM book
WHERE price > 500 AND amount > 1
GROUP BY author
HAVING COUNT(title) > 1;

SELECT author, COUNT(title) as Количество_произведений, MIN(price) as Минимальная_цена, SUM(amount) as Число_книг
FROM book
WHERE author IN
            (SELECT author FROM book 
             WHERE price > 500 AND amount > 1 
             GROUP BY author)
GROUP BY author
HAVING COUNT(DISTINCT title) > 1;

SELECT author,
    COUNT(DISTINCT(title)) AS Количество_произведений,
    MIN(price) AS Минимальная_цена,
    SUM(amount) AS Число_книг
FROM book
WHERE price > 500 AND amount > 1
GROUP BY author 
HAVING COUNT(DISTINCT title) > 1;

SELECT author,
        COUNT(title) AS Количество_произведений,
        MIN(price) AS Минимальная_цена,
        SUM(amount) AS Число_книг
  FROM  book
 WHERE  price > 500 AND amount > 1
 GROUP BY author
HAVING  COUNT(title) >= 2;

-- Вывести информацию о самых дешевых книгах, хранящихся на складе.
SELECT title, author, price, amount
FROM book
WHERE price = (
         SELECT MIN(price) 
         FROM book
      );
-- Вложенный запрос определяет минимальную цену книг во всей таблице (это 460.00), а затем в основном запросе для каждой записи проверяется, равна ли цена минимальному значению, если равна, информация о книге включается в результирующую таблицу запроса.


-- Вывести информацию (автора, название и цену) о  книгах, цены которых меньше или равны средней цене книг на складе. Информацию вывести в отсортированном по убыванию цены виде. Среднее вычислить как среднее по цене книги.
SELECT author, title, price
FROM book
WHERE price <= (
         SELECT AVG(price) 
         FROM book
      )
ORDER BY price DESC;


-- Вывести информацию о книгах, количество экземпляров которых отличается от среднего количества экземпляров книг на складе более чем на 3. То есть нужно вывести и те книги, количество экземпляров которых меньше среднего на 3, или больше среднего на 3.
-- ABS - absolute - абсолютная величина(или простыми словами модуль)
SELECT title, author, amount 
FROM book
WHERE ABS(amount - (SELECT AVG(amount) FROM book)) >3;

-- Вывести информацию (автора, название и цену) о тех книгах, цены которых превышают минимальную цену книги на складе не более чем на 150 рублей в отсортированном по возрастанию цены виде.
SELECT  author,title, price 
FROM book
WHERE (price - (SELECT MIN(price) FROM book)) <=150
ORDER BY price;

-- Вывести информацию о книгах тех авторов, общее количество экземпляров книг которых не менее 12.
SELECT title, author, amount, price
FROM book
WHERE author IN (
        SELECT author 
        FROM book 
        GROUP BY author 
        HAVING SUM(amount) >= 12
      );
-- Вложенный запрос отбирает двух авторов (Достоевского и Есенина). А в основном запросе для каждой записи таблицы book  проверяется, входит ли автор книги в отобранный список, если входит - информация о книге включается в запрос.


-- Вывести информацию (автора, книгу и количество) о тех книгах, количество экземпляров которых в таблице book не дублируется.
SELECT  author,title, amount
FROM book
WHERE amount IN (
    SELECT amount
    FROM book
    GROUP BY amount
    HAVING COUNT(amount)=1
    );
    
-- Вывести информацию о тех книгах, количество которых меньше самого маленького среднего количества книг каждого автора.
SELECT title, author, amount, price
FROM book
WHERE amount < ALL (
        SELECT AVG(amount) 
        FROM book 
        GROUP BY author 
      ); 
      

-- Вывести информацию о книгах(автор, название, цена), цена которых меньше самой большой из минимальных цен, вычисленных для каждого автора.
SELECT  author, title, price
FROM book
WHERE price < ANY (
        SELECT MIN(price) 
        FROM book 
        GROUP BY author
);   

-- Вывести информацию о книгах, количество экземпляров которых отличается от среднего количества экземпляров книг на складе более чем на 3,  а также указать среднее значение количества экземпляров книг.
SELECT title, author, amount, 
    (
     SELECT AVG(amount) 
     FROM book
    ) AS Среднее_количество 
FROM book
WHERE abs(amount - (SELECT AVG(amount) FROM book)) >3;

SELECT title, author, amount, 
      FLOOR((SELECT AVG(amount) FROM book)) AS Среднее_количество 
FROM book
WHERE ABS(amount - (SELECT AVG(amount) FROM book)) >3;   

-- Посчитать сколько и каких экземпляров книг нужно заказать поставщикам, чтобы на складе стало одинаковое количество экземпляров каждой книги, равное значению самого большего количества экземпляров одной книги на складе. Вывести название книги, ее автора, текущее количество экземпляров на складе и количество заказываемых экземпляров книг. Последнему столбцу присвоить имя Заказ. В результат не включать книги, которые заказывать не нужно.
SELECT title, author, amount, 
ABS(amount - (SELECT MAX(amount) FROM book))AS 'Заказ'
FROM book
WHERE ABS(amount - (SELECT MAX(amount) FROM book)) >0;

-- Можно посмотреть, при продаже всех книг, какая книга принесет больше всего выручки, в процентах.
SELECT *, round((100*price*amount/(SELECT SUM(price*amount) FROM book)), 2) AS income_percent
FROM book
ORDER BY income_percent DESC;


-- Вывести из таблицы trip информацию о командировках тех сотрудников, фамилия которых заканчивается на букву «а», в отсортированном по убыванию даты последнего дня командировки виде. В результат включить столбцы name, city, per_diem, date_first, date_last.
SELECT name, city, per_diem, date_first, date_last
FROM trip
WHERE name LIKE '%а %'
ORDER BY date_last DESC;

--
SELECT DISTINCT(name)
FROM trip
WHERE city IN ('Москва');

-- Для каждого города посчитать, сколько раз сотрудники в нем были.  Информацию вывести в отсортированном в алфавитном порядке по названию городов. Вычисляемый столбец назвать Количество. 
SELECT city, COUNT(city) AS Количество
FROM trip
GROUP BY city
ORDER BY city;

-- Вывести информацию о первой  командировке из таблицы trip. "Первой" считать командировку с самой ранней датой начала.
SELECT *
FROM trip
ORDER BY  date_first
LIMIT 1;

-- Вывести два города, в которых чаще всего были в командировках сотрудники. Вычисляемый столбец назвать Количество.
SELECT city, COUNT(city) AS Количество
FROM trip
GROUP BY city
ORDER BY Количество DESC
LIMIT 2;

-- Вывести информацию о командировках во все города кроме Москвы и Санкт-Петербурга (фамилии и инициалы сотрудников, город ,  длительность командировки в днях, при этом первый и последний день относится к периоду командировки). Последний столбец назвать Длительность. Информацию вывести в упорядоченном по убыванию длительности поездки, а потом по убыванию названий городов (в обратном алфавитном порядке).
SELECT name,city, DATEDIFF(date_last, date_first)+1 AS Длительность
FROM trip
WHERE city NOT IN ('Москва','Санкт-Петербург')
ORDER BY Длительность DESC, city DESC;

-- Вывести информацию о командировках сотрудника(ов), которые были самыми короткими по времени. В результат включить столбцы name, city, date_first, date_last.
SELECT name,city, date_first, date_last
FROM trip
WHERE DATEDIFF(date_last, date_first)+1 = (SELECT  MIN((DATEDIFF(date_last, date_first)+1)) FROM trip);

-- Вывести информацию о командировках, начало и конец которых относятся к одному месяцу (год может быть любой). В результат включить столбцы name, city, date_first, date_last. Строки отсортировать сначала  в алфавитном порядке по названию города, а затем по фамилии сотрудника .
SELECT name,city, date_first, date_last
FROM trip
WHERE MONTH(date_first) = MONTH(date_last)
ORDER BY city, name;

-- Вывести название месяца и количество командировок для каждого месяца. Считаем, что командировка относится к некоторому месяцу, если она началась в этом месяце. Информацию вывести сначала в отсортированном по убыванию количества, а потом в алфавитном порядке по названию месяца виде. Название столбцов – Месяц и Количество.
SELECT MONTHNAME(date_first) AS Месяц, COUNT(MONTHNAME(date_first)) AS Количество
FROM trip
GROUP BY Месяц
ORDER BY Количество DESC, Месяц;

SELECT MONTHNAME(date_first) AS Месяц, COUNT(MONTHNAME(date_first)) AS Количество
FROM trip
GROUP BY Месяц
ORDER BY COUNT(MONTHNAME(date_first)) DESC, MONTHNAME(date_first) ASC;

SELECT MONTHNAME(date_first) AS Месяц, COUNT(MONTHNAME(date_first)) AS Количество
FROM trip
GROUP BY Месяц
ORDER BY 2 desc, 1;

SELECT MONTHNAME(date_first) AS Месяц, COUNT(MONTHNAME(date_first)) AS Количество
FROM trip
GROUP BY Месяц
order by count(monthname(date_first)) desc;

-- Вывести сумму суточных (произведение количества дней командировки и размера суточных) для командировок, первый день которых пришелся на февраль или март 2020 года. Значение суточных для каждой командировки занесено в столбец per_diem. Вывести фамилию и инициалы сотрудника, город, первый день командировки и сумму суточных. Последний столбец назвать Сумма. Информацию отсортировать сначала  в алфавитном порядке по фамилиям сотрудников, а затем по убыванию суммы суточных.
SELECT name, city, date_first,  (DATEDIFF(date_last, date_first)+1)*per_diem AS Сумма
FROM trip
WHERE MONTHNAME(date_first) IN ('February', 'March')
ORDER BY name, Сумма DESC;

-- Вывести фамилию с инициалами и общую сумму суточных, полученных за все командировки для тех сотрудников, которые были в командировках больше чем 3 раза, в отсортированном по убыванию сумм суточных виде. Последний столбец назвать Сумма.
SELECT name, SUM((DATEDIFF(date_last, date_first)+1)*per_diem) AS Сумма
FROM trip
GROUP BY name
HAVING COUNT(name)>3
ORDER BY Сумма DESC;

-- Для тех, кто уже оплатил штраф, вывести информацию о том, изменялась ли стандартная сумма штрафа.
SELECT  f.name, f.number_plate, f.violation, 
   if(
    f.sum_fine = tv.sum_fine, "Стандартная сумма штрафа", 
    if(
      f.sum_fine < tv.sum_fine, "Уменьшенная сумма штрафа", "Увеличенная сумма штрафа"
    )
  ) AS description               
FROM  fine f, traffic_violation tv
WHERE tv.violation = f.violation and f.sum_fine IS NOT Null;

-- Сначала записи таблицы  fine разделяются на группы. В каждую группу включаются строки, у которых равны значения в столбцах name, number_plate и violation  соответственно. Получается 6 групп. 
SELECT name, number_plate, violation, count(*)
FROM fine
GROUP BY name, number_plate, violation;


-- Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило   два и более раз. При этом учитывать все нарушения, независимо от того оплачены они или нет. Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.
SELECT name, number_plate, violation
FROM fine
GROUP BY name, number_plate, violation
HAVING COUNT(violation) >=2
ORDER BY name,number_plate,violation;
-- WHERE ВСЕГДА выполняется ДО группировки, а HAVING ПОСЛЕ

-- Вывести название книг и их авторов.
SELECT title, name_author
FROM 
    author INNER JOIN book
    ON author.author_id = book.author_id;
    
-- Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.
SELECT title,name_genre,price
FROM 
    genre INNER JOIN book
    ON genre.genre_id = book.genre_id
    WHERE amount>8
    ORDER BY price DESC;
    
-- Вывести название всех книг каждого автора, если книг некоторых авторов в данный момент нет на складе – вместо названия книги указать Null.
SELECT name_author, title 
FROM author LEFT JOIN book
     ON author.author_id = book.author_id
ORDER BY name_author;    

-- Вывести все жанры, которые не представлены в книгах на складе.
SELECT name_genre
FROM genre LEFT JOIN book
     ON genre.genre_id = book.genre_id
     WHERE book.genre_id IS NULL
ORDER BY name_genre; 

-- каждому автору из таблицы author поставит в соответствие все возможные жанры из таблицы genre:
SELECT name_author, name_genre
FROM 
    author, genre;
    
    
-- Есть список городов, хранящийся в таблице city:
-- city_id	name_city
-- 1	Москва
-- 2	Санкт-Петербург
-- 3	Владивосток
-- Необходимо в каждом городе провести выставку книг каждого автора в течение 2020 года. Дату проведения выставки выбрать случайным образом. Создать запрос, который выведет город, автора и дату проведения выставки. Последний столбец назвать Дата. Информацию вывести, отсортировав сначала в алфавитном порядке по названиям городов, а потом по убыванию дат проведения выставок.
SELECT  name_city, name_author, (DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY)) as Дата
FROM 
    city CROSS JOIN author
ORDER BY name_city ASC, Дата DESC;

-- Вывести информацию о тех книгах, их авторах и жанрах, цена которых принадлежит интервалу от 500  до 700 рублей  включительно.
SELECT title, name_author, name_genre, price, amount
FROM
    author 
    INNER JOIN  book ON author.author_id = book.author_id
    INNER JOIN genre ON genre.genre_id = book.genre_id
WHERE price BETWEEN 500 AND 700;

-- Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в отсортированном по названиям книг виде.
SELECT  name_genre,title, name_author
FROM
    genre
    INNER JOIN  book ON genre.genre_id = book.genre_id
    INNER JOIN author ON author.author_id = book.author_id
WHERE name_genre LIKE '%роман%'
ORDER BY title ASC;


-- Вывести количество различных книг каждого автора. Информацию отсортировать в алфавитном порядке по фамилиям  авторов.
SELECT name_author, count(title) AS Количество
FROM 
    author INNER JOIN book
    on author.author_id = book.author_id
GROUP BY name_author
ORDER BY name_author; 

-- При использовании соединения INNER JOIN мы не можем узнать, что книг Лермонтова на складе нет, но предполагается, что они могут быть.  Чтобы автор Лермонтов был включен в результат, нужно изменить соединение таблиц.
SELECT name_author, count(title) AS Количество
FROM 
    author LEFT JOIN book
    on author.author_id = book.author_id
GROUP BY name_author
ORDER BY name_author;

-- Посчитать количество экземпляров  книг каждого автора из таблицы author.  Вывести тех авторов,  количество книг которых меньше 10, в отсортированном по возрастанию количества виде. Последний столбец назвать Количество.
SELECT  name_author, SUM(amount) As Количество 
FROM author LEFT JOIN book
ON author.author_id = book.author_id
GROUP BY name_author
HAVING SUM(amount)<10 OR SUM(amount) IS NULL
ORDER BY Количество;

-- Вывести авторов, общее количество книг которых на складе максимально.
-- по шагам:
-- 1) 
SELECT author_id, SUM(amount) AS sum_amount 
FROM book 
GROUP BY author_id
-- 2) 
SELECT MAX(sum_amount) AS max_sum_amount
FROM 
    (
     SELECT author_id, SUM(amount) AS sum_amount 
     FROM book 
     GROUP BY author_id
    ) query_in
-- 3) 
SELECT name_author, SUM(amount) as Количество
FROM 
    author INNER JOIN book
    on author.author_id = book.author_id
GROUP BY name_author
-- 4)
SELECT name_author, SUM(amount) as Количество
FROM 
    author INNER JOIN book
    on author.author_id = book.author_id
GROUP BY name_author
HAVING SUM(amount) = 
     (/* вычисляем максимальное из общего количества книг каждого автора */
      SELECT MAX(sum_amount) AS max_sum_amount
      FROM 
          (/* считаем количество книг каждого автора */
            SELECT author_id, SUM(amount) AS sum_amount 
            FROM book GROUP BY author_id
          ) query_in
      );
      
-- Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре. Поскольку у нас в таблицах так занесены данные, что у каждого автора книги только в одном жанре,  для этого запроса внесем изменения в таблицу book. Пусть у нас  книга Есенина «Черный человек» относится к жанру «Роман», а книга Булгакова «Белая гвардия» к «Приключениям» (эти изменения в таблицы уже внесены).
SELECT name_author
FROM
    author INNER JOIN book
    on author.author_id = book.author_id
    GROUP BY name_author
    HAVING COUNT(DISTINCT genre_id)=1;
-- OR
SELECT name_author FROM author 
WHERE author_id IN(SELECT author_id FROM book
                    GROUP BY author_id
                    HAVING COUNT(DISTINCT genre_id) = 1);
-- OR
SELECT name_author
FROM author JOIN (SELECT author_id, COUNT(DISTINCT genre_id) AS genre_count
                  FROM book
                  GROUP BY author_id) query_in
     ON author.author_id = query_in.author_id
WHERE query_in.genre_count = 1;      

-- Вывести авторов, пишущих книги в самом популярном жанре. Указать этот жанр.
-- 1) Найдем общее количество книг по каждому жанру, отсортируем его по убыванию и ограничим вывод одной строкой. Рекомендуется, если запрос будет использоваться в качестве вложенного (особенно в операциях соединения), вычисляемым полям запроса давать собственное имя.
SELECT genre_id, SUM(amount) AS sum_amount
FROM book
GROUP BY genre_id
ORDER BY sum_amount DESC
LIMIT 1
-- 2) Используя запрос с предыдущего шага, найдем id самых популярных жанров.
SELECT query_in_1.genre_id
FROM 
    (/* выбираем код жанра и количество произведений, относящихся к нему */
      SELECT genre_id, SUM(amount) AS sum_amount
      FROM book
      GROUP BY genre_id 
    )query_in_1
    INNER JOIN
    (/* выбираем запись, в которой указан код жанр с максимальным количеством книг */
      SELECT genre_id, SUM(amount) AS sum_amount
      FROM book
      GROUP BY genre_id
      ORDER BY sum_amount DESC
      LIMIT 1
     ) query_in_2
     ON query_in_1.sum_amount= query_in_2.sum_amount ;
-- 3) Используя запрос с шага 2, выведем фамилии авторов, которые пишут в самых популярных жанрах, и названия этих жанров. В этом запросе обязательно выполнить группировку по фамилиям авторов и id жанров, так как без этого фамилии авторов будут повторяться, поскольку в таблице book есть разные книги, написанные автором в одном жанре.
SELECT  name_author, name_genre
FROM 
    author 
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON  book.genre_id = genre.genre_id
GROUP BY name_author,name_genre, genre.genre_id
HAVING genre.genre_id IN
         (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
          SELECT query_in_1.genre_id
          FROM 
              ( /* выбираем код жанра и количество произведений, относящихся к нему */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
               )query_in_1
          INNER JOIN 
              ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
                ORDER BY sum_amount DESC
                LIMIT 1
               ) query_in_2
          ON query_in_1.sum_amount= query_in_2.sum_amount
         ); 
         
 SELECT name_author, name_genre /* выбираем автора и жанр */
FROM /* указываем таблицы, откуда мы хотим вытащить эту информацию */
     genre /* первой берем таблицу с жанрами  */
     INNER JOIN book ON genre.genre_id = book.genre_id /* у ней добавляем таблицу book по genre_id  */
     INNER JOIN author ON book.author_id = author.author_id /* к таблицам genre и book добавляем таблицу author */
/* Мы последовательно сджойнили три наших таблицы и, пока что, в результирующей таблицы будут ВСЕ записи */
GROUP BY name_author, name_genre, genre.genre_id /* итоговый результат мы хотим видеть сгруппированным по авторам и жанрам */
HAVING genre.genre_id IN /* в сгруппированном результате покажи нам только те жанры, которые содержатся в: */
    (
        SELECT query_in_1.genre_id /* вложенный запрос, он выдаст только значения genre_id */
        FROM /* создаются 2 временные таблицы, которые джойнятся по sum_amount: */
            (/* в первой временной таблице мы выбираем id жанра и количество книг на складе, относящихся к этому жанру */
                SELECT genre_id, SUM(amount) as sum_amount /* вложенный подзапрос 1.1 */
                FROM book
                GROUP BY genre_id
            ) query_in_1
        INNER JOIN /* результат одного вложенного подзапроса 1.1 джойним с результатом второго вложенного подзапроса 1.2 */
            (
                /* во второй временной таблице выбираем так же, но группируем по жанрам, внутри групп считаем количество книг
                   и выбираем одну запись, у которой максимальное количество книг на складе, так как мы отсортировали по максимальному
                   значению SUM(amount) и взяли первое (то есть самое большое)
                */
                SELECT genre_id, SUM(amount) as sum_amount /* вложенный подзапрос 1.2 */
                FROM book
                GROUP BY genre_id
                ORDER BY sum_amount DESC
                LIMIT 1
            ) query_in_2
        /* в первом джойне у нас получено 3 записи со значениями sum_amount: 31, 31, 7.
           во втором джойне только одно значение sum_amount: 31.
           Но в результирующей таблице будут только те записи sum_amount, у которых sum_amount одинаковые, т.е. 31
           А так как в самом подзапросе мы просили показать только id жанра genre_id, то результат будет такой:
           genre_id: 1 и 2, т.е. HAVING genre.genre_id IN (1,2)
        */
        ON query_in_1.sum_amount = query_in_2.sum_amount
    );
    
  --   ---------------------------------------------------
-- отбираем жанры и их макс.сумму по кол-ву книг =31 (но может быть несколько жанров по 31) => 1-31
SELECT genre_id, SUM(amount) AS sum_amount
FROM book
GROUP BY genre_id
ORDER BY sum_amount DESC
LIMIT 1;

-- отбираем жанры и их сумму по кол-ву книг  => 1- 31 \ 2-31 \ 3-7   
SELECT genre_id, SUM(amount) AS sum_amount
FROM book
GROUP BY genre_id
ORDER BY sum_amount DESC;
 
-- отбираем жанры по совпадению 31 и 31 в 2х временных таблицах по запросам  => 1 \ 2  
SELECT query_in_1.genre_id
FROM 
    (/* выбираем код жанра и количество произведений, относящихся к нему*/
      SELECT genre_id, SUM(amount) AS sum_amount
      FROM book
      GROUP BY genre_id 
    )query_in_1
    INNER JOIN
       ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг*/
      SELECT genre_id, SUM(amount) AS sum_amount
      FROM book
      GROUP BY genre_id
      ORDER BY sum_amount DESC
      LIMIT 1
     ) query_in_2
     ON query_in_1.sum_amount= query_in_2.sum_amount;

SELECT  name_author, name_genre
FROM 
    author 
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON  book.genre_id = genre.genre_id
GROUP BY name_author,name_genre, genre.genre_id
HAVING genre.genre_id IN 
        (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
          SELECT query_in_1.genre_id
          FROM 
              ( /* выбираем код жанра и количество произведений, относящихся к нему */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
               ) query_in_1
          INNER JOIN 
              ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
                ORDER BY sum_amount DESC
                LIMIT 1
               ) query_in_2
          ON query_in_1.sum_amount= query_in_2.sum_amount
         ); 
         
-- Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество экземпляров книги), написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде. Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально.    
SELECT  title, name_author, name_genre, price, amount
FROM 
    author 
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON  book.genre_id = genre.genre_id
/*GROUP BY name_author,name_genre, genre.genre_id*/
WHERE genre.genre_id IN
         (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
          SELECT query_in_1.genre_id
          FROM 
              ( /* выбираем код жанра и количество произведений, относящихся к нему */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
               )query_in_1
          INNER JOIN 
              ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
                ORDER BY sum_amount DESC
                LIMIT 1
               ) query_in_2
          ON query_in_1.sum_amount= query_in_2.sum_amount
         )
         ORDER BY title;
         
-- Вывести название книг, фамилии и id их авторов.   
-- Вариант с ON      
SELECT title, name_author, author.author_id /* явно указать таблицу - обязательно */
FROM 
    author INNER JOIN book
    ON author.author_id = book.author_id;
-- Вариант с USING
SELECT title, name_author, author_id /* имя таблицы, из которой берется author_id, указывать не обязательно*/
FROM 
    author INNER JOIN book
    USING(author_id);
    
-- Если в таблицах supply  и book есть одинаковые книги,  вывести их название и автора. При этом учесть, что у нескольких авторов могут быть книги с одинаковым названием.
SELECT book.title, name_author
FROM 
    author 
    INNER JOIN book USING (author_id)   
    INNER JOIN supply ON book.title = supply.title 
                         and author.name_author = supply.author;    
                         
-- Если в таблицах supply  и book есть одинаковые книги, которые имеют равную цену,  вывести их название и автора, а также посчитать общее количество экземпляров книг в таблицах supply и book,  столбцы назвать Название, Автор  и Количество.
SELECT book.title AS Название, name_author AS Автор, book.amount+supply.amount AS Количеcтво
FROM 
    author 
    INNER JOIN book USING (author_id)   
    INNER JOIN supply ON book.title = supply.title 
                         and book.price=supply.price;
-- OR 
SELECT book.title AS Название, name_author AS Автор, (book.amount+supply.amount) AS Количество
FROM 
    author 
    INNER JOIN book USING (author_id)   
    INNER JOIN supply ON book.title = supply.title AND author.name_author=supply.author
where supply.price=book.price;                         

-- /*Вывести Автор, Жанр, Название, Цена, Количество,  Город. Указать общее кол-во в проданных книг для самого читающего города. Отсортировать по убыванию  */
Select name_author as Автор, name_genre as Жанр, title as Название, b.price as Цена, amount as Количество, name_city as Город
from author a
INNER JOIN book b on a.author_id=b.author_id
INNER JOIN genre g on g.genre_id=b.genre_id
INNER join city c on c.city_id=b.city_id
where b.city_id in (select city_id
                   from book
                   group by city_id
                   having sum(amount)=(select max(s)
                                       from (select sum(amount) s
                                             from book 
                                             group by city_id) as q1))
                                             order by amount desc;
                                             
-- Вывести название книг, ФИО авторов, наименование жанров, цены, количество книг , минимальная цена которых меньше 500 рублей. Столбцы назвать Название, Автор, Наименование_жанра, Цена, Количество
SELECT  title AS Название , name_author AS Автор, name_genre AS Наименование_жанра,  price AS Цена,  amount AS Количество
 FROM author
 INNER JOIN book ON author.author_id = book.author_id
 INNER JOIN genre ON  book.genre_id = genre.genre_id
 GROUP BY title, name_author, name_genre, price, amount HAVING MIN(price)< 500;  
 
-- /*Есть список городов в каждом из которых необходимо произвести распродажу книг авторов в зависимости от популярности (предполагаемое количество книг для продажи рассчитанное маркетологами) с раскладкой по датам. В таблице указать Автора, Произведение, Количество в наличии, Цена Город и Дату распродажи */
SELECT author.name_author AS Автор, book.title AS Название, book.amount AS Количество, book.price AS Цена, city.name_city AS Город, DATE_ADD('2020-01-01', INTERVAL (FLOOR(RAND() * 365)) DAY) AS Дата
FROM author
        INNER JOIN book USING (author_id)
        CROSS JOIN city
WHERE amount = (SELECT MAX(book.amount) FROM book); 

-- Посчитать минимальную, максимальную и среднюю стоимость одной книги каждого жанра, и отсортировать по средней стоимости в порядке возрастания.
SELECT name_genre, MIN(price), MAX(price), ROUND(AVG(price), 2) AS "AVG(price)"
FROM book JOIN genre USING(genre_id)
GROUP BY name_genre
ORDER BY 4;

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

-- Запросы на основе трех и более связанных таблиц
-- Вывести фамилии всех клиентов, которые заказали книгу Булгакова «Мастер и Маргарита».
SELECT DISTINCT name_client
FROM 
    client 
    INNER JOIN buy ON client.client_id = buy.client_id
    INNER JOIN buy_book ON buy_book.buy_id = buy.buy_id
    INNER JOIN book ON buy_book.book_id=book.book_id
WHERE title ='Мастер и Маргарита' and author_id = 1; 
-- В запросе отбираются уникальные клиенты (DISTINCT) так как один и тот же клиент мог заказать одну и ту же книгу несколько раз.

-- Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал) в отсортированном по номеру заказа и названиям книг виде.
SELECT buy.buy_id, book.title, book.price, buy_book.amount
FROM 
    client 
    INNER JOIN buy ON client.client_id = buy.client_id
    INNER JOIN buy_book ON buy_book.buy_id = buy.buy_id
    INNER JOIN book ON buy_book.book_id=book.book_id
    WHERE name_client LIKE '%Баранов Павел%' 
ORDER BY buy.buy_id, title;

-- Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора (нужно посчитать, в каком количестве заказов фигурирует каждая книга).  Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество. Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
SELECT author.name_author, book.title, COUNT(buy_book.book_id) AS Количество
FROM 
    author
    INNER JOIN book ON author.author_id = book.author_id
    LEFT JOIN buy_book ON book.book_id = buy_book.book_id
GROUP BY author.name_author, book.title, buy_book.book_id
ORDER BY author.name_author, book.title;

-- Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов в каждый город, этот столбец назвать Количество. Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.
SELECT name_city, COUNT(client.client_id) AS Количество
FROM 
    city
    INNER JOIN client ON city.city_id = client.city_id
    INNER JOIN buy ON buy.client_id = client.client_id
GROUP BY client.client_id
ORDER BY Количество DESC, name_city ASC;

-- Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
SELECT buy_id, date_step_end
FROM buy_step
INNER JOIN step ON buy_step.step_id=step.step_id
WHERE name_step = 'Оплата' and date_step_end is not null; 

-- Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены), в отсортированном по номеру заказа виде. Последний столбец назвать Стоимость
SELECT buy.buy_id, client.name_client, SUM(book.price*buy_book.amount) AS Стоимость 
FROM client
INNER JOIN buy ON buy.client_id=client.client_id
INNER JOIN buy_book ON buy.buy_id=buy_book.buy_id
INNER JOIN book ON book.book_id=buy_book.book_id
GROUP BY buy.buy_id, client.name_client
ORDER BY buy_id; 

-- Вывести номера заказов (buy_id) и названия этапов,  на которых они в данный момент находятся. Если заказ доставлен –  информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id.
SELECT buy.buy_id, name_step
FROM buy
INNER JOIN buy_step ON buy.buy_id=buy_step.buy_id
INNER JOIN step ON buy_step.step_id=step.step_id
WHERE date_step_beg IS NOT NULL AND date_step_end IS NULL
ORDER BY buy.buy_id;

-- В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в этот город (рассматривается только этап Транспортировка). Для тех заказов, которые прошли этап транспортировки, вывести количество дней за которое заказ реально доставлен в город. А также, если заказ доставлен с опозданием, указать количество дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id), а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.
SELECT buy.buy_id, DATEDIFF(date_step_end, date_step_beg) AS Количество_дней, IF (DATEDIFF(date_step_end, date_step_beg)>days_delivery,DATEDIFF(date_step_end, date_step_beg)-days_delivery,0) AS Опоздание
FROM buy
INNER JOIN buy_step ON buy.buy_id=buy_step.buy_id
INNER JOIN step ON buy_step.step_id=step.step_id
INNER JOIN client ON buy.client_id=client.client_id
INNER JOIN city ON city.city_id=client.city_id
WHERE name_step='Транспортировка' AND date_step_beg IS NOT NULL AND date_step_end IS NOT NULL
ORDER BY buy.buy_id;

-- Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. В решении используйте фамилию автора, а не его id.
SELECT DISTINCT name_client 
FROM client
INNER JOIN buy ON buy.client_id=client.client_id
INNER JOIN buy_book ON buy.buy_id=buy_book.buy_id
INNER JOIN book ON book.book_id=buy_book.book_id
INNER JOIN author ON author.author_id=book.author_id
WHERE name_author LIKE '%Достоевский%'
ORDER BY name_client;
-- or
SELECT DISTINCT name_client
FROM
    author
    INNER JOIN book ON (author.author_id = book.author_id) AND author.name_author LIKE '%остоевский%'
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id)
    INNER JOIN client USING(client_id)
ORDER BY 1 ASC;

-- Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество. Последний столбец назвать Количество.
SELECT name_genre, SUM(buy_book.amount) as Количество
FROM 
    genre
    INNER JOIN book ON genre.genre_id = book.genre_id
    INNER JOIN buy_book ON buy_book.book_id = book.book_id
GROUP BY name_genre
HAVING SUM(buy_book.amount) = 
     (/* вычисляем максимальное из общего количества книг каждого автора 7*/
      SELECT MAX(sum_amount) AS max_sum_amount
      FROM 
          (/* считаем количество книг каждого автора = 7,4 */
            SELECT SUM(buy_book.amount) AS sum_amount 
            FROM buy_book 
            INNER JOIN book ON buy_book.book_id = book.book_id
            INNER JOIN genre ON genre.genre_id = book.genre_id
            GROUP BY genre.genre_id
          ) query_in
      );
      
-- Вывести всех клиентов, которые делали заказы или в этом, или в предыдущем году.
-- На этом примере рассмотрим разницу между UNION и UNION ALL.
-- С UNION клиенты будут выведены без повторений:
SELECT name_client
FROM 
    buy_archive
    INNER JOIN client USING(client_id)
UNION
SELECT name_client
FROM 
    buy 
    INNER JOIN client USING(client_id);

-- C UNION ALL будут выведены клиенты с повторением (для тех, кто заказывал книги в обоих годах, а также несколько раз в одном году)
SELECT name_client
FROM 
    buy_archive
    INNER JOIN client USING(client_id)
UNION ALL
SELECT name_client
FROM 
    buy 
    INNER JOIN client USING(client_id);
    
-- Вывести информацию об оплаченных заказах за предыдущий и текущий год, информацию отсортировать по  client_id.
SELECT buy_id, client_id, book_id, date_payment, amount, price
FROM 
    buy_archive
UNION ALL
SELECT buy.buy_id, client_id, book_id, date_step_end, buy_book.amount, price
FROM 
    book 
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id) 
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)                  
WHERE  date_step_end IS NOT Null and name_step = "Оплата" ;
 -- В результат включены сначала записи архивной таблицы, а затем информация об оплаченных заказах  текущего года.     
 
 -- Для того, чтобы изменить порядок следования записей в объединенном запросе, можно использовать сортировку по всем объединенным записям. В этом случае ключевые слова ORDER BY указываются после последнего запроса: 
SELECT buy_id, client_id, book_id, date_payment, amount, price
FROM 
    buy_archive
UNION ALL
SELECT buy.buy_id, client_id, book_id, date_step_end, buy_book.amount, price
FROM 
    book 
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id) 
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)                  
WHERE  date_step_end IS NOT Null and name_step = "Оплата"
ORDER BY client_id;


-- Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. Для этого вывести год, месяц, сумму выручки в отсортированном сначала по возрастанию месяцев, затем по возрастанию лет виде. Название столбцов: Год, Месяц, Сумма.
SELECT * FROM buy_archive;

SELECT YEAR(date_payment) As Год, MONTHNAME(date_payment) As Месяц, SUM(price*amount) AS Сумма
FROM 
    buy_archive
GROUP BY Месяц, Год 
UNION ALL
SELECT YEAR(buy_step.date_step_end) As Год, MONTHNAME(buy_step.date_step_end) As Месяц, SUM(book.price*buy_book.amount) AS Сумма
FROM 
    book 
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id) 
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)                  
WHERE  buy_step.date_step_end IS NOT Null and step.name_step = "Оплата"
GROUP BY Месяц, Год 
ORDER BY Месяц, Год;

-- Вывести клиентов, которые делали покупки в прошлом году, но не делали в этом. А также новых клиентов, которые делали заказы только в текущем году. Информацию отсортировать по возрастанию лет.
--  Отберем клиентов прошлого года, указав дату самого раннего заказа, а также клиентов этого года, указав для них самую раннюю дату оплаты заказа.
-- Как видно из таблицы, некоторые клиенты делали покупки как в прошлом, так и в этом году. Они встречаются в таблице 2 раза.
SELECT name_client, MIN(date_payment) AS first_payment
FROM 
    buy_archive 
    INNER JOIN client USING(client_id)
GROUP BY  name_client
UNION
SELECT name_client, MIN(date_step_end)
FROM 
    buy 
    INNER JOIN client USING(client_id)
    INNER JOIN buy_step USING(buy_id)
GROUP BY name_client;

-- Оставим только тех клиентов, которые встречаются в полученной таблице один раз, для этого используем предыдущий запрос как вложенный.
SELECT name_client, MIN(YEAR(first_payment)) AS Год
FROM
  (
   SELECT name_client, MIN(date_payment) AS first_payment
   FROM 
       buy_archive 
       INNER JOIN client USING(client_id)
   GROUP BY  name_client
   UNION
   SELECT name_client, MIN(date_step_end)
   FROM 
       buy 
       INNER JOIN client USING(client_id)
       INNER JOIN buy_step USING (buy_id)
   GROUP BY name_client
  ) query_in
GROUP BY name_client
HAVING COUNT(*) = 1
ORDER BY 2;

-- Для каждой отдельной книги необходимо вывести информацию о количестве проданных экземпляров и их стоимости за 2020 и 2019 год . Вычисляемые столбцы назвать Количество и Сумма. Информацию отсортировать по убыванию стоимости.
SELECT * FROM buy_archive;

SELECT title,  SUM(buy_archive.amount) AS Количество, SUM(buy_archive.price*buy_archive.amount) AS Сумма  
FROM 
    buy_archive 
    INNER JOIN book USING(book_id)
GROUP BY title;

SELECT title,  SUM(buy_book.amount) AS Количество, SUM(book.price*buy_book.amount) AS Сумма 
FROM 
    book 
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)
WHERE buy_step.date_step_end IS NOT Null and step.name_step = "Оплата"
GROUP BY title;

SELECT title,  SUM(buy_archive.amount) AS Количество, SUM(buy_archive.price*buy_archive.amount) AS Сумма  
FROM 
    buy_archive 
    INNER JOIN book USING(book_id)
GROUP BY title
UNION
SELECT title,  SUM(buy_book.amount) AS Количество, SUM(book.price*buy_book.amount) AS Сумма 
FROM 
    book 
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)
WHERE buy_step.date_step_end IS NOT Null and step.name_step = "Оплата"
GROUP BY title;

SELECT title,  SUM(Количество) AS Количество, SUM(Сумма) AS Сумма  
FROM
  (
    SELECT title,  SUM(buy_archive.amount) AS Количество, SUM(buy_archive.price*buy_archive.amount) AS Сумма  
    FROM 
        buy_archive 
        INNER JOIN book USING(book_id)
    GROUP BY title
    UNION
    SELECT title,  SUM(buy_book.amount) AS Количество, SUM(book.price*buy_book.amount) AS Сумма 
    FROM 
        book 
        INNER JOIN buy_book USING(book_id)
        INNER JOIN buy_step USING(buy_id)
        INNER JOIN step USING(step_id)
    WHERE buy_step.date_step_end IS NOT Null and step.name_step = "Оплата"
    GROUP BY title
  ) query_in
GROUP BY title
ORDER BY Сумма DESC;

 -- Название              | Автор            | Стоимость | Склад | Заказ | Остаток 
select  title as Название,name_author as Автор, price as  Стоимость,sum(book.amount) as Склад, if(sum(buy_book.amount) is not null, sum(buy_book.amount), 0) as Заказ,if(sum(book.amount) - sum(buy_book.amount) is null, sum(book.amount), sum(book.amount - buy_book.amount))  as Остаток
from buy_book 
right join book using (book_id)
join author using (author_id)
Group by title, name_author, price;


-- Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат. Информацию вывести по убыванию результатов тестирования.
select name_student,date_attempt,result
from student  
JOIN attempt USING (student_id)
JOIN subject USING (subject_id)
WHERE name_subject='Основы баз данных'
ORDER BY result DESC;
-- or
SELECT name_student, date_attempt, result
FROM subject s JOIN attempt a ON s.subject_id = a.subject_id AND s.name_subject LIKE 'Основы б%'
               JOIN student USING(student_id)
ORDER BY 3 DESC;

-- Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, который округлить до 2 знаков после запятой. Под результатом попытки понимается процент правильных ответов на вопросы теста, который занесен в столбец result.  В результат включить название дисциплины, а также вычисляемые столбцы Количество и Среднее. Информацию вывести по убыванию средних результатов.
select name_subject, Count(result) AS Количество, ROUND(AVG(result),2) AS Среднее 
from subject  
LEFT JOIN attempt USING (subject_id)
GROUP BY subject_id
ORDER BY Среднее DESC;

-- Вывести студентов (различных студентов), имеющих максимальные результаты попыток. Информацию отсортировать в алфавитном порядке по фамилии студента.
-- Максимальный результат не обязательно будет 100%, поэтому явно это значение в запросе не задавать.
SELECT name_student, result 
FROM student
JOIN attempt USING (student_id)
WHERE result = (
         SELECT MAX(result) 
         FROM attempt
      )
ORDER BY name_student;


-- Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях между первой и последней попыткой. В результат включить фамилию и имя студента, название дисциплины и вычисляемый столбец Интервал. Информацию вывести по возрастанию разницы. Студентов, сделавших одну попытку по дисциплине, не учитывать. 
-- подзапрос
select name_student, name_subject ,MIN(date_attempt)
FROM student
JOIN attempt USING (student_id)
JOIN subject USING (subject_id)
GROUP BY student_id,  subject_id
HAVING COUNT(attempt_id)>1;
-- запрос
SELECT name_student, name_subject, DATEDIFF(MAX(date_attempt), MIN(date_attempt)) AS  Интервал
FROM student
JOIN attempt USING (student_id)
JOIN subject USING (subject_id)
GROUP BY student_id,  subject_id
HAVING COUNT(attempt_id)>1
ORDER BY Интервал;

-- Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем). Вывести дисциплину и количество уникальных студентов (столбец назвать Количество), которые по ней проходили тестирование . Информацию отсортировать сначала по убыванию количества, а потом по названию дисциплины. В результат включить и дисциплины, тестирование по которым студенты еще не проходили, в этом случае указать количество студентов 0.
-- Если один и тот же студент тестировался несколько раз по одной и той же дисциплине, то студента учитывать один раз.
SELECT name_subject, COUNT(DISTINCT(student_id)) AS  Количество 
FROM subject
LEFT JOIN attempt USING (subject_id)
GROUP BY subject_id
ORDER BY Количество DESC, name_subject ASC;

-- Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». В результат включите столбцы question_id и name_question.
SELECT question_id, name_question  
FROM subject
JOIN question USING (subject_id)
WHERE name_subject='Основы баз данных'
ORDER BY RAND()
LIMIT 3;

-- Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине «Основы SQL» 2020-05-17  (значение attempt_id для этой попытки равно 7). Указать, какой ответ дал студент и правильный он или нет (вывести Верно или Неверно). В результат включить вопрос, ответ и вычисляемый столбец  Результат.
SELECT name_question, name_answer, IF(is_correct=1,'Верно', 'Неверно') AS Результат
FROM testing
JOIN question USING (question_id)
JOIN answer USING (answer_id)
WHERE attempt_id=7;

-- Посчитать результаты тестирования. Результат попытки вычислить как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до двух знаков после запятой. Вывести фамилию студента, название предмета, дату и результат. Последний столбец назвать Результат. Информацию отсортировать сначала по фамилии студента, потом по убыванию даты попытки.
-- В запрос не рекомендуется включать таблицу question, нужно связать answer непосредственно с testing. Если же в этом запросе использовать связь testing - question - answer и считать верные ответы, то получится, что считаются ВЕРНЫЕ ответы на вопросы, занесенные в таблицу question, а не верные ответы, которые дал пользователь.
SELECT name_student,name_subject,date_attempt,  ROUND(SUM(is_correct)*100/3,2) AS Результат
FROM answer
    JOIN testing USING(answer_id)
    JOIN attempt USING(attempt_id)
    JOIN subject USING(subject_id)
    JOIN student USING(student_id)
GROUP BY name_student, name_subject, date_attempt
ORDER BY name_student ASC, date_attempt DESC ;

-- Для каждого вопроса вывести процент успешных решений, то есть отношение количества верных ответов к общему количеству ответов, значение округлить до 2-х знаков после запятой. Также вывести название предмета, к которому относится вопрос, и общее количество ответов на этот вопрос. В результат включить название дисциплины, вопросы по ней (столбец назвать Вопрос), а также два вычисляемых столбца Всего_ответов и Успешность. Информацию отсортировать сначала по названию дисциплины, потом по убыванию успешности, а потом по тексту вопроса в алфавитном порядке.
-- Поскольку тексты вопросов могут быть длинными, обрезать их 30 символов и добавить многоточие "...".
SELECT name_subject, CONCAT(LEFT(name_question, 30),'...') AS Вопрос, COUNT(testing.question_id) AS Всего_ответов, ROUND(SUM(is_correct)/COUNT(testing.question_id)*100, 2) AS Успешность
FROM subject
    JOIN question USING(subject_id)
    JOIN testing USING(question_id) 
    JOIN answer USING(answer_id)    
GROUP BY name_subject, name_question
ORDER BY name_subject ASC, Успешность DESC, Вопрос ASC;

/*
ROUND(SUM(is_correct)/COUNT(testing.question_id)*100, 2)
*/

SELECT name_subject, CONCAT(LEFT(name_question, 30),'...') AS Вопрос, SUM(is_correct)

FROM subject
    JOIN question USING(subject_id)
    JOIN testing USING(question_id) 
    JOIN answer USING(answer_id)    
GROUP BY name_subject, name_question
ORDER BY name_subject ASC;


-- Вывести абитуриентов, которые хотят поступать на образовательную программу «Мехатроника и робототехника» в отсортированном по фамилиям виде.
select name_enrollee 
from enrollee
JOIN program_enrollee USING (enrollee_id)
JOIN program USING (program_id)
WHERE  name_program='Мехатроника и робототехника'
Order by name_enrollee;
-- or 
SELECT name_enrollee
FROM enrollee
     INNER JOIN program_enrollee USING(enrollee_id)
     INNER JOIN program ON program_enrollee.program_id = program.program_id AND 
                           program.name_program = 'Мехатроника и робототехника'
ORDER BY name_enrollee;

-- Вывести образовательные программы, на которые для поступления необходим предмет «Информатика». Программы отсортировать в обратном алфавитном порядке.
select name_program 
from program
JOIN program_subject USING (program_id)
JOIN subject USING (subject_id)
WHERE  name_subject='Информатика'
Order by name_program DESC;
-- or 
SELECT name_program
FROM program
     INNER JOIN program_subject USING(program_id)
     INNER JOIN subject ON program_subject.subject_id = subject.subject_id AND 
                           subject.name_subject = 'Информатика'
ORDER BY name_program DESC;
-- or 
select name_program 
from program_subject join program using(program_id)
where subject_id = (select subject_id from subject where name_subject like('Информатика'));


-- Выведите количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное, минимальное и среднее значение баллов по предмету ЕГЭ. Вычисляемые столбцы назвать Количество, Максимум, Минимум, Среднее. Информацию отсортировать по названию предмета в алфавитном порядке, среднее значение округлить до одного знака после запятой.
select name_subject, COUNT(subject_id ) AS Количество, MAX(result) AS Максимум, MIN(result) AS Минимум, ROUND(AVG(result),1) AS Среднее
from subject join enrollee_subject using(subject_id)
GROUP BY  subject_id 
order by name_subject;

-- Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету больше или равен 40 баллам. Программы вывести в отсортированном по алфавиту виде.
select name_program                        
from program join program_subject using(program_id)
GROUP BY  program_id 
HAVING MIN(min_result) >=40
order by name_program;


-- Вывести образовательные программы, которые имеют самый большой план набора,  вместе с этой величиной.
select name_program, plan                          
from program
WHERE plan = (select MAX(plan) from program);

-- Посчитать, сколько дополнительных баллов получит каждый абитуриент. Столбец с дополнительными баллами назвать Бонус. Информацию вывести в отсортированном по фамилиям виде.
select name_enrollee, IF(SUM(bonus) IS NULL, 0,SUM(bonus)) AS Бонус                           
from enrollee
left join enrollee_achievement USING(enrollee_id)
left join achievement USING(achievement_id)
GROUP BY enrollee_id
order by name_enrollee;

-- Выведите сколько человек подало заявление на каждую образовательную программу и конкурс на нее (число поданных заявлений деленное на количество мест по плану), округленный до 2-х знаков после запятой. В запросе вывести название факультета, к которому относится образовательная программа, название образовательной программы, план набора абитуриентов на образовательную программу (plan), количество поданных заявлений (Количество) и Конкурс. Информацию отсортировать в порядке убывания конкурса.
select name_department, name_program, plan, COUNT(program_id) AS Количество,  ROUND(COUNT(program_id)/plan,2) AS Конкурс                      
from department
 join program USING(department_id)
 join program_enrollee USING(program_id)
GROUP BY name_department, name_program, plan
order by Конкурс DESC;

-- Вывести образовательные программы, на которые для поступления необходимы предмет «Информатика» и «Математика» в отсортированном по названию программ виде.
select name_program                                        
from program
 join program_subject USING(program_id)
 join subject ON program_subject.subject_id=subject.subject_id AND name_subject IN('Информатика','Математика')
 GROUP BY name_program
 having COUNT(name_subject)=2
 order by name_program;
 
 -- Посчитать количество баллов каждого абитуриента на каждую образовательную программу, на которую он подал заявление, по результатам ЕГЭ. В результат включить название образовательной программы, фамилию и имя абитуриента, а также столбец с суммой баллов, который назвать itog. Информацию вывести в отсортированном сначала по образовательной программе, а потом по убыванию суммы баллов виде.
select name_program,name_enrollee, SUM(result) itog   
from enrollee
 join program_enrollee USING(enrollee_id)
 join program USING(program_id) 
 join program_subject USING(program_id)
 join subject USING(subject_id)
 join enrollee_subject ON subject.subject_id = enrollee_subject.subject_id  and enrollee_subject.enrollee_id = enrollee.enrollee_id
group by enrollee_subject.enrollee_id,name_program,name_enrollee
order by name_program ASC, itog DESC;

-- Вывести название образовательной программы и фамилию тех абитуриентов, которые подавали документы на эту образовательную программу, но не могут быть зачислены на нее. Эти абитуриенты имеют результат по одному или нескольким предметам ЕГЭ, необходимым для поступления на эту образовательную программу, меньше минимального балла. Информацию вывести в отсортированном сначала по программам, а потом по фамилиям абитуриентов виде.
-- Например, Баранов Павел по «Физике» набрал 41 балл, а  для образовательной программы «Прикладная механика» минимальный балл по этому предмету определен в 45 баллов. Следовательно, абитуриент на данную программу не может поступить.
 select distinct name_program,name_enrollee
from enrollee
 join program_enrollee USING(enrollee_id)
 join program USING(program_id) 
 join program_subject USING(program_id)
 join subject USING(subject_id)
 join enrollee_subject ON subject.subject_id = enrollee_subject.subject_id  and enrollee_subject.enrollee_id = enrollee.enrollee_id
WHERE result < min_result
order by name_program, name_enrollee;
-- or
SELECT name_program, name_enrollee
FROM program
     INNER JOIN program_subject USING(program_id)
     INNER JOIN subject USING(subject_id)
     INNER JOIN enrollee_subject USING(subject_id)
     INNER JOIN enrollee USING(enrollee_id)
     INNER JOIN program_enrollee USING(program_id, enrollee_id)
WHERE result < min_result
GROUP BY name_program, name_enrollee
ORDER BY name_program, name_enrollee;

-- Вывести список абитуриентов с результатами тестирования и комментарием по каждому результату - Проходной или Непродной бал они получили по результатам тестирования.
SELECT  name_program, name_enrollee, name_subject, result,
       IF(result >= min_result, 'Проходной', 'Непроходной') Бал
FROM program_enrollee
    INNER JOIN program_subject USING(program_id)
    INNER JOIN enrollee_subject ON enrollee_subject.subject_id = program_subject.subject_id 
                                   AND
                                   program_enrollee.enrollee_id = enrollee_subject.enrollee_id
    INNER JOIN program ON program_enrollee.program_id = program.program_id
    INNER JOIN enrollee ON enrollee.enrollee_id = program_enrollee.enrollee_id
    INNER JOIN department USING(department_id)
    INNER JOIN subject ON program_subject.subject_id = subject.subject_id
ORDER BY name_program, name_enrollee, result DESC;

-- Для каждого студента отметить предпочтительную программу обучения, то есть ту в которой он набрал наибольшее число баллов:
SELECT
    name_enrollee,
    name_program AS Предпочтительная_программа
FROM student
WHERE
    (name_enrollee, itog) IN (
        SELECT
            name_enrollee,
            MAX(itog)
        FROM student
        GROUP BY name_enrollee)
ORDER BY name_enrollee;


-- Включить в таблицу applicant_order новый столбец str_id целого типа , расположить его перед первым.
select * from applicant_order;
ALTER TABLE applicant_order ADD str_id int FIRST;
select * from applicant_order;

-- Пронумеруем записи в таблице applicant_order.
SET @row_num := 0;
SELECT *, (@row_num := @row_num + 1) AS str_num
FROM  applicant_order;
-- Выражение  @row_num := @row_num + 1 означает, что для каждой записи, выводимой в запрос, значение переменной @row_num увеличивается на 1. В результате получается нумерация строк запроса.


-- Создадим нумерацию, которая начинается заново для каждой образовательной программы. Для этого можно использовать алгоритм, в котором в переменную @row_num заносится 1, если id программы в предыдущей записи не равен id программы в текущей:
-- объявить переменную @num_pr, задать ей начальное значение;
-- запомнить id образовательной программы для текущей записи в переменной @num_pr;
-- для следующей записи сравнить значение переменной @num_pr с id образовательной программы;
-- если они равны, то продолжить нумерацию @row_num := @row_num + 1;
-- в противном случае начать нумерацию снова, для этого установить @row_num := 1.
SET @num_pr := 0;
SET @row_num := 1;
SELECT *, 
     if(program_id = @num_pr, @row_num := @row_num + 1, @row_num := 1) AS str_num,
     @num_pr := program_id AS add_var 
from applicant_order;


-- Занести в столбец str_id таблицы applicant_order нумерацию абитуриентов, которая начинается с 1 для каждой образовательной программы.
select * from applicant_order;
SET @num_pr := 0;
SET @row_num := 1;
update applicant_order
SET str_id =if(program_id = @num_pr, @row_num := @row_num + 1, @row_num := 1 AND  @num_pr := program_id);
select * from applicant_order;


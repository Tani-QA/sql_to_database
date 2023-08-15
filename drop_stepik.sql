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

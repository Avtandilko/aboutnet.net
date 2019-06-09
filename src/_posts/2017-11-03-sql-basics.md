---
layout: post
title: SQL Basics
categories: SQL
permalink: /sql-basics
---

## Содержание
   * [Манипуляции с таблицами](/sql-basics#Манипуляции с таблицами)
   * [Запросы к базе данных](/sql-basics#Запросы к базе данных)
   * [Aggregate Functions](/sql-basics#Aggregate Functions)
   * [Связь нескольких таблиц в базе данных](/sql-basics#Связь нескольких таблиц в базе данных)
   
Конспект курса Learn SQL с ресурса <a href="https://www.codecademy.com/learn/learn-sql">codeacademy.com</a>. Во всех примерах используется синтаксис SQLite.

Реляционные базы данных - базы данных, организованные в виде одной или нескольких таблиц. 
Таблица - определенный набор данных. Таблицы состоят из строк и столбцов (полей и записей).

<!---excerpt-break-->

## Манипуляции с таблицами <a name="Манипуляции с таблицами"></a>
Пример создания таблицы:
```sql
CREATE TABLE table_name (
    column_1 data_type, 
    column_2 data_type, 
    column_3 data_type
  );
```
Пример добавления данных в таблицу:
```sql
INSERT INTO table_name (column_1, column_2, column_2) VALUES (value_1, value_2, value_3);
INSERT INTO table_name (column_2) VALUES (value_2);
```
Примеры запроса значений из таблицы:
```sql
SELECT * FROM table_name;
SELECT column_1 FROM table_name;
```
Пример добавления столбца в таблицу:
```sql
ALTER TABLE table_name 
ADD COLUMN column_4 TYPE;
```
Пример удаления столбца из таблицы:
```sql
ALTER TABLE table_name 
DROP COLUMN column_4;
```
Пример изменения записи в таблице:
```sql
UPDATE table_name
SET column_2 = value_2
WHERE column_1 = value_1;
```
Пример удаления записи в таблице:
```sql
DELETE FROM table_name WHERE column_1=value_1;
```
### Constraints
 * ```PRIMARY KEY```- уникально идентифицирует каждую запись в таблице. Таблица может содержать только один столбец, использующийся как ```PRIMARY KEY```;
 * ```UNIQUE```- схож с ```PRIMARY KEY```, с тем отличием, что в таблице может быть несколько столбцов с уникальными значениями (ключевым словом ```UNIQUE```);
 * ```NOT NULL```- указатель на то, что каждая запись должна иметь значение в данном столбце. Записи без значения в таблицу вставлены не будут;
 * ```DEFAULT```- указывает на значение по умолчанию поля для записи.

Пример создания таблицы:
```sql
CREATE TABLE table_name (
   column_1 data_type PRIMARY KEY, 
   column_2 data_type UNIQUE, 
   column_3 data_type NOT NULL,
   column_4 data_type DEFAULT value_4,
 );
```  
## Запросы к базе данных <a name="Запросы к базе данных"></a>
 * ```SELECT DISTINCT ...``` - возвращает только уникальные значения из таблицы;
 * ```SELECT * FROM table_name WHERE condition;``` - возвращает записи, отвечающие определенному условию;
 * ```SELECT * FROM table_name WHERE column LIKE pattern;``` - возвращает записи, удовлетворяющие определенному паттерну;
 * ```SELECT * FROM table_name WHERE column BETWEEN value_1 AND value_2;``` - возвращает записи в интервале между указанными значениями;
 * ```SELECT * FROM table_name ORDER BY column ASC/DESC;``` - возвращает записи в сортированном виде в порядке возрастания/убывания;
 * ```SELECT * FROM table_name LIMIT <number>;``` - возвращает указанное количество записей;

Синтаксис, используемый в LIKE:
 * '_' - любой символ;
 * '%' - любая последовательность символов;

## Aggregate Functions <a name="Aggregate Functions"></a>
Функции, позволяющие проводить манипуляции над набором значений и получать единственный результат
 * ```COUNT```- возвращает количество записей в таблице.
 
Пример запроса:```SELECT COUNT(*) FROM table_name;```
 * ```GROUP BY```- группирует результаты запроса по значению одного или нескольких полей.
 
Пример запроса:```SELECT column_1, COUNT(*) FROM table_name GROUP BY column_1;```
 * ```SUM```- возвращает сумму всех значений поля (только для INTEGER).
 
Пример запроса:```SELECT SUM(column_1) FROM table_name;```
 * ```MAX```- возвращает максимальное значение для поля.
 
Пример запроса:```SELECT MAX(column_1) FROM table_name;```
 * ```MIN```- возвращает минимальное значение для поля.
 
Пример запроса:```SELECT MIN(column_1) FROM table_name;```
 * ```AVG```- возвращает среднее значение для поля.
 
Пример запроса:  ```SELECT AVG(column_1) FROM table_name;```
 * ```ROUND```- округляет результаты запроса с указанной точностью.
 
Пример запроса (2 знака после запятой):  ```SELECT ROUND(AVG(column_1), 2) FROM table_name;```

## Связь нескольких таблиц в базе данных <a name="Связь нескольких таблиц в базе данных"></a>

 * ```FOREIGN KEY``` - поле таблицы, которое содержит ```PRIMARY KEY``` другой таблицы в базе данных. Могут быть неуникальными в пределах таблицы, либо типа NULL.
 * Cross Join - указание на то, что ```FOREIGN KEY``` одной таблицы является ```PRIMARY KEY``` другой таблицы.
 * Inner Join, ```FOREIGN KEY``` (column_1) из таблицы table_name_1 сопоставляется с ```PRIMARY KEY``` (column_2) таблицы table_name_2:
```sql
SELECT * FROM table_name_1
JOIN table_name_2 ON table_name_1.column_1 = table_name_2.column_2;
```
 * ```Outer Join``` - запрос, аналогичный ```Inner Join```, но выполнение Join Condition необязательно. Пример запроса ```Outer Join```:
```sql
SELECT * FROM table_name_1
LEFT JOIN table_name_2 ON table_name_1.column_name_1 = table_name_2.column_name_2;
```
 * ```AS``` (Alias) - ключевое слово, позволяющее переименовать поле таблицы при присоединении. Пример:
```sql
SELECT column_1 AS column_2 FROM table_name;
```
 * ```DROP TABLE IF EXISTS``` - удаление таблицы из базы данных, если таблица существует;
 * ```CREATE TABLE IF NOT EXISTS``` - создание таблицы в базе данных, если таблица еще не существует.
 * ```REFERENCES``` - указание на зависимость поля одной таблицы от поля другой таблицы. Пример:
```sql 
CREATE TABLE IF NOT EXISTS table_name_1(
  FOREIGN KEY(column_1) REFERENCES table_name_2(column_2)
);
```

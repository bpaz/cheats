---
title: MySQL
category: databases
layout: 2017/sheet
updated: 2018-10-28
description: ""
---

### Database commands

| create a database                | `CREATE DATABASE db_name;`                    |
| list the databases on the server | `SHOW DATABASES;`                             |
| show a table's fields            | `DESCRIBE tbl;`                               |
| create table                     | `CREATE TABLE tbl (field1, field2);`          |
| insert data into table           | `INSERT INTO tbl VALUES ("va­l1", "­val­2");` |
| add column to table              | `ALTER TABLE tbl ADD COLUMN col;`             |
| remove a column from a table     | `ALTER TABLE tbl DROP COLUMN col;`            |


### Datatypes

| CHAR        | String (0 - 255)                                              |
| VARCHAR     | String (0 - 255)                                              |
| TINYTEXT    | String (0 - 255)                                              |
| TEXT        | String (0 - 65535)                                            |
| BLOB        | String (0 - 65535)                                            |
| MEDIUMTEXT  | String (0 - 16777215)                                         |
| MEDIUMBLOB  | String (0 - 16777215)                                         |
| LONGTEXT    | String (0 - 429496­7295)                                      |
| LONGBLOB    | String (0 - 429496­7295)                                      |
| TINYINT x   | Integer (-128 to 127)                                         |
| SMALLINT x  | Integer (-32768 to 32767)                                     |
| MEDIUMINT x | Integer (-8388608 to 8388607)                                 |
| INT x       | Integer (-2147­483648 to 214748­3647)                         |
| BIGINT x    | Integer (-9223­372­036­854­775808 to 922337­203­685­477­5807) |
| FLOAT       | Decimal (precise to 23 digits)                                |
| DOUBLE      | Decimal (24 to 53 digits)                                     |
| DECIMAL     | "­DOU­BLE­" stored as string                                  |
| DATE        | YYYY-MM-DD                                                    |
| DATETIME    | YYYY-MM-DD HH:MM:SS                                           |
| TIMESTAMP   | YYYYMM­DDH­HMMSS                                              |
| TIME        | HH:MM:SS                                                      |
| ENUM        | One of preset options                                         |


### DDL

| Create table | `create table tutorials_tbl(tutorial_id INT NOT NULL AUTO_INCREMENT, tutorial_title VARCHAR(100) NOT NULL, tutorial_author VARCHAR(40) NOT NULL, submission_date DATE,PRIMARY KEY ( tutorial_id ));` |
| Add column to existing table | `ALTER TABLE table_name ADD column_name datatype;` |
| Modify column | `ALTER TABLE table_name MODIFY COLUMN column_name datatype;` |
| Add foreign key | `ALTER TABLE users ADD CONSTRAINT fk_grade_id FOREIGN KEY (grade_id) REFERENCES grades(id);` |
| Add index  | `ALTER TABLE tbl_student ADD INDEX student_index (student_id)` |
| Add unique index | `ALTER TABLE tbl_student ADD UNIQUE student_unique_index (student_id)` |
| Drop index | `DROP INDEX student_index ON tbl_student` |

### Database administration

| Connect to database | `mysql -h localhost -u root -p` |
| Show running processes | `show processlist;` |
| Grant priviledges | `GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'localhost';` |
| Backup datatabase | `mysqldump -h localhost -u root -p <database_name> > dump.sql` |

### Json

| Search json data | `SELECT * FROM book WHERE JSON_CONTAINS(tags, '["JavaScript"]');` |
| Select from json field | `SELECT name, profile->"$.twitter" AS twitter FROM user;` |

## References
{: .-one-column}

* <https://www.mysql.com/>
* <https://www.cheatography.com/guslong/cheat-sheets/essential-mysql/>
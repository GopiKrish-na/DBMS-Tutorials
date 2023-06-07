CREATE DATABASE db_College;

CREATE TABLE tb_Student(

student_id INT NOT NULL PRIMARY KEY,
std_name VARCHAR(255) NOT NULL,
std_address VARCHAR(255) NOT NULL,
std_age INT NOT NULL
);

CREATE TABLE tb_Subject(
subjectCode VARCHAR(255) NOT NULL,
subjects VARCHAR (255) NOT NULL PRIMARY KEY
);

CREATE TABLE tb_Marks(
student_id INT FOREIGN KEY REFERENCES tb_Student(student_id),
subjects VARCHAR(255) FOREIGN KEY REFERENCES tb_Subject(subjects),
Marks INT
);
ALTER TABLE tb_Student ADD class VARCHAR(255);
ALTER TABLE tb_Student DROP COLUMN class;
INSERT INTO tb_Student (student_id, std_name, std_address, std_age)
VALUES (1, 'Ethan Thompson', 'Main Street', 25),
       (2, 'Olivia Parker', 'Oak Avenue', 32),
       (3, 'Liam Campbell', 'Elm Street', 41),
       (4, 'Ava Mitchell', 'Pine Avenue', 28),
       (5, 'Noah Anderson', 'Main Street', 35),
       (6, 'Sophia Turner', 'Oak Avenue', 25),
       (7, 'Benjamin Roberts', 'Elm Street', 41),
       (8, 'Isabella Hughes', 'Maple Lane', 32),
       (9, 'James Collins', 'Cedar Road', 28),
       (10, 'Mia Nelson', 'Pine Avenue', 35),
       (11, 'Samuel Young', 'Main Street', 41),
       (12, 'Emma Cooper', 'Elm Street', 25),
       (13, 'Alexander Ward', 'Maple Lane', 32),
       (14, 'Charlotte Hill', 'Cedar Road', 28),
       (15, 'Jacob Bennett', 'Oak Avenue', 35);
INSERT INTO tb_Subject(subjectCode, subjects)
VALUES ('MEC', 'Mechanical Engineering'),
       ('CIV', 'Civil Engineering'),
       ('ELE', 'Electrical Engineering'),
       ('CHE', 'Chemical Engineering'),
       ('CSE', 'Computer Science'),
       ('AER', 'Aerospace Engineering'),
       ('ENV', 'Environmental Engineering'),
       ('BME', 'Biomedical Engineering'),
       ('IND', 'Industrial Engineering'),
       ('MAT', 'Materials Science'),
       ('PET', 'Petroleum Engineering'),
       ('SWE', 'Software Engineering'),
       ('STR', 'Structural Engineering'),
       ('ROB', 'Robotics Engineering'),
       ('NUC', 'Nuclear Engineering');
INSERT INTO tb_Marks(student_id, Marks)
VALUES (1,64),(2, 25),(3, 79),(4, 15),(5, 57),(6, 41),(7, 76),(8, 3),(9, 35),(10, 68),(11, 22),(12, 52),(13, 70),(14, 29),(15, 46);

-- Display the student id with marks less than 32
SELECT std_name
FROM tb_Marks, tb_Student
WHERE tb_MARKS.Marks>40 AND tb_Marks.student_id = tb_Student.student_id;
--subquery
SELECT std_name FROM tb_Student
WHERE student_id IN (SELECT student_id FROM tb_Marks WHERE Marks>40); 

SELECT * FROM tb_Marks;
UPDATE  tb_Student SET std_name = 'Sabin Acharya'  WHERE student_id = 15;
SELECT std_name AS nam FROM tb_Student;
SELECT * FROM tb_Student
WHERE std_name = 'Sophia Turner' AND std_age = 25;
SELECT * FROM tb_Student
WHERE NOT std_name  = 'Ethan Thompson';
SELECT * FROM tb_Student
WHERE std_name = 'Sophia Turner' OR std_age = 25;

SELECT * FROM tb_Student
WHERE std_age BETWEEN 20 AND 30;
SELECT std_name FROM tb_Student
WHERE std_name LIKE  'E%';
SELECT std_name FROM tb_Student
WHERE std_name LIKE  '%et';
SELECT std_name FROM tb_Student
WHERE std_name LIKE  '_i%';
SELECT std_name FROM tb_Student
ORDER BY std_name ASC;
SELECT std_name FROM tb_Student
ORDER BY std_name DESC;
SELECT * FROM tb_Student
ORDER BY std_address ASC;                 
SELECT * FROM tb_Student;
SELECT * FROM tb_Subject;
SELECT * FROM tb_Marks;
TRUNCATE TABLE tb_Student;
DELETE FROM tb_Student
WHERE std_name = 'Sabin Acharya';
SELECT std_age FROM tb_Student;
ALTER TABLE tb_Student
ALTER COLUMN std_age VARCHAR(255);
DROP TABLE tb_Marks;
DROP TABLE tb_Student;
DROP TABLE tb_Subject;



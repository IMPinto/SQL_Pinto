CREATE SEQUENCE city_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE city (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    area VARCHAR(100)
);

CREATE SEQUENCE school_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE school (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES city(id)
);

CREATE SEQUENCE student_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE student (
    id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    school_id INT,
    FOREIGN KEY (school_id) REFERENCES school(id)
);

CREATE TABLE exams (
    id INT PRIMARY KEY,
    subject VARCHAR(100),
    student_id INT,
    test_date DATE,
    school_id INT,
    grade NUMBER(3),
    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (school_id) REFERENCES school(id)
);
-- INSERTS--
-- Inserts citys--
INSERT INTO city (id, name, area)
VALUES (city_seq.NEXTVAL, 'ירושלים', 'מרכז');

INSERT INTO city (id, name, area)
VALUES (city_seq.NEXTVAL, 'תל אביב', 'מרכז');

INSERT INTO city (id, name, area)
VALUES (city_seq.NEXTVAL, 'חיפה', 'צפון');

INSERT INTO city (id, name, area)
VALUES (city_seq.NEXTVAL, 'באר שבע', 'דרום');

-- Inserts schools--
INSERT INTO school (id, name, city_id)
VALUES (school_seq.NEXTVAL, 'תיכון הרצליה', 1);

INSERT INTO school (id, name, city_id)
VALUES (school_seq.NEXTVAL, 'תיכון בליך', 2);

INSERT INTO school (id, name, city_id)
VALUES (school_seq.NEXTVAL, 'מקיף חיפה', 3);

INSERT INTO school (id, name, city_id)
VALUES (school_seq.NEXTVAL, 'מקיף ד באר שבע', 4);

-- Inserts students--
INSERT INTO student (id, first_name, last_name, school_id)
VALUES (student_seq.NEXTVAL, 'שירה', 'כהן', 3);

INSERT INTO student (id, first_name, last_name, school_id)
VALUES (student_seq.NEXTVAL, 'דוד', 'לוי', 4);

INSERT INTO student (id, first_name, last_name, school_id)
VALUES (student_seq.NEXTVAL, 'נועה', 'ישראלי', 1);

INSERT INTO student (id, first_name, last_name, school_id)
VALUES (student_seq.NEXTVAL, 'יואב', 'ברק', 2);

INSERT INTO student (id, first_name, last_name, school_id)
VALUES (student_seq.NEXTVAL, 'טל', 'אוחנה', 3);

INSERT INTO student (id, first_name, last_name, school_id)
VALUES (student_seq.NEXTVAL, 'רוני', 'כהן', 1);

-- Inserts exams--
INSERT INTO exams (id, subject, student_id, test_date, school_id, grade)
VALUES (1, 'מתמטיקה', 1, TO_DATE('2025-06-01', 'YYYY-MM-DD'), 3, 88);

INSERT INTO exams (id, subject, student_id, test_date, school_id, grade)
VALUES (2, 'אנגלית', 2, TO_DATE('2025-06-02', 'YYYY-MM-DD'), 4, 92);

INSERT INTO exams (id, subject, student_id, test_date, school_id, grade)
VALUES (3, 'מדעים', 3, TO_DATE('2025-06-03', 'YYYY-MM-DD'), 1, 75);

INSERT INTO exams (id, subject, student_id, test_date, school_id, grade)
VALUES (4, 'היסטוריה', 4, TO_DATE('2025-06-05', 'YYYY-MM-DD'), 2, 90);

INSERT INTO exams (id, subject, student_id, test_date, school_id, grade)
VALUES (5, 'מתמטיקה', 5, TO_DATE('2025-06-06', 'YYYY-MM-DD'), 3, 85);

INSERT INTO exams (id, subject, student_id, test_date, school_id, grade)
VALUES (6, 'עברית', 6, TO_DATE('2025-06-07', 'YYYY-MM-DD'), 1, 78);

-- Simple Queries --
-- a --
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM student;

-- b --
SELECT name
FROM school;

-- c --
SELECT grade, subject
FROM exams
WHERE grade > 55;

-- d --
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM student
WHERE last_name LIKE 'ב%';

-- e -- 
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM student
ORDER BY first_name;

-- JOINS -- 
-- a --
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM student std
INNER JOIN school scl
ON std.SCHOOL_ID = scl.ID
ORDER BY LOWER(scl.name), LOWER(full_name);

-- b -- 
SELECT test_date, grade
FROM exams
WHERE TO_DATE('1995-01-01', 'YYYY-MM-DD') < test_date;

-- c --
SELECT CONCAT(st.first_name, ' ', st.last_name) AS full_name
FROM student st
INNER JOIN school sc
ON st.SCHOOL_ID = sc.ID
INNER JOIN city cty
ON sc.CITY_ID = cty.ID
WHERE cty.NAME = 'חיפה' AND sc.name = 'הריאלי';

-- d --
SELECT sc.NAME
FROM school sc
INNER JOIN city cty
ON sc.CITY_ID = cty.ID
WHERE LOWER(cty.AREA) = 'מרכז';

-- e --
SELECT sc.NAME, cty.AREA, cty.NAME AS city_name
FROM school sc
INNER JOIN city cty
ON sc.CITY_ID = cty.ID;

-- f --
SELECT CONCAT(st.first_name, ' ', st.last_name) AS full_name,
       AVG(ex.grade) AS average_grade
FROM student st
INNER JOIN exams ex ON st.id = ex.student_id
WHERE st.first_name = 'דפנה'
GROUP BY st.first_name, st.last_name;

-- g --
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       sch.name AS school_name,
       ex.subject,
       ex.grade
FROM exams ex
JOIN student s ON s.id = ex.student_id
JOIN school sch ON sch.id = s.school_id
JOIN city c ON sch.city_id = c.id
WHERE c.area = 'צפון';

-- GROUP BY -- 
-- a --
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       AVG(ex.grade) AS average_grade
FROM exams ex
JOIN student s ON s.id = ex.student_id
JOIN school sch ON sch.id = s.school_id
WHERE sch.name = 'תיכון לאומנויות'
GROUP BY s.id, s.first_name, s.last_name;

-- b --
SELECT sch.name AS school_name,
       AVG(ex.grade) AS average_grade
FROM exams ex
JOIN school sch ON ex.school_id = sch.id
GROUP BY sch.id, sch.name;

-- c --
SELECT AVG(ex.grade) AS biology_avg
FROM exams ex
JOIN school sch ON ex.school_id = sch.id
WHERE ex.subject = 'ביולוגיה'
  AND sch.name = 'העירוני א';

-- d -- 
SELECT sch.name AS school_name,
       AVG(ex.grade) AS chemistry_avg
FROM exams ex
JOIN school sch ON ex.school_id = sch.id
WHERE ex.subject = 'כימיה'
GROUP BY sch.id, sch.name
ORDER BY chemistry_avg DESC;

-- e --

-- f -- 
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name, 
       AVG(e.grade) AS avg_grade
FROM student s
JOIN exams e ON s.id = e.student_id
GROUP BY s.id, s.first_name, s.last_name
ORDER BY avg_grade DESC
FETCH FIRST 1 ROWS ONLY;

-- g --
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       AVG(e.grade) AS avg_math
FROM exams e
JOIN student s ON e.student_id = s.id
JOIN school sc ON s.school_id = sc.id
WHERE e.subject = 'מתמטיקה' AND sc.name = 'העירוני ב'
GROUP BY s.id, s.first_name, s.last_name
ORDER BY avg_math DESC
FETCH FIRST 1 ROWS ONLY;

-- h --
SELECT school_name, MAX(avg_grade) AS max_avg
FROM (
    SELECT sc.name AS school_name,
           s.id AS student_id,
           AVG(e.grade) AS avg_grade
    FROM student s
    JOIN school sc ON s.school_id = sc.id
    JOIN exams e ON s.id = e.student_id
    GROUP BY sc.name, s.id
)
GROUP BY school_name
ORDER BY max_avg ASC;

-- INSERT, UPDATE, DELETE --
-- a --
INSERT INTO student (id, first_name, last_name, school_id)
VALUES (student_seq.NEXTVAL, 'עמית', 'זיו', 2);

INSERT INTO exams (id, subject, student_id, test_date, school_id, grade)
VALUES (7, 'פיזיקה', 7, TO_DATE('2025-06-10', 'YYYY-MM-DD'), 2, 89);

INSERT INTO exams (id, subject, student_id, test_date, school_id, grade)
VALUES (8, 'ספרות', 7, TO_DATE('2025-06-12', 'YYYY-MM-DD'), 2, 93);

INSERT INTO exams (id, subject, student_id, test_date, school_id, grade)
VALUES (9, 'כימיה', 7, TO_DATE('2025-06-14', 'YYYY-MM-DD'), 2, 85);

-- b --
DELETE FROM exams
WHERE subject = 'אנגלית' AND grade < 40;

-- c --
UPDATE exams
SET grade = CASE 
    WHEN grade - 3 < 0 THEN 0
    ELSE grade - 3
END
WHERE subject = 'מתמטיקה';

-- d --
CREATE OR REPLACE VIEW northern_schools AS
SELECT sc.*
FROM school sc
JOIN city c ON sc.city_id = c.id
WHERE c.area = 'צפון';
CREATE TABLE school (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES city(id)
);

CREATE TABLE student (
    id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    school_id INT,
    FOREIGN KEY (school_id) REFERENCES school(id)
);

CREATE TABLE examination (
    id INT PRIMARY KEY,
    subject VARCHAR(100),
    student_id INT,
    creation_date DATE,
    school_id INT,
    grade NUMBER(3),
    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (school_id) REFERENCES school(id)
);

CREATE TABLE city (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    area VARCHAR(100)
);


-- 1 --
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM student;

-- 2 --
SELECT name
FROM school;

-- 3 --
SELECT grade, subject
FROM examination
WHERE grade >= 55;

-- 4 --
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM student
WHERE last_name LIKE 'ב%';

-- 5 -- 
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM student
ORDER BY first_name;

-- JOINS -- 
-- 6 --
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM student std
INNER JOIN school scl
ON std.SCHOOL_ID = scl.ID
ORDER BY scl.name, CONCAT(std.first_name, ' ', std.last_name);

-- 7 -- 
SELECT creation_date
FROM examination
WHERE TO_DATE('1995-01-01', 'YYYY-MM-DD') < CREATION_DATE;

-- 8 --
SELECT CONCAT(st.first_name, ' ', st.last_name) AS full_name
FROM student st
INNER JOIN school sc
ON st.SCHOOL_ID = sc.ID
INNER JOIN city cty
ON sc.CITY_ID = cty.ID
WHERE cty.NAME = 'חיפה';

-- 9 --
SELECT sc.NAME
FROM school sc
INNER JOIN city cty
ON sc.CITY_ID = cty.ID
WHERE cty.AREA = 'מרכז';

-- 10 --
SELECT sc.NAME, cty.AREA, cty.NAME AS city_name
FROM school sc
INNER JOIN city cty
ON sc.CITY_ID = cty.ID;

-- 11 --
SELECT CONCAT(st.first_name, ' ', st.last_name) AS full_name,
       AVG(ex.grade) AS average_grade
FROM student st
INNER JOIN examination ex ON st.id = ex.student_id
WHERE st.first_name = 'דפנה'
GROUP BY st.first_name, st.last_name;

-- 12 --
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       sch.name AS school_name,
       ex.subject,
       ex.grade
FROM examination ex
JOIN student s ON s.id = ex.student_id
JOIN school sch ON sch.id = s.school_id
JOIN city c ON sch.city_id = c.id
WHERE c.area = 'צפון';

-- 13 --
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       AVG(ex.grade) AS average_grade
FROM examination ex
JOIN student s ON s.id = ex.student_id
JOIN school sch ON sch.id = s.school_id
WHERE sch.name = 'תיכון לאומנויות'
GROUP BY s.id, s.first_name, s.last_name;


-- 14 --
SELECT sch.name AS school_name,
       AVG(ex.grade) AS average_grade
FROM examination ex
JOIN school sch ON ex.school_id = sch.id
GROUP BY sch.id, sch.name;


-- 15 --
SELECT AVG(ex.grade) AS biology_avg
FROM examination ex
JOIN school sch ON ex.school_id = sch.id
WHERE ex.subject = 'ביולוגיה'
  AND sch.name = 'העירוני א';

-- 16 -- 
SELECT sch.name AS school_name,
       AVG(ex.grade) AS chemistry_avg
FROM examination ex
JOIN school sch ON ex.school_id = sch.id
WHERE ex.subject = 'כימיה'
GROUP BY sch.id, sch.name
ORDER BY chemistry_avg DESC;


-- 18 -- 
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name, 
       AVG(e.grade) AS avg_grade
FROM student s
JOIN examination e ON s.id = e.student_id
GROUP BY s.id, s.first_name, s.last_name
ORDER BY avg_grade DESC
FETCH FIRST 1 ROWS ONLY;

-- 19 --
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       AVG(e.grade) AS avg_math
FROM examination e
JOIN student s ON e.student_id = s.id
JOIN school sc ON s.school_id = sc.id
WHERE e.subject = 'מתמטיקה' AND sc.name = 'העירוני ב'
GROUP BY s.id, s.first_name, s.last_name
ORDER BY avg_math DESC
FETCH FIRST 1 ROWS ONLY;

-- 20 --
SELECT school_name, MAX(avg_grade) AS max_avg
FROM (
    SELECT sc.name AS school_name,
           s.id AS student_id,
           AVG(e.grade) AS avg_grade
    FROM student s
    JOIN school sc ON s.school_id = sc.id
    JOIN examination e ON s.id = e.student_id
    GROUP BY sc.name, s.id
)
GROUP BY school_name
ORDER BY max_avg ASC;

-- 21 --
DELETE FROM examination
WHERE subject = 'אנגלית' AND grade < 40;

-- 22 --
UPDATE examination
SET grade = CASE 
    WHEN grade - 3 < 0 THEN 0
    ELSE grade - 3
END
WHERE subject = 'מתמטיקה';

-- 23 --
CREATE OR REPLACE VIEW northern_schools AS
SELECT sc.*
FROM school sc
JOIN city c ON sc.city_id = c.id
WHERE c.area = 'צפון';
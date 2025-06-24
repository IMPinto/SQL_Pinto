-- 1 --
ALTER TABLE schools
ADD student_count INT DEFAULT 0;

-- 2 --
CREATE TRIGGER update_student_count_on_delete
AFTER DELETE ON students
FOR EACH ROW
BEGIN
    UPDATE schools
    SET student_count = student_count - 1
    WHERE id = OLD.school_id;
END;

CREATE TRIGGER update_student_count_on_add
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    UPDATE schools
    SET student_count = student_count + 1
    WHERE id = NEW.school_id;
END;

CREATE OR REPLACE TRIGGER update_student_count_on_school_change
AFTER UPDATE OF school_id ON student
FOR EACH ROW
BEGIN
    IF :OLD.school_id != :NEW.school_id THEN
        -- Decrease count from old school
        UPDATE school
        SET student_amount = student_amount - 1
        WHERE id = :OLD.school_id;

        -- Increase count in new school
        UPDATE school
        SET student_amount = student_amount + 1
        WHERE id = :NEW.school_id;
    END IF;
END;

-- 3 --
DELETE FROM student;

DELETE FROM school;

DELETE FROM examination;

DELETE FROM CITY;

-- ? 4 ? --

-- ? 5 ? --

-- 6 --
ALTER TABLE city
ADD status INT DEFAULT 1;

-- 7 --
UPDATE city
SET status = 0
WHERE status IS NULL;

CREATE OR REPLACE PACKAGE israel_city_updater AS
    PROCEDURE israel_update_city;
END israel_city_updater;

CREATE OR REPLACE PACKAGE BODY israel_city_updater AS

    PROCEDURE israel_update_city IS
    BEGIN
        UPDATE city
        SET status = 2
        WHERE status = 1;
    END israel_update_city;

END israel_city_updater;

BEGIN
    israel_city_updater.israel_update_city;
END;

-- 8 --
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'update_city_status_job',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN israel_city_updater.israel_update_city; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=1',
        enabled         => TRUE
    );
END;
-- =========================================
-- Project Name: University Registration System
-- Faculty of Computers and Information
-- 
-- Team Members:
-- 1. Youssef Marzouk - ID: 24030213
-- 2. Mohamed Abdelaziz Elashmony - ID: 24030057
-- 3. Mohamed Ahmed Nagiub - ID: 24030175
-- 4. Abdallah Ayman SAQER - ID: 24030261
-- 5. MOHAMED AHMED HUSSEIN - ID: 24030244
-- =========================================

DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS schedule;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS server;
DROP TABLE IF EXISTS network_device;
DROP TABLE IF EXISTS room;
DROP TABLE IF EXISTS instructor;
DROP TABLE IF EXISTS department;
GO

CREATE TABLE department (
    dep_id INT PRIMARY KEY,
    dep_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    location VARCHAR(150),
    vlan_id INT,
    subnet VARCHAR(50)
);
GO

CREATE TABLE instructor (
    instructor_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE,
    dept_id INT,
    CONSTRAINT fk_instructor_dept 
        FOREIGN KEY (dept_id) REFERENCES department(dep_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);
GO

CREATE TABLE course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    credit INT CHECK (credit > 0),
    semester VARCHAR(20) CHECK (semester IN ('Fall', 'Spring', 'Summer')),
    dept_id INT,
    instructor_id INT,
    CONSTRAINT fk_course_dept 
        FOREIGN KEY (dept_id) REFERENCES department(dep_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    CONSTRAINT fk_course_instructor 
        FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id) 
        ON DELETE SET NULL 
        ON UPDATE NO ACTION
);
GO

CREATE TABLE student (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    gpa DECIMAL(3,2) CHECK (gpa >= 0.00 AND gpa <= 4.00),
    dep_id INT,
    enroll_date DATE,
    CONSTRAINT fk_student_dept 
        FOREIGN KEY (dep_id) REFERENCES department(dep_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);
GO

CREATE INDEX idx_student_name ON student(last_name, first_name);
CREATE INDEX idx_instructor_email ON instructor(email);
GO

CREATE TABLE grades (
    grade_id INT PRIMARY KEY,
    letter_grade CHAR(2) NOT NULL,
    grade_point DECIMAL(3,2) NOT NULL,
    min_score DECIMAL(5,2) NOT NULL,
    max_score DECIMAL(5,2) NOT NULL,
    CHECK (min_score <= max_score)
);
GO

CREATE TABLE enrollment (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enroll_date DATE,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active','completed','dropped','pending')),
    grade_id INT,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_enroll_student 
        FOREIGN KEY (student_id) REFERENCES student(student_id) 
        ON DELETE NO ACTION 
        ON UPDATE NO ACTION,
    CONSTRAINT fk_enroll_course 
        FOREIGN KEY (course_id) REFERENCES course(course_id) 
        ON DELETE NO ACTION 
        ON UPDATE NO ACTION,
    CONSTRAINT fk_enroll_grade 
        FOREIGN KEY (grade_id) REFERENCES grades(grade_id) 
        ON DELETE SET NULL 
        ON UPDATE NO ACTION
);
GO

CREATE TABLE network_device (
    device_id INT PRIMARY KEY,
    device_type VARCHAR(50),
    ip_address VARCHAR(15),
    mac_address VARCHAR(17),
    dept_id INT,
    CONSTRAINT fk_device_dept 
        FOREIGN KEY (dept_id) REFERENCES department(dep_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);
GO

CREATE TABLE server (
    server_id INT PRIMARY KEY,
    server_name VARCHAR(50),
    ip_address VARCHAR(15),
    service_type VARCHAR(50),
    dept_id INT,
    CONSTRAINT fk_server_dept 
        FOREIGN KEY (dept_id) REFERENCES department(dep_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);
GO

CREATE TABLE room (
    room_id INT PRIMARY KEY,
    building VARCHAR(255),
    dept_id INT,
    CONSTRAINT fk_room_dept 
        FOREIGN KEY (dept_id) REFERENCES department(dep_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);
GO

CREATE TABLE schedule (
    schedule_id INT PRIMARY KEY,
    day_of_week VARCHAR(20),
    start_time TIME,
    end_time TIME,
    course_id INT,
    room_id INT,
    CONSTRAINT fk_schedule_course 
        FOREIGN KEY (course_id) REFERENCES course(course_id) 
        ON DELETE NO ACTION 
        ON UPDATE NO ACTION,
    CONSTRAINT fk_schedule_room 
        FOREIGN KEY (room_id) REFERENCES room(room_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);
GO

INSERT INTO department VALUES
(1, 'Computer Science', '555-0101', 'Building A', 10, '192.168.10.0/24'),
(2, 'Mathematics',      '555-0102', 'Building B', 20, '192.168.20.0/24'),
(3, 'Physics',          '555-0103', 'Building C', 30, '192.168.30.0/24');

INSERT INTO instructor VALUES
(1, 'Alice',  'Morgan',  'a.morgan@uni.edu',  '2015-09-01', 1),
(2, 'James',  'Carter',  'j.carter@uni.edu',  '2018-01-15', 2),
(3, 'Sofia',  'Reyes',   's.reyes@uni.edu',   '2020-03-10', 3);

INSERT INTO course VALUES
(101, 'Introduction to Programming', 3, 'Fall',   1, 1),
(102, 'Calculus I',                  4, 'Spring', 2, 2),
(103, 'Mechanics',                   3, 'Fall',   3, 3);

INSERT INTO student VALUES
(1001, 'Omar',   'Hassan', 'o.hassan@uni.edu', 3.75, 1, '2022-09-01'),
(1002, 'Lina',   'Adel',   'l.adel@uni.edu',   3.50, 2, '2022-09-01'),
(1003, 'Karim',  'Samir',  'k.samir@uni.edu',  2.90, 1, '2023-01-15');

INSERT INTO grades VALUES
(1, 'A+', 4.00, 95.00, 100.00),
(2, 'A',  4.00, 90.00,  94.99),
(3, 'B+', 3.50, 85.00,  89.99),
(4, 'B',  3.00, 80.00,  84.99),
(5, 'C',  2.00, 70.00,  79.99),
(6, 'F',  0.00,  0.00,  69.99);

INSERT INTO enrollment VALUES
(1001, 101, '2022-09-05', 'completed', 2),
(1001, 102, '2022-09-05', 'active',    NULL),
(1002, 101, '2022-09-06', 'completed', 1),
(1003, 103, '2023-01-20', 'active',    NULL);

INSERT INTO network_device VALUES
(1, 'Switch', '192.168.10.2', 'AA:BB:CC:DD:EE:01', 1),
(2, 'PC', '192.168.10.10', 'AA:BB:CC:DD:EE:02', 1),
(3, 'Printer', '192.168.20.5', 'AA:BB:CC:DD:EE:03', 2);

INSERT INTO server VALUES
(1, 'Email Server', '192.168.90.10', 'SMTP/IMAP', 1),
(2, 'Web Server', '192.168.90.11', 'HTTP/HTTPS', 1);

INSERT INTO room VALUES
(101, 'Building A - Lab 1', 1),
(102, 'Building B - Hall 1', 2);

INSERT INTO schedule VALUES
(1, 'Monday', '09:00:00', '11:00:00', 101, 101),
(2, 'Wednesday', '12:00:00', '14:00:00', 102, 102);
GO

SELECT * FROM department;
SELECT * FROM instructor;
SELECT * FROM course;
SELECT * FROM student;
SELECT * FROM grades;
SELECT * FROM enrollment;
SELECT * FROM network_device;
SELECT * FROM server;
SELECT * FROM room;
SELECT * FROM schedule;

SELECT 
    s.student_id AS [رقم الطالب],
    s.first_name + ' ' + s.last_name AS [اسم الطالب],
    c.course_name AS [اسم الكورس],
    e.status AS [حالة التسجيل],
    ISNULL(g.letter_grade, 'N/A') AS [التقدير]
FROM enrollment e
JOIN student s ON e.student_id = s.student_id
JOIN course c ON e.course_id = c.course_id
LEFT JOIN grades g ON e.grade_id = g.grade_id;
GO


ALTER TABLE room ADD capacity INT;
GO

UPDATE student 
SET gpa = 3.85 
WHERE student_id = 1001;
GO

DELETE FROM network_device 
WHERE device_id = 3;
GO




CREATE DATABASE IF NOT EXISTS hr_management_project;
USE hr_management_project;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Login;
DROP TABLE IF EXISTS Payroll;
DROP TABLE IF EXISTS Performance;
DROP TABLE IF EXISTS Leave_Request;
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS Employee_Project;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Designation;


SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE Designation (
    desig_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    level INT NOT NULL
);

CREATE TABLE Department (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    manager_id INT NULL 
);

CREATE TABLE Employee (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    dept_id INT NOT NULL,
    desig_id INT NOT NULL,

    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (desig_id) REFERENCES Designation(desig_id)
);

CREATE TABLE Project (
    proj_id INT AUTO_INCREMENT PRIMARY KEY,
    proj_name VARCHAR(100) NOT NULL,
    dept_id INT NOT NULL,

    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Employee_Project (
    emp_id INT NOT NULL,
    proj_id INT NOT NULL,
    role VARCHAR(100),

    PRIMARY KEY (emp_id, proj_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (proj_id) REFERENCES Project(proj_id)
);
CREATE TABLE Attendance (
    att_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Leave', 'Holiday') NOT NULL DEFAULT 'Absent',

    UNIQUE (emp_id, date),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

CREATE TABLE Leave_Request (
    leave_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT,
    status ENUM('Pending', 'Approved', 'Rejected') NOT NULL DEFAULT 'Pending',
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    CHECK (start_date <= end_date)
);

CREATE TABLE Performance (
    perf_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    review_date DATE NOT NULL,
    rating DECIMAL(3, 1) NOT NULL,
    bonus DECIMAL(10, 2) DEFAULT 0.00,
    reviewer_emp_id INT NULL, 

    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (reviewer_emp_id) REFERENCES Employee(emp_id)
);

CREATE TABLE Payroll (
    pay_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    pay_date DATE NOT NULL,
    base_salary DECIMAL(10, 2) NOT NULL,
    deductions DECIMAL(10, 2) DEFAULT 0.00,
    net_salary DECIMAL(10, 2) AS (base_salary - deductions) STORED,
    
    UNIQUE (emp_id, pay_date),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);


CREATE TABLE Login (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL UNIQUE, 
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Manager', 'Employee') NOT NULL DEFAULT 'Employee',

    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

ALTER TABLE Department
ADD CONSTRAINT fk_department_manager
FOREIGN KEY (manager_id) REFERENCES Employee(emp_id)
ON DELETE SET NULL;


INSERT INTO Designation (title, level) VALUES
('Project manager', 1),    
('Networking specilist', 2),             
('UI/UX desinger', 1);         

INSERT INTO Department (dept_name) VALUES
('Technology'),               
('Human Resources');          

INSERT INTO Employee (first_name, last_name, email, phone, dept_id, desig_id) VALUES
('Dnyaneshwari', 'Taur', 'dnyaneshwari.t@hrms.com', '9876543210', 2, 3), 
('Suraj', 'Raut', 'suraj.r@hrms.com', '9870000001', 1, 1),           
('Siddhi', 'Dhait', 'siddhi.d@hrms.com', '9870000002', 1, 1);         


UPDATE Department
SET manager_id = 1 
WHERE dept_id = 2;


INSERT INTO Project (proj_name, dept_id) VALUES
('HRMS Implementation', 2), 
('Product Feature X', 1);   


INSERT INTO Employee_Project (emp_id, proj_id, role) VALUES
(1, 1, 'Project Lead'),       
(2, 2, 'Developer'),          
(3, 2, 'Developer');          


INSERT INTO Login (emp_id, username, password, role) VALUES
(1, 'dnyan_admin', 'hashed_pw_1', 'Admin'),
(2, 'suraj_user', 'hashed_pw_2', 'Employee'),
(3, 'siddhi_user', 'hashed_pw_3', 'Employee');


INSERT INTO Attendance (emp_id, date, status) VALUES
(1, '2025-10-21', 'Present'),
(2, '2025-10-21', 'Present'),
(3, '2025-10-21', 'Present'),
(1, '2025-10-22', 'Leave'),
(2, '2025-10-22', 'Present'),
(3, '2025-10-22', 'Present');


INSERT INTO Leave_Request (emp_id, start_date, end_date, reason, status) VALUES
(1, '2025-10-22', '2025-10-22', 'Urgent matter', 'Approved'),
(2, '2025-12-24', '2025-12-31', 'Family vacation', 'Pending');


INSERT INTO Performance (perf_id, emp_id, review_date, rating, bonus, reviewer_emp_id) VALUES
(1, 2, '2025-07-15', 4.5, 500.00, 1),
(2, 3, '2025-07-15', 4.2, 350.00, 1);


INSERT INTO Payroll (emp_id, pay_date, base_salary, deductions) VALUES
(1, '2025-09-30', 65000.00, 5000.00), -- Dnyaneshwari
(2, '2025-09-30', 72000.00, 6000.00), -- Suraj
(3, '2025-09-30', 70000.00, 5500.00); -- Siddhi

--
SELECT * FROM Designation;
SELECT * FROM Department;
SELECT * FROM Employee;
SELECT * FROM Project;
SELECT * FROM Employee_Project;
SELECT * FROM Login; 
SELECT * FROM Attendance;
SELECT * FROM Leave_Request;
SELECT * FROM Performance;
SELECT * FROM Payroll;



SELECT * FROM Employee;
UPDATE Employee
SET phone = '9999999999'
WHERE emp_id = 2;

DELETE FROM Attendance
WHERE att_id = 1;

SELECT * FROM Employee;
SELECT * FROM Attendance;

-- ✅ 1. Show all employees with their Department and Designation
SELECT 
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS Employee_Name,
    d.dept_name AS Department,
    des.title AS Designation,
    e.email,
    e.phone
FROM Employee e
JOIN Department d ON e.dept_id = d.dept_id
JOIN Designation des ON e.desig_id = des.desig_id;

DROP PROCEDURE IF EXISTS Show_Employee_Names;
DELIMITER //

CREATE PROCEDURE Show_Employee_Names()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE total INT;

    -- Count total employees
    SELECT COUNT(*) INTO total FROM Employee;

    -- Loop through all employee IDs
    WHILE i <= total DO
        SELECT CONCAT('Employee ID: ', emp_id, ' | Name: ', first_name, ' ', last_name) AS Employee_Info
        FROM Employee
        WHERE emp_id = i;
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

--  Call the procedure to display result
CALL Show_Employee_Names();


DROP PROCEDURE IF EXISTS Show_Employee_Projects;

DELIMITER //

CREATE PROCEDURE Show_Employee_Projects()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE empId INT;
    DECLARE projId INT;

    -- Declare cursor for Employee_Project table
    DECLARE ep_cursor CURSOR FOR 
        SELECT emp_id, proj_id FROM Employee_Project;

    -- Handler for end of cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open cursor
    OPEN ep_cursor;

    read_loop: LOOP
        FETCH ep_cursor INTO empId, projId;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Display employee ID and project ID
        SELECT CONCAT('Employee ID: ', empId, ' | Project ID: ', projId) AS Assignment_Info;
    END LOOP;

    -- Close cursor
    CLOSE ep_cursor;
END //

DELIMITER ;

-- ✅ Call the procedure
CALL Show_Employee_Projects();



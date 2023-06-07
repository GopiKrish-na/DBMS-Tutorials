CREATE DATABASE employee;

-- Create tbl_employee table
CREATE TABLE tbl_employee (
  employee_name VARCHAR(255) PRIMARY KEY,
  street VARCHAR(255),
  city VARCHAR(255)
);

-- Create tbl_company table
CREATE TABLE tbl_company (
  company_name VARCHAR(255) PRIMARY KEY,
  city VARCHAR(255)
);

-- Create tbl_works table
CREATE TABLE tbl_works (
  employee_name VARCHAR(255),
  company_name VARCHAR(255),
  salary DECIMAL(10, 2),
  PRIMARY KEY (employee_name, company_name),
  FOREIGN KEY (employee_name) REFERENCES tbl_employee(employee_name),
  FOREIGN KEY (company_name) REFERENCES tbl_company(company_name)
);

-- Create tbl_manages table
CREATE TABLE tbl_manages (
  employee_name VARCHAR(255),
  manager_name VARCHAR(255),
  PRIMARY KEY (employee_name),
  FOREIGN KEY (employee_name) REFERENCES tbl_employee(employee_name),
  FOREIGN KEY (manager_name) REFERENCES tbl_employee(employee_name)
);

-- Insert random names into tbl_employee
INSERT INTO tbl_employee (employee_name, street, city)
VALUES
  ('John Doe', '123 Main St', 'New York'),
  ('Jane Smith', '456 Elm St', 'Los Angeles'),
  ('Michael Johnson', '789 Oak St', 'Chicago'),
  ('Emily Davis', '789 Oak st', 'Chicago'),
  ('David Lee', '555 Maple Ave', 'Seattle'),
  ('Sarah Adams', '777 Cedar Ln', 'Boston');

-- Insert random company names into tbl_company
INSERT INTO tbl_company (company_name, city)
VALUES
  ('First Bank Corporation', 'Seattle'),
  ('ABC Industries', 'Houston'),
  ('XYZ Corporation', 'Boston'),
  ('Acme Enterprises', 'Miami');

-- Insert random data into tbl_works
INSERT INTO tbl_works (employee_name, company_name, salary)
VALUES
  ('John Doe', 'First Bank Corporation', 5000.00),
  ('Jane Smith', 'ABC Industries', 4000.00),
  ('Michael Johnson', 'First Bank Corporation', 4500.00),
  ('Emily Davis', 'Acme Enterprises', 5500.00),
  ('David Lee', 'First Bank Corporation', 4800.00),
  ('Sarah Adams', 'XYZ Corporation', 5200.00);

-- Insert random data into tbl_manages
INSERT INTO tbl_manages (employee_name, manager_name)
VALUES
  ('John Doe', 'Michael Johnson'),
  ('Jane Smith', 'Michael Johnson'),
  ('Emily Davis', 'Michael Johnson'),
  ('David Lee', 'Sarah Adams');
------------------------------------------------------------------------------------------------
/* The join condition specifies that rows from tbl_employee (e) and tbl_works (w) should be combined or 
matched where the employee_name values in both tables are equal. It fetches the records 
where an employee from tbl_employee has a corresponding entry in tbl_works. */

-- Fetching employee name that work for First Bank Corporation

SELECT e.employee_name
FROM tbl_employee e
JOIN tbl_works w ON e.employee_name = w.employee_name
JOIN tbl_company c ON w.company_name = c.company_name
WHERE c.company_name = 'First Bank Corporation';

-- without joining

SELECT employee_name FROM tbl_employee
WHERE employee_name IN (SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank Corporation');
----------------------------------------------------------------------------------------------------------------
-- Fetching name and city of the employee that work for First Bank Corporation

SELECT employee_name, city FROM tbl_employee
WHERE employee_name IN (SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank Corporation');

-- Fetching name, street address and city of the employee that wotk for First Bank Corporation

SELECT employee_name, street, city FROM tbl_employee
WHERE employee_name IN (SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank Corporation');
-----------------------------------------------------------------------------------------------------------------
-- Fetching employee name that work in the same city as the companies they work

SELECT employee_name, city
FROM tbl_employee
WHERE city IN (SELECT city FROM tbl_company WHERE company_name IN 
(SELECT company_name FROM tbl_works WHERE employee_name = tbl_employee.employee_name));

/* Its' easier to understand using join */

SELECT e.employee_name, e.city
FROM tbl_employee e
JOIN tbl_works w ON e.employee_name = w.employee_name
JOIN tbl_company c ON w.company_name = c.company_name AND e.city = c.city;
---------------------------------------------------------------------------------------------------------------------
-- Display the employees who live in the same cities and street as their manager

SELECT employee_name, street, city
FROM tbl_employee
WHERE CONCAT(street, city) IN (   
SELECT CONCAT(street, city)
    FROM tbl_employee AS manager
    WHERE manager.employee_name IN (
        SELECT manager_name
        FROM tbl_manages
        WHERE employee_name = tbl_employee.employee_name
    )
);
/* CONCAT() function is used to combine the street and city columns into a 
single string in both the outer and inner subqueries. By doing this, we can 
compare the combined values using the IN clause. */

/* JOIN on the go */

SELECT e.employee_name, e.street, e.city
FROM tbl_employee e
JOIN tbl_employee m ON e.street = m.street AND e.city = m.city
JOIN tbl_manages mg ON e.employee_name = mg.employee_name AND m.employee_name = mg.manager_name;
---------------------------------------------------------------------------------------------------------------
-- Display the employees name who do not work for First Bank Corporation

SELECT employee_name FROM tbl_employee
WHERE employee_name NOT IN (SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank Corporation');


SELECT * FROM tbl_employee;
SELECT * FROM tbl_company;
SELECT * FROM tbl_works;
SELECT * FROM tbl_manages;

DROP TABLE tbl_employee;
DROP TABLE tbl_company;
DROP TABLE tbl_works;
DROP TABLE tbl_manages;

/******************************************** 
Name: Bal Krishna Shah (THA077BEI010)
***********************************************/

CREATE DATABASE db_employee;

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
  ('Small Bank Corporation', 'Houston'),
  ('XYZ Corporation', 'Boston'),
  ('Acme Enterprises', 'Miami'),
  ('ABC Industries', 'Houston');

-- Insert random data into tbl_works
INSERT INTO tbl_works (employee_name, company_name, salary)
VALUES
  ('John Doe', 'First Bank Corporation', 5000.00),
  ('Jane Smith', 'Small Bank Corporation', 4000.00),
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

-- CROSS JOIN

SELECT * FROM tbl_employee CROSS JOIN tbl_works;
------------------------------------------------------------------------------------------------
/* The join condition specifies that rows from tbl_employee (e) and tbl_works (w) should be combined or 
matched where the employee_name values in both tables are equal. It fetches the records 
where an employee from tbl_employee has a corresponding entry in tbl_works. */

-- Fetching employee name that work for First Bank Corporation

SELECT e.employee_name
FROM tbl_employee e
JOIN tbl_works w ON e.employee_name = w.employee_name
--JOIN tbl_company c ON w.company_name = c.company_name
WHERE w.company_name = 'First Bank Corporation';

-- without joining

SELECT employee_name FROM tbl_employee
WHERE employee_name IN (SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank Corporation');
----------------------------------------------------------------------------------------------------------------
-- Fetching name and city of the employee that work for First Bank Corporation

SELECT employee_name, city FROM tbl_employee
WHERE employee_name IN (SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank Corporation');

-- using INNER JOIN
SELECT e.employee_name, e.city
FROM tbl_employee e
JOIN tbl_works w ON e.employee_name = w.employee_name
WHERE w.company_name = 'First Bank Corporation';
------------------------------------------------------------------------------------------------------------

-- Fetching name, street address and city of the employee that wotk for First Bank Corporation and earns more than $4500

SELECT employee_name, street, city FROM tbl_employee
WHERE employee_name IN (SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank Corporation' AND salary > 4500);

SELECT e.employee_name, e.street, e.city
FROM tbl_employee e
JOIN tbl_works w ON e.employee_name = w.employee_name
WHERE w.company_name = 'First Bank Corporation' AND w.salary >4500;
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

-- Display employee name having higher salary than each employee of Small Bank Corporation

SELECT employee_name FROM tbl_works 
WHERE company_name <> 'Small Bank Corporation'
GROUP BY employee_name
HAVING MAX(salary) > (SELECT MAX(salary) FROM tbl_works WHERE company_name ='Small Bank Corporation');

-- Display  company name which is in the same city as Small Bank Corporation

SELECT company_name FROM tbl_company
WHERE city IN (SELECT city FROM tbl_company WHERE company_name = 'Small Bank Corporation') AND company_name <> 'Small Bank Corporation';

-------------------------------------------------------------------------------------------------------------------
-- Display the name of employees that earn higher than the average salary of all employees they work in

SELECT e.employee_name
FROM tbl_employee e
JOIN tbl_works w ON e.employee_name = w.employee_name
JOIN ( SELECT company_name, AVG(salary) AS avg_salary
  FROM tbl_works
  GROUP BY company_name ) AS avg ON w.company_name = avg.company_name
WHERE w.salary > avg.avg_salary;

-- simple

SELECT employee_name FROM tbl_works
WHERE salary > (SELECT AVG(salary) FROM tbl_works w WHERE w.company_name = tbl_works.company_name);
------------------------------------------------------------------------------------------------------------

-- company with the highest number of employee

SELECT company_name
FROM tbl_works
GROUP BY company_name
HAVING COUNT(*) = ( SELECT MAX(emp_count) FROM ( SELECT company_name, COUNT(*) AS emp_count
    FROM tbl_works
    GROUP BY company_name
  ) AS counts
);

-- company with the smallest  payroll
SELECT TOP 1 company_name
FROM tbl_works
GROUP BY company_name
ORDER BY SUM(salary) ASC ;

-- company whose employee earns higher on avg than avg of First Bank Corporation
SELECT company_name
FROM tbl_works
GROUP BY company_name
HAVING AVG(salary) > ( SELECT AVG(salary) FROM tbl_works WHERE company_name = 'First Bank Corporation' );

-- John now livs in Newtown

UPDATE tbl_employee
SET city = 'Newtown'
WHERE employee_name = 'John Doe';

-- 10% raise to employee of First Bank Corporation

UPDATE tbl_works
SET salary = salary * 1.1
WHERE company_name = 'First Bank Corporation';

-- 10% raise to the manager of first bank corporation

UPDATE tbl_works
SET salary = salary * 1.1
WHERE employee_name IN (
  SELECT manager_name
  FROM tbl_manages
  WHERE company_name = 'First Bank Corporation');

-- 10 % raise to the managers of first bank corporation unless $100000 after that 3% raise

UPDATE tbl_works
SET salary = 
  CASE
    WHEN salary * 1.1 <= 100000 THEN salary * 1.1
    ELSE salary * 1.03
  END
WHERE employee_name IN (
  SELECT manager_name
  FROM tbl_manages
  WHERE company_name = 'First Bank Corporation'
);

-- delete all data of employee in tbl_works of Small bank corporation
DELETE FROM tbl_works
WHERE company_name = 'Small Bank Corporation';





SELECT * FROM tbl_employee;
SELECT * FROM tbl_company;
SELECT * FROM tbl_works;
SELECT * FROM tbl_manages;

DROP TABLE tbl_employee;
DROP TABLE tbl_company;
DROP TABLE tbl_works;
DROP TABLE tbl_manages;



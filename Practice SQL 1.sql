SELECT TOP (1000) [emp_no]
      ,[emp_title_id]
      ,[birth_date]
      ,[first_name]
      ,[last_name]
      ,[sex]
      ,[hire_date]
  FROM [Employee].[dbo].[employees]

 INSERT INTO Employee.dbo.employees(emp_no, emp_title_id, birth_date, first_name,last_name,sex,hire_date)
 VALUES (101624, 'd0001', '10-04-1990', 'Dipal','Paneri','F', '01-01-2024');

 SELECT * FROM Employee.dbo.employees;

 UPDATE Employee.dbo.employees
 SET last_name = 'Aditya' 
 WHERE emp_title_id = 'd0001';

 --WHERE YEAR(birth_date) < 1998 specifies the condition for deletion, where it deletes rows where the year from the birth_date column is less than 1998.
 DELETE FROM Employee.dbo.employees WHERE Year(birth_date) > 1998
 
 SELECT * FROM Employee.dbo.employees;
 SELECT * FROM Employee.dbo.salaries;
 SELECT * FROM Employee.dbo.departments;

 --SQL Query fetch data where employee salary is higher than 50000
 SELECT E.hire_date, first_name, E.last_name, S.salary
 FROM Employee.dbo.employees E
 FULL JOIN Employee.dbo.salaries AS S
 ON E.emp_no = S.emp_no
 WHERE salary > 50000
 ORDER BY  salary;

 SELECT E.emp_no, DM.dept_no, D.dept_name, E.first_name + ' ' + E.last_name AS Full_Name, S.salary, ISNULL(DM.dept_no, 0)
 from Employee.dbo.employees AS E
 FULL JOIN Employee.dbo.dept_manager DM ON E.emp_no = DM.emp_no
 FULL JOIN Employee.dbo.departments D ON D.dept_no = DM. dept_no
 FULL JOIN Employee.dbo.salaries S ON E.emp_no = S.emp_no
 WHERE S.salary BETWEEN 50000 AND 80000
 ORDER BY S.salary DESC;

 SELECT E.first_name+' '+E.last_name AS Full_name, E.emp_title_id, S.salary, T.title
 FROM Employee.dbo.employees E --Employee.dbo.salaries S, Employee.dbo.departments D
 LEFT JOIN Employee.dbo.titles AS T ON E.emp_title_id = T.title_id
 LEFT JOIN Employee.dbo.salaries AS S ON E.emp_no = S.emp_no
 WHERE S.salary > 70000 --(SELECT AVG(salary) FROM Employee.dbo.salaries)
 ORDER BY Full_name, salary DESC;

-- Aggregate Functions
SELECT 
	CASE 
		WHEN sex = 'M' THEN 'Men'
		WHEN sex = 'F' THEN 'Female'
		ELSE 'other'
	END AS Gender,
	COUNT(*) AS Total_Employees
FROM Employee.dbo.employees 
GROUP BY sex ;
--Total No of Female Employees - 120052, Male Employees - 179973

SELECT emp_no, first_name, last_name, sex, DATEDIFF(year, birth_date, GETDATE()) AS age
FROM Employee.dbo.employees

SELECT emp_no, first_name, last_name, sex, DATEDIFF(year, birth_date, GETDATE()) AS age
INTO #Age_Employee
FROM Employee.dbo.employees
SELECT * FROM #Age_Employee
ORDER BY age;

--Added the age column in employee table to perform analysis on the data later. 
ALTER TABLE Employee.dbo.employees
ADD age AS DATEDIFF(year, birth_date, GETDATE());

SELECT * FROM Employee.DBO.employees

--Age is calculated column we inserted in the database where age status is the resultset we need for this query.
SELECT emp_no, first_name, last_name, sex, employees.age,
CASE 
	WHEN age > 35 THEN 'Old'
	WHEN age <= 35 THEN 'Adult'
	ELSE 'Retirement Approaching'
END AS Age_Stat	
FROM Employee.dbo.employees
ORDER BY age;

SELECT * FROM Employee.dbo.titles

SELECT E.first_name+' '+E.last_name AS emp_name, T.title, S.salary,
CASE 
	WHEN T.title = 'Senior Engineer' THEN S.salary + (S.salary * 0.15) 
	WHEN T.title = 'Engineer' THEN S.salary + (S.salary * 0.10) 
	WHEN T.title = 'Manager' THEN S.salary + (S.salary * 0.07) 
	ELSE S.salary + (S.salary * 0.03) 
END AS total_raise
FROM Employee.dbo.employees E
JOIN Employee.dbo.titles T ON E.emp_title_id = T.title_id
JOIN Employee.dbo.salaries S ON E.emp_no = S.emp_no
ORDER BY S.salary DESC;

--LIKE and Wildcards
SELECT * FROM Employee.dbo.employees 
WHERE first_name LIKE '[aidb]%';

SELECT * FROM Employee.dbo.employees 
WHERE first_name LIKE '[_aidb]%';

--String Function, Date Function, Numeric Function
SELECT DATEPART(YEAR,birth_date) AS BIrth_Year, COUNT(*) AS No_Empl
FROM Employee.dbo.employees
GROUP BY DATEPART(YEAR,birth_date);

SELECT DATEPART(MONTH,birth_date) AS BIrth_Month, COUNT(*) AS No_Empl
FROM Employee.dbo.employees
GROUP BY DATEPART(MONTH,birth_date)
ORDER BY BIrth_Month ASC;

SELECT DATEPART(WEEKDAY,birth_date) AS BIrth_Day, COUNT(*) AS No_Empl
FROM Employee.dbo.employees
GROUP BY DATEPART(WEEKDAY,birth_date);

SELECT DATEPART(D, hire_date) AS Start_date, COUNT(*) AS EMP
FROM Employee.dbo.employees
GROUP BY DATEPART(D, hire_date)
ORDER BY DATEPART(D, hire_date) ASC;

--GETDATE() to fetch todays Date and Time
SELECT GETDATE();
SELECT DATEADD(DAY, 1, GETDATE()); -- ADD one day to Getdate() ie.e 29th March 2024
SELECT DATEDIFF(DAY, '2023-01-01', '2024-01-01'); -- Shows diffrenece of No of Days bwteen two dates

-- Returns a specific part of a date, Month, Year.
SELECT DATEPART(YEAR, GETDATE());
SELECT DATEPART(YEAR, '10-04-1990'),DATEPART(MONTH, GETDATE()), DATEPART(DAY,'10-04-1990');

SELECT FORMAT(GETDATE(), 'yyyy-MMM-dddd HH:mm:ss');
--MM - Month Number, mmm-Month in 3 char, mmmm- Month Name
-- dd- Numeric Day, ddd- THU, FRI, Mon, dddd-Sunday, Monday, tuesday
SELECT FORMAT(GETDATE(), 'dd-MMMM-yyyy'); --Month will be Capital M always


SELECT * FROM Employee.dbo.employees
SELECT * FROM Employee.dbo.departments
SELECT * FROM Employee.dbo.salaries

--SUBQUERY
SELECT E.first_name, E.last_name, S.salary
FROM Employee.dbo.employees E, Employee.dbo.salaries S, Employee.dbo.departments D
--Left Join Employee.dbo.salaries S ON E.emp_no = S.emp_no
--LEFT JOIN Employee.dbo.departments D ON E.emp_title_id = D.dept_no
WHERE S.salary > (SELECT Max(salary) FROM Employee.dbo.salaries 
				WHERE D.dept_no = (SELECT dept_no FROM Employee.dbo.departments 
									WHERE dept_name = 'Marketing'));

SELECT E.first_name+' '+E.last_name AS full_name, 
		S.salary,	
		AVG(S.salary) as avg_sal
FROM Employee.dbo.salaries S
JOIN Employee.dbo.employees E ON S.emp_no = E.emp_no
GROUP BY E.first_name, E.last_name, S.salary;

--SUbquery In from
SELECT * FROM 
(SELECT emp_no, AVG(salary) over(Partition BY emp_no) as avg_sal FROM Employee.dbo.salaries)  AS Subquery

--Subquery in Where 
SELECT E.emp_no, E.emp_title_id, S.salary
FROM Employee.dbo.salaries S
JOIN Employee.dbo.employees E ON S.emp_no = E.emp_no
Where E.emp_title_id in (SELECT emp_title_id FROM Employee.dbo.employees)

--String Functions
SELECT SUBSTRING('Hello World', 1, 6) AS substring_result;

--Replace String 
SELECT REPLACE('HELLO WORLD','WORLD','UNIVERSE');
SELECT TRIM('   Hello   ') AS trimmed_string;
SELECT LTRIM('   Hello')
SELECT RTRIM('Hello          ')
SELECT LEFT('Hello World', 5)
SELECT RIGHT('Hello World', 5)
SELECT CHARINDEX('Hey There', 'Hey') AS position;
SELECT CHARINDEX('World', 'Hello World') AS position;

--Concatanate multiple Strings
SELECT CONCAT_WS('-', '2022', '01', '01') AS formatted_date;
SELECT REVERSE('Hello') AS reversed_string;

SELECT FORMAT(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')
SELECT FORMAT(CONVERT(datetime, '4 OCT 1990', 106), 'yyyy-MM-dd') AS formatted_date;
SELECT CONVERT(VARCHAR(19), CURRENT_TIMESTAMP, 120) AS formatted_datetime;

SELECT CONVERT(NVARCHAR(20),CURRENT_TIMESTAMP, 120)
SELECT CONVERT(NVARCHAR(20),CURRENT_TIMESTAMP, 130) --TIMESTAMP OF ARAB COUNTRIES
SELECT CURRENT_TIMESTAMP ;
SELECT SYSDATETIME()

SELECT ROUND(12.76, 1) AS rounded_value;
SELECT CEILING(123.456) AS ceiling_value;
SELECT FLOOR(316.786)
SELECT ABS(-146.7)
SELECT 10 % 3 AS modulus_value;

--NESTED Queries
SELECT E.first_name, E.last_name
FROM Employee.dbo.employees AS E 
JOIN Employee.dbo.departments AS D ON E.emp_title_id = D.dept_no
JOIN Employee.dbo.salaries AS S ON E.emp_no = S.emp_no
WHERE D.dept_no = (
    SELECT TOP 1 dept_no, emp_title_id
    FROM Employee.dbo.salaries
	--JOIN Employee.dbo.salaries AS S ON E.emp_no = S.emp_no
    GROUP BY dept_no, emp_title_id
    ORDER BY AVG(S.salary) DESC 
);

--Having Clouse 
SELECT T.title_id, T.title, S.salary , COUNT(T.title)
FROM Employee.dbo.employees AS E 
JOIN Employee.dbo.titles AS T ON E.emp_title_id = T.title_id
JOIN Employee.dbo.salaries AS S ON E.emp_no = S.emp_no
GROUP BY T.title, T.title_id, S.salary
HAVING COUNT(T.title) > 1 
ORDER BY T.title DESC;

--Calculating No of employees In each Position Group in the Company.
SELECT  T.title, COUNT(T.title) AS No_Emp
FROM Employee.dbo.employees AS E 
JOIN Employee.dbo.titles AS T ON E.emp_title_id = T.title_id
GROUP BY T.title
HAVING COUNT(T.title) > 1 
ORDER BY T.title DESC;
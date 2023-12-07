-- Querying all rows and columns from the teachers table
SELECT * FROM teachers;
-- Querying specific columns from a table
SELECT last_name, first_name, salary FROM teachers;

-- Using DISTINCT to eliminate duplicates
SELECT DISTINCT school
FROM teachers;
-- DISTINCT also works on multiple columns and satisfies the unique values in both columns
SELECT DISTINCT school, salary
FROM teachers;

-- sorting a column using ORDER BY
SELECT first_name, last_name, salary
FROM teachers
ORDER BY salary DESC;
-- we can also sort multiple columns
SELECT last_name, school, hire_date
FROM teachers
ORDER BY school ASC, hire_date DESC;

-- Filtering rows using WHERE
SELECT last_name, school, hire_date
FROM teachers
WHERE school = 'Myers Middle School';

-- Examples of 'WHERE' comparison operators

-- Teachers with first name of Janet
SELECT first_name, last_name, school
FROM teachers
WHERE first_name = 'Janet';

-- School names not equal to F.D. Roosevelt HS
SELECT school
FROM teachers
WHERE school != 'F.D. Roosevelt HS';

-- Teachers hired before Jan. 1, 2000
SELECT first_name, last_name, hire_date
FROM teachers
WHERE hire_date < '2000-01-01';

-- Teachers earning 43,500 or more
SELECT first_name, last_name, salary
FROM teachers
WHERE salary >= 43500;

-- Teachers who earn between $40,000 and $65,000
SELECT first_name, last_name, school, salary
FROM teachers
WHERE salary BETWEEN 40000 AND 65000;

-- Listing 2-8: Filtering with LIKE AND ILIKE
SELECT first_name
FROM teachers
WHERE first_name LIKE 's_am';

SELECT first_name
FROM teachers
WHERE first_name ILIKE 'sam%';

-- Listing 2-9: Combining operators using AND and OR
SELECT *
FROM teachers
WHERE school = 'Myers Middle School'
      AND salary < 40000;

SELECT *
FROM teachers
WHERE last_name = 'Cole'
      OR last_name = 'Bush';

SELECT *
FROM teachers
WHERE school = 'F.D. Roosevelt HS'
      AND (salary < 38000 OR salary > 40000);

-- Listing 2-10: A SELECT statement including WHERE and ORDER BY
SELECT first_name, last_name, school, hire_date, salary
FROM teachers
WHERE school LIKE '%Roos%'
ORDER BY hire_date DESC;

-- TRY it yourself 1
SELECT school, first_name, last_name
FROM teachers
Order by school, last_name;

-- TRY it yourself 2
SELECT first_name, last_name, school, salary
FROM teachers
WHERE first_name LIKE 'S%' and salary > '40000'

-- TRY it yourself 3
SELECT first_name, last_name, school, hire_date, salary
FROM teachers
WHERE hire_date > '2010-01-01'
ORDER BY salary DESC;
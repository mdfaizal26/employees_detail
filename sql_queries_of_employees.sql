-------Empolyees Table--------------
create table employees(
Employee_ID int primary key,
Name varchar(50) not null,
Department_ID int,
Designation	varchar(50),
Salary int,
Joining_Date date
);
select * from employees;

-----Departments Table------------
create table departments(
Department_ID int,
Department_Name varchar(50)
);
select * from departments;

------Attendances Table---------------
drop table if exists attendances;
create table attendances(
Attendance_ID int,
Employee_ID int,
Date date,
Status varchar
);
select * from attendances;
select * from employees;
select * from departments;

---------Queries------------------

--1) Find the total number of employees.
    select count(*) as total_employees
	from employees;

--2) Find minimun and maximun salary of employees
    select max(salary) as max_salary, min(salary) as min_salary
	from employees;

--3) Find the average salary of employees.
    select employee_id,name, avg(salary)as avg_salary
	from employees
	group by employee_id,name;

--4) Count employees per department.
    select department_id, count(employee_id)as total_employees
	from employees
	group by department_id;

--5) List all employees joined after 2020.
    select *
	from employees
	where joining_date>'2020-01-01';

--6) Show distinct designations.
    select distinct designation
	from employees;

--7) find the top 10 highest salaries.	
	select employee_id,name,salary
	from employees
	order by salary desc 
	limit 10;

--8) Employees with salary less than 40,000.
    select employee_id,name,salary
	from employees
	where salary<40000;

--9) Employees sorted by joining date (earliest first)
   select employee_id, name, joining_date
   from employees
   order by joining_date asc
   limit 1;

--10) Find total attendance records.
    select count(*) as total_attendance
	from attendances;

	
--11) find Department-wise average salary.
     select e.employee_id,e.name,avg(e.salary),d.department_name
	 from employees e
	 join departments d
	 on e.department_id = d.department_id
	 group by e.employee_id,e.name,d.department_name;

--12) find	Employees with salary above department average.
    select e.name, e.salary, d.department_Name
    from employees e
    join departments d on e.department_id = d.Department_id
    where e.salary > (
    select avg(salary)
    from employees 
    where  department_Id = e.Department_Id
);

--13) Department with maximum employees.
    select d.department_name, count(e.employee_id) as total_employees
    from employees e
    join departments d on e.department_id = d.department_id
    group by d.Department_Name
    order by Total_Employees desc
    limit 1;

--14) Attendance percentage of each employee.
     select e.name,
     count
	 (case when a.Status = 'Present'
	         then 1 
			 end) * 100.0 / count(*) as attendance_percentage
     from employees e
     join attendances a on e.employee_id = a.employee_id
     group by e.name;

--15) Number of employees joined each year.
     select  extract(year from Joining_Date) as year, count(*) as employees_joined
     from employees
    group by year
     order by year;

--16) Department-wise highest salary.
    select d.department_name, max(e.salary) as max_salary
    from employees e
   join departments d on e.department_id = d.department_id
   group by d.Department_Name;

--17) Find absent count per employee..
    select e.name, count(*) as Absent_Days
   from employees e
   join attendances a ON e.employee_id = a.employee_id
   where a.status = 'Absent'
  group by e.name;

--18) Top 5 employees with highest attendance.
    select e.name, count(*) as  present_days
   from employees e
   join attendances a on e.employee_id = a.employee_id
   where a.Status = 'Present'
   group by e.Name
   order by Present_Days desc
   limit 5;

--19) Rank employees by salary within each department.
     select e.name, d.department_name, e.salary,
     rank() over (partition by d.department_Name order by e.salary desc) as Salary_Rank
      from employees e
      join departments d on e.department_id = d.department_id;

--20)Find top 3 highest salaries per department..
    
   select *
   from (
    select e.name, d.department_Name, e.salary,
           dense_rank() over (partition by d.department_name order by e.Salary desc)as Salary_Rank
    from employees e
    join departments d on e.department_id = d.department_id
    ) ranked
    where salary_rank <= 3;

--21) Running total of salaries ordered by joining date.
    select name, joining_date, salary,
    sum(salary) over (order by joining_date) as running_total_salary
    from employees;

--22)Employees whose salary is above overall average..
    select name, salary 
    from employees
    where salary > (
	select avg(Salary) 
	from employees
	);

--23)Find departments where avg salary > overall avg salary.
    select d.department_name, avg(e.salary) as dept_avg_salary
    from employees e
    join departments d on e.department_ID = d.Department_ID
   group by d.department_Name
   having avg(e.salary) > (
   select avg(Salary) 
   from employees);

--24)Employee with earliest joining date in each department.
     select e.name, d.department_Name, e.joining_date
    from employees e
   join departments d on e.department_id = d.department_id
    where e.joining_date = (
    select min(joining_date) 
    from employees 
    where department_id = e.department_id
);
























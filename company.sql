create database company;
use company;

create table if not exists Employee(
	ssn varchar(35) primary key,
	ename varchar(35) not null,
	address varchar(255) not null,
	sex varchar(7) not null,
	salary int not null,
	super_ssn varchar(35),
	d_no int,
	foreign key (super_ssn) references Employee(ssn) on delete set null
);

create table if not exists Department(
	d_no int primary key,
	dname varchar(100) not null,
	mgr_ssn varchar(35),
	mgr_start_date date,
	foreign key (mgr_ssn) references Employee(ssn) on delete cascade
);

create table if not exists DLocation(
	d_no int not null,
	d_loc varchar(100) not null,
	foreign key (d_no) references Department(d_no) on delete cascade
);

create table if not exists Project(
	p_no int primary key,
	p_name varchar(25) not null,
	p_loc varchar(25) not null,
	d_no int not null,
	foreign key (d_no) references Department(d_no) on delete cascade
);

create table if not exists WorksOn(
	ssn varchar(35) not null,
	p_no int not null,
	hours int not null default 0,
	foreign key (ssn) references Employee(ssn) on delete cascade,
	foreign key (p_no) references Project(p_no) on delete cascade
);

INSERT INTO Employee VALUES
("01NB235", "Chandan_Scott","Siddartha Nagar, Mysuru", "Male", 1500000, "01NB235", 5),
("01NB354", "Employee_2", "Lakshmipuram, Mysuru", "Female", 1200000,"01NB235", 2),
("02NB254", "Employee_3", "Pune, Maharashtra", "Male", 1000000,"01NB235", 4),
("03NB653", "Employee_4", "Hyderabad, Telangana", "Male", 2500000, "01NB354", 5),
("04NB234", "Employee_5", "JP Nagar, Bengaluru", "Female", 1700000, "01NB354", 1);

INSERT INTO Department VALUES
(1, "Human Resources", "01NB235", "2020-10-21"),
(2, "Quality Assesment", "03NB653", "2020-10-19"),
(3,"System assesment","04NB234","2020-10-27"),
(5,"Production","02NB254","2020-08-16"),
(4,"Accounts","01NB354","2020-09-4");

INSERT INTO DLocation VALUES
(1, "Jaynagar, Bengaluru"),
(2, "Vijaynagar, Mysuru"),
(3, "Chennai, Tamil Nadu"),
(4, "Mumbai, Maharashtra"),
(5, "Kuvempunagar, Mysuru");

INSERT INTO Project VALUES
(241563, "System Testing", "Mumbai, Maharashtra", 4),
(532678, "IOT", "JP Nagar, Bengaluru", 1),
(453723, "Product Optimization", "Hyderabad, Telangana",5),
(278345, "Yeild Increase", "Kuvempunagar, Mysuru",5),
(426784, "Product Refinement", "Saraswatipuram, Mysuru",2);

INSERT INTO WorksOn VALUES
("01NB235", 278345, 5),
("01NB354", 426784, 6),
("04NB234", 532678, 3),
("02NB254", 241563, 3),
("03NB653", 453723, 6);

alter table Employee add constraint foreign key (d_no) references Department(d_no) on delete cascade;

SELECT * FROM Department;
SELECT * FROM Employee;
SELECT * FROM DLocation;
SELECT * FROM Project;
SELECT * FROM WorksOn;

-- Make a list of all project numbers for projects that involve an employee whose last name is ???Scott???, either as a worker or as a manager of the department that controls the project.
select p.p_no,p.p_name,e.ename from Project p,Employee e where p.d_no=e.d_no and e.ename like "%Scott";

-- Show the resulting salaries if every employee working on the ???IoT??? project is given a 10 percent raise
select w.ssn,e.ename,e.salary as old_salary,salary*1.1 as new_salary from WorksOn w,Employee e where w.ssn=e.ssn and w.p_no=(select p_no from Project where p_name="IOT") ;

-- Find the sum of the salaries of all employees of the ???Accounts??? department, as well as the maximum salary, the minimum salary, and the average salary in this department
select sum(e.salary) as sal_sum, max(e.salary) as sal_max,min(e.salary) as sal_min,avg(e.salary) as sal_avg from Employee e , Department d where e.d_no=d.d_no and d.dname="Accounts";

-- Retrieve the name of each employee who works on all the projects controlled by department number 5 (use NOT EXISTS operator).
select Employee.ssn,ename,d_no from Employee where not exists
    (select p_no from Project p where p.d_no=5 and p_no not in
    	(select p_no from WorksOn w where w.ssn=Employee.ssn));
        
-- For each department that has more than one employees, retrieve the department number and the number of its employees who are making more than Rs. 6,00,000.
select d.d_no, count(e.ssn) as no_of_emp from Department d ,Employee e where e.d_no=d.d_no and e.salary>600000 group by d.d_no having count(*)>1;

-- Create a view that shows name, dept name and location of all employees
create view EmpView as select e.ename,d.dname,dl.d_loc from Employee e,Department d,DLocation dl where e.d_no=d.d_no and d.d_no=dl.d_no;
select * from EmpView;

-- Create a trigger that prevents a project from being deleted if it is currently being worked by any employee.

DELIMITER //
create trigger PreventDelete
before delete on Project
for each row
BEGIN
	IF EXISTS (select * from WorksOn where p_no=old.p_no) THEN
		signal sqlstate '45000' set message_text='This project has an employee assigned';
	END IF;
END; //

DELIMITER ;

delete from Project where p_no=453723; -- Will give error 
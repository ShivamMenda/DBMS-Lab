create database company;
use company;
create table employee(
ssn varchar(10) primary key,
ename varchar(20),
address text,
sex varchar(7),
salary int,
superSSN varchar(10),
dno int
);

create table department(
dno int primary key,
dname varchar(20),
mgrSSN varchar(10),
mgrStartDate date
);

alter table employee add constraint foreign key(dno) references department(dno) on delete cascade;

create table dlocation(
dno int,
dloc varchar(20),
foreign key (dno) references department(dno) on delete cascade
);

create table project(
pno int primary key,
pname char(30),
plocation char(30),
dno int,
foreign key (dno) references department(dno)
);

create table works_on(
ssn varchar(10),
pno int,
hours int,
foreign key (pno) references project(pno) on delete cascade,
foreign key (ssn) references employee(ssn)
);

INSERT INTO department VALUES
(001, "Human Resources", "473DS322", "2020-10-21"),
(002, "Quality Assesment", "473DS584", "2020-10-19"),
(003, "Technical", "473DS635", "2020-10-20"),
(004, "Quality Control", "473DS684", "2020-10-18"),
(005, "R & D", "473DS475", "2020-10-17");

INSERT INTO employee VALUES
("01NB235", "Employee_1","Siddartha Nagar, Mysuru", "Male", 1500000, "2001BD05", 5),
("01NB354", "Employee_2", "Lakshmipuram, Mysuru", "Female", 1200000,"2001BD08", 2),
("02NB254", "Employee_3", "Pune, Maharashtra", "Male", 1000000,"2002BD04", 4),
("03NB653", "Employee_4", "Hyderabad, Telangana", "Male", 2500000, "2003BD10", 5),
("04NB234", "Employee_5", "JP Nagar, Bengaluru", "Female", 1700000, "2004BD01", 1);

INSERT INTO dlocation VALUES
(001, "Jaynagar, Bengaluru"),
(002, "Vijaynagar, Mysuru"),
(003, "Chennai, Tamil Nadu"),
(004, "Mumbai, Maharashtra"),
(005, "Kuvempunagar, Mysuru");

INSERT INTO project VALUES
(241563, "System Testing", "Mumbai, Maharashtra", 004),
(532678, "Cost Mangement", "JP Nagar, Bengaluru", 001),
(453723, "Product Optimization", "Hyderabad, Telangana", 005),
(278345, "Yeild Increase", "Kuvempunagar, Mysuru", 005),
(426784, "Product Refinement", "Saraswatipuram, Mysuru", 002);

INSERT INTO works_on VALUES
("01NB235", 278345, 5),
("01NB354", 426784, 6),
("04NB234", 532678, 3),
("02NB254", 241563, 3),
("03NB653", 453723, 6);

select * from dlocation;
select * from department;
select * from project;
select * from department;
select * from works_on;
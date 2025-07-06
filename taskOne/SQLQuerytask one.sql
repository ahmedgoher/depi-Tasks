use company
go
create table employee (
ssn int  primary key,
Birthdate date not null,
gender varchar(1) ,
firstname varchar(20) not null,
lastname varchar(20) not null,
superviser int,
constraint Emp_super_FK foreign key (superviser) references employee (ssn) 
);
alter table employee add  Dnum int ;
alter table employee add constraint CK_Gender Check(gender ='M' or gender ='F')
create table department (
DNum int primary key,
Dname varchar(30) not null,
ssn int, 
Hiredate date default getdate(),
constraint department_emp_FK foreign key (ssn) references employee (ssn)
);
alter table employee add constraint fk_empAndDepartment foreign key (Dnum) references department (DNum)
alter table department add locat varchar(50)
create table projects (
Pnum int primary key,
Pname varchar(30) not null,
city varchar(20),
locations varchar(50),
DNum int,
constraint proj_department_FK foreign key (DNum) references department (DNum)
);
create table dependents(
Dname varchar(20) primary key,
birthdate date,
gender varchar(1) check(gender ='M' or gender ='F'),
ssn int ,
constraint dependent_employee_FK foreign key (ssn) references employee (ssn) on delete cascade
)
create table EmpOnProject(
Pnum int,
ssn int,
workhoure time,
constraint PK primary key (Pnum,ssn)
);
alter table EmpOnProject add constraint EmpOnProject_Fk1  foreign key (ssn) references employee (ssn)
alter table EmpOnProject add constraint EmpOnProject_Fk2  foreign key (Pnum) references projects (Pnum)
insert into employee (ssn,Birthdate,gender,firstname,lastname,superviser)
values (1,'2005-03-03','M','gaber','ibrahim',null),
	   (2,'2005-03-06','M','ahmed','goher',1),
	   (3,'2002-03-07','F','menna','ali',1),
	   (4,'2000-06-07','M','ali','mohamed',1),
	   (5,'2007-07-01','M','mohamed','kaled',1);
Go
select * from employee;
insert into department(DNum,Dname,ssn,Hiredate,locat)
values (1,'web',1,'2025-3-2','cairo'),
		(2,'android',3,'2025-3-2','Giza'),
		(3,'IT',2,'2025-3-2','Menof')
select * from department;
delete  from department
update employee 
set Dnum=2
where ssn=1 or ssn=2 or ssn=4
update employee 
set Dnum=1
where ssn=3
update employee 
set Dnum =3
WHERE ssn=5
update department
set Dname='HR'
where Dnum=1
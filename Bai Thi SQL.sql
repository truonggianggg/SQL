create table Department(
DepartId int identity(1,1) primary key,
DepartName varchar(50) not null,
Description varchar(100) not null
);
drop table Department;
create table Employee(
	EmpCode char(6) primary key,
	FirstName varchar(30) not null,
	LastName varchar(30) not null,
	Birthday smalldatetime not null,
	Gender bit default 1,
	Address varchar(100),
	DepartId int not null foreign key references Department(DepartId),
	Salary money
);
drop table Employee;
--1:
insert into Department values (N'Ke Toan',N'Kiem tra tien');
insert into Department values (N'Thu Ngan',N'Thanh toan tien');
insert into Department values (N'Nhan Su',N'Tuyen nhan su');
insert into Department values (N'Hanh chinh',N'Quan ly cong viec');

select * from Department;

insert into Employee values ('B1',N'Truong',N'Giang','19991112',1,N'HaNoi',1,500);
insert into Employee values ('B2',N'Hoang',N'Anh','19951019',0,N'HaNoi',2,600);
insert into Employee values ('B3',N'Le',N'Tuan','19970516',1,N'HaNoi',3,700);
insert into Employee values ('B4',N'Thanh',N'Huyen','19941211',0,N'HaNoi',4,800);

select * from Employee;
--2:
Update Employee set Salary = Salary*1.1;
--3:
alter table Employee add constraint check_salary check(Salary > 0);
--4:
create trigger tg_chkBirthday
on Employee
after insert
as
begin
	if exists (select * from inserted where Birthday < 22)
	begin
		print 'Employee’s age is greater than 22';
		rollback transaction;
	end
end
--5:
create index IX_DepartmentName on Department(DepartName);
--6:

--7:
create procedure sp_getAllEmp @departmentId int as
select * from Employee where DepartId = @departmentId;
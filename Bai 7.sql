create table Customerss (
	Name nvarchar(255) not null ,
	IdCard varchar(100) primary key check(IdCard not like '%[^0-9]%'),
	Address nvarchar(255) not null
);

create table Subscriber (
	PhoneNumber varchar(100) primary key check(PhoneNumber not like '%[^0-9]%'),
	Types nvarchar(255) not null,
	RegistrationDate date not null default GETDATE(),
	IdCard varchar(100) not null foreign key references Customerss(IdCard)
);

drop table Subscriber;
drop table Customerss;

insert into Customerss values 
(N'Nguyễn Nguyệt Nga', '123456789', N'Hà Nội'),
(N'Nguyễn Phương Ngân', '123456798', N'Hà Nam'),
(N'Hoàng Duy Quốc', '123456987', N'Hải Dương'),
(N'Nguyễn Phú Trọng', '123447433', N'Bắc Ninh'),
(N'Nguyễn Xuân Phúc', '123456786', N'Hà Nội');

insert into Subscriber values
('0123456789', N'Trả trước', '20121209', '123456789'),
('0123456798', N'Trả sau', '20110803', '123456798'),
('0123465789', N'Trả trước', '20130811', '123456987'),
('0123437789', N'Trả trước', '20141202', '123456798'),
('0123456389', N'Trả sau', '20121124', '123456786'),
('0123456732', N'Trả sau', '20121209', '123447433'),
('0123456737', N'Trả trước', '20120708', '123456789');

--4. Viết các câu lênh truy vấn để
--a) Hiển thị toàn bộ thông tin của các khách hàng của công ty.
select * from Customerss;

--b) Hiển thị toàn bộ thông tin của các số thuê bao của công ty.

select * from Subscriber;

--5. Viết các câu lệnh truy vấn để lấy
--a) Hiển thị toàn bộ thông tin của thuê bao có số: 0123456789
select *  from Customerss 
inner join Subscriber on Subscriber.IdCard = Customerss.IdCard where PhoneNumber = '0123456789';

--b) Hiển thị thông tin về khách hàng có số CMTND: 123456789
select * from Customerss 
inner join Subscriber on Subscriber.IdCard = Customerss.IdCard where Customerss.IdCard = '123447433';

--c) Hiển thị các số thuê bao của khách hàng có số CMTND:123456789
select PhoneNumber from Subscriber where IdCard = '123456789';

--d) Liệt kê các thuê bao đăng ký vào ngày 12/12/09


--e) Liệt kê các thuê bao có địa chỉ tại Hà Nội
select PhoneNumber from Subscriber where IdCard in (
select IdCard from Customerss where Address like N'Hà Nội');


--6. Viết các câu lệnh truy vấn để lấy
--a) Tổng số khách hàng của công ty.
select count(*) as tong_so_khach_hang from Customerss;

--b) Tổng số thuê bao của công ty.
select count(*) as tong_so_thue_bao from Subscriber;

--c) Tổng số thuê bào đăng ký ngày 12/12/09.

select count(*) as tong_so_thue_bao,RegistrationDate  
from Subscriber where RegistrationDate = '20121209' group by RegistrationDate;

--d) Hiển thị toàn bộ thông tin về khách hàng và thuê bao của tất cả các số thuê bao.
select * from Customerss 
inner join Subscriber on Subscriber.IdCard = Customerss.IdCard;
create table SubscriberName (
	Id int primary key identity(1,1),
	FullName nvarchar(100) not null,
	Address nvarchar(150) not null,
	DateOfBirth date not null default '2001-04-29'
);

create table PhoneNumber (
	IdPN int primary key identity(1,1),
	Number varchar(20) not null unique check(number not like '%[^0-9]%'),
	SubscriberNameId int not null foreign key references SubscriberName(Id)
);


--drop table PhoneNumber;
--drop table SubscriberName;

--CREATE DATA

insert into SubscriberName(FullName, Address,DateOfBirth)
values 
(N'Nguyễn Văn An', N'111, Nguyễn Trãi, Thanh Xuân, Hà Nội', '1987-08-11'),
(N'Nguyễn Duy Quốc', N'Tân Lộc, Lộc Hà, Hà Tĩnh', '2001-04-29'),
(N'Nguyễn Trường Giang', N'Minh Khai, Bắc Từ Liêm, Hà Nội', '1999-08-16'),
(N'Vũ Xuân Đồng', N'Phú Diễn, Bắc Từ Liêm, Hà Nội', '2000-11-17'),
(N'Trần Hùng', N'Tây Hồ, Hà Nội', '1998-01-11');

insert into PhoneNumber(Number, SubscriberNameId) 
values
('0949348934',1),
('0253654756',2),
('0546767854',4),
('0974463646',2),
('0949344546',1),
('0963677534',1),
('0878646443',4),
('0546756763',5),
('0949789366',5);

select * from SubscriberName;
select * from PhoneNumber;

--4. Viết các câu lênh truy vấn để
--a) Liệt kê danh sách những người trong danh bạ
select * from SubscriberName;

--b) Liệt kê danh sách số điện thoại có trong danh bạ
select * from PhoneNumber;

--5. Viết các câu lệnh truy vấn để lấy
--a) Liệt kê danh sách người trong danh bạ theo thứ thự alphabet.
select * from SubscriberName order by FullName asc;



--b) Liệt kê các số điện thoại của người có tên là Nguyễn Văn An.
select Number from PhoneNumber where SubscriberNameId in
(select Id from SubscriberName where FullName in (N'Nguyễn Văn An'));


--select Number from PhoneNumber where SubscriberNameId in (1); -- like hoac = đều được


--c) Liệt kê những người có ngày sinh là 2001/04/29
select * from SubscriberName where DateOfBirth = '2001-04-29';


--6. Viết các câu lệnh truy vấn để
--a) Tìm số lượng số điện thoại của mỗi người trong danh bạ.
select count(Number) as SoLuongSDT, SubscriberNameId 
from PhoneNumber group by SubscriberNameId;


--b) Tìm tổng số người trong danh bạ sinh vào thang 8.

select count(DateOfBirth) as SoLuongSinhVaoThang8 from SubscriberName where DateOfBirth like '%08%';

select count(DateOfBirth) as SoLuongSinhVaoThang8 from SubscriberName where month(DateOfBirth) = '08';


--c) Hiển thị toàn bộ thông tin về người, của từng số điện thoại.

select PhoneNumber.IdPN, PhoneNumber.Number, * from SubscriberName inner join PhoneNumber 
on PhoneNumber.SubscriberNameId = SubscriberName.Id;

--d) Hiển thị toàn bộ thông tin về người, của số điện thoại 0253654756


select PhoneNumber.IdPN, PhoneNumber.Number, * from SubscriberName inner join PhoneNumber 
on PhoneNumber.SubscriberNameId = SubscriberName.Id where Number = '0253654756';

--7. Thay đổi những thư sau từ cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường ngày sinh là trước ngày hiện tại.
alter table SubscriberName add constraint CK_birthdate_before_today check(DateOfBirth < getdate());


ALTER TABLE persons
ADD CONSTRAINT CK_birthdate_before_today
CHECK (birth_date < GETDATE());

--b) Viết câu lệnh để xác định các trường khóa chính và khóa ngoại của các bảng.
SELECT * 
FROM information_schema.key_column_usage;  

--c) Viết câu lệnh để thêm trường ngày bắt đầu liên lạc

alter table SubscriberName add firstDate date;
--8. Thực hiện các yêu cầu sau
--a) Thực hiện các chỉ mục sau(Index)
--◦ IX_HoTen : đặt chỉ mục cho cột Họ và tên

create index IX_HoTen on SubscriberName(FullName);


--◦ IX_SoDienThoai: đặt chỉ mục cho cột Số điện thoại

create index IX_SoDienThoa on PhoneNumber(Number);


--b) Viết các View sau:
--◦ View_SoDienThoai: hiển thị các thông tin gồm Họ tên, Số điện thoại

create view View_SoDienThoai as
select SubscriberName.FullName as HoTen, PhoneNumber.Number as SoDienThoai
from SubscriberName inner join PhoneNumber on PhoneNumber.SubscriberNameId= SubscriberName.Id;


--◦ View_SinhNhat: Hiển thị những người có sinh nhật trong tháng hiện tại (Họ tên, Ngày sinh, Số điện thoại)

create view View_SinhNhat as
select SubscriberName.FullName as HoTen, SubscriberName.DateOfBirth as Ngaysinh, PhoneNumber.Number as SoDienThoai
from SubscriberName inner join PhoneNumber on PhoneNumber.SubscriberNameId= SubscriberName.Id;


--c) Viết các Store Procedure sau:
--◦ SP_Them_DanhBa: Thêm một người mới vào danh bạ
create procedure add_subscribername  @fname nvarchar(100), @address nvarchar(150) ,@birth_day date as 
insert into SubscriberName(FullName, Address, DateOfBirth)  values(@fname, @address, @birth_day);

--drop procedure add_subscribername;
exec add_subscribername 
@fname = N'Chu Văn Anh',@address = N'Kim Chòi, Tân Lôc, Lộc Hà, Hà Tĩnh', @birth_day= '2001-01-01';



--◦ SP_Tim_DanhBa: Tìm thông tin liên hệ của một người theo tên (gần đúng)


create procedure SP_Tim_DanhBa @an nvarchar(100) as
select * ,PhoneNumber.Number from SubscriberName 
inner join PhoneNumber on PhoneNumber.SubscriberNameId = SubscriberName.Id  where SubscriberName.FullName like '%' + @an + '%';

drop procedure SP_Tim_DanhBa;
exec SP_Tim_DanhBa @an = N'Quốc';



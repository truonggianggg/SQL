--CREATE TABLE
create table ProductType (
	TypeId varchar(20) primary key,
	TypeName nvarchar(100) not null
);

create table Reponsible (
	Id varchar(20) primary key,
	Name nvarchar(100) not null
);

create table ProDuctsss (
	Id varchar(20) primary key,
	DateManufacture date not null default getdate(),
	TypeId varchar(20) not null foreign key references ProductType(TypeId),
	ReponsibleId varchar(20) not null foreign key references Reponsible(Id)
);

drop table ProDuctsss;
drop table Reponsible;
drop table ProductType;

--CREATE DATA

insert into ProductType
values
('Z37E', N'Máy tính xách tay Z37'),
('O48G', N'Điện thoại Oppo fIndX 2'),
('D79H', N'Đồng hồ thông minh S4');

insert into Reponsible
values
('987688',N'Nguyễn Văn An'),
('987689',N'Nguyễn Duy Quốc'),
('987690',N'Hoàng Duy Quốc');

insert into ProDuctsss
values
('Z37 111111', '2020-8-20', 'Z37E','987688'),
('O48 111111', '2020-4-20', 'O48G','987688'),
('D79 111111', '2022-8-21', 'D79H','987688'),
('O48 111112', '2022-7-20', 'O48G','987689'),
('D79 111112', '2021-8-20', 'D79H','987690'),
('Z37 111112', '2021-10-20', 'Z37E','987689'),
('O48 111113', '2022-1-20', 'O48G','987690');

--4. Viết các câu lênh truy vấn để
--a) Liệt kê danh sách loại sản phẩm của công ty.
select * from ProductType;

--b) Liệt kê danh sách sản phẩm của công ty.
select * from Productsss;
--c) Liệt kê danh sách người chịu trách nhiệm của công ty.
select * from Reponsible;


--5. Viết các câu lệnh truy vấn để lấy
--a) Liệt kê danh sách loại sản phẩm của công ty theo thứ tự tăng dần của tên
select TypeName from ProductType order by TypeName asc;

--b) Liệt kê danh sách người chịu trách nhiệm của công ty theo thứ tự tăng dần của tên.
select * from Reponsible order by Name asc;

--c) Liệt kê các sản phẩm của loại sản phẩm có mã số là Z37E.
select Id, DateManufacture, ReponsibleId from ProDuctsss where TypeId = 'Z37E';
--d) Liệt kê các sản phẩm Nguyễn Văn An chịu trách nhiệm theo thứ tự giảm đần của mã.
select Id, DateManufacture, TypeId from ProDuctsss where ReponsibleId = '987688' order by Id asc;
--6. Viết các câu lệnh truy vấn để
--a) Số sản phẩm của từng loại sản phẩm.
select count(Id) as Soluong, TypeId from ProDuctsss group by TypeId;


--b) Số loại sản phẩm trung bình theo loại sản phẩm.
select count(*)/count  (distinct TypeId) as trungBinh
from ProDuctsss;


--c) Hiển thị toàn bộ thông tin về sản phẩm và loại sản phẩm.

select * from ProDuctsss
full join ProductType on ProductType.TypeId = ProDuctsss.TypeId;

--d) Hiển thị toàn bộ thông tin về người chịu trách nhiêm, loại sản phẩm và sản phẩm
select * from ProDuctsss
inner join ProductType on ProductType.TypeId = ProDuctsss.TypeId
inner join Reponsible on Reponsible.Id = ProDuctsss.ReponsibleId;

--7. Thay đổi những thư sau từ cơ sở dữ liệu
--a) Viết câu lệnh để thay đổi trường ngày sản xuất là trước hoặc bằng ngày hiện tại.
alter table ProDuctsss
add constraint check_date_manufacture
check(DateManufacture <= getdate());


--b) Viết câu lệnh để xác định các trường khóa chính và khóa ngoại của các bảng.
select *
from information_schema.key_column_usage;


--c) Viết câu lệnh để thêm trường phiên bản của sản phẩm.

alter table ProDuctsss
add Versions varchar(20) not null default 1 check(Versions >= 1);

--8. Thực hiện các yêu cầu sau
--a) Đặt chỉ mục (index) cho cột tên người chịu trách nhiệm
create index index_name on Reponsible(Name);
--drop index index_name on Reponsible;


--b) Viết các View sau:
--◦ View_SanPham: Hiển thị các thông tin Mã sản phẩm, Ngày sản xuất, Loại sản phẩm
create view View_SanPham as
select ProDuctsss.Id  as Masanpham, ProDuctsss.DateManufacture as NgaySanXuat,ProductType.TypeName  as LoaiSanPham
from ProDuctsss inner join ProductType on ProDuctsss.TypeId = ProductType.TypeId;

--drop view View_SanPham;

--◦ View_SanPham_NCTN: Hiển thị Mã sản phẩm, Ngày sản xuất, Người chịu trách nhiệm
create view View_SanPham_NCTN as
select ProDuctsss.Id  as Masanpham, ProDuctsss.DateManufacture as NgaySanXuat, Reponsible.Name as NguoiChiuTrachNhiem
from ProDuctsss inner join Reponsible on ProDuctsss.ReponsibleId = Reponsible.Id;

--drop view View_SanPham_NCTN;

--◦ View_Top_SanPham: Hiển thị 5 sản phẩm mới nhất (mã sản phẩm, loại sản phẩm, ngàysản xuất)
create view View_Top_SanPham as
select top 5 ProDuctsss.Id, ProductType.TypeName, ProDuctsss.DateManufacture
from ProDuctsss
inner join ProductType
on ProDuctsss.TypeId = ProductType.TypeId
order by ProDuctsss.DateManufacture desc;




--c) Viết các Store Procedure sau:
--◦ SP_Them_LoaiSP: Thêm mới một loại sản phẩm
--◦ SP_Them_NCTN: Thêm mới người chịu trách nhiệm
--◦ SP_Them_SanPham: Thêm mới một sản phẩm
--◦ SP_Xoa_SanPham: Xóa một sản phẩm theo mã sản phẩm
--◦ SP_Xoa_SanPham_TheoLoai: Xóa các sản phẩm của một loại nào đó
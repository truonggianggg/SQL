create table Types(
	Id int primary key identity(1,1),
	TypeName nvarchar(255) not null unique
);

create table Author(
	Id int primary key identity(1,1),
	Name nvarchar(255) not null
);

create table Publishions(
	IdPl int primary key identity(1,1),
	Name nvarchar(100) not null unique,
	Address nvarchar(255)
);

create table Books(
	Id varchar(20) primary key,
	Name nvarchar(255) not null,
	Content ntext,
	YearPubish date not null default GETDATE(),
	NumberPublish int not null check(NumberPublish > 0) default 1,
	Price decimal(16,0) not null check(Price >= 0) default 100000,
	Quantity int not null check(Quantity >= 0) default 0,
	TypeId int not null foreign key references Types(Id),
	PublishionId int not null foreign key references Publishions(IdPl),
	AuthorId int not null foreign key references Author(Id)
);

--drop table Books;
--drop table Publishions;
--drop table Author;
--drop table Types;


--2,  Chèn dữ liệu vào bảng

insert into Types 
values
(N'Tri Thức'),
(N'Truyện cười dân gian'),
(N'Kinh Dị'),
(N'Sức khỏe và đời sống'),
(N'Chính trị và Quân sự');

insert into Author
values 
('Eran Katz'),
('Lio Messi'),
(N'Châu Tinh Trì'),
(N'Nam Cao'),
(N'Hoàng Duy Quốc');

insert into Publishions
values
(N'NXB Tri Thức',  N'53 Nguyễn Du, Hai Bà Trưng, Hà Nội'),
(N'NXB chính trị quốc gia sự thật',  N'Số 6/86 Duy Tân, Cầu Giấy, Hà Nội; Số 24 Quang Trung, Hoàn Kiếm, Hà Nội'),
(N'NXB Kim Đồng', N'55 Quang Trung, Hai Bà Trưng, Hà Nội'),
(N'NXB Giáo dục', N'Số 81 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội'),
(N'NXB Hội nhà văn', N' Số 65 Nguyễn Du, Hà Nộ');

insert into Books values
('B001', N'Trí thức Do Thái', N'Bạn có muốn biết: Người Do Thái sáng tạo ra', '2007', 1,100000, 120,1,1,1),
('H001', N'Có con ma dưới gầm giường', N'Có con ma đen thùi lùi', '2008', 4, 300000, 80,3,2,5),
('K001', N'Trạng Quỳnh', N'Quỳnh và ba chú bé đần', '2006', 5, 240000, 60, 2, 3, 2),
('I001', N'Việt Nam có vũ khí hạt nhân',  N'Viêt Nam sẽ thống trị thế giới trong 20 năm nữa', '2010', 1, 350000, 95, 5, 5, 3),
('Q001', N'Uống rượu mỗi ngày nâng cao sức khỏe', N'Mỗi ngày bạn hãy uống một chai rượu hay một chai bia', '2008', 4,100000, 70, 4, 4, 4),
('I002', N'Việt Nam mua thành công tàu ngầm hạt nhân',  N'Theo một số nguồn tin từ Nga, Việt Nam đã kí thành công hợp đông mua ', '2010', 1, 350000, 95, 5, 5, 3);



select * from Types;
select * from Author;
select * from Publishions;
select * from Books;


--3. Liệt kê các cuốn sách có năm xuất bản từ 2008 đến nay

select * from Books 
where YearPubish between '2008-01-01' and GETDATE();


--4,Liet ke 3 cuon sach co gia ban cao nhat

select top 3 * from Books  order by Price desc;


--5, Tim nhung cuon sach co tieu de chua tu "Viet Nam"

select * from Books where Name like N'%Việt Nam%';


--6, Liet ke cac cuon sach co ten bat dau voi chu "T" theo thu tu gia giam dan

select Name from Books where Name like N'T%' order by Price desc;

--7, Liet ke cac cuon sach cua nha xuat ban Tri Thuc


select Name from Books where PublishionId in
(select IdPl from Publishions where Name = N'NXB Tri Thức');


--8, Lay thong tin chi tiet ve nha xuat ban xuat ban cuon sach "Tri thuc Do Thai"

select * from Publishions where IdPl in 
(select PublishionId from Books where Name = N'Trí thức Do Thái'); 

--9, Hien thi cac thong tin sau ve cac cuon sach : Ma sach, Ten sach,  Nam xuat ban, Nhà xuat ban, Loai sach

select Books.Id as MaSach, Books.Name, Books.YearPubish , Publishions.Name, Types.TypeName from Books 
inner join Publishions on Publishions.IdPl = Books.PublishionId
inner join Types on Types.Id = Books.TypeId;



--10. Tim cuon sach co gia ban dat nhat

select top 1 Name, Price from Books order by Price desc;

--11. Tim cuon sach co so luong lon nhat trong kho

select top 1 Name, Quantity from Books order by Quantity desc;



--12. Tim cuon sach cua tac gia “Eran Katz”


select Name from Books where AuthorId in
(select Id from Author where Name = N'Eran Katz');


--13 Giam gia ban 10% cac cuon sach xuat ban tu nam 2008 tro ve truoc

update Books set Price = Price * (1 - 0.1)
where YearPubish < '2008';

--14. Thong ke so luong sach cua moi nha xuat ban

select count(PublishionId) as NumberBook, PublishionId from Books group by PublishionId;


--15. Thong ke so luong sach cua moi loai sach

select count(TypeId) as NumberBook , TypeId from Books group by TypeId;

--16. Dat chi muc index cho truong ten sach

create index IX_Tensach on Books(Name);

--17. 17. Viết view lấy thông tin gồm: Mã sách, tên sách, tác giả, nhà xb và giá bán

create view View_Information 
as
select Books.Id as Masach, Books.Name as Tensach, Author.Id as Tacgia, Publishions.Name as Nhaxuatban , Books.Price as Giaban
from Books 
inner join Publishions on Publishions.IdPl= Books.PublishionId
inner join Author on Author.Id = Books.AuthorId;



--18. Viết Store Procedure:
--◦ SP_Them_Sach: thêm mới một cuốn sách

create procedure SP_Them_Sach 
@Id varchar(20),@name nvarchar(100), @content ntext, @yearpublish date, @number_publish int, @price decimal(16,0), @quantity int ,
@type_id int, @PublishionId int, @authorId int
as
insert into Books(Id, Name, Content, YearPubish, NumberPublish, Price, Quantity, TypeId, PublishionId, AuthorId) 
values(@Id,@name, @content,@yearpublish, @number_publish, @price, @quantity, @type_id, @PublishionId, @authorId);

exec SP_Them_Sach @Id = 'Q002' ,@name = N'Mật ong rất có lợi cho sức khỏe', @content = N'Như thông báo mới đây của các nhà khoa học đại tài Việt Nam', 
@yearpublish = '2011', @number_publish = 1, @price = 120000, @quantity = 70, @type_id = 4, @PublishionId = 3, @authorId = 4;

drop procedure more_new_book;


--◦ SP_Tim_Sach: Tìm các cuốn sách theo từ khóa

create procedure SP_Tim_Sach @book_name nvarchar(100) as
select * from InforBook where BookName like '%' + @book_name + '%';

drop procedure SP_Tim_Sach;

exec SP_Tim_Sach @book_name = N'thức Do';


--◦ SP_Sach_ChuyenMuc: Liệt kê các cuốn sách theo mã chuyên mục



--19. Viết trigger không cho phép xóa các cuốn sách vẫn còn trong kho (số lượng > 0)

create trigger can_not_delete_book
on Books
after delete 
as
begin
	if exists (select * from deleted where quantity > 0)
	begin
		print 'Sach van con trong kho';
		rollback transaction;
	end
end;


--20. Viết trigger chỉ cho phép xóa một danh mục sách khi không còn cuốn sách nào thuộc chuyên
mục này.
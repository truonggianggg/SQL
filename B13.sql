create table Products(
	Id varchar(20) primary key,
	Name nvarchar(100) not null unique,
	DeScriptions nvarchar(255) not null,
	Unit nvarchar(100) not null,
	Price decimal(16,0) not null check(Price >= 0) default 0

);

create table Customers(
	Id varchar(20) primary key,
	Name nvarchar(100) not null,
	Address nvarchar(255) not null,
	PhoneNumber varchar(20) not null unique
);

create table Orders(
	Id varchar(20) primary key,
	OrderDate date not null default GETDATE(),
	GrandTotal decimal(16,0) not null default 0 check(GrandTotal >= 0),
	CustomerId varchar(20) not null foreign key references Customers(Id)
);

create table Order_Product(
	Quantity int not null check(Quantity > 0),
	SubTotal decimal(16,0) not null check(SubTotal > 0) default 100,
	OrderId varchar(20) not null foreign key references Orders(Id),
	ProductId varchar(20) not null foreign key references Products(Id)
);

--drop table Order_Product;
--drop table Orders;
--drop table Customers;
--drop table Products;

--CREATE DATA
insert into Products
values
('SP000001', N'Máy tính T450', N'Máy nh?p m?i', N'chi?c', 1000),
('SP000002', N'Di?n tho?i Nokia5670', N'?i?n tho?i ?ang hot', N'chi?c', 400),
('SP000003', N'Máy in Samsung 450', N'Máy in ?ang ?', N'chi?c', 100);

insert into Customers
values
('0000001', N'Nguy?n V?n An', N'111, Nguy?n Trãi, Thanh Xuân, Hà N?i', '09347479234'),
('0000002', N'Nguy?n Duy Qu?c', N'135, Minh Khai, B?c T? Liêm, Hà N?i','03838328288'),
('0000003', N'Hoàng Duy Qu?c', N'131, Tân L?c, L?c Hà, Hà T?nh','09337324832');

insert into Orders(Id, OrderDate, CustomerId)
values
('OD01', '2019-03-29', '0000001'),
('OD02', '2019-02-22', '0000003'),
('OD03', '2019-09-02', '0000002'),
('OD04', '2019-05-12', '0000003');

insert into Order_Product
values
(3, 3000, 'OD01', 'SP000001'),
(2, 800, 'OD02', 'SP000002'),
(20, 2000, 'OD01', 'SP000003'),
(4, 4000, 'OD03', 'SP000001'),
(10, 1000, 'OD03', 'SP000003'),
(7, 7000, 'OD04', 'SP000001'),
(4, 1600, 'OD04', 'SP000002');


update Orders
set GrandTotal = (
	select sum(SubTotal)
	from Order_Product
	where OrderId = 'OD01'
)
where Id = 'OD01';

update Orders
set GrandTotal = (
	select sum(SubTotal)
	from Order_Product
	where OrderId = 'OD02'
)
where Id = 'OD02';


update Orders
set GrandTotal = (
	select sum(SubTotal)
	from Order_Product
	where OrderId = 'OD03'
)
where Id = 'OD03';

update Orders
set GrandTotal = (
	select sum(SubTotal)
	from Order_Product
	where OrderId = 'OD04'
)
where Id = 'OD04';

--READ
select * from Products;
select * from Customers;
select * from Orders;
select * from Order_Product;

--CÁC CÂU L?NH TRUY V?N
--4.a Li?t kê danh sách khách hàng ?ã mua ? c?a hàng
select Name from Customers;

--4.b Li?t kê danh sách s?n ph?m c?a c?a hàng
select Name from Products;

--4.c Li?t kê danh sách các ??n ??t hàng c?a c?a hàng
select Orders.Id, Customers.Name, Customers.PhoneNumber, Customers.Address, Orders.OrderDate, Orders.GrandTotal from Orders
inner join Customers on Customers.Id = Orders.CustomerId;

--5.aLi?t kê danh sách khách hàng theo th? th? alphabet.
select Name from Customers order by Name asc;

--5.b Li?t kê danh sách s?n ph?m c?a c?a hàng theo th? th? giá gi?m d?n.
select Name from Products order by Name desc;

--5.c Li?t kê các s?n ph?m mà khách hàng Nguy?n V?n An ?ã mua.
select Name from Products
	where Id in (
		select ProductId from Order_Product
			where OrderId in (
				select Id from Orders
					where CustomerId in ('0000001')
														)

															);

--6.a S? khách hàng ?ã mua ? c?a hàng.
select count(Id) as SoLuongKhachDaMuaOCuaHang from Customers;


--6.b S? m?t hàng mà c?a hàng bán.
select count(*) as SoMatHangMaCuaHangBan from Products;

--6.c T?ng ti?n c?a t?ng ??n hàng.
select Id, GrandToTal from Orders;
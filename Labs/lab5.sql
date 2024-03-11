use ClothingStore;
go

create proc insertIntoProducts
as
	declare @i int=0
	while @i < 30
	begin
		insert into Products values (@i, 'Product', 'Description','Brand', 'Category', 100, 20)
		set @i = @i + 1
	end
	declare @j int=30
	while @j < 50
	begin
		insert into Products values (@j, 'Product', 'Description','Brand', 'Category', 100, 10)
		set @j = @j + 1
	end

exec insertIntoProducts
select * from Products
go

create proc insertIntoOrders
as
	declare @i int=0
	while @i < 15
	begin
		insert into Orders values (@i, @i, '2023-10-10', 300)
		set @i = @i + 1
	end
	declare @j int=15
	while @j < 30
	begin
		insert into Orders values (@j, @j, '2023-10-11', 200)
		set @j = @j + 1
	end

exec insertIntoOrders
select * from Orders
go

create proc insertIntoOrderItem
as
	declare @i int=0
	while @i < 25
	begin
		insert into OrderItem values (@i, @i, @i, 5, 100, 300)
		set @i = @i + 1
	end

exec insertIntoOrderItem
select * from OrderItem
go

--a.
-- clustered index scan
select TotalAmount
from Orders 
where TotalAmount = 300

--clustered index seek
select OrderDate
from Orders 
where OrderId between 15 and 20

--nonclustered index scan 
select CustomerId
from Orders

--nonclustered index seek
select CustomerId 
from Orders 
where CustomerId > 25

-- key lookup
select CustomerId, OrderDate
from Orders
where CustomerId = 20

-- b.
select * 
from Products 
where QuantityInStock = 10

create index ProductsIndex 
	on Products(QuantityInStock)

drop index ProductsIndex on Products

--c.
go
create view joinProductsAndOrderItem
as
	select P.PName
	from Products P inner join OrderItem O on P.ProductId = O.ProductId
go

select * from joinProductsAndOrderItem

create index OrderItemIndex 
	on OrderItem(ProductId)

drop index OrderItemIndex on OrderItem

create index ProductsIndex1 
	on Products(ProductId)

drop index ProductsIndex1 on Products
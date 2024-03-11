use ClothingStore;

go
create view allProducts
as
	select * from Products

go

create view joinCustomersOrders
as
	select C.FirstName, C.LastName
	from Customers C inner join Orders O on C.CustomerId = O.CustomerId

go

create view totalOrderAmount
as
	select c.CustomerID, c.FirstName, c.LastName, sum(o.TotalAmount) as TotalOrderAmount
	from Customers c
	inner join Orders o on c.CustomerId = o.CustomerId
	group by c.CustomerId, c.FirstName, c.LastName

go

create proc insertProducts @noOfRows int
as
	declare @i int=0
	while @i < @noOfRows
	begin
		insert into Products values (@i, 'Product', 'Description','Brand', 'Category', 100, 10)
		set @i = @i + 1
	end

go

create proc deleteProducts
as
	delete from Products where PName = 'Product'

go

create proc insertCustomers @noOfRows int
as
	declare @i int=0
	while @i < @noOfRows
	begin
		insert into Customers values (@i, 'FName', 'LName','Email', null)
		set @i = @i + 1
	end

go

create proc deleteCustomers
as
	delete from Customers where Email = 'Email'

go

create proc insertProductReviews @noOfRows int
as
	declare @i int=0
	while @i < @noOfRows
	begin
		insert into ProductReviews values (@i, @i, 10,'Review')
		set @i = @i + 1
	end

go

create proc deleteProductReviews
as
	delete from ProductReviews where Rating = 10

go

create proc insertOrders @noOfRows int 
as
	declare @cid int
	declare curs cursor
		for
		select c.CustomerId from (select CustomerId from Customers where Email = 'Email') c
	open curs
	declare @i int=0
	while @i < @noOfRows
	begin
		fetch next from curs into @cid
		insert into Orders values (@i, @cid, '2023-10-10', 300)
		set @i=@i+1
	end 
	close curs 
	deallocate curs

go

create proc deleteOrders
as
	delete from Orders where OrderDate = '2023-10-31'

go

create proc selectView @name varchar(100)
as
	declare @query varchar(250) = 'select * from ' + @name
	exec(@query)

go

insert into Tests(Name) values ('insertProducts'), ('deleteProducts'), ('insertCustomers'), ('deleteCustomers'), ('insertProductReviews'), ('deleteProductReviews'), ('insertOrders'), ('deleteOrders'),('selectView')
insert into dbo.Tables(Name) values ('Products'), ('Customers'), ('ProductReviews'), ('Orders')
insert into dbo.Views(Name) values ('allProducts'), ('joinCustomersOrders'), ('totalOrderAmount')
insert into TestViews(TestID, ViewID) values (9, 1), (9, 2), (9, 3)
insert into TestTables(TestID, TableID, NoOfRows, Position) 
values (8, 4, 30, 1),
		(6, 3, 40, 2),
		(4, 2, 50, 3),
		(2, 1, 60, 4),
		(1, 1, 70, 1),
		(3, 2, 60, 2),
		(5, 3, 50, 3),
		(7, 4, 40, 4)

go

create proc mainTest
as
	insert into TestRuns values ('', '2000', '2000')

	declare @testRunID int
	set @testRunID = (select max(TestRunID) from TestRuns)

	update TestRuns
	set Description = 'test' + convert(varchar, @testRunID)
	where TestRunID = @testRunID 

	declare @noOfRows int
	declare @tableID int
	declare @tableName varchar(100)
	declare @startAt datetime
	declare @endAt datetime
	declare @viewID int
	declare @viewName varchar(100)
	declare @name varchar(100)

	declare testDeleteCursor cursor
	for
	select TableID, Name, NoOfRows
	from Tests inner join TestTables on Tests.TestID = TestTables.TestID
	where Name like 'delete%' 
	order by Position 

	open testDeleteCursor
	
	fetch next
	from testDeleteCursor
	into @tableID, @name, @noOfRows

	set @startAt = getdate()

	update TestRuns
	set StartAt = @startAt
	where TestRunID = @testRunID and year(StartAt) = 2000


	while @@FETCH_STATUS = 0
	begin
		exec(@name) 
		fetch next
		from testDeleteCursor
		into @tableID,@name,  @noOfRows
	end
	close testDeleteCursor
	deallocate testDeleteCursor


	declare testInsertCursor cursor
	for
	select TableID, Name, NoOfRows
	from Tests inner join TestTables on Tests.TestID = TestTables.TestID
	where Name like 'insert%' 
	order by Position 

	open testInsertCursor

	fetch next
	from testInsertCursor
	into @tableID, @name, @noOfRows

	while @@FETCH_STATUS = 0
	begin
		set @startAt = getdate()
		exec @name @noOfRows
		set @endAt = getdate()

		insert into TestRunTables values (@testRunID, @tableID, @startAt, @endAt)

		fetch next
		from testInsertCursor
		into @tableID, @name, @noOfRows
	end

	close testInsertCursor
	deallocate testInsertCursor


	declare testViewCursor cursor
	for 
	select ViewID
	from TestViews

	open testViewCursor

	fetch next
	from testViewCursor
	into @viewID

	while @@FETCH_STATUS = 0
	begin
		set @viewName = (select Name from Views where ViewID = @viewID)
		set @startAt = getdate()
		exec selectView @viewName
		set @endAt = getdate()

		insert into TestRunViews values (@testRunID, @viewID, @startAt, @endAt)

		fetch next
		from testViewCursor
		into @viewID
	end

	update TestRuns
	set EndAt = @endAt
	where TestRunID = @testRunID

	close testViewCursor
	deallocate testViewCursor

go

exec mainTest

select * from TestRunTables
select * from TestRunViews
select * from TestRuns 

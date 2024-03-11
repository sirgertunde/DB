use ClothingStore;

insert into Products (ProductId, PName, PDescription, Brand, Category, Price, QuantityInStock)
values (1234, 'knitted dress', 'confortable and warm', 'H&M', 'dress', 120, 7),
	   (1235, 'oversized T-shirt', 'very confortable', 'Bershka', 'T-shirt', 45, 12),
	   (1236, 'straight high jeans','slightly elastic', 'Zara', 'jeans', 150, 9)

insert into Brands (BrandId, ProductId, BName, BDescription)
values (2345, 1234, 'H&M', 'H&M description'),
	   (2346, 1235, 'Bershka', 'Bershka description'),
	   (2347, 1236, 'Zara', null)

insert into Categories (CategoryId, ProductId, CName, CDescription)
values (3456, 1234, 'dress', 'dress category description'),
	   (3457, 1235, 'T-shirt', 'T-shirt category description'),
	   (3458, 1236, 'jeans', 'jeans category description')

insert into Customers (CustomerId, FirstName, LastName, Email, Phone)
values (4567, 'Andrei', 'Popescu', 'popescuandrei@gmail.com', '0712345678'),
	   (4568, 'Carina', 'Ionescu', 'ionescucarina@gmail.com', '0754321785'),
	   (4569, 'Denis', 'Alexandrescu', 'alexandrescudenis@gmail.com', '0732175489'),
	   (4560, 'Maria', 'Danescu', 'danescumaria@gmail.com', '0796357124')

insert into Orders (OrderId, CustomerId, OrderDate, TotalAmount)
values (5678, 4568, '2023-10-31', 320)

insert into OrderItem (OrderItemId, OrderId, ProductId, Quantity, UnitPrice, Subtotal)
values (6789, 5678, 1234, 2, 120, 240),
	   (6780, 5678, 1236, 1, 150, 150)

insert into Payments (PaymnetId, OrderId, PaymentDate, PaymentAmount, PaymentMethod)
values (12, 5678, '2023-10-31', 320, 'cash')

insert into ProductAttributes (AttributeID, AttributeName)
values (1, 'Color'),
	   (2, 'Size')

insert into ProductAttributeMapping (ProductID, AttributeID)
VALUES (1234, 1),
       (1234, 2), 
       (1235, 1)

update Customers
set Phone = '0745623712'
where FirstName = 'Andrei' and LastName = 'Popescu'

update Products
set QuantityInStock = 11
where Price < 60

update Brands 
set BDescription = 'Zara description'
where BDescription is null

delete 
from Customers 
where FirstName like 'D%'

delete 
from Customers 
where CustomerId between 4550 and 4565

select C.CustomerId
from Customers C
where LastName like 'P%'
union
select O.CustomerId
from Orders O

select distinct PName
from Products
where Price < 100 or Price > 130
order by PName

select C.CustomerId
from Customers C
intersect
select O.CustomerId
from Orders O

select BrandId
from Brands
where BName in ('H&M', 'Zara')

select C.CustomerId
from Customers C
except
select O.CustomerId
from Orders O

select BrandId
from Brands
where BName not in ('H&M', 'Zara')

select C.FirstName, C.LastName
from Customers C inner join Orders O on C.CustomerId = O.CustomerId

select *
from Products P
inner join ProductAttributeMapping PAM on P.ProductID = PAM.ProductID
inner join ProductAttributes PA on PAM.AttributeID = PA.AttributeID
inner join OrderItem OI on P.ProductID = OI.ProductID
inner join Orders O on OI.OrderID = O.OrderID

select *
from Customers C left join Orders O on C.CustomerId = O.CustomerId

select top 2 *
from Brands B right join Products P on B.ProductId = P.ProductId

select *
from Orders O
full join Customers C on O.CustomerId = C.CustomerId
full join Payments P on O.OrderId = P.OrderId


select distinct P.PName
from Products P
where P.ProductId in 
	(select B.ProductId
	from Brands B 
	where B.BrandId = 2346)

select P.PName
from Products P
where P.ProductId in
	(select OI.ProductId
	from OrderItem OI
	where OI.OrderId in
		(select O.OrderId
		from Orders O 
		where O.OrderDate = '2023-10-31'))

select P.PName
from Products P 
where exists (select *
			 from Brands B 
			 where B.BrandId = 2346 and B.ProductId = P.ProductId)

select distinct C.CName
from Categories C
where exists (select *
			 from Products P
			 where P.Brand = 'Zara' and C.ProductId = P.ProductId)

select *
from (select OrderId, CustomerId, OrderDate, TotalAmount
     from Orders
     where CustomerId in (
        select CustomerId
        from Customers
        where LastName LIKE 'I%')
) as CustomerOrders

select *
from (
    select CustomerId, sum(TotalAmount) as TotalAmountSpent
    from Orders
    group by CustomerId
) as CustomerSpending
order by TotalAmountSpent desc

select CustomerId, count(OrderId) as TotalOrders
from Orders
group by CustomerId

select CustomerId, sum(TotalAmount) as TotalSpent
from Orders
group by CustomerId
having sum(TotalAmount) > 300

select Category, avg(QuantityInStock) as AvgQuantity
from Products
group by Category
having avg(QuantityInStock) > (select avg(QuantityInStock) from Products)

select Brand, avg(Price) as AvgPrice
from Products
group by Brand
having avg(Price) > (select avg(Price) from Products)

select *
from Orders
where TotalAmount = any (
    select MAX(TotalAmount)
    from Orders)

select *
from Orders
where TotalAmount in (
    select MAX(TotalAmount)
    from Orders)

select *
from Products
where QuantityInStock > all (
    select max(QuantityInStock)
    from Products
    where Category = Products.Category
    group by Category)

select *
from Products
where QuantityInStock not in (
    select max(QuantityInStock)
    from Products
    where Category = Products.Category
    group by Category)

select *
from Orders
where TotalAmount > all (
    select TotalAmount
    from Orders
    where CustomerId = 4567 or CustomerId = 4568)

select *
from Orders
where TotalAmount > (
    select max(TotalAmount)
    from Orders
    where CustomerId in (4567, 4568))

select *
from Products
where QuantityInStock > any (
    select QuantityInStock
    from Products
    where Category = 'jeans')

select *
from Products
where QuantityInStock > (
    select min(QuantityInStock)
    from Products
    where Category = 'jeans')

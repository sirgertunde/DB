--create database ClothingStore;
use ClothingStore;

create table Products(
	ProductId int primary key,
	PName varchar(50) not null,
	PDescription varchar(100),
	Brand varchar(50) not null,
	Category varchar(50), 
	Price numeric(6, 2), 
	QuantityInStock int)

create table ProductImages(
	ImageId int primary key,
	ProductId int,
	foreign key (ProductId) references Products(ProductId),
	ImageLink varchar(80) not null)

create table Brands(
	BrandId int primary key,
	ProductId int,
	foreign key (ProductId) references Products(ProductId),
	BName varchar(50) not null,
	BDescription varchar(100))

create table Categories(
	CategoryId int primary key,
	ProductId int,
	foreign key (ProductId) references Products(ProductId),
	CName varchar(50) not null,
	CDescription varchar(100))

create table Customers(
	CustomerId int primary key,
	FirstName varchar(50) not null,
	LastName varchar(50) not null,
	Email varchar(50),
	Phone char(10) unique)

create table Orders(
	OrderId int primary key,
	CustomerId int,
	foreign key (CustomerId) references Customers(CustomerId),
	OrderDate date,
	TotalAmount numeric(7,2))

create table OrderItem(
	OrderItemId int primary key,
	OrderId int,
	foreign key (OrderId) references Orders(OrderId),
	ProductId int,
	foreign key (ProductId) references Products(ProductId),
	Quantity int, 
	UnitPrice numeric(6,2),
	Subtotal numeric(7,2))

create table Payments(
	PaymnetId int primary key,
	OrderId int,
	foreign key (OrderId) references Orders(OrderId),
	PaymentDate date,
	PaymentAmount numeric(7,2),
	PaymentMethod varchar (10))

create table Shipments(
	ShipmentId int primary key,
	OrderId int,
	foreign key (OrderId) references Orders(OrderId),
	ShipmentDate date,
	TrackingNumber int not null,
	ShipmentStatus varchar(50))

create table Inventory(
	InventoryId int primary key,
	ProductId int,
	foreign key (ProductId) references Products(ProductId),
	StockQuantity int)

create table ProductAttributes (
    AttributeID int primary key,
    AttributeName varchar(50) NOT NULL)

create table ProductAttributeMapping (
    ProductID int,
    AttributeID int,
    primary key (ProductID, AttributeID),
    foreign key (ProductID) references Products(ProductID),
    foreign key (AttributeID) references ProductAttributes(AttributeID))

create table ProductReviews (
	ProductID int, 
	CustomerID int, 
	Rating int, 
	Review varchar(200)
	primary key (ProductID, CustomerID)
)

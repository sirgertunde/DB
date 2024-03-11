use ClothingStore
go

create proc uspChangeTypeStockQuantity
as
	alter table Inventory
	alter column StockQuantity varchar(5)

go

create proc uspUndoChangeTypeStockQuantity
as
	alter table Inventory
	alter column StockQuantity int

go

create proc uspRemoveColumnShipmentStatus
as
	alter table Shipments
	drop column ShipmentStatus

go

create proc uspAddColumnShipmentStatus
as
	alter table Shipments
	add ShipmentStatus varchar(50)

go

create proc uspAddDefaultConstraintStockQuantity
as
	alter table Inventory
	add constraint defaultStockQuantity default 0 for StockQuantity

go

create proc uspRemoveDefaultConstraintStockQuantity
as
	alter table Inventory
	drop constraint defaultStockQuantity

go

create or alter proc uspAddPrimaryKeyPhone
as
	alter table Customers
	add constraint PKCustomers primary key(Phone)

go

create proc uspRemovePrimaryKeyPhone
as
	alter table Customers
	drop constraint PKCustomers

go

create proc uspAddCandidateKeyBName
as
	alter table Brands
	add constraint uniqueBName unique(BName)

go

create proc uspRemoveCandidateKeyBName
as
	alter table Brands
	drop constraint uniqueBName

go

create proc uspAddForeignKeyPhone
as
	alter table Orders
	add constraint FKPhone foreign key(Phone) references Customers(Phone)

go

create proc uspRemoveForeignKeyPhone
as
	alter table Orders
	drop constraint FKPhone

go

create proc uspCreateEmployeesTable
as
	create table Employees(EID int primary key, EName varchar(50))

go

create proc uspDropEmployees
as
	drop table if exists Employees

go

exec uspChangeTypeStockQuantity
exec uspUndoChangeTypeStockQuantity
exec uspRemoveColumnShipmentStatus
exec uspAddColumnShipmentStatus
exec uspAddDefaultConstraintStockQuantity
exec uspRemoveDefaultConstraintStockQuantity
exec uspAddPrimaryKeyPhone
exec uspRemovePrimaryKeyPhone
exec uspAddCandidateKeyBName
exec uspRemoveCandidateKeyBName
exec uspRemoveForeignKeyPhone
exec uspAddForeignKeyPhone
exec uspCreateEmployeesTable
exec uspDropEmployees

create table CurrentVersion (currentVersion int)

insert into CurrentVersion values (1)

create table Versions
	(currentProcedure varchar(50),
	undoProcedure varchar(50),
	toVersion int unique)

insert into Versions values
	('uspChangeTypeStockQuantity', 'uspUndoChangeTypeStockQuantity', 2),
	('uspRemoveColumnShipmentStatus', 'uspAddColumnShipmentStatus', 3),
	('uspAddDefaultConstraintStockQuantity', 'uspRemoveDefaultConstraintStockQuantity', 4),
	('uspAddPrimaryKeyPhone', 'uspRemovePrimaryKeyPhone', 5),
	('uspAddCandidateKeyBName', 'uspRemoveCandidateKeyBName', 6),
	('uspRemoveForeignKeyPhone', 'uspAddForeignKeyPhone', 7),
	('uspCreateEmployeesTable', 'uspDropEmployees', 8)
go

create proc bringToVersion @version int
as
	declare @currentVersion int
	set @currentVersion = (select currentVersion from CurrentVersion)
	declare @currentProcedure varchar(50)
	if @currentVersion < @version
	begin
		while @currentVersion < @version
		begin
			set @currentProcedure = (select currentProcedure
									from Versions
									where toVersion = @currentVersion + 1)
			exec @currentProcedure
			set @currentVersion = @currentVersion + 1
		end
	end
	else 
		if @currentVersion > @version
		begin
			while @currentVersion > @version
			begin
				set @currentProcedure = (select undoProcedure
										from Versions
										where toVersion = @currentVersion)
				exec @currentProcedure
				set @currentVersion = @currentVersion - 1
			end
		end
		update CurrentVersion
		set currentVersion = @currentVersion
go

exec bringToVersion 3
exec bringToVersion 2

select * from Versions
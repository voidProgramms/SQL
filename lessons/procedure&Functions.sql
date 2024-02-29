use l1;
go

CREATE TABLE Clients(
 ID_Client INT PRIMARY KEY IDENTITY(1,1),
 ClientName VARCHAR(50) NOT NULL,
 ClientSurname VARCHAR(50) NOT NULL,
 ClientMiddleName VARCHAR(50) NOT NULL,
 Email VARCHAR(100) NOT NULL UNIQUE,
 PhoneNumber VARCHAR(11) NOT NULL UNIQUE
);
GO

INSERT INTO Clients(ClientName, ClientSurname, ClientMiddleName, Email, PhoneNumber)
VALUES
('Мария','Гарвикова','Анатольевна','gavrikova@ya.ru','81234567891'),
('Илья','Пушкин','Александрович','qewew@mail.ru','81234592463'),
('Дмитрий','Кирилов','Сергеевич','aaaaaa@yandex.ru','89153862714');
GO

CREATE TABLE Products(
 ID_Product INT PRIMARY KEY IDENTITY(1,1),
 ProductName VARCHAR(100) NOT NULL,
 Price DECIMAL(10,2) NOT NULL
);

INSERT INTO Products(ProductName, Price)
VALUES 
('Монитор',2400.95),
('Клавиатура',900.00),
('Мышка',500.00);
GO

CREATE TABLE Orders(
 ID_Order INT PRIMARY KEY IDENTITY(1,1),
 OrderDate DATE NOT NULL,
 Client_ID INT NOT NULL FOREIGN KEY REFERENCES Clients(ID_Client)
);
GO

INSERT INTO Orders(OrderDate, Client_ID)
VALUES
('25.01.2023',1),
('01.01.2024',2),
('23.12.2023',3);
GO

CREATE TABLE OrderDetails(
 ID_OrderDetails INT PRIMARY KEY IDENTITY(1,1),
 Order_ID INT NOT NULL FOREIGN KEY REFERENCES Orders(ID_Order),
 Product_ID INT NOT NULL FOREIGN KEY REFERENCES Products(ID_Product),
 Amount INT NOT NULL
);

INSERT INTO OrderDetails(Order_ID, Product_ID, Amount)
VALUES
(1,2,3),
(1,3,2),
(2,1,1),
(3,1,1);
GO

CREATE VIEW OrderClientView_Version1 AS 
SELECT Orders.OrderDate, Clients.ClientSurname, Clients.ClientName, 
 Clients.ClientMiddleName, Clients.Email, Clients.PhoneNumber
FROM Orders 
INNER JOIN Clients ON Orders.Client_ID = Clients.ID_Client;
GO

SELECT * FROM OrderClientView_Version1;
GO

CREATE VIEW OrderClientView_Version2 AS 
SELECT Orders.OrderDate AS 'Дата', 
 Clients.ClientSurname + ' ' + SUBSTRING(Clients.ClientName, 1, 1) + 
 '. ' + SUBSTRING(Clients.ClientMiddleName,1,1) + '.' AS 'Фамилимя и инициалы покупателя',
 'Почта": ' + Clients.Email + 'Телефон: ' + Clients.PhoneNumber AS 'Контактная информация'
FROM Orders 
INNER JOIN Clients ON Orders.Client_ID = Clients.ID_Client;
GO

SELECT * FROM OrderClientView_Version2;
GO

CREATE VIEW OrderClientView_Version3 AS 
SELECT Orders.OrderDate AS 'Дата', 
 Clients.ClientSurname + ' ' + SUBSTRING(Clients.ClientName, 1, 1) + 
 '. ' + SUBSTRING(Clients.ClientMiddleName,1,1) + '.' AS 'Фамилия и инициалы покупателя',
 COUNT(*) AS 'Количество повторений'
FROM Orders 
INNER JOIN Clients ON Orders.Client_ID = Clients.ID_Client
GROUP BY OrderDate, ClientName, ClientMiddleName, ClientSurname;
GO

SELECT * FROM OrderClientView_Version3;
GO

CREATE VIEW PriductsView AS 
SELECT Products.ProductName AS 'Название продукта',
 'Цена без скидки:' + CONVERT(VARCHAR(50),Products.Price) + 
 ' Цена со скидкой 50%:' + CONVERT(VARCHAR(50),ROUND(Products.Price * 0.5, 2)) AS 'Цена'
FROM Products
GO
SELECT * FROM PriductsView
go

create procedure AddProductProcedure
	@Name varchar(100),
	@Price decimal(10, 2)
as 
begin
	insert into Products(ProductName, Price)
	values(@Name, @Price);
end;
go

exec AddProductProcedure
	@Name = 'Charge',
	@Price = 12.23;
go

select * from Products;
go

create procedure UpdateProductProcedure
	@Name varchar(100),
	@Price decimal(10, 2),
	@ProductId int
as 
begin
	update Products set ProductName = @Name, Price = @Price where ID_Product = @ProductId;
end;

exec UpdateProductProcedure
	@Name = 'Charge',
	@Price = 130,
	@ProductId = 4;
go

select * from Products;
go

create procedure DeleteProductProcedure
	@Id int
as 
begin
	delete from Products where ID_Product = @Id;
end;

exec DeleteProductProcedure
	@Id = 4;
go


create procedure GetProductProcedure
	@Name varchar(100)
as 
begin
	select * from products where ProductName = @Name;
end;

exec GetProductProcedure
	@Name = 'Мышка';
go

create function CountClients()
returns varchar(50)
as 
begin
	declare @count int;
	select @count = COUNT(*) from Clients;
	return convert(varchar(50), @count);
end;
go

print 'Количество клиентов: ' + dbo.CountClients();
go

create function CountProducts(
	@id int
)
returns int
as 
begin
	declare @count int;
	select @count = sum(Amount) from OrderDetails inner join Orders on 
	(OrderDetails.Order_ID = Orders.ID_Order) where Client_ID = @id;  
	return @count;
end;
go

print 'Количество купленного товара: ' + convert(varchar(50), dbo.CountProducts(1));
go

create function CountProfitFunction()
returns decimal(10, 2)
as
begin
	declare @profit decimal(10, 2);
	select @profit = sum(OrderDetails.Amount * Products.Price) from OrderDetails inner join Products
	on (OrderDetails.Product_ID = Products.ID_Product);
	return @profit;
end;
go

print 'Сумма прибыли: ' + convert(varchar(50), dbo.CountProfitFunction());
go

create trigger OrderDetailsDelete_trigger
on OrderDetails 
after delete 
as
begin
	print 'Сумма прибыли: ' + convert(varchar(50), dbo.CountProfitFunction());
end;


insert into OrderDetails(Order_ID, Product_ID, Amount)
values (3,3,5),
(2,2,5),
(3,3,10);
go

delete from OrderDetails where ID_OrderDetails = 5;

create trigger AmountOrderDetails_trigger
on OrderDetails
after insert 
as
begin
	if exists
	(
		select 1
		from inserted
		where Amount <= 0
	)
	begin
		throw 51000, 'Количество должно быть больше 0!!!!!', 1
		rollback transaction
	end
end;
go

insert into OrderDetails(Order_ID, Product_ID, Amount)
values (2, 2, -10);
go


create login loginP322 with password = '123123';
go

create user logP322 for login loginP322;
go

create role superPupa;
go

alter role superPupa add member logP322;

exec sp_helpuser 'logP322';

grant insert, select on Products to logP322;

execute as user = 'logP322';
insert into Products(Price, ProductName)
values(123.22, 'aaa');
select * from Products;
select * from Orders;
go
revert;


CREATE LOGIN VladP322 WITH PASSWORD = '123';
GO

CREATE USER Vlad FOR LOGIN VladP322;
GO

ALTER ROLE superPupa ADD MEMBER Vlad;
GO

grant select on orders to logP322;
go

execute as user = 'logP322';
go

select * from Products;
go
revert;

backup database l1 to disk = 'l1.bak';

use master;
go
drop database l1;
go

restore database l1 from disk = 'l1.bak';
go

use l1;
go

select * from Products;

exec sp_configure 'show advanced options', 1
go
reconfigure
go
exec sp_configure 'xp_cmdshell', 1
go
reconfigure
go

EXEC xp_cmdshell 'bcp l1.dbo.Orders out "C:\Users\Public\Documents\SQL\MSSQL\ExportP3.csv" -w -t, -T -S trydyaga\SQLEXPRESS';
go





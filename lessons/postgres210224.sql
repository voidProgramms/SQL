CREATE TABLE Clients(
  ID_Client SERIAL PRIMARY KEY,
  ClientName VARCHAR(50) NOT NULL,
  ClientSurname VARCHAR(50) NOT NULL, 
  ClientMiddleName VARCHAR(50), 
  Email VARCHAR(100) NOT NULL UNIQUE,
  PhoneNumber VARCHAR(11) NOT NULL UNIQUE
);


INSERT INTO Clients(ClientName, ClientSurname, ClientMiddleName, Email, PhoneNumber)
VALUES
('Мария','Гаврикова','Анатольевна','gavrik150@yandex.ru','89224899962'),
('Илья','Пушкин','Александрович','pashkinIll13@gmail.com','89233884554'),
('Андрей','Андреев','Андреевич','manchkinov66@gmail.com','89166264920');


CREATE TABLE Products(
  ID_Product SERIAL PRIMARY KEY,
  ProductName VARCHAR(100) NOT NULL,
  Price DECIMAL(10,2) NOT NULL
);


INSERT INTO Products (ProductName, Price)
VALUES
('Монитор', 24000.98),
('Видеокарта', 55620.00),
('Мышка', 920.99);


CREATE TABLE Orders(
  ID_Order SERIAL PRIMARY KEY,
  OrderDate DATE NOT NULL,
  Client_ID INT NOT NULL REFERENCES Clients(ID_Client)
);


INSERT INTO Orders(OrderDate, Client_ID)
VALUES
('25.02.2024', 1), 
('26.02.2024', 2), 
('25.02.2023', 3);


CREATE TABLE OrderDetails (
  ID_OrderDetails SERIAL PRIMARY KEY,
  Order_ID INT NOT NULL  REFERENCES Orders(ID_Order),
  Product_ID INT NOT NULL  REFERENCES Products(ID_Product),
  Amount INT NOT NULL
);


INSERT INTO OrderDetails(Order_ID, Product_ID, Amount)
VALUES
(1,2,3),
(1,3,2),
(2,1,1),
(3,1,1);


CREATE VIEW OrderClientsView_Version1 AS
SELECT Orders.OrderDate as "Дата",  Clients.ClientSurname || ' ' || left(Clients.ClientName, 1) || '. ' || left(Clients.ClientMiddleName, 1) || '. ' as "Фамилия и инициалы покупателя",
'Почта: ' || Clients.Email || ' Телефон: ' || Clients.PhoneNumber as "Контактная информация" 
FROM Orders INNER JOIN Clients ON Orders.Client_ID = Clients.ID_Client;


SELECT * FROM OrderClientsView_Version1;


CREATE VIEW OrderClientsView_Version2 AS
SELECT Orders.OrderDate as "Дата",  Clients.ClientSurname || ' ' || left(Clients.ClientName, 1) || '. ' || left(Clients.ClientMiddleName, 1) || '. ' as "Фамилия и инициалы покупателя",
'Почта: ' || Clients.Email || ' Телефон: ' || Clients.PhoneNumber as "Контактная информация",
count (*) as "Кол-во повторений"
FROM Orders INNER JOIN Clients ON Orders.Client_ID = Clients.ID_Client
group by OrderDate, ClientSurname, ClientName, ClientMiddleName, Email, PhoneNumber;


SELECT * FROM Orders;


SELECT * FROM OrderClientsView_Version2;

SELECT * FROM OrderClientsView_Version3;


CREATE VIEW ProductsView AS 
SELECT Products.ProductName AS "Название продукта",
  'Цена без скидки: ' || Products.Price || ' Цена со скидкой 50%: ' || round(Products.Price * 0.5,2) AS "ЦЕНА" 
FROM Products;

select * from ProductsView;

CREATE or replace PROCEDURE AddProductProcedure(
    in ProductName1 VARCHAR(100),
    in Price1 DECIMAL(10,2)
) language plpgsql
as $$
BEGIN
   INSERT INTO Products(ProductName, Price)
    VALUES (ProductName1, Price1);
end $$;


call AddProductProcedure(
    'Зарядка', 12.23
);


SELECT * FROM Products;


CREATE or replace PROCEDURE UpdateProductProcedure (
    in ProductName1 VARCHAR(100),
    in Price1 DECIMAL(10,2),
    in ID_Product1 INT
) language plpgsql
AS $$
BEGIN
    UPDATE Products
    SET ProductName=ProductName1, Price=Price1
    WHERE ID_Product=ID_Product1;
END $$;


call UpdateProductProcedure(
     'Ядерная бомба', 12345.67, 4
);

select * from Products;


CREATE PROCEDURE DeleteProductProcedure
    @ID INT
AS
BEGIN
    DELETE FROM Products
    WHERE ID_Product = @ID
END;


EXEC DeleteProductProcedure @ID = 5;


CREATE PROCEDURE GetProductProcedure
    @Name VARCHAR(100)
AS
BEGIN
    SELECT * FROM Products
    WHERE ProductName = @Name
END;


EXEC GetProductProcedure @Name = 'Клавиатура';


CREATE FUNCTION CountClientsFunction()
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) FROM Clients;
    RETURN CONVERT(VARCHAR(50), @Count);
END;


PRINT dbo.CountClientsFunction();


PRINT  'Количество клиентов: ' + dbo.CountClientsFunction();

SELECT  'Количество клиентов: ' + dbo.CountClientsFunction() AS 'СТОЛБЕЦ';


CREATE FUNCTION CountProductClientFunction(@ID INT)
RETURNS INT
AS
BEGIN
    DECLARE @ProductCount INT;

    SELECT @ProductCount = SUM(OrderDetails.Amount)
    FROM OrderDetails
    INNER JOIN Orders ON Orders.ID_Order = OrderDetails.Order_ID
    WHERE Orders.Client_ID = @ID;

    RETURN @ProductCount;
END;


PRINT dbo.CountProductClientFunction(6);


SELECT * FROM Clients;
SELECT * FROM Orders;
SELECT * FROM Products;
SELECT * FROM OrderDetails;

CREATE FUNCTION ProfitStoreFunction()
RETURNS DECIMAL(18,2)
AS
BEGIN
  DECLARE @Profit DECIMAL(10,2)

  SELECT @Profit = SUM(OrderDetails.Amount * Products.Price)
  FROM OrderDetails
  INNER JOIN Products ON Products.ID_Product = OrderDetails.Product_ID;

  RETURN @Profit;
END;

PRINT dbo.ProfitStoreFunction();


CREATE TRIGGER OrderDetailsDelete_trg
ON OrderDetails
AFTER DELETE 
AS 
BEGIN
  PRINT dbo.ProfitStoreFunction();
END;


SELECT * FROM OrderDetails;

DELETE FROM OrderDetails
WHERE ID_OrderDetails = 1;


INSERT INTO OrderDetails(Order_ID, Product_ID, Amount)
Values
(1,2,3),
(1,3,2),
(2,1,1);


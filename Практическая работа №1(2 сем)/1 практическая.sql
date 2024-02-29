create database universary;
go

use universary;
go

create table storages(
	ID_storage int primary key identity(1, 1),
	storageName int,
);
go

go
create table typeOfProduct(
	ID_typeOfProduct int primary key identity(1, 1),
);
go

go
create table volumeOfProductPackaging(
	ID_volumeOfProductPackaging int primary key identity(1, 1),
	volumeOfProductPackaging int,
);
go

go
create table producers(
	ID_producer int primary key identity(1, 1),
	producer nvarchar(20) not null,
);
go

create table product(
	ID_product int primary key identity(1, 1),
	productName nvarchar(20) not null,
	productCode nvarchar(20) not null,
	productDescription nvarchar(20) not null
);
go

create table storageConditionOfProducts(
	ID_storageConditionOfProducts int primary key identity(1, 1),
	storageConditionOfProduct nvarchar(20) not null,
);
go

create table conditionForIssuingProduct(
	ID_conditionForIssuingProduct int primary key identity(1, 1),
	conditionForIssuingProduct nvarchar(20) not null,
);
go

create table allProducts(
	ID int primary key identity(1, 1),
	quantityOfProduct int not null,
	productExpirationDate date not null,
	ID_storage int
	foreign key (ID_storage) references storages(ID_storage),
	ID_typeOfProduct int
	foreign key (ID_typeOfProduct) references
	typeOfProduct(ID_typeOfProduct),
	ID_volumeOfProductPackaging int
	foreign key (ID_volumeOfProductPackaging) references
	volumeOfProductPackaging(ID_volumeOfProductPackaging),
	ID_producer int,
	ID_product int
	foreign key (ID_product) references product(ID_product),
	ID_storageConditionOfProducts int
	foreign key (ID_storageConditionOfProducts) references
	storageConditionOfProducts(ID_storageConditionOfProducts),
	ID_conditionForIssuingProduct int
	foreign key (ID_conditionForIssuingProduct) references
	conditionForIssuingProduct(ID_conditionForIssuingProduct),
);
go

alter table storages
alter column storageName nvarchar(20) not null;

alter table volumeOfProductPackaging
add constraint volumeOfProductPackaging_Check check (volumeOfProductPackaging > 0);

alter table typeOfproduct
add nameTypeOfProduct nvarchar(20) not null;

alter table allProducts
add foreign key (ID_producer) references
producers(ID_producer);

alter table product
drop column productDescription;

insert into storages(storageName)
values('1'), ('2'), ('3'), ('4'), ('5');

update storages set storageName=2 where ID_storage=1;
delete from storages where storageName='5';

insert into typeOfProduct(nameTypeOfProduct)
values ('сироп'), ('тыблетки'),('раствор'), ('батончики');

update typeOfProduct set nameTypeOfProduct='капли' where ID_typeOfProduct=3;
delete from typeOfProduct where ID_typeOfProduct=2;

insert into volumeOfProductPackaging(volumeOfProductPackaging)
values (700), (500), (600), (300), (350);

update volumeOfProductPackaging set volumeOfProductPackaging=600 where ID_volumeOfProductPackaging=2;
delete from volumeOfProductPackaging where ID_volumeOfProductPackaging=4;

insert into producers(producer)
values('ООО "РосГрупп"'), ('ЗАО "РусМед"'), ('ОАО "МосМед"'), ('ООО "ФранцГрупп"'), ('ЗАО "УГНМед"');

update producers set producer='ЗАО ГРОММед' where ID_producer=2;
delete from producers where producer='ООО "ФранцГрупп"';

insert into product(productName, productCode)
values('Нурафен', '43242'), ('Доктор МОМ', '48294'), ('Мирамистин', '65874'), ('Гемотаген', '90328'), ('Тизин', '63542');

update product set productCode='5555' where productName='Нурафен';
delete from product where productCode='65874';

insert into storageConditionOfProducts(storageConditionOfProduct)
values('от 5 до 15'), ('от 0'), ('от 10 до 15'), ('до 15'), ('от -5 до 15');

update storageConditionOfProducts set storageConditionOfProduct='от 0' where ID_storageConditionOfProducts=2;
delete from storageConditionOfProducts where ID_storageConditionOfProducts=4;

insert into conditionForIssuingProduct(conditionForIssuingProduct)
values('выписка врача'), ('свободная продажа'), ('отсутствует');

update conditionForIssuingProduct set conditionForIssuingProduct='не нуждается' where ID_conditionForIssuingProduct=1;
delete from conditionForIssuingProduct where ID_conditionForIssuingProduct=3;

insert into allProducts (quantityOfProduct, productExpirationDate, ID_storage, ID_typeOfProduct, ID_volumeOfProductPackaging,
ID_producer, ID_product, ID_storageConditionOfProducts, ID_conditionForIssuingProduct)
values(2034, '13.10.2023' , 1, 1, 1, 1, 1, 1, 1), (1234, '15.12.2025' , 2, 3, 2, 2, 2, 2, 2), (2034, '4.1.2028' , 3, 3, 3, 3, 2, 3, 1),
(2034, '5.3.2026' , 4, 4, 3, 5, 5, 5, 2);

update allProducts set ID_storage=2 where quantityOfProduct=2034;
delete from allProducts where ID=4;

update storages set storageName=6 where ID_storage=2;
go

update volumeOfProductPackaging set volumeOfProductPackaging = 615 where ID_volumeOfProductPackaging = 3;
go

delete from typeOfProduct where ID_typeOfProduct = 5;
go

delete from typeOfProduct where ID_typeOfProduct = 8;
go

create view productStorageConditionView as
select storageConditionOfProducts.storageConditionOfProduct as 'Условия хранения',
product.productName as 'Продукт'
from storageConditionOfProducts inner join allProducts on (storageConditionOfProducts.ID_storageConditionOfProducts = allProducts.ID_storageConditionOfProducts)
inner join product on (allProducts.ID_product = product.ID_product);
go

select * from productStorageConditionView;
go

create view productProducerView as 
select producers.producer as 'Произоводитель',
allProducts.productExpirationDate as 'Срок годности', product.productName as 'Продукт'
from allProducts left join producers on (allProducts.ID_producer = producers.ID_producer) 
left join product on (allProducts.ID_product = product.ID_product);
go

select * from productProducerView;
go

create view quantityOfProductView as
select allProducts.quantityOfProduct as 'Количество товара',
product.productName as 'Продукт'
from product right join allProducts on (product.ID_product = allProducts.ID_product);
go

select * from quantityOfProductView;
go

create procedure addProductProcedure
	@name nvarchar(20),
	@code nvarchar(20)
as
begin
	insert into product(productName, productCode)
	values (@name, @code);
end;
go

create procedure editProductCodeProcedure
	@id int,
	@code nvarchar(20)
as 
begin
	update product set productCode = @code where ID_product = @id;
end;
go

create procedure deleteProductProcedure
	@id int
as
begin
	delete from product where ID_product = @id;
end;
go

exec addProductProcedure
	@name = 'Лук',
	@code = '123n4!'
go

select * from product;

exec editProductCodeProcedure
	@id = 6,
	@code = 33333
go
select * from product;

exec deleteProductProcedure
	@id = 6
go 

create function CountAnyType(@type nvarchar(20))
returns nvarchar(10)
as 
begin
	declare @count int;
	select @count = COUNT(*) 
	from typeOfProduct inner join allProducts on (typeOfProduct.ID_typeOfProduct = allProducts.ID_typeOfProduct)
	where typeOfProduct.nameTypeOfProduct = @type;
	return convert(nvarchar(10), @count);
end;
go

print 'Количество продуктов с вашим типом: ' + dbo.CountAnyType('сироп');
go

create function volumeOfProductsPackaging()
returns nvarchar(15)
as
begin
	declare @volume int;
	select @volume = sum(volumeOfProductPackaging.volumeOfProductPackaging * allProducts.quantityOfProduct) from
	volumeOfProductPackaging full join allProducts on
	(volumeOfProductPackaging.ID_volumeOfProductPackaging = allProducts.ID_volumeOfProductPackaging);
	return convert(nvarchar(15), @volume);
end;
go

print 'Объем упаковок всех продуктов: ' + dbo.volumeOfProductsPackaging() + ' кубических см';
go

create function volumeOfProductPackaginInStorage(@storageName nvarchar(20))
returns nvarchar(15)
as
begin
	declare @volume decimal(10, 2);
	declare @storageId int;
	select @storageId = storages.ID_storage from storages where storageName = @storageName;
	select @volume = sum(volumeOfProductPackaging.volumeOfProductPackaging * allProducts.quantityOfProduct) from
	storages inner join allProducts on (storages.ID_storage = allProducts.ID_storage) 
	inner join volumeOfProductPackaging on (allProducts.ID_volumeOfProductPackaging =
	volumeOfProductPackaging.ID_volumeOfProductPackaging) where storages.ID_storage = @storageId;
	return convert(nvarchar(15), @volume);
end;
go

print 'Объем продуктов на Вашем складе: ' + dbo.volumeOfProductPackaginInStorage('6') + ' кубических см';
go

create trigger productsVolumeOfPackaging
on allProducts
after insert, update, delete
as 
begin
	if update(quantityOfProduct) 
	begin
print 'Объем упаковок всех продуктов: ' + dbo.volumeOfProductsPackaging() + ' кубических см';
	end
	if exists(select * from inserted) 
	begin
		print 'Объем упаковок всех продуктов: ' + dbo.volumeOfProductsPackaging() + ' кубических см';
	end
	if exists(select * from deleted)
	begin
		print 'Объем упаковок всех продуктов: ' + dbo.volumeOfProductsPackaging() + ' кубических см';
	end
end;
go

create trigger UniqueTypeOfProduct
on typeOfproduct
after insert
as
begin
	if exists (
        select 1
        from inserted 
        inner join typeOfproduct  on inserted.nameTypeOfProduct = typeOfproduct.nameTypeOfProduct
    )
    begin
        throw 51000, 'Значение поля nameTypeOfProduct должно быть уникальным.', 1;
        rollback transaction
    end
end;
go

create trigger minimumQuantity
on allProducts
after insert, update
as
begin
	if update(quantityOfProduct) 
	begin
		update allProducts set quantityOfProduct = 0 where quantityOfProduct < 0;
	end
	if exists(select * from inserted) 
	begin
		update allProducts set quantityOfProduct = 0 where quantityOfProduct < 0;
	end
end;

create role anyGroup;

create login genius with password = '***';
create user genius for login genius;
alter role anyGroup add member genius;
grant select, insert to genius;

create login idiot with password = '123';
create user idiot for login idiot;
alter role anyGroup add member idiot;
grant select to idiot;

exec sp_configure 'show advanced options', 1
go
reconfigure
go
exec sp_configure 'xp_cmdshell', 1
go
reconfigure
go

exec xp_cmdshell 'bcp universary.dbo.allProducts out "C:\Users\Public\Documents\SQL\MSSQL\allProducts.csv" -w -t, -T -S trydyaga\SQLEXPRESS';
go

exec xp_cmdshell 'bcp universary.dbo.storageConditionOfProducts out "C:\Users\Public\Documents\SQL\MSSQL\storageConditionOfProducts.csv" -w -t, -T -S trydyaga\SQLEXPRESS';
go

delete from allProducts;
delete storageConditionOfProducts;

exec xp_cmdshell 'bcp universary.dbo.storageConditionOfProducts in "C:\Users\Public\Documents\SQL\MSSQL\storageConditionOfProducts.csv" -w -t, -T -S trydyaga\SQLEXPRESS';
go

exec xp_cmdshell 'bcp universary.dbo.allProducts in "C:\Users\Public\Documents\SQL\MSSQL\allProducts.csv" -w -t, -T -S trydyaga\SQLEXPRESS';
go

backup database universary to disk = 'universary.bak';

select * from product where product.productName like '%МОМ%';
select * from producers where producers.producer like 'ООО%';
select * from allProducts where allProducts.productExpirationDate like '%13';
select * from typeOfProduct where typeOfProduct.nameTypeOfProduct like '_ироп';






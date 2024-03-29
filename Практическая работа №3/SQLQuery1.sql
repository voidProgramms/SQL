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

go
create table storageConditionOfProducts(
	ID_storageConditionOfProducts int primary key identity(1, 1),
	storageConditionOfProduct nvarchar(20) not null,
);
go

go
create table conditionForIssuingProduct(
	ID_conditionForIssuingProduct int primary key identity(1, 1),
	conditionForIssuingProduct nvarchar(20) not null,
);
go

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
add constraint volumeOfProductPackaging check (volumeOfProductPackaging > 0);

alter table typeOfproduct
add typeOfProduct nvarchar(20) not null;

alter table allProducts
add foreign key (ID_producer) references
producers(ID_producer);

alter table product
drop column productDescription;


insert into storages(storageName)
values('1');
insert into storages(storageName)
values('2');
insert into storages(storageName)
values('3');
insert into storages(storageName)
values('4');
insert into storages(storageName)
values('5');

update storages set storageName=2 where ID_storage=1;
delete from storages where storageName='5';

insert into typeOfProduct(typeOfProduct)
values ('�����');
insert into typeOfProduct(typeOfProduct)
values ('��������');
insert into typeOfProduct(typeOfProduct)
values ('�������');
insert into typeOfProduct(typeOfProduct)
values ('���������');


update typeOfProduct set typeOfProduct='�����' where ID_typeOfProduct=3;
delete from typeOfProduct where ID_typeOfProduct=2;

insert into volumeOfProductPackaging(volumeOfProductPackaging)
values (700);
insert into volumeOfProductPackaging(volumeOfProductPackaging)
values (500);
insert into volumeOfProductPackaging(volumeOfProductPackaging)
values (600);
insert into volumeOfProductPackaging(volumeOfProductPackaging)
values (300);
insert into volumeOfProductPackaging(volumeOfProductPackaging)
values (350);

update volumeOfProductPackaging set volumeOfProductPackaging=600 where ID_volumeOfProductPackaging=2;
delete from volumeOfProductPackaging where ID_volumeOfProductPackaging=4;

insert into producers(producer)
values('��� "��������"');
insert into producers(producer)
values('��� "������"');
insert into producers(producer)
values('��� "������"');
insert into producers(producer)
values('��� "����������"');
insert into producers(producer)
values('��� "������"');

update producers set producer='��� �������' where ID_producer=2;
delete from producers where producer='��� "������"';

insert into product(productName, productCode)
values('�������', '43242');
insert into product(productName, productCode)
values('������ ���', '48294');
insert into product(productName, productCode)
values('����������', '65874');
insert into product(productName, productCode)
values('���������', '90328');
insert into product(productName, productCode)
values('�����', '63542');

update product set productCode='5555' where productName='�������';
delete from product where productCode='65874';

insert into storageConditionOfProducts(storageConditionOfProduct)
values('�� 5 �� 15');
insert into storageConditionOfProducts(storageConditionOfProduct)
values('�� 0');
insert into storageConditionOfProducts(storageConditionOfProduct)
values('�� 10 �� 15');
insert into storageConditionOfProducts(storageConditionOfProduct)
values('�� 15');
insert into storageConditionOfProducts(storageConditionOfProduct)
values('�� -5 �� 15');

update storageConditionOfProducts set storageConditionOfProduct='�� 0' where ID_storageConditionOfProducts=2;
delete from storageConditionOfProducts where ID_storageConditionOfProducts=4;

insert into conditionForIssuingProduct(conditionForIssuingProduct)
values('������� �����');
insert into conditionForIssuingProduct(conditionForIssuingProduct)
values('��������� �������');
insert into conditionForIssuingProduct(conditionForIssuingProduct)
values('�����������');

update conditionForIssuingProduct set conditionForIssuingProduct='�� ���������' where ID_conditionForIssuingProduct=1;
delete from conditionForIssuingProduct where ID_conditionForIssuingProduct=3;

insert into allProducts (quantityOfProduct, productExpirationDate, ID_storage, ID_typeOfProduct, ID_volumeOfProductPackaging,
ID_producer, ID_product, ID_storageConditionOfProducts, ID_conditionForIssuingProduct)
values(2034, '13.10.2023' , 1, 1, 1, 1, 1, 1, 1);
insert into allProducts (quantityOfProduct, productExpirationDate, ID_storage, ID_typeOfProduct, ID_volumeOfProductPackaging,
ID_producer, ID_product, ID_storageConditionOfProducts, ID_conditionForIssuingProduct)
values(1234, '15.12.2025' , 2, 2, 2, 2, 2, 2, 2);
insert into allProducts (quantityOfProduct, productExpirationDate, ID_storage, ID_typeOfProduct, ID_volumeOfProductPackaging,
ID_producer, ID_product, ID_storageConditionOfProducts, ID_conditionForIssuingProduct)
values(2034, '4.1.2028' , 3, 3, 3, 3, 3, 3, 1);
insert into allProducts (quantityOfProduct, productExpirationDate, ID_storage, ID_typeOfProduct, ID_volumeOfProductPackaging,
ID_producer, ID_product, ID_storageConditionOfProducts, ID_conditionForIssuingProduct)
values(2034, '5.3.2026' , 4, 4, 4, 5, 5, 5, 2);

update allProducts set ID_storage=2 where quantityOfProduct=2034;
delete from allProducts where ID=4;

select storageName from storages;
select * from producers;
select quantityOfProduct from allProducts where productExpirationDate='15.12.2025';

select * from
allProducts right join producers on (ID = 3);

select productCode, storageConditionOfProduct from
storageConditionOfProducts inner join product on (ID_storageConditionOfProducts=2 and ID_product=2)

select productName, producer from
producers full join product on (ID_producer = ID_product);

select conditionForIssuingProduct, productName from
product left join conditionForIssuingProduct on (ID_product = ID_conditionForIssuingProduct);




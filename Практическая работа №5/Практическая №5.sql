create table if not exists storages(
	ID_storage serial primary key,
	storageName int
);

create table if not exists typeOfProduct(
	ID_typeOfProduct serial primary key
);

create table if not exists volumeOfProductPackaging(
	ID_volumeOfProductPackaging serial primary key,
	volumeOfProductPackaging int
);

create table if not exists producers(
	ID_producer serial primary key,
	producer varchar(20) not null
);

create table if not exists product(
	ID_product serial primary key,
	productName varchar(20) not null,
	productCode varchar(20) not null,
	productDescription varchar(20) not null
);

create table if not exists storageConditionOfProducts(
	ID_storageConditionOfProducts serial primary key,
	storageConditionOfProduct varchar(20) not null
);

create table if not exists conditionForIssuingProduct(
	ID_conditionForIssuingProduct serial primary key,
	conditionForIssuingProduct varchar(20) not null
);

create table if not exists allProducts(
	ID_allProducts serial primary key ,
	quantityOfProduct int not null,
	productExpirationDate date not null,
	ID_storage int,
	ID_volumeOfProductPackaging int,
	ID_producer int,
	ID_product int,
	foreign key (ID_storage) references storages(ID_storage),
	ID_typeOfProduct int,
	foreign key (ID_typeOfProduct) references
	typeOfProduct(ID_typeOfProduct),
	foreign key (ID_volumeOfProductPackaging) references
	volumeOfProductPackaging(ID_volumeOfProductPackaging),
	foreign key (ID_product) references product(ID_product),
	ID_storageConditionOfProducts int,
	foreign key (ID_storageConditionOfProducts) references
	storageConditionOfProducts(ID_storageConditionOfProducts),
	ID_conditionForIssuingProduct int,
	foreign key (ID_conditionForIssuingProduct) references
	conditionForIssuingProduct(ID_conditionForIssuingProduct)
);

alter table storages
alter column storageName type varchar(20),
alter column storageName set not null;

alter table volumeOfProductPackaging
add constraint volumeOfProductPackaging_Check check (volumeOfProductPackaging > 0);

alter table typeOfproduct
add nameTypeOfProduct varchar(20),
alter column nameTypeOfProduct set not null;

alter table allProducts
add foreign key (ID_producer) references
producers(ID_producer);

alter table product
drop column productDescription;
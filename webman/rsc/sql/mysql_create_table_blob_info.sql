create table webman_appName_blob_info (
blob_id smallint not null,
filename varchar(255) not null,
extension varchar(25) not null,
upload_date date not null,
upload_time time not null,
mime_type varchar(255) not null,
owner_entity_id smallint not null,
owner_entity_name varchar(255) not null,
language varchar(25),
primary key (blob_id)
);
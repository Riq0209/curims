create table webman_appName_blob_content_temp (
blob_id smallint not null,
content mediumblob,
filename varchar(255),
extension varchar(255),
owner_entity_id smallint,
owner_entity_name varchar(255),
primary key (blob_id)
);
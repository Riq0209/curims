create table webman_appName_link_reference (
link_ref_id smallint auto_increment not null,
link_id smallint not null,
dynamic_content_num smallint not null,
dynamic_content_name varchar(255),
ref_type enum('DYNAMIC_MODULE', 'STATIC_FILE') not null,
ref_name varchar(255) not null,
blob_id smallint,
primary key(link_ref_id)
)
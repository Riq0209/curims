create table webman_appName_static_content_dyna_mod_ref (
scdmr_id smallint auto_increment not null,
blob_id smallint not null,
dynamic_content_name varchar(255) not null,
dyna_mod_name varchar(255) not null,
primary key(scdmr_id)
);
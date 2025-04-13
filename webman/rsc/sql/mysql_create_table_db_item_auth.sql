create table webman_appName_db_item_auth (
id_dbia int not null auto_increment,
login_name varchar(50),
group_name varchar(50),
table_name varchar(50),
key_field_name varchar(50),
key_field_value varchar(50),
mode_insert tinyint(1),
mode_update tinyint(1),
mode_delete tinyint(1),
set_by_login_name varchar(15),
set_by_app_name varchar(100),
primary key (id_dbia)
);
create table webman_appName_dyna_mod_param_global (
dmpg_id smallint auto_increment not null,
dyna_mod_name varchar(255) not null,
dynamic_content_num smallint,
 dynamic_content_name varchar(255),
param_name varchar(255),
param_value text,
primary key (dmpg_id)
);
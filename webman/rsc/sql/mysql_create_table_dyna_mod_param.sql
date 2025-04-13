create table webman_appName_dyna_mod_param (
dmp_id smallint auto_increment not null,
link_ref_id smallint not null,
scdmr_id smallint not null,
dyna_mod_selector_id smallint not null,
param_name varchar(255),
param_value text,
primary key (dmp_id)
);
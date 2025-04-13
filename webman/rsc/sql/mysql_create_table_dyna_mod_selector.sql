create table webman_appName_dyna_mod_selector (
dyna_mod_selector_id smallint not null auto_increment,
link_ref_id smallint,
parent_id smallint,
cgi_param varchar(100),
cgi_value varchar(100),
dyna_mod_name varchar(255),
primary key (dyna_mod_selector_id)
);
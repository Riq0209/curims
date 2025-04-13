create table webman_appName_cgi_var_cache (
id_cgi_var_cache int auto_increment not null,
session_id varchar(15),
link_id smallint,
name varchar(255),
value text,
active_mode smallint default 1,
primary key(id_cgi_var_cache)
);
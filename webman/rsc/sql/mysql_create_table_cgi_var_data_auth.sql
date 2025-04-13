create table webman_appName_cgi_var_data_auth (
id smallint unsigned not null auto_incerement,
key_name_value varchar(255),
login_name varchar(15),
group_name varchar(50),
var_name varchar(50),
var_value varchar(50)
primary_key (id)
);
create table webman_appName_user (
id_user binary(6) not null,
login_name varchar(50) not null,
password varchar(50),
full_name varchar(50),
description varchar(255),
web_service_url varchar(255),
primary key(id_user),
unique key `idx_login_name` (`login_name`)
);
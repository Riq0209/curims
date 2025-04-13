create table webman_appName_link_auth (
id_link_auth int not null auto_increment,
link_id smallint not null,
login_name varchar(50) null,
group_name varchar(50) null,
primary key (id_link_auth)
);
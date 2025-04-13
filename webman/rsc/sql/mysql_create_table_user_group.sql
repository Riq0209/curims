create table webman_appName_user_group (
id_user_group smallint unsigned not null auto_increment,
login_name varchar(50),
group_name varchar(50),
primary key (id_user_group)
);

insert into webman_appName_user_group (login_name, group_name) values ('admin', 'ADMIN');
insert into webman_appName_user_group (login_name, group_name) values ('admin', 'COM_JSON');
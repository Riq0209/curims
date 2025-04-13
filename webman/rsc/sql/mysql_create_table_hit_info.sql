create table webman_appName_hit_info (
hit_id int not null auto_increment,
session_id varchar(15) not null,
date date,
time time,
method varchar(5),
primary key (hit_id)
);
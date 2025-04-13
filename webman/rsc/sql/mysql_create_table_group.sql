create table webman_appName_group (
id_group binary(6),
group_name varchar(50) not null,
description varchar(255),
primary key(id_group),
unique key `idx_group_name` (`group_name`)
);
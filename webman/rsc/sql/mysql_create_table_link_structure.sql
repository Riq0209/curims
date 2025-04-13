create table webman_appName_link_structure (
link_id smallint auto_increment not null,
parent_id smallint,
name varchar(255),
sequence smallint,
auto_selected enum('NO', 'YES'),
target_window varchar(10),
primary key (link_id)
);

insert into webman_appName_link_structure (parent_id, name, sequence, auto_selected) values ('0', 'Home', '0', 'YES');
insert into webman_appName_link_structure (parent_id, name, sequence, auto_selected) values ('0', 'json_entities_', '1', 'NO');
insert into webman_appName_link_structure (parent_id, name, sequence, auto_selected) values ('0', 'test_', '2', 'NO');

insert into webman_appName_link_structure (parent_id, name, sequence, auto_selected) values ('2', 'authentication', '0', 'NO');
insert into webman_appName_link_structure (parent_id, name, sequence, auto_selected) values ('2', 'users', '1', 'NO');
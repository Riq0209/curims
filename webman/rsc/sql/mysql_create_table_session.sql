create table webman_appName_session (
session_id varchar(15) not null,
login_name varchar(50),
login_date date,
login_time time,
last_active_date date,
last_active_time time,
epoch_time int,
idle_time int,
status varchar(10),
temp_table smallint,
client_ip varchar(50),
hits smallint,
auth_status varchar(15) default 'LOCAL',
primary key (session_id)
);
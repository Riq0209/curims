create table webman_appName_session_info_daily (
date date not null,
day smallint not null,
day_abbr varchar(10),
total_user int,
total_login int,
total_hits int,
primary key (date)
);
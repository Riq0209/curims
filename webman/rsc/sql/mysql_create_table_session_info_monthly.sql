create table webman_appName_session_info_monthly (
yearmonth varchar(7) not null, 
total_user int, 
total_login int, 
total_hits int, 
primary key (yearmonth)
);
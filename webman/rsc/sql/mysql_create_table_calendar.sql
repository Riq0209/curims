create table webman_appName_calendar (
cal_id smallint auto_increment not null,
year smallint not null,
month smallint not null,
date smallint not null,
day smallint not null,
month_abbr varchar(10),
day_abbr varchar(10),
next_cal_id smallint,
prev_cal_id smallint,
iso_ymd date,
primary key (cal_id)
);
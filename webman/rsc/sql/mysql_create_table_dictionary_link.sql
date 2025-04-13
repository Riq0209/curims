create table webman_appName_dictionary_link (
link_lang_id smallint not null,
link_id smallint not null,
lang_id smallint not null,
link_name_translate varchar(255),
primary key(link_lang_id)
);
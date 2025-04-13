create table webman_appName_dictionary_dyna_mod (
phrase_id smallint not null auto_increment,
lang_id smallint not null,
dyna_mod_name varchar(255),
phrase varchar(255),
phrase_word_num smallint,
phrase_translate varchar(255),
primary key(phrase_id)
);
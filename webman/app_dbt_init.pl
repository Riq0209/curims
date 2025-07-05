#! #!/usr/bin/perl

unshift (@INC, "./pm/cli_tool/");
unshift (@INC, "./pm/core");

use DBI;

require DB_Utilities;
require Webman_Config_Tools;

my $app_name = $ARGV[0];
my $db_host = $ARGV[1];
my $db_name = $ARGV[2];
my $db_user_name = $ARGV[3];
my $db_password = $ARGV[4];

my $wmct = new Webman_Config_Tools;

my $dir_web_cgi = $wmct->{dir_web_cgi};

print "Initialize Webman Application DB Tables\n\n";


print "Application Name: ";
if ($app_name eq "") {
    $app_name = <STDIN>; 
    $app_name =~ s/\n//;
    $app_name =~ s/\r//;
    
} else {
    print "$app_name\n";
}

print $dir_web_cgi . "/$app_name" . "\n";

my $file_opres = -e $dir_web_cgi . "/$app_name";

if (!$file_opres) {
    print "Can't proceed since the application '$app_name' is not exist!!!\n";
    exit 1;
}

print "\n\n Database Information:\n\n";

print "     DB HOST: ";
if ($db_host eq "") {
    if ($wmct->{"db_host"} ne "") {
        $db_host = $wmct->{"db_host"};
        
    } else {
        $db_host = <STDIN>;
        $db_host =~ s/\n//;
        $db_host =~ s/\r//;
    }
    
}
print "$db_host\n";


print "     DB Name: ";
if ($db_name eq "") {
    if ($wmct->{"db_name"} ne "") {
        $db_name = $wmct->{"db_name"};
        
    } else {
        $db_name = <STDIN>;
        $db_name =~ s/\n//;
        $db_name =~ s/\r//;
    }
    
}
print "$db_name\n";


print "DB User Name: ";
if ($db_user_name eq "") {
    if ($wmct->{"db_user_name"} ne "") {
        $db_user_name = $wmct->{"db_user_name"};
        
    } else {
        $db_user_name = <STDIN>;
        $db_user_name =~ s/\n//;
        $db_user_name =~ s/\r//;
    }
    
}
print "$db_user_name\n";


print " DB Password: ";

if ($db_password eq "") {
    if ($wmct->{"db_password"} ne "") {
        $db_password = $wmct->{"db_password"};
        
    } else {
        $db_password = <STDIN>;
        $db_password =~ s/\n//;
        $db_password =~ s/\r//;
    }
    
}
print "$db_password\n";

print "\n";

my $dbu = new DB_Utilities;
my $db_conn = $dbu->make_DBI_Conn("./conf/dbi_connection.conf");

my @file_name = ("mysql_create_table_blob_content.sql", "mysql_create_table_blob_content_temp.sql", 
                 "mysql_create_table_blob_info.sql", "mysql_create_table_blob_parent_info.sql",
                 "mysql_create_table_dyna_mod.sql", "mysql_create_table_dyna_mod_param.sql", "mysql_create_table_dyna_mod_selector.sql",
                 "mysql_create_table_dyna_mod_param_global.sql", "mysql_create_table_link_reference.sql", 
                 "mysql_create_table_link_structure.sql", "mysql_create_table_static_content_dyna_mod_ref.sql", 
                 "mysql_create_table_calendar.sql", "mysql_create_table_dictionary_link.sql", 
                 "mysql_create_table_dictionary_language.sql", "mysql_create_table_dictionary_dyna_mod.sql",
                 "mysql_create_table_comp_auth.sql", "mysql_create_table_session.sql", "mysql_create_table_cgi_var_cache.sql",
                 "mysql_create_table_user.sql", "mysql_create_table_group.sql", 
                 "mysql_create_table_user_group.sql", "mysql_create_table_db_item_auth.sql",
                 "mysql_create_table_hit_info.sql", "mysql_create_table_hit_info_query_string.sql", "mysql_create_table_hit_info_content.sql", 
                 "mysql_create_table_session_info_daily.sql");
          

my @file_content = undef;
my $sql = undef;

for (my $i = 0; $i < @file_name; $i++) {
    $sql = "";
    
    if (open(MYFILE, "<./rsc/sql/$file_name[$i]")) {
        print "Run SQL for $file_name[$i]\n";
        
        @file_content = <MYFILE>;
        
        for (my $j = 0; $j < @file_content; $j++) {
            $sql .= $file_content[$j];
        }
        
        $sql =~ s/appName/$app_name/;
        
        my $sth = $db_conn->prepare($sql);
        $sth->execute;
        $sth->finish;
        
        close (MYFILE);
    }
}

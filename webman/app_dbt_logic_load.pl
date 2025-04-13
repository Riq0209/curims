#! C:/xampp/perl/bin/perl

unshift (@INC, "./pm/cli_tool");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require Webman_Config_Tools;

my $app_name = $ARGV[0];
my $backup_date = $ARGV[1];
my $db_host = $ARGV[2];
my $db_name = $ARGV[3];
my $db_user_name = $ARGV[4];
my $db_password = $ARGV[5];

my $os = $^O;

my $wmct = new Webman_Config_Tools;

my $dir_web_cgi = $wmct->{dir_web_cgi};

#print "\$dir_web_cgi = " . $dir_web_cgi . "\n";

print "Be cautious! (if this operation is to load logical DB tables from development to live server).\n";
print "This operation will also overwrite the user's account login and group information.\n\n";
print "You may only want to load the following application logic tables:\n";
print "1) webman_*_link_auth.sql\n2) webman_*_link_reference.sql\n3) webman_*_link_structure.sql\n4) webman_*_dyna_mod*.sql\n\n";

my $dbtl_only = undef;
my $dbtl_dict = { "webman_". $app_name . "_link_auth" => 1, 
                  "webman_". $app_name . "_link_reference" => 1,
                  "webman_". $app_name . "_link_structure" => 1,
                  "webman_". $app_name . "_dyna_mod" => 1,
                  "webman_". $app_name . "_dyna_mod_param" => 1,
                  "webman_". $app_name . "_dyna_mod_param_global" => 1,
                  "webman_". $app_name . "_dyna_mod_selector" => 1, };

while ($dbtl_only ne 'y' && $dbtl_only ne 'n') {
  print "Only load application logic tables (y/n)?: ";
  $dbtl_only = <STDIN>;
  $dbtl_only =~ s/\n//;
  $dbtl_only =~ s/\r//; 
}

print "+----------------------------------------+\n";
print "|Load Webman Application Logic DB Tables.|\n";
print "+----------------------------------------+\n\n";

print "Running in $os OS\n\n";

print "Application Name: ";
if ($app_name eq "") {
    $app_name = <STDIN>;
    $app_name =~ s/\n//;
    $app_name =~ s/\r//;    
    
} else {
    print "$app_name\n";
}

print "\n";

if (!(-e $dir_web_cgi . "/$app_name")) {
    print "Can't proceed since the application '$app_name' is not exist!!!\n";
    exit 1;
}

my $dbt_backup_date = $wmct->get_AppDBT_Backup_Date_Str("./app_rsc/" . $app_name . "/db");

print "Available backup date: $dbt_backup_date->{logical}\n\n";

print "Backup Date (yyyy-mm-dd): ";
if ($backup_date eq "") {
    $backup_date = <STDIN>;
    $backup_date =~ s/\n//;
    $backup_date =~ s/\r//;
    
} else {
    print "$backup_date\n";
}

my $backup_dir = $backup_date;
   $backup_dir =~ s/-/_/g;
   $backup_dir = "dbtl_" . $backup_dir;
   
my $dirpath = "./app_rsc/" . $app_name . "/db/" . $backup_dir;

#print "\$dirpath = $dirpath\n";

$file_opres = -e $dirpath;

if (!$file_opres) {
    print "Can't proceed since the backup database file on $backup_date is not exist!!!\n";
    exit 1;
}

print "\nDatabase Information...\n";

if ($db_host eq "" && $wmct->{"db_host"} ne "") {
    $db_host = $wmct->{"db_host"};
}

if ($db_name eq "" && $wmct->{"db_name"} ne "") {
    $db_name = $wmct->{"db_name"};
}

if ($db_user_name eq "" && $wmct->{"db_user_name"} ne "") {
    $db_user_name = $wmct->{"db_user_name"};
}

if ($db_password eq "" && $wmct->{"db_password"} ne "") {
    $db_password = $wmct->{"db_password"};
}

print "     DB HOST: ";
if ($db_host eq "") {
    $db_host = <STDIN>;
    $db_host =~ s/\n//;
    $db_host =~ s/\r//;
    
} else {
    print "$db_host\n";
}


print "     DB Name: ";
if ($db_name eq "") {
    $db_name = <STDIN>;
    $db_name =~ s/\n//;
    $db_name =~ s/\r//;
    
} else {
    print "$db_name\n";
}

print "DB User Name: ";
if ($db_user_name eq "") {
    $db_user_name = <STDIN>;
    $db_user_name =~ s/\n//;
    $db_user_name =~ s/\r//;
    
} else {
    print "$db_user_name\n";
}

print " DB Password: ";
if ($db_password eq "") {
    $db_password = <STDIN>;
    $db_password =~ s/\n//;
    $db_password =~ s/\r//;
    
} else {
    print "$db_password\n";
}

print "\n";

my @table_names = ("webman_" . $app_name . "_blob_content",
                   "webman_" . $app_name . "_blob_content_temp",
                   "webman_" . $app_name . "_blob_info",   
                   "webman_" . $app_name . "_blob_parent_info", 
                   "webman_" . $app_name . "_calendar",
                   "webman_" . $app_name . "_cgi_var_cache",
                   "webman_" . $app_name . "_comp_auth",   
                   "webman_" . $app_name . "_db_item_auth",
                   "webman_" . $app_name . "_dictionary_dyna_mod",
                   "webman_" . $app_name . "_dictionary_language",
                   "webman_" . $app_name . "_dictionary_link",
                   "webman_" . $app_name . "_dyna_mod",
                   "webman_" . $app_name . "_dyna_mod_param",
                   "webman_" . $app_name . "_dyna_mod_param_global",
                   "webman_" . $app_name . "_dyna_mod_selector",
                   "webman_" . $app_name . "_group",
                   "webman_" . $app_name . "_hit_info",
                   "webman_" . $app_name . "_hit_info_content",
                   "webman_" . $app_name . "_hit_info_query_string",
                   "webman_" . $app_name . "_link_auth",
                   "webman_" . $app_name . "_link_reference",
                   "webman_" . $app_name . "_link_structure",
                   "webman_" . $app_name . "_session",
                   "webman_" . $app_name . "_session_info_daily",
                   "webman_" . $app_name . "_session_info_monthly",
                   "webman_" . $app_name . "_static_content_dyna_mod_ref",
                   "webman_" . $app_name . "_user",
                   "webman_" . $app_name . "_user_group");
                   
print "\nStart load logical tables...\n";  

#print "$db_host \n$db_name \n$db_user_name \n$db_password \n";

foreach my $item (@table_names) {
    my $file_name = $dirpath . "/" . $item . ".sql";
    
    if ($dbtl_only eq 'y') {
        if ($dbtl_dict->{$item}) {
            print "$file_name\n";
            `mysql -h $db_host -u $db_user_name -p$db_password $db_name < $file_name`;
        }
        
    } else {
        print "$file_name\n";
        `mysql -h $db_host -u $db_user_name -p$db_password $db_name < $file_name`;
    }
}

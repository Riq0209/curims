#! /usr/bin/perl

unshift (@INC, "./pm/cli_tool");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require Webman_Config_Tools;

my $app_name = $ARGV[0];
my $db_host = $ARGV[1];
my $db_name = $ARGV[2];
my $db_user_name = $ARGV[3];
my $db_password = $ARGV[4];

my $os = $^O;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

$year += 1900;
$mon += 1;

if ($mon < 10) {
    $mon = "0" . $mon;
}

if ($mday < 10) {
    $mday = "0" . $mday;
}

my $wmct = new Webman_Config_Tools;
   
my $dir_web_cgi = $wmct->{"dir_web_cgi"};

#print "\$dir_web_cgi = " . $dir_web_cgi . "\n";

print "+----------------------------------------+\n";
print "|Dump Webman Application Logic DB Tables.|\n";
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

my $file_opres = -e $dir_web_cgi . "/$app_name";

if (!$file_opres) {
    print "Can't proceed since the application '$app_name' is not exist!!!\n";
    exit 1;
}

my $dirpath = "./app_rsc/" . $app_name . "/db/dbtl_" . $year . "_" . $mon . "_" . $mday;

if (!(-e $dirpath)) {
    print "Create dump directory at $dirpath\n";
    
    if ($os eq "linux") {
        `mkdir $dirpath`;
        
    } else {
        my $dirpath_win = $dirpath; 
           $dirpath_win =~ s/\//\\\\/g;
           
        `mkdir $dirpath_win`;
    }
}

print "\n\n Database Information:\n\n";

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

my %no_data_opt = ("webman_" . $app_name . "_cgi_var_cache" => 1, 
                   "webman_" . $app_name . "_hit_info" => 1, 
                   "webman_" . $app_name . "_hit_info_content" => 1, 
                   "webman_" . $app_name . "_hit_info_query_string" => 1, 
                   "webman_" . $app_name . "_session" => 1, 
                   "webman_" . $app_name . "_session_info_daily" => 1);

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
                   
print "\nStart dump tables...\n";

my $file_name_all_tables = $dirpath . "/" . "webman_" . $app_name . "_all_tables.sql";

open(FILE_WRITE, ">$file_name_all_tables");

foreach my $item (@table_names) {
    my $file_name = $dirpath . "/" . $item . ".sql";
    
    print "$file_name\n";
    
    if ($no_data_opt{$item}) {
        `mysqldump -d -h $db_host -u $db_user_name -p$db_password $db_name $item > $file_name`;
        
    } else {
        `mysqldump -c -h $db_host -u $db_user_name -p$db_password $db_name $item > $file_name`;
    }
    
    if (open(FILE_READ, "<$file_name") && FILE_WRITE) {
        my @lines = <FILE_READ>;
        
        foreach my $line (@lines) {
            print FILE_WRITE $line;
        }
        
        close(FILE_READ);
    }
}

if (FILE_WRITE) {
    close(FILE_WRITE);
}
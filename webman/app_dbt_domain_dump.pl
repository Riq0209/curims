#! #!/usr/bin/perl

unshift (@INC, "./pm/cli_tool");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require Webman_Config_Tools;
require DB_Utilities;

my $app_name = $ARGV[0];
my $db_host = $ARGV[1];
my $db_name = $ARGV[2];
my $db_user_name = $ARGV[3];
my $db_password = $ARGV[4];
my $dbt_prefix_opt = $ARGV[5];

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

print "+---------------------------------------------+\n";
print "|Dump Webman Application Domain Data DB Tables|\n";
print "+---------------------------------------------+\n\n";

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

my $dirpath = "./app_rsc/" . $app_name . "/db/dbtd_" . $year . "_" . $mon . "_" . $mday;

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

my $dbt_prefix_name = $app_name . "_";

if ($dbt_prefix_opt eq "n") {
    ### Do nothing. 
    
} else {
    print "Default prefix table name is '$dbt_prefix_name' \n\n";
    print "Change default prefix table name [y/n]: ";
    my $option = <STDIN>;
       $option =~ s/\n//;
   
    if ($option eq "y") {
        print "\nEnter new prefix table name: ";
        $dbt_prefix_name = <STDIN>;
        $dbt_prefix_name =~ s/\n//;
    }
}

my $dbu = new DB_Utilities;
my $db_conn = $dbu->make_DBI_Conn("./conf/dbi_connection.conf");

$dbu->set_DBI_Conn($db_conn);

my @tbl = $dbu->get_Table_List;

print "\nStart dump tables...\n";

if ($dbt_prefix_name ne "") {
    foreach $item (@tbl) {
        if ($item =~ /^$dbt_prefix_name/) {
            my $file_name = $dirpath . "/" . $item . ".sql";
            
            print "$item -> $file_name\n";
        
            `mysqldump -c -h $db_host -u $db_user_name -p$db_password $db_name $item > $file_name`;        
        }
    }
}

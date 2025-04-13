#! #!

unshift (@INC, "./pm/cli_tool");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require Webman_Config_Tools;
require DB_Utilities;

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

print "+----------------------------------------+\n";
print "|Load Webman Application Domain DB Tables|\n";
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
    print "Can't proceed since '$app_name' application is not exist!!!\n";
    exit 1;
}

my $dbt_backup_date = $wmct->get_AppDBT_Backup_Date_Str("./app_rsc/" . $app_name . "/db");

print "Available backup date: $dbt_backup_date->{domain}\n\n";

print "Enter backup date (yyyy-mm-dd): ";

if ($backup_date eq "") {
    $backup_date = <STDIN>;
    $backup_date =~ s/\n//;
    $backup_date =~ s/\r//;
    
} else {
    print "$backup_date\n";
}

my $backup_dir = $backup_date;
   $backup_dir =~ s/-/_/g;
   $backup_dir = "dbtd_" . $backup_dir;
   
my $dirpath = "./app_rsc/" . $app_name . "/db/" . $backup_dir;

#print "\dirpath = $dirpath\n";

$file_opres = -e $dirpath;

if (!$file_opres) {
    print "Can't proceed since database backup on $backup_date is not exist!!!\n";
    exit 1;
}

print "\n Database Information...\n";

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

my $dbu = new DB_Utilities;
my $db_conn = $dbu->make_DBI_Conn("./conf/dbi_connection.conf");

$dbu->set_DBI_Conn($db_conn);

my @tbl = $dbu->get_Table_List;

my %dbt_dict = undef;

foreach my $item (@tbl) {
    $dbt_dict{$item . ".sql"} = $item;
}

print "\nStart load domain tables...\n";

if (opendir(DIRHANDLE, $dirpath)) {
    my @ref_points = readdir(DIRHANDLE);
    
    my $overwrite_all = 0;
    
    foreach my $item (@ref_points) {
        if (-f "$dirpath/$item") {
            my $option = "y";
            
            if ($dbt_dict{$item} ne "" && !$overwrite_all) {
                print "$item - Warning!!! Table already exist. Continue? [y/n/all]: ";
                
                $option = <STDIN>;
                $option =~ s/\n//;
                
            }
            
            if ($option eq "all") {
                $overwrite_all = 1;
                $option = "y";
            }
            
            if ($option eq "y") {
                my $file_name = "$dirpath/$item";
                
                if ($dbt_dict{$item} ne "") {
                    print "$file_name -> $dbt_dict{$item}\n";
                    
                } else {
                    print "$file_name\n";
                }
                
                `mysql -h $db_host -u $db_user_name -p$db_password $db_name < $file_name`;
            }
        }
    }
}

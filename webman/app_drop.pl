#! C:/xampp/perl/bin/perl

unshift (@INC, "./pm/cli_tool");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require DB_Utilities;
require Webman_Config_Tools;

my $app_name = $ARGV[0];

my $os = $^O;

print "+------------------------------------------------------------+\n";
print "|Drop Webman Application Resources (Directories & DB Tables).|\n"; 
print "+------------------------------------------------------------+\n\n";

print "Running in $os OS\n\n";

print "Application Name: ";

if ($app_name eq "") {
    $app_name = <STDIN>;
}

$app_name =~ s/\n//;
$app_name =~ s/\r//;

while ($app_name =~ / $/) {
    $app_name =~ s/ $//;
}
   
print "$app_name\n\n";

my $info = undef;

$info = `perl app_dir_delete.pl $app_name`;
print $info;

print "\n";

$info = `perl app_dbt_drop.pl $app_name`;
print $info;




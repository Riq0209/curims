#! C:/xampp/perl/bin/perl

unshift (@INC, "./pm/cli_tool");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require DB_Utilities;
require Webman_Config_Tools;

my $app_name = $ARGV[0];

my $os = $^O;

print "+--------------------------------------+\n";
print "|Delete Webman Application Directories.|\n";
print "+--------------------------------------+\n\n";

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

###############################################################################
# Get all required information on directories.                                #
###############################################################################

my $perl_bin = undef;

my $dir_base = undef;
my $dir_web_public = undef;
my $dir_web_cgi = undef;

my $wmct = new Webman_Config_Tools;

my $cnf_info = $wmct->get_Configuration_Info;

################################################################################

$perl_bin = $cnf_info->{"perl_bin"};

$dir_base = $cnf_info->{"base"};
$dir_web_public = $cnf_info->{"web_public"};
$dir_web_cgi = $cnf_info->{"web_cgi"};

print "Delete application directories...\n";

if ($os eq "linux") {
    ### for Linux/Unix ##################################################
    
    print "Delete -> $dir_base/webman/app_rsc/$app_name\n";
    `rm -rf $dir_base/webman/app_rsc/$app_name`;
    
    print "Delete -> $dir_base/webman/pm/apps/$app_name\n";
    `rm -rf $dir_base/webman/pm/apps/$app_name`;

    print "Delete -> $dir_web_public/$app_name\n";
    `rm -rf $dir_web_public/$app_name`;
    
    print "Delete -> $dir_web_cgi/$app_name\n";
    `rm -rf $dir_web_cgi/$app_name`;    
    
} else {

    ### for Windows #####################################################
    my $dir_base_ori = $dir_base;
    my $dir_web_public_ori = $dir_web_public;
    my $dir_web_cgi_ori = $dir_web_cgi;
    
    $dir_base =~ s/\//\\\\/g;
    $dir_web_public =~ s/\//\\\\/g;
    $dir_web_cgi =~ s/\//\\\\/g;
    
    print "Delete -> $dir_base_ori/webman/app_rsc/$app_name\n";
    `rd /s /q $dir_base\\webman\\app_rsc\\$app_name`;
    
    print "Delete -> $dir_base_ori/webman/pm/apps/$app_name\n";
    `rd /s /q $dir_base\\webman\\pm\\apps\\$app_name`;

    print "Delete -> $dir_web_public_ori/$app_name\n";
    `rd /s /q $dir_web_public\\$app_name`;
    
    print "Delete -> $dir_web_cgi_ori/$app_name\n";
    `rd /s /q $dir_web_cgi\\$app_name`;      

}

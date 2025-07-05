#! /usr/bin/perl

unshift (@INC, "./pm/cli_tool/");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require DB_Utilities;
require Webman_Config_Tools;

my $app_name = $ARGV[0];

my $os = $^O;

print "+------------------------------------+\n";
print "|Backup Webman Application Resources.|\n";
print "+------------------------------------+\n\n";

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

my $today = $wmct->get_Today_ISO;

################################################################################

$perl_bin = $cnf_info->{"perl_bin"};

$dir_base = $cnf_info->{"base"};
$dir_web_public = $cnf_info->{"web_public"};
$dir_web_cgi = $cnf_info->{"web_cgi"};

### for Windows 
my $dir_base_w = $dir_base;
my $dir_web_public_w = $dir_web_public;
my $dir_web_cgi_w = $dir_web_cgi;

$dir_base_w =~ s/\//\\\\/g;
$dir_web_public_w =~ s/\//\\\\/g;
$dir_web_cgi_w =~ s/\//\\\\/g;

###############################################################################

if (-e "$dir_base/webman/app_dist/$app_name/$today") {
    print "Backup directory already exist!!!\n";
        
    if (!$wmct->get_YN_Options("Continue and remove the existing backup directory")) {
        exit 1;
    }
    
    if ($os eq "linux") { 
        `rm -rf $dir_base/webman/app_dist/$app_name/$today`;
        
    } else {
        `rd /s /q $dir_base_w\\webman\\app_dist\\$app_name\\$today`;
    }
}

#my $stuck = <STDIN>;
    
print "\nBackup directories...\n";

if ($os eq "linux") {
    ### for Linux/Unix ##################################################
    
    if (!(-e "$dir_base/webman/app_dist/$app_name")) {
        `mkdir $dir_base/webman/app_dist/$app_name`;
    }
    
    `mkdir $dir_base/webman/app_dist/$app_name/$today`;
     
    print "$dir_web_public/$app_name         ---> $dir_base/webman/app_dist/$app_name/$today/__public_html__\n";
    `cp -r $dir_web_public/$app_name $dir_base/webman/app_dist/$app_name/$today`;
    `mv $dir_base/webman/app_dist/$app_name/$today/$app_name $dir_base/webman/app_dist/$app_name/$today/__public_html__`;

    print "$dir_web_cgi/$app_name ---> $dir_base/webman/app_dist/$app_name/$today/__cgi-bin__\n";
    `cp -r $dir_web_cgi/$app_name $dir_base/webman/app_dist/$app_name/$today`;
    `mv $dir_base/webman/app_dist/$app_name/$today/$app_name $dir_base/webman/app_dist/$app_name/$today/__cgi-bin__`;
    
    print "$dir_base/webman/app_rsc/$app_name             ---> $dir_base/webman/app_dist/$app_name/$today/__rsc__\n";
    `cp -r $dir_base/webman/app_rsc/$app_name $dir_base/webman/app_dist/$app_name/$today`;
    `mv $dir_base/webman/app_dist/$app_name/$today/$app_name $dir_base/webman/app_dist/$app_name/$today/__rsc__`;
    
    print "$dir_base/webman/pm/apps/$app_name             ---> $dir_base/webman/app_dist/$app_name/$today/__modules__\n";
    `cp -r $dir_base/webman/pm/apps/$app_name $dir_base/webman/app_dist/$app_name/$today`;
    `mv $dir_base/webman/app_dist/$app_name/$today/$app_name $dir_base/webman/app_dist/$app_name/$today/__modules__`;
    
} else {
    if (!(-e "$dir_base/webman/app_dist/$app_name")) {
        #print "$dir_base_w\\webman\\app_dist\\$app_name\n";
        `mkdir $dir_base_w\\webman\\app_dist\\$app_name`;
    }
    
    `mkdir $dir_base_w\\webman\\app_dist\\$app_name\\$today`;
    
    print "$dir_web_public/$app_name         ---> $dir_base/webman/app_dist/$app_name/$today/__public_html__\n";
    `mkdir $dir_base_w\\webman\\app_dist\\$app_name\\$today\\__public_html__`;
    `xcopy /E $dir_web_public_w\\$app_name $dir_base_w\\webman\\app_dist\\$app_name\\$today\\__public_html__`;
    
    print "$dir_web_cgi/$app_name ---> $dir_base/webman/app_dist/$app_name/$today/__cgi-bin__\n";
    `mkdir $dir_base_w\\webman\\app_dist\\$app_name\\$today\\__cgi-bin__`;
    `xcopy /E $dir_web_cgi_w\\$app_name $dir_base_w\\webman\\app_dist\\$app_name\\$today\\__cgi-bin__`;
    
    print "$dir_base/webman/app_rsc/$app_name             ---> $dir_base/webman/app_dist/$app_name/$today/__rsc__\n";
    `mkdir $dir_base_w\\webman\\app_dist\\$app_name\\$today\\__rsc__`;
    `xcopy /E $dir_base_w\\webman\\app_rsc\\$app_name $dir_base_w\\webman\\app_dist\\$app_name\\$today\\__rsc__`;
    
    print "$dir_base/webman/pm/apps/$app_name             ---> $dir_base/webman/app_dist/$app_name/$today/__modules__\n";
    `mkdir $dir_base_w\\webman\\app_dist\\$app_name\\$today\\__modules__`;
    `xcopy /E $dir_base_w\\webman\\pm\\apps\\$app_name $dir_base_w\\webman\\app_dist\\$app_name\\$today\\__modules__`;
    
}

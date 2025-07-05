#! #!/usr/bin/perl

unshift (@INC, "./pm/cli_tool");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require DB_Utilities;
require Webman_Config_Tools;

my $app_name = $ARGV[0];

my $os = $^O;

print "+------------------------------------+\n";
print "|Deploy Webman Application Resources.|\n";
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
   
print "$app_name\n";



###############################################################################
# Get all required information on directories.                                #
###############################################################################

my $perl_bin = undef;

my $dir_base = undef;
my $dir_web_public = undef;
my $dir_web_cgi = undef;

my $wmct = new Webman_Config_Tools;

my $cnf_info = $wmct->get_Configuration_Info;

###############################################################################

$perl_bin = $cnf_info->{"perl_bin"};

$dir_base = $cnf_info->{"base"};
$dir_web_public = $cnf_info->{"web_public"};
$dir_web_cgi = $cnf_info->{"web_cgi"};

my $file_opres = -e $dir_base . "/webman/app_dist/$app_name";

print $dir_base . "/webman/app_dist/$app_name\n";

if (!$file_opres) {
    print "\nCan't proceed since '$app_name' application distribution resources are not exist!!!\n";
    exit 1;
}

if (-e "$dir_web_public/$app_name" || -e "$dir_web_cgi/$app_name" ||
    -e "$dir_base/webman/app_rsc/$app_name" || -e "$dir_base/webman/pm/apps/$app_name") {
    print "\nCan't proceed since '$app_name' application resources are somehow already deployed!!!\n";
    print "\nDrop the application first using 'app_drop.pl' script.\n";
    exit 1;
}

###############################################################################
my $app_backup_date = undef;
my $app_backup_date_str  = $wmct->get_AppSrc_Backup_Date_Str("$dir_base/webman/app_dist/$app_name");

print "\nDeploy application resources...\n";
print "\nAvailable backup date: $app_backup_date_str\n";
print "\nEnter backup bate (yyyy-mm-dd): ";
$app_backup_date = <STDIN>;
$app_backup_date =~ s/\n//;
$app_backup_date =~ s/\r//;

if (!(-e "$dir_base/webman/app_dist/$app_name/$app_backup_date")) {
    print "\nCan't proceed since the application backup date entered is not exist!!!\n";
    exit 1;
}

###############################################################################

print "\nCopying directory structure... \n";

if ($os eq "linux") {
    ### for Linux/Unix ##################################################
    print "$dir_base/webman/app_dist/$app_name/$app_backup_date/__public_html__ ---> $dir_web_public/$app_name\n";
    `cp -r $dir_base/webman/app_dist/$app_name/$app_backup_date/__public_html__ $dir_web_public`;
    `mv $dir_web_public/__public_html__ $dir_web_public/$app_name`;

    print "$dir_base/webman/app_dist/$app_name/$app_backup_date/__cgi-bin__     ---> $dir_web_cgi/$app_name\n";
    `cp -r $dir_base/webman/app_dist/$app_name/$app_backup_date/__cgi-bin__ $dir_web_cgi`;
    `mv $dir_web_cgi/__cgi-bin__ $dir_web_cgi/$app_name`;
    
    print "$dir_base/webman/app_dist/$app_name/$app_backup_date/__rsc__         ---> $dir_base/webman/app_rsc/$app_name\n";
    `cp -r $dir_base/webman/app_dist/$app_name/$app_backup_date/__rsc__ $dir_base/webman/app_rsc`;
    `mv $dir_base/webman/app_rsc/__rsc__ $dir_base/webman/app_rsc/$app_name`;
    
    print "$dir_base/webman/app_dist/$app_name/$app_backup_date/__modules__     ---> $dir_base/webman/pm/apps/$app_name\n";
    `cp -r $dir_base/webman/app_dist/$app_name/$app_backup_date/__modules__ $dir_base/webman/pm/apps`;
    `mv $dir_base/webman/pm/apps/__modules__ $dir_base/webman/pm/apps/$app_name`;
    
} else {
    ### for Windows ###########################################################
    my $dir_base_ori = $dir_base;
    my $dir_web_public_ori = $dir_web_public;
    my $dir_web_cgi_ori = $dir_web_cgi;
    
    $dir_base =~ s/\//\\\\/g;
    $dir_web_public =~ s/\//\\\\/g;
    $dir_web_cgi =~ s/\//\\\\/g;
    
    #`mkdir $dir_base\\webman\\app_rsc\\$app_name`;
    #`xcopy /E $dir_base\\webman\\rsc\\app_rsc_skel $dir_base\\webman\\app_rsc\\$app_name`;
    
    print "$dir_base_ori/webman/app_dist/$app_name/$app_backup_date/__public_html__  ---> $dir_web_public_ori/$app_name\n";
    `mkdir $dir_web_public\\$app_name`;
    `xcopy /E $dir_base\\webman\\app_dist\\$app_name\\$app_backup_date\\__public_html__ $dir_web_public\\$app_name`;
    
    print "$dir_base/webman/app_dist/$app_name/$app_backup_date/__cgi-bin__     ---> $dir_web_cgi/$app_name\n";
    `mkdir $dir_web_cgi\\$app_name`;
    `xcopy /E $dir_base\\webman\\app_dist\\$app_name\\$app_backup_date\\__cgi-bin__ $dir_web_cgi\\$app_name`;
    
    print "$dir_base/webman/app_dist/$app_name/$app_backup_date/__rsc__         ---> $dir_base/webman/app_rsc/$app_name\n";
    `mkdir $dir_base\\webman\\app_rsc\\$app_name`;
    `xcopy /E $dir_base\\webman\\app_dist\\$app_name\\$app_backup_date\\__rsc__ $dir_base\\webman\\app_rsc\\$app_name`;
    
    print "$dir_base/webman/app_dist/$app_name/$app_backup_date/__modules__     ---> $dir_base/webman/pm/apps/$app_name\n";
    `mkdir $dir_base\\webman\\pm\\apps\\$app_name`;
    `xcopy /E $dir_base\\webman\\app_dist\\$app_name\\$app_backup_date\\__modules__ $dir_base\\webman\\pm\\apps\\$app_name`;
}

################################################################################

my $backup_date = undef;
my $opr_result = undef;

my $dbt_backup_date = $wmct->get_AppDBT_Backup_Date_Str("$dir_base/webman/app_rsc/$app_name/db");

if ($dbt_backup_date->{logical} ne "") {
    print "\nLoad database tables (logical)...\n";
    print "\nAvailable backup date: $dbt_backup_date->{logical}\n";
    print "\nEnter backup bate (yyyy-mm-dd): ";
    $backup_date = <STDIN>;
    $backup_date =~ s/\n//;
    $backup_date =~ s/\r//;

    print "\n";

    $opr_result = `perl app_dbt_logic_load.pl $app_name $backup_date`;
    print $opr_result;
}

if ($dbt_backup_date->{domain} ne "") {
    print "\nLoad database tables (domain)...\n";
    print "\nAvailable backup date: $dbt_backup_date->{domain}\n";
    print "\nEnter backup bate (yyyy-mm-dd): ";
    $backup_date = <STDIN>;
    $backup_date =~ s/\n//;
    $backup_date =~ s/\r//;

    print "\n";

    $opr_result = `perl app_dbt_domain_load.pl $app_name $backup_date`;
    print $opr_result;
}

print "\n";

### Make sure all new added CGI script headers are following the current 
### system's Perl binary path setting.

my $current_perl_bin_path = undef;

if (open(MYFILE, "<./conf/dir_org.conf")) {
    my @lines = <MYFILE>;
    
    foreach my $line (@lines) {
        if ($line =~ /^perl_bin/) {
            while ($line =~ / /) {
                $line =~ s/ //g;
            }
            
            my @parts = split(/=/, $line );
            
            $current_perl_bin_path = $parts[1];
            $current_perl_bin_path =~ s/\n//;
        }
    }
    
    close(MYFILE);
}

$opr_result = `perl config_perl_bin.pl $current_perl_bin_path`;
print $opr_result;

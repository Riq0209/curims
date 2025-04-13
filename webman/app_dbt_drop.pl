#! C:/xampp/perl/bin/perl

unshift (@INC, "./pm/cli_tool");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require DB_Utilities;
require Webman_Config_Tools;

my $app_name = $ARGV[0];

my $os = $^O;

print "+----------------------------------+\n";
print "|Drop Webman Application DB Tables.|\n";
print "+----------------------------------+\n\n";

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
# Get all required information on database account.                           #
###############################################################################

my $perl_bin = undef;

my $db_host = undef;
my $db_driver = undef;
my $db_name = undef;
my $db_user_name = undef;
my $db_password = undef;

my $wmct = new Webman_Config_Tools;

my $cnf_info = $wmct->get_Configuration_Info;

###########################################################

$perl_bin = $cnf_info->{"perl_bin"};

$db_host = $cnf_info->{"db_host"};
$db_driver = $cnf_info->{"db_driver"};
$db_name = $cnf_info->{"db_name"};
$db_user_name = $cnf_info->{"db_user_name"};
$db_password = $cnf_info->{"db_password"};
$db_socket = $cnf_info->{"db_socket"};


###########################################################

if ($db_host eq "") {
    print "\n DB Host: ";
    $db_host = <STDIN>;
    $db_host =~ s/\n//;
    $db_host =~ s/\r//;
}

if ($db_name eq "") {
    print "\n DB Name: ";
    $db_name = <STDIN>;
    $db_name =~ s/\n//;
    $db_name =~ s/\r//;
}

if ($db_user_name eq "") {
    print "\n DB User Name: ";
    $db_user_name = <STDIN>;
    $db_user_name =~ s/\n//;
    $db_user_name =~ s/\r//;
}

if ($db_password eq "") {
    print "\n DB Password: ";
    $db_password = <STDIN>;
    $db_password =~ s/\n//;
    $db_password =~ s/\r//;
}

###############################################################################
# Start drop operations database tables.                                      #
###############################################################################

#print "DBI:$db_driver:dbname=$db_name:$db_host\n";

my $dbi_conn = undef;
        
if ($db_socket eq "") {
    $dbi_conn = DBI->connect("DBI:$db_driver:dbname=$db_name:$db_host", $db_user_name, $db_password);
    
} else {
    $dbi_conn = DBI->connect("DBI:$db_driver:dbname=$db_name:$host;mysql_socket=$db_socket", $db_user_name, $db_password);
}

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
                   
print "\n\nStart drop tables...\n\n";

print "Drop database tables (logic)...\n";
foreach my $item (@table_names) {
    print "Drop -> $item\n";
    `mysql -h $db_host -u $db_user_name -p$db_password $db_name  -BNe "drop table $item"`;
}

print "\nDrop database tables (domain)...\n";
my $dbt_prefix_name = $app_name . "_";

print "Default prefix table name is '$dbt_prefix_name'\n";

my $dbu = new DB_Utilities;
my $db_conn = $dbu->make_DBI_Conn("./conf/dbi_connection.conf");

$dbu->set_DBI_Conn($db_conn);

my @tbl = $dbu->get_Table_List;

    foreach $item (@tbl) {
        if ($item =~ /^$dbt_prefix_name/) {
            print "Drop -> $item\n";
        
            `mysql -h $db_host -u $db_user_name -p$db_password $db_name  -BNe "drop table $item"`;
        }
    }



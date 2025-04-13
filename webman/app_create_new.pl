#! C:/xampp/perl/bin/perl

unshift (@INC, "./pm/cli_tool/");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require DB_Utilities;
require Webman_Config_Tools;

my $app_name = $ARGV[0];

my $os = $^O;

print "+------------------------------------------------------+\n";
print "|Initialize Webman Application Directories & DB Tables.|\n";
print "+------------------------------------------------------+\n\n";

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
# Get all required information on directories and database account.           #
###############################################################################

my $perl_bin = undef;

my $dir_base = undef;
my $dir_web_public = undef;
my $dir_web_cgi = undef;

my $db_host = undef;
my $db_driver = undef;
my $db_name = undef;
my $db_user_name = undef;
my $db_password = undef;

my $wmct = new Webman_Config_Tools;

my $cnf_info = $wmct->get_Configuration_Info;

###########################################################

$perl_bin = $cnf_info->{"perl_bin"};

$dir_base = $cnf_info->{"base"};
$dir_web_public = $cnf_info->{"web_public"};
$dir_web_cgi = $cnf_info->{"web_cgi"};

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
# Start the operations on directories and database.                           #
###############################################################################

print "DBI:$db_driver:dbname=$db_name:$db_host\n";

my $dbi_conn = undef;
        
if ($db_socket eq "") {
    $dbi_conn = DBI->connect("DBI:$db_driver:dbname=$db_name:$db_host", $db_user_name, $db_password);
    
} else {
    $dbi_conn = DBI->connect("DBI:$db_driver:dbname=$db_name:$host;mysql_socket=$db_socket", $db_user_name, $db_password);
}

### copy application directories ##############################################

if ($os eq "linux") {
    ### for Linux/Unix ##################################################
    
    print "Create $dir_base/webman/app_rsc/$app_name\n";
    #`mkdir $dir_base/webman/app_rsc/$app_name`;
    `cp -r $dir_base/webman/rsc/app_rsc_skel/ $dir_base/webman/app_rsc/$app_name`;
    
    print "Create $dir_base/webman/pm/apps/$app_name\n";
    #`mkdir $dir_base/webman/pm/apps/$app_name`;
    `cp -r $dir_base/webman/rsc/app_mod/ $dir_base/webman/pm/apps/$app_name`;
    
    print "Create $dir_web_public/$app_name\n";
    #`mkdir $dir_web_public/$app_name`;
    `cp -r $dir_base/webman/rsc/app_public/ $dir_web_public/$app_name`;
    
    print "Create $dir_web_cgi/$app_name\n";
    #`mkdir $dir_web_cgi/$app_name`;
    `cp -r $dir_base/webman/rsc/app_cgi/ $dir_web_cgi/$app_name`;
    `chmod a+x $dir_web_cgi/$app_name/*.cgi`; 
    
    #my $stuck = <STDIN>;  
    
} else {

    ### for Windows #####################################################
    $dir_base =~ s/\//\\\\/g;
    $dir_web_public =~ s/\//\\\\/g;
    $dir_web_cgi =~ s/\//\\\\/g;

    `mkdir $dir_base\\webman\\app_rsc\\$app_name`;
    `xcopy /E $dir_base\\webman\\rsc\\app_rsc_skel $dir_base\\webman\\app_rsc\\$app_name`;

    `mkdir $dir_base\\webman\\pm\\apps\\$app_name`;
    `xcopy /E $dir_base\\webman\\rsc\\app_mod $dir_base\\webman\\pm\\apps\\$app_name`;

    `mkdir $dir_web_public\\$app_name`;
    `xcopy /E $dir_base\\webman\\rsc\\app_public $dir_web_public\\$app_name`;
    
    `mkdir $dir_web_cgi\\$app_name`;
    `xcopy /E $dir_base\\webman\\rsc\\app_cgi $dir_web_cgi\\$app_name`;    
}

### reset back to the original one ###
$dir_base = $cnf_info->{"base"};
$dir_web_public = $cnf_info->{"web_public"};
$dir_web_cgi = $cnf_info->{"web_cgi"};

### should be flexible for both Linux & Windows #####################
### if File::Copy::Recursive is available             ###############

#make_path("$dir_web_cgi/$app_name");
#dircopy("$dir_base/webman/rsc/app_cgi","$dir_web_cgi/$app_name");

#make_path("$dir_web_public/$app_name");
#dircopy("$dir_base/webman/rsc/app_public", "$dir_web_public/$app_name");

###############################################################################


if (open(MYFILE, "<$dir_base/webman/pm/apps/$app_name/__app_name__.pm")) {
    my @file_content = <MYFILE>;

    close (MYFILE);

    my $new_content = undef;

    foreach my $line (@file_content) {
        $line =~ s/__app_name__/$app_name/;

        $new_content .= $line;
    }

    if (open(MYFILE, ">$dir_base/webman/pm/apps/$app_name/__app_name__.pm")) {
        print MYFILE ($new_content);
        close (MYFILE);
    }
    
    rename("$dir_base/webman/pm/apps/$app_name/__app_name__.pm", 
           "$dir_base/webman/pm/apps/$app_name/$app_name.pm");
}


my @cgi_scripts = ("index.cgi", "index_json.cgi", "index_view_hits_content.cgi", "index_blob_content_printer_v2.cgi");

foreach my $script (@cgi_scripts) {
    if (open(MYFILE, "<$dir_web_cgi/$app_name/$script")) {
        my @file_content = <MYFILE>;

        close (MYFILE);

        my $new_content = undef;

        foreach my $line (@file_content) {
            $line =~ s/__path_perl_bin__/$perl_bin/;
            $line =~ s/__app_name__/$app_name/;

            $new_content .= $line;
        }

        if (open(MYFILE, ">$dir_web_cgi/$app_name/$script")) {
            print MYFILE ($new_content);
            close (MYFILE);
        }
    }
}

### prepare the DB Tables ########################################################


my @file_name = ("mysql_create_table_blob_content.sql", "mysql_create_table_blob_content_temp.sql", 
                 "mysql_create_table_blob_info.sql", "mysql_create_table_blob_parent_info.sql",
                 "mysql_create_table_dyna_mod.sql", "mysql_create_table_dyna_mod_param.sql", "mysql_create_table_dyna_mod_selector.sql",
                 "mysql_create_table_dyna_mod_param_global.sql", "mysql_create_table_link_reference.sql", 
                 "mysql_create_table_link_structure.sql", "mysql_create_table_static_content_dyna_mod_ref.sql", 
                 "mysql_create_table_calendar.sql", "mysql_create_table_dictionary_link.sql", 
                 "mysql_create_table_dictionary_language.sql", "mysql_create_table_dictionary_dyna_mod.sql",
                 "mysql_create_table_comp_auth.sql", "mysql_create_table_session.sql", "mysql_create_table_cgi_var_cache.sql",
                 "mysql_create_table_user.sql", "mysql_create_table_group.sql", 
                 "mysql_create_table_user_group.sql", "mysql_create_table_db_item_auth.sql", "mysql_create_table_link_auth.sql",
                 "mysql_create_table_hit_info.sql", "mysql_create_table_hit_info_query_string.sql", "mysql_create_table_hit_info_content.sql", 
                 "mysql_create_table_session_info_daily.sql", "mysql_create_table_session_info_monthly.sql");

for (my $i = 0; $i < @file_name; $i++) {
    my $txt = "";
    
    if (open(MYFILE, "<./rsc/sql/$file_name[$i]")) {
        print "Run SQL for $file_name[$i]\n";
        
        my @file_content = <MYFILE>;
        
        for (my $j = 0; $j < @file_content; $j++) {
            $txt .= $file_content[$j];
        }
        
        $txt =~ s/appName/$app_name/g;
        
        my @sql_list = split(/;/, $txt);
        
        foreach my $sql (@sql_list) {
            my $sth = $dbi_conn->prepare($sql);

            $sth->execute;
            $sth->finish;
        }
        
        close(MYFILE);
    }
}

### insert data for various related webman_$app_name_* tables #################

my $dbu = new DB_Utilities;

$dbu->set_DBI_Conn($dbi_conn);

#######################################

my $rnd62base = undef;

$dbu->set_Table("webman_" . $app_name . "_user");

$rnd62base = $dbu->get_Unique_Random_62Base("id_user");
$dbu->insert_Row("id_user login_name password full_name description", 
                 "$rnd62base admin admin Application\\ Administrator Administrator");
                 
$rnd62base = $dbu->get_Unique_Random_62Base("id_user");
$dbu->insert_Row("id_user login_name password full_name description", 
                 "$rnd62base guest guest Anonymous\\ User Guest");
                 
                 
$dbu->set_Table("webman_" . $app_name . "_group");

$rnd62base = $dbu->get_Unique_Random_62Base("id_group");
$dbu->insert_Row("id_group group_name description", 
                 "$rnd62base ADMIN Application\\ Administrator");
                 
$rnd62base = $dbu->get_Unique_Random_62Base("id_group");
$dbu->insert_Row("id_group group_name description", 
                 "$rnd62base COM_JSON JSON-based\\ Service\\ Users");                

#######################################

$dbu->set_Table("webman_" . $app_name . "_link_reference");

$dbu->insert_Row("link_ref_id link_id dynamic_content_num ref_type ref_name blob_id",
                 "10000 5 0 DYNAMIC_MODULE webman_JSON -1");
                 
$dbu->insert_Row("link_ref_id link_id dynamic_content_num ref_type ref_name blob_id",
                 "10001 4 0 DYNAMIC_MODULE webman_JSON_authentication -1");
                 
#######################################

my $param_value = "select\\ id_user,\\ login_name,\\ full_name,\\ description,\\ web_service_url\\ from\\ webman_" . $app_name . "_user\\ order\\ by\\ full_name";

$dbu->set_Table("webman_" . $app_name . "_dyna_mod_param");

$dbu->insert_Row("link_ref_id scdmr_id dyna_mod_selector_id param_name param_value",
                 "10000 -1 -1 sql $param_value");

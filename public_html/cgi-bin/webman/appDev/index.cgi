#! /usr/bin/perl

unshift (@INC, "./");
unshift (@INC, "../../../../webman/pm/core");
unshift (@INC, "../../../../webman/pm/comp");
unshift (@INC, "../../../../public_html/cgi-bin/webman/appDev");

use DBI;
use CGI::Carp qw(fatalsToBrowser);

require GMM_CGI;
require DB_Utilities;
#require Session;
require "../../../../webman/pm/core/Session.pm";
require web_man_select_application;
require web_man_admin_main;

my $cgi = new GMM_CGI;
my $dbu = new DB_Utilities;
my $session = new Session;

#$cgi->add_Param("trace_module", 1);

my $dbi_conn = $dbu->make_DBI_Conn("../../../../webman/conf/dbi_connection.conf"); ### 15/05/2009

$dbu->set_DBI_Conn($dbi_conn); ### 12/12/2008
$cgi->set_DBI_Conn($dbi_conn);

### Handle session related data ###############################################
$session->set_CGI($cgi);
$session->set_DBI_Conn($dbi_conn);
$session->set_Idle_Time(3600);

### appDev share the 'admin' user account create inside appAdmin 
$session->set_Session_Table("webman_appAdmin_session");
$session->set_User_Auth_Table("webman_appAdmin_user", "login_name", "password");
$session->set_CGI_Var_DB_Cache_Table("webman_appAdmin_cgi_var_cache"); 

my $session_id = $cgi->param("session_id");

if ($session_id eq "") { 
    ### Session ID is not available from CGI parameter list, 
    ### try to get it from browser's cookie.
    $session_id = $cgi->get_Cookie_Val("session_id");
    
    ### Push session ID from cookie into CGI parameter list.
    $cgi->push_Param("session_id", $session_id);
}

if ($session_id eq "") {
    ### Session ID is not available from both cookie and CGI parameter 
    ### list. Try to create new session from user authentication.
    
    my $login = $cgi->param("login");

    my $password = $cgi->param("password");
       $password =~ s/\'//g; ### Basic sql injection prevention.
   
       $session->set_Auth_Info($login, $password);
       $session->create_Session;

       $session_id = $session->get_Session_ID;

    if ($login eq "admin" and $session_id != -1) {
        ### Make the generated session ID available from both
        ### CGI parameter list and browser's cookie data.
        $cgi->set_Cookie("session_id", $session_id);
        $cgi->push_Param("session_id", $session_id);
    }
}

#$cgi->add_Debug_Text("\$session_id = $session_id");

if ($session_id ne "" && $session_id != -1) {
    $session->set_Session_ID($session_id);
    
    if (!$session->is_Valid) {
        $cgi->delete_Cookie("session_id");
    }
}

#$cgi->add_Debug_Text("\$session->is_Valid = " .  $session->is_Valid);

if ($cgi->param("logout") == 1) {
    ### Mark current session ID with 'logout' status.
    $session->logout($session_id);
    
    ### Remove session ID from cookie.
    $cgi->delete_Cookie("session_id");
}



###############################################################################

my $app_name = $cgi->param("app_name");

my $mode = "appDev - $app_name";

if ($app_name eq "") {
    $mode = "appDev";
}

my $page_properties = "<style type=\"text/css\"><!-- body{font-family:Geneva, Arial, Helvetica, sans-serif;} --></style>";

### The next two functions call must be here since many of the modules still 
### using direct "print ..." command instead of "$cgi->add_Debug_Text ..." 
$cgi->print_Header;
$cgi->start_HTML("Webman $mode", $page_properties);

###############################################################################

my $content = "_blank_";

if ($session->is_Valid) {
    $component_name = $cgi->param("component_name");

    if ($app_name eq "") {
        $component_name = "web_man_select_application";

    } elsif ($component_name eq "") {
        $component_name = "web_man_admin_main";
    }

    my $component = new $component_name;

    $component->set_CGI($cgi);
    $component->set_DBI_Conn($dbi_conn);

    #$component->set_Debug_Mode(1);

    $component->run_Task;

    $component->process_Content;

    $content = $component->get_Content;

} else {
    my $sc = new Static_Content;
    
    $content = $sc->get_Content("./login.html");
}

###############################################################################

print $content;

$cgi->print_Debug_Text;
$cgi->end_HTML();

#! #!/usr/bin/perl

unshift (@INC, "../../../../webman/pm/core");
unshift (@INC, "../../../../webman/pm/comp");
unshift (@INC, "../../../../webman/pm/apps/appAdmin");

use DBI;
use CGI::Carp qw(fatalsToBrowser);

require appAdmin;
require DB_Utilities;

require app_admin_select_application;

my $cgi = new GMM_CGI;
my $dbu = new DB_Utilities;

my $dbi_conn = $dbu->make_DBI_Conn("../../../../webman/conf/dbi_connection.conf"); ### 15/05/2009

$dbu->set_DBI_Conn($dbi_conn); ### 12/12/2008
$cgi->set_DBI_Conn($dbi_conn); ### 12/12/2008

my $login = $cgi->param("login");

my $password = $cgi->param("password");
   $password =~ s/\'//g; ### prevent sql injection

my $session_id = $cgi->param("session_id");
my $link_name = $cgi->param("link_name");
my $app_name = $cgi->param("app_name");

if ($app_name eq "") {
    $app_name = "appAdmin";
    $cgi->add_Param("app_name", $app_name); ### 13/07/2007
}

my $logout = 0;

my $today_ISO = undef;
my $time_ISO = undef;

if ($link_name eq "Logout") {
    $logout = 1;
}

my $session = new Session;

$session->set_CGI($cgi);
$session->set_DBI_Conn($dbi_conn);

$session->set_Session_Table("webman_" . $app_name . "_session");
$session->set_User_Auth_Table("webman_" . $app_name . "_user", "login_name", "password");
$session->set_CGI_Var_DB_Cache_Table("webman_" . $app_name . "_cgi_var_cache");
$session->set_Idle_Time(3600);

###############################################################################

my $content = undef;

if ($session_id eq "" && $login eq "") { ### try to get it from cookie ### 19/01/2011
    #$cgi->add_Debug_Text("Try to get session_id from cookies.", __FILE__, __LINE__);
    $session_id = $cgi->get_Cookie_Val("session_id");
    $cgi->push_Param("session_id", $session_id);
}

$cgi->activate_DB_Cache_Var;   ### 16/12/2008

if ($session_id eq "") {
    $cgi->delete_Cookie_All;
    
    $session->set_Auth_Info($login, $password);
    #$session->set_Auth_Info("guest", "guest");
    $session->create_Session;
    
    #print "Try to get session <br>";
    
    $session_id = $session->get_Session_ID;
    
    #$cgi->add_Debug_Text("\$session_id = $session_id");
    
    if (!$cgi->set_Param_Val("session_id", $session_id)) {
        $cgi->set_Cookie("session_id", $session_id);
        $cgi->add_Param("session_id", $session_id);
    }
}

if ($session_id != -1) {
    my $valid = undef;
    
    $session->set_Session_ID($session_id);
    
    $valid = $session->is_Valid;
    
    $session->refresh_Session; # mark any possible zombie session
    
    #$cgi->add_Debug_Text("\$valid = $valid"); 
    #$cgi->add_Debug_Text("Session error: " . $session->get_Error);
    
    if (!$logout && $valid) {
        my $component_name = $cgi->param("component_name");
        my $app_in_control = $cgi->param("app_name_in_control");
        
        #$cgi->add_Debug_Text("\$app_in_control = $app_in_control", __FILE__, __LINE__);
        
        if ($app_in_control eq "") {
            $component_name = "app_admin_select_application";
            
            if (!$cgi->set_Param_Val("link_id", -1)) {
                $cgi->add_Param("link_id", -1);
            }            
        } else {
            $component_name = $app_name;
        }

        if ($component_name eq "") {
            $component_name = $app_name;
        }
        
        #$cgi->add_Debug_Text("\$component_name = $component_name", __FILE__, __LINE__);

        my $component = new $component_name;
        
        #$component->set_Caller_Module_Name("index.cgi");

        $component->set_CGI($cgi);
        $component->set_DBI_Conn($dbi_conn);

        if ($component_name eq $app_name) {
            $component->set_Module_DB_Param;
        }

        $component->run_Task;

        $component->process_Content;

        $content = $component->get_Content;
        
        $today_ISO = $component->get_Today_ISO;
        $time_ISO = $component->get_Time_ISO;
        
        $cgi->update_DB_Cache_Var; ### 16/12/2008 ### 06/01/2007
        
    } else {
        $cgi->delete_Cookie_All;
        
        if ($logout) {
            $session->set_DBI_Conn($dbi_conn);
            $session->logout($session_id);
    
            $session->set_DBI_Conn($dbi_conn);
        }
        
        my $sc = new Static_Content;
                
        $content = $sc->get_Content("./login.html");
    }
    
    $dbu->set_Table("webman_" . $app_name . "_session");
    $login = $dbu->get_Item("login_name", "session_id", "$session_id");
    
    $dbu->set_Table("webman_" . $app_name . "_user");
    $user_full_name = $dbu->get_Item("full_name", "login_name", "$login");
    
    $content =~ s/\$login_name_/$login/;
    $content =~ s/\$user_full_name_/$user_full_name/;
    
    $content = &process_Main_Template_Dynamic_Info($content);
    
    $session->update_Hits;
    &log_Hit_Info($content);
    
} else {
    
    my $sc = new Static_Content;
        
    $content = $sc->get_Content("./login.html");
    
    $content =~ s/\$app_name_/$app_name/;
    
    $content = &process_Main_Template_Dynamic_Info($content);
    
    &log_Hit_Info($content);
}

###############################################################################

my $mode = "$app_name";

if ($cgi->param("app_name_in_control") ne "" && 
    $cgi->param("link_name") ne "Select Application") {
    $mode .= " - " . $cgi->param("app_name_in_control");
}

my $page_properties = "<style type=\"text/css\"><!-- body{font-family:Geneva, Arial, Helvetica, sans-serif; font-size:10px;} --></style>";

$cgi->print_Header;
$cgi->start_HTML("Webman $mode", $page_properties);

print $content;

$cgi->print_Debug_Text;
$cgi->end_HTML();

###############################################################################

###############################################################################

sub process_Main_Template_Dynamic_Info {
    my $content_display = shift @_;
    
    my $time = localtime;

    $time =~ s/\b  \b/ /g;
    
    my @tarikh = split(/ /, $time);

    if ($tarikh[2] < 10) { $tarikh[2] = "0" . $tarikh[2]; }
    
    my $year = $tarikh[4];
    my $month = $tarikh[1];
    my $date = $tarikh[2];
    
    $content_display =~ s/\$app_name_/$app_name/;
    $content_display =~ s/\$copyright_year_current_/$year/;
    
    return $content_display;
}

sub log_Hit_Info {
    my $content_display = shift @_;
    
    if ($session_id ne "" && $session_id ne "-1" && !$logout) {
        #print "Try to log Hit info - $session_id<br>\n";
        #print "$today_ISO / $time_ISO <br>\n";
        #print $cgi->request_Method . "<br>\n";
        #print $cgi->generate_GET_Data(ALL) . "<br>\n";
        
        my $method = $cgi->request_Method;
        my $query_string = $cgi->generate_GET_Data(ALL);
        
        $content_display =~ s/ /\\ /g;
        $content_display =~ s/\'/\\\'/g;
        
        $dbu->set_Table("webman_" . $app_name . "_hit_info");
        
        $dbu->insert_Row("session_id date time method",
                         "$session_id $today_ISO $time_ISO $method");
                         
        my $hit_id = $dbu->get_Item("hit_id", "session_id date time", "$session_id $today_ISO $time_ISO");
        
        #$cgi->add_Debug_Text("\$hit_id = $hit_id ", __FILE__, __LINE__);
        
        $dbu->set_Table("webman_" . $app_name . "_hit_info_query_string");
        $dbu->insert_Row("hit_id query_string", "$hit_id $query_string");
        
        
        $dbu->set_Table("webman_" . $app_name . "_hit_info_content");
        $dbu->insert_Row("hit_id content", "$hit_id $content_display");
    }
}
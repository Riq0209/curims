#! C:/xampp/perl/bin/perl

unshift (@INC, "../../../../webman/pm/core");
unshift (@INC, "../../../../webman/pm/comp");
unshift (@INC, "../../../../webman/pm/apps/curims");

use DBI;
use CGI::Carp qw(fatalsToBrowser);

require GMM_CGI;
require DB_Utilities;
require Web_Service_Auth;

require curims;

my $cgi = new GMM_CGI;
my $dbu = new DB_Utilities;

my $dbi_conn = $dbu->make_DBI_Conn("../../../../webman/conf/dbi_connection.conf"); ### 15/05/2009

$dbu->set_DBI_Conn($dbi_conn); ### 12/12/2008
$cgi->set_DBI_Conn($dbi_conn); ### 12/12/2008

###############################################################################

my $app_name = $cgi->param("app_name");

if ($app_name eq "") {
    $app_name = "curims";
    $cgi->add_Param("app_name", $app_name); ### 13/07/2007
}

my $component_name = $cgi->param("component_name");

if ($component_name eq "") {
    $component_name = $app_name;
}

### $mc will be the main-controller 
### component instance
my $mc = new $component_name;

$mc->set_CGI($cgi);
$mc->set_DBI_Conn($dbi_conn);

$mc->set_Caller_Module_Name("index.cgi");
$mc->init;

###############################################################################

my $session = new Session;

$session->set_CGI($cgi);
$session->set_DBI_Conn($dbi_conn);

### 14/01/2017
if ($mc->{session_idle_time} > 0) {
    $session->set_Idle_Time($mc->{session_idle_time});
} else {
    $session->set_Idle_Time(3600);
}

### Options to manually set the database table names involved in session data management.
#$session->set_Session_Table("webman_" . $app_name . "_session");
#$session->set_User_Auth_Table("webman_" . $app_name . "_user", "login_name", "password");
#$session->set_CGI_Var_DB_Cache_Table("webman_" . $app_name . "_cgi_var_cache");

###############################################################################
my $link_id = $cgi->param("link_id");

my $login = $cgi->param("login");

my $password = $cgi->param("password");
   $password =~ s/\'//g; ### basic sql injection prevention

my $session_id = $cgi->param("session_id");
my $link_name = $cgi->param("link_name");

### Allow to switch to other different user.
if ($login ne "") {
    $session_id = "";
}

#$cgi->add_Debug_Text("$session_id - $login - $password ", __FILE__, __LINE__);

if ($session_id eq "" && $login eq "") { ### try to get it from cookie ### 19/01/2011
    $session_id = $cgi->get_Cookie_Val("session_id");
    $cgi->push_Param("session_id", $session_id);
    #$cgi->add_Debug_Text("Get session_id:$session_id from cookies.", __FILE__, __LINE__);
}

#$cgi->add_Debug_Text("$session_id - $login - $password ", __FILE__, __LINE__);

if ($login eq "" && $mc->{enforce_guest_auth}) {
    if ($session_id eq "") { 
        $login = "guest";
        $password = "guest";
        
    } else {
        $session->set_Session_ID($session_id);
        
        if (!$session->is_Valid) {
            $login = "guest";
            $password = "guest";
            $session_id = "";
        }
    }
}

#$cgi->add_Debug_Text("$session_id - $login - $password ", __FILE__, __LINE__);

###############################################################################

$cgi->activate_DB_Cache_Var;   ### 16/12/2008

if ($session_id eq "") {
    $cgi->delete_Cookie_All; ### 19/01/2011
    
    $session->set_Auth_Info($login, $password);
    
    if ($login eq "guest") {        
        ### 14/01/2017
        if ($mc->{session_idle_time} > 0) { 
            ### Do nothing, just follow session idle time previously
            ### set using $mc->{session_idle_time} value.
            
        } else {
            ### Make "guest" type login valid for 12 hours. 
            $session->set_Idle_Time(43200);

            #$cgi->add_Debug_Text(43200);
        }        
    }
    
    ### the create_Session function below will also check if current user
    ### requires JSON service authentication from different webman
    ### applications/servers    
    $session->create_Session;
    
    #$cgi->add_Debug_Text("Try to get session", __FILE__, __LINE__);

    $session_id = $session->get_Session_ID;
    
    #$cgi->add_Debug_Text("\$session_id = $session_id", __FILE__, __LINE__);

    ### 22/02/2011, 13/10/2013
    ### Try to authenticate user using user information from other 
    ### Webman-framework's web-based applications via JSON service. 
    if ($session_id == -1 && !$session->check_User($login) && defined($mc->{web_service_URL})) { 
        #$cgi->add_Debug_Text("User not exist locally. Try from other webman application via web service", __FILE__, __LINE__);
        
        ### try to login using webman web service 
        my $wsauth = new Web_Service_Auth;
        
        $wsauth->set_CGI($cgi);
        $wsauth->set_Local_Session($session);
        $wsauth->set_Web_Service_URL($mc->{web_service_URL});
        
        $session_id = $wsauth->get_Session_ID;
        
        #$cgi->add_Debug_Text("\$session_id = $session_id", __FILE__, __LINE__);
        
        if ($session_id != -1) {
            $wsauth->register_Web_Service_User;
            $mc->register_Web_Service_User;
        }
    }
    
    if ($session_id != -1) { ### 19/01/2011
        #$cgi->add_Debug_Text("Store session_id: $session_id", __FILE__, __LINE__);
        $cgi->set_Cookie("session_id", $session_id);
        $cgi->push_Param("session_id", $session_id);
    }
}

###############################################################################

my $content = undef;

my $logout = 0;

my $today_ISO = undef;
my $time_ISO = undef;

if ($link_name eq "Logout" || $cgi->param("logout")) {
    $logout = 1;
}

if ($session_id == -1) {
    if ($mc->{enforce_guest_auth}) {
        $cgi->redirect_Page("index.cgi?link_id=$link_id");
        
    } else {
        my $sc = new Static_Content;

        $content = $sc->get_Content($mc->{login_page});
        $content =~ s/\$app_name_/$app_name/;
        $content = &process_Main_Template_Dynamic_Info($content);
    }
    
} else {
    $session->set_Session_ID($session_id);
    
    if ($session->get_Login_Name eq "guest") {
        ### 14/01/2017
        if ($mc->{session_idle_time} > 0) { 
            ### Do nothing, just follow session idle time previously
            ### set using $mc->{session_idle_time} value.
            
        } else {
            ### Make "guest" type login valid for 12 hours. 
            $session->set_Idle_Time(43200);

            #$cgi->add_Debug_Text(43200);
        }
    }    
    
    my $valid = $session->is_Valid;
    
    #$cgi->add_Debug_Text("\$valid = $valid, \$link_name = $link_name, \$logout = $logout", __FILE__, __LINE__);
    
    if (!$logout && $valid) {
        ### 27/02/2016
        $mc->{session} = $session;
        
        if ($component_name eq $app_name) {
            $mc->set_Module_DB_Param;
        }

        $mc->run_Task;

        $mc->process_Content;

        $content = $mc->get_Content;
        
        $today_ISO = $mc->get_Today_ISO;
        $time_ISO = $mc->get_Time_ISO;
        
        $cgi->update_DB_Cache_Var; ### 16/12/2008 ### 06/01/2007
        
    } else {
        if ($logout) {
            $session->set_DBI_Conn($dbi_conn);
            
            ### 27/02/2016
            ### Mark any possible zombie sessions.
            $session->refresh_Session;
            
            $session->logout($session_id);
        }
        
        $cgi->delete_Cookie_All; ### 9/01/2011
        
        if ($mc->{enforce_guest_auth}) {
            $cgi->redirect_Page("index.cgi?link_id=$link_id");
            
        } else {
            my $sc = new Static_Content;
            $content = $sc->get_Content($mc->{login_page});
        }
    }
    
    $dbu->set_Table("webman_" . $app_name . "_session");
    my $login = $dbu->get_Item("login_name", "session_id", "$session_id");
    
    $dbu->set_Table("webman_" . $app_name . "_user");
    my $user_full_name = $dbu->get_Item("full_name", "login_name", "$login");
    
    $dbu->set_Table("webman_" . $app_name . "_user_group");
    my @groups = $dbu->get_Items("group_name", "login_name", "$login");
    
    my $user_groups = undef;
    foreach my $item (@groups) {
		$user_groups .= "$item->{group_name} ";
	}
       
    $content =~ s/\$login_name_/$login/;
    #$content =~ s/\$user_full_name_/$user_full_name/;
    $content =~ s/\$user_full_name_/$user_full_name/g;
    $content =~ s/\$user_groups_/$user_groups/;
    
    $content = &process_Main_Template_Dynamic_Info($content);   
}

###############################################################################

#$cgi->add_Debug_Text($cgi->{cookies_raw_str}, __FILE__, __LINE__);

#$cgi->{allow_origin} = 1;
$cgi->print_Header;

if (!$mc->{trim_html_start}) {
    $cgi->start_HTML("curims", $mc->{page_subheader}, $mc->{page_properties});
}

$content = $mc->customize_Content($content);

print $content;

if ($mc->{log_hit_info}) {
    $session->update_Hits;
    &log_Hit_Info($content);
    #$cgi->add_Debug_Text("Log hit info", __FILE__, __LINE__);
}
    
$cgi->print_Debug_Text;

if (!$mc->{trim_html_end}) {
    $cgi->end_HTML();
}


###############################################################################

sub process_Main_Template_Dynamic_Info {
    my $content_display = shift @_;
    
    my $time = localtime;

    $time =~ s/\b  \b/ /g;
    
    my @date_info = split(/ /, $time);

    if ($date_info[2] < 10) { $date_info[2] = "0" . $date_info[2]; }
    
    my $year = $date_info[4];
    my $month = $date_info[1];
    my $date = $date_info[2];
    
    $content_display =~ s/\$app_name_/$app_name/;
    $content_display =~ s/\$current_year_/$year/g;

    #15/4/2025
    my $previous_year = $year - 1;
    $content_display =~ s/\$previous_year_/$previous_year/g;
    
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
        
        #print "\$hit_id = $hit_id ";
        
        $dbu->set_Table("webman_" . $app_name . "_hit_info_query_string");
        $dbu->insert_Row("hit_id query_string", "$hit_id $query_string");
        
        
        $dbu->set_Table("webman_" . $app_name . "_hit_info_content");
        $dbu->insert_Row("hit_id content", "$hit_id $content_display");
    }
}

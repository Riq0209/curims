package wmcudas;

use webman_main;

@ISA=("webman_main");

### Include new customized application modules next to this line.

#__cust_mod__

use wmcudas_apps_group_add;
use wmcudas_apps_group_list;
use wmcudas_apps_group_remove;
use wmcudas_apps_group_user_link;
use wmcudas_apps_multirows_delete;
use wmcudas_apps_multirows_insert;
use wmcudas_apps_multirows_update;
use wmcudas_apps_text2db_delete;
use wmcudas_apps_text2db_insert;
use wmcudas_apps_text2db_update;
use wmcudas_apps_user_add;
use wmcudas_apps_user_list;
use wmcudas_apps_user_remove;
use wmcudas_group_apps_add;
use wmcudas_group_apps_list;
use wmcudas_group_apps_remove;
use wmcudas_group_apps_user_link;
use wmcudas_group_multirows_delete;
use wmcudas_group_multirows_insert;
use wmcudas_group_multirows_update;
use wmcudas_group_text2db_delete;
use wmcudas_group_text2db_insert;
use wmcudas_group_text2db_update;
use wmcudas_group_user_add;
use wmcudas_group_user_list;
use wmcudas_group_user_remove;
use wmcudas_user_apps_add;
use wmcudas_user_apps_group_link;
use wmcudas_user_apps_list;
use wmcudas_user_apps_remove;
use wmcudas_user_group_add;
use wmcudas_user_group_list;
use wmcudas_user_group_remove;
use wmcudas_user_multirows_delete;
use wmcudas_user_multirows_insert;
use wmcudas_user_multirows_update;
use wmcudas_user_text2db_delete;
use wmcudas_user_text2db_insert;
use wmcudas_user_text2db_update;

#__cust_mod__

### Don't remove the above "#__cust_mod__" comments since they are used 
### by the framework code generator to automatically add/remove modules.

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    bless $this, $class;
    
    return $this;
}

sub get_Name {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub get_Name_Full {
    my $this = shift @_;
    
    return $this->SUPER::get_Name_Full . "::" . __PACKAGE__;
}

sub init {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    ### Add page's external resources (Javascript, CSS, etc.)
    $this->{page_extrsc} .= "<script type=\"text/javascript\" src=\"../../../webman/wmcudas/js/wm_functions_std.js\"></script>\n";
    $this->{page_extrsc} .= "<script type=\"text/javascript\" src=\"../../../webman/wmcudas/js/wm_functions_ajax.js\"></script>\n";
    $this->{page_extrsc} .= "<link href=\"../../../webman/wmcudas/css/wm_tag_std.css\" rel=\"stylesheet\" type=\"text/css\">\n";
    $this->{page_extrsc} .= "<link href=\"../../../webman/wmcudas/css/wm_class_std.css\" rel=\"stylesheet\" type=\"text/css\">\n";
    #$this->{page_extrsc} .= "<link href=\"../../../webman/wmcudas/css/cust_minimalistic.css\" rel=\"stylesheet\" type=\"text/css\">\n";
    
    ### The framework uses special web-based application named "wmcudas" to
    ### support the implementation of "Central User Directory Access Service". 
    ### Using this service, user's authentication for many web applications can 
    ### be centralized and managed by single "wmcudas" application. The service 
    ### is a type of JSON-based web service. 
    #$this->{web_service_URL} = "http://???/cgi-bin/webman/wmcudas/index_json.cgi";    
    
    ### Option to log hit info (data & content). Useful to keep track (via AAT) 
    ### and better understand user problems while using the application. 
    ### However, this option will take more resources on database table space 
    ### and might also degrade application response time especially in a very 
    ### high traffic situation.
    $this->{log_hit_info} = 1;
    
    ### Option to enforce guest-type user authentication whenever 
    ### login & password is not supplied or session is expired.
    #$this->{enforce_guest_auth} = 1;    
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    
    ### Below is example of basic logical control to channel users 
    ### to specific context of links.
    
    #my $match_group = $this->match_Group($group_name_, @groups);
    
    #my $link_id = $cgi->param("link_id");
    
    #$cgi->add_Debug_Text("login_name = $login_name, link_id = $link_id", __FILE__, __LINE__);
    
    #if ($link_id == 1) { ### default is Home
    #    if (grep(/^ADMIN$/, @groups)) {
    #        $cgi->redirect_Page("./index.cgi?link_id=???");
    #
    #    } elsif ($login_name eq "guest") {
    #        $cgi->redirect_Page("./index.cgi?link_id=???");
    #    }
    #}
    
    $this->SUPER::run_Task();
    
    #$cgi->add_Debug_Text($this->get_Link_Path_Info, __FILE__, __LINE__, "TRACING");  
}

sub customize_Content {
    my $this = shift @_;
    my $content = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    ### Final content can be further customized here. The most simplest one is 
    ### to use Perl's standard pattern matching & replacement command.
    #$content =~ s/???/???/;
    
    return $content;
}

1;
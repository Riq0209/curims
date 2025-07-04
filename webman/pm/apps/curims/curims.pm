package curims;

use webman_main;

@ISA=("webman_main");

### Include new customized application modules next to this line.

#__cust_mod__

use curims_clo_multirows_delete;
use curims_clo_multirows_insert;
use curims_clo_multirows_update;
use curims_clo_plo_add;
use curims_clo_plo_link;
use curims_clo_plo_list;
use curims_clo_plo_remove;
use curims_course_assesment_clo_curriculum_topic_link;
use curims_course_assesment_multirows_delete;
use curims_course_assesment_multirows_insert;
use curims_course_assesment_multirows_update;
use curims_course_assesment_plo_add;
use curims_course_assesment_plo_link;
use curims_course_assesment_plo_list;
use curims_course_assesment_plo_remove;
use curims_course_clo_list;
use curims_course_clo_multirows_delete;
use curims_course_clo_multirows_insert;
use curims_course_clo_multirows_update;
use curims_course_curriculum_list;
use curims_course_information;
use curims_course_multirows_delete;
use curims_course_multirows_insert;
use curims_course_multirows_update;
use curims_course_topic_multirows_delete;
use curims_course_topic_multirows_insert;
use curims_course_topic_multirows_update;
use curims_course_topic_schedule_link;
use curims_course_topic_schedule_list;
use curims_course_topic_schedule_multirows_delete;
use curims_course_topic_schedule_multirows_insert;
use curims_course_topic_schedule_multirows_update;
use curims_curriculum_course_add;
use curims_curriculum_course_elective_add;
use curims_curriculum_course_elective_list;
use curims_curriculum_course_elective_list_view;
use curims_curriculum_course_elective_remove;
use curims_curriculum_course_link;
use curims_curriculum_course_list;
use curims_curriculum_course_list_bysem;
use curims_curriculum_course_remove;
use curims_curriculum_multirows_delete;
use curims_curriculum_multirows_insert;
use curims_curriculum_multirows_update;
use curims_curriculum_plo_list;
use curims_curriculum_plo_multirows_delete;
use curims_curriculum_plo_multirows_insert;
use curims_curriculum_plo_multirows_update;
use curims_lecturer_course_add;
use curims_lecturer_course_link;
use curims_lecturer_course_list;
use curims_lecturer_course_remove;
use curims_lecturer_multirows_delete;
use curims_lecturer_multirows_insert;
use curims_lecturer_multirows_update;
use curims_lecturer_text2db_delete;
use curims_lecturer_text2db_insert;
use curims_lecturer_text2db_update;
use curims_schedule_list;
use curims_schedule_multirows_delete;
use curims_schedule_multirows_insert;
use curims_schedule_multirows_update;

#__cust_mod__
use curims_course_information;
use curims_dashboard;
#use curims_course_sidebar;
#use curims_curriculum_course_elective_add;
#use curims_curriculum_course_elective_list;

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
    $this->{page_subheader} .= "<link href=\"../../../webman/curims/css/curims_sidebar.css\" rel=\"stylesheet\" type=\"text/css\">\n";
    $this->{page_subheader} .= "<script type=\"text/javascript\" src=\"../../../webman/curims/js/wm_functions_std.js\"></script>\n";
    $this->{page_subheader} .= "<script type=\"text/javascript\" src=\"../../../webman/curims/js/wm_functions_ajax.js\"></script>\n";
    $this->{page_subheader} .= "<link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/5/w3.css\">\n";
    $this->{page_subheader} .= "<link href=\"../../../webman/curims/css/curims_main.css\" rel=\"stylesheet\" type=\"text/css\">\n";
    $this->{page_subheader} .= "<link href=\"../../../webman/curims/css/curims_style.css\" rel=\"stylesheet\" type=\"text/css\">\n";
    $this->{page_subheader} .= '<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">' . "\n";
    $this->{page_subheader} .= '<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">' . "\n"; 
    $this->{page_subheader} .= "<script type=\"text/javascript\" src=\"../../../webman/curims/js/table_style.js\"></script>\n";
    $this->{page_subheader} .= "<link href=\"../../../webman/curims/css/curims_multiselect_dropdown.css\" rel=\"stylesheet\" type=\"text/css\">\n";
    $this->{page_subheader} .= "<script type=\"text/javascript\" src=\"../../../webman/curims/js/multiselect.js\"></script>\n";
    #$this->{page_subheader} .= "<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n";
    #$this->{page_subheader} .= "<link href=\"../../../webman/curims/css/wm_tag_std.css\" rel=\"stylesheet\" type=\"text/css\">\n";
    #$this->{page_subheader} .= "<link href=\"../../../webman/curims/css/wm_class_std.css\" rel=\"stylesheet\" type=\"text/css\">\n";
    #$this->{page_subheader} .= "<link href=\"../../../webman/curims/css/cust_minimalistic.css\" rel=\"stylesheet\" type=\"text/css\">\n";
    
    ### Page properties (the BODY tag settings)
    #$this->{page_properties} .= "style=\"max-width:400px\"";
    
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
    
    ### 22/08/2014
    ### The default view template for login page.
    #$this->{login_page} = "./template_login_modern.html"; #-- previously used
    $this->{login_page} = "./Presentation/Login/template_login_modern.html";# -- latest 15/4/2025
    
    ### The possible way to change the default login page 
    ### on certain condition.
    #if (???) {
    #    $this->{login_page} = "./template_login_mobile.html";
    #}
    
    ### 14/01/2017
    ### Default session idle time is 12 hours for "guest" and 1 hour for 
    ### other type of users. Enable the following line to change this default 
    ### setting (15 minutes for all type of users).
    #$this->{session_idle_time} = 900;     
}

sub register_Web_Service_User {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    ### Do the necessary things below when login is first made via "wmcudas", 
    ### a special web-based application that provide support for 
    ### "Central User Directory Access Service". The most basic one might  
    ### to copy user info. from app. logical table to app. problem 
    ### domain table. Below is the possible example for application with 
    ### name "lmslight" 
    #my $login_name = $cgi->param("login");
    
    #$dbu->set_Table("webman_lmslight_user");
    #my $full_name = $dbu->get_Item("full_name", "login_name", "$login_name");
    
    #$dbu->set_Table("webman_lmslight_user_group");
    #my @ahr = $dbu->get_Items("group_name", "login_name", "$login_name");
    
    #my %groupkeys = ();
    
    #foreach my $item (@ahr) {
    #    $groupkeys{$item->{group_name}} = 1;
    #}
    
    #my $full_name_fmtd = $full_name;
    #   $full_name_fmtd =~ s/ /\\ /g;
       
    #if ($groupkeys{"INSTRUCTOR"}) {
    #    $cgi->add_Debug_Text("$login_name - $full_name - INSTRUCTOR", __FILE__, __LINE__);
        
    #    $dbu->set_Table("lmslight_instructor");
    #    $dbu->insert_Row("login_name instructor_name", "$login_name $full_name_fmtd");
    #}
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
    
    ### 27/02/2016
    ### Web application can also be stop for maintenance here.
    my $stop_app = 0;
    
    if ($stop_app) {
        $content = "<center>\n" .
                   "<h1>Webman-framework Notification</h1>\n" .
                   "<h3>curims application is currently closed.</h3>\n";
                   
        if ($this->{session}) {
            $content .= "<h3>" . $this->{session} . ":" . $this->{session}->get_Session_ID . "</h3>\n" .
            $this->{session}->logout;
        }
                   
        $content .= "</center>\n";
    }
    
    ## Return the final content after customization.
    return $content;
}

1;
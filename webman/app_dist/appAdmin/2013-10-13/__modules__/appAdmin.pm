package appAdmin;

use webman_main;

@ISA=("webman_main");

### customized application modules
use app_admin_user;
use app_admin_group;
use app_admin_link;
use app_admin_component;
use app_admin_db_item_auth;
use app_admin_login_info_all;
use app_admin_login_info_daily;
use app_admin_login_info_monthly;
use app_admin_login_info_all_hits_content;


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

sub run_Task {
    my $this = shift @_;
    
    $this->SUPER::run_Task();
    
    #print "<font color=\"#FF00FF\">run_Task from webman_init</font><br>\n";
    
    #$this->print_Link_Path_Info;
}

1;
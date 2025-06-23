package curims_currcourse_course_remove;

use webman_db_item_delete;

@ISA=("webman_db_item_delete");

sub new {
    my $class = shift;
    
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
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);

    ### Part for multiple item remove operation. 
    my @cgi_var_list = $cgi->var_Name;

    foreach my $param_name (@cgi_var_list) {
        if ($param_name =~ /^id_elective_62base_/) {
            my $id_elective_62base = $cgi->param_Shift($param_name);

            #$cgi->add_Debug_Text("$this->{table_name} : $param_name = $id_elective_62base", __FILE__, __LINE__);
            
            $dbu->set_Table($this->{table_name});
            $dbu->delete_Item("id_elective_62base", $id_elective_62base);
        }
    }
    
    ### Part for single itme remove operation.    
    $this->SUPER::run_Task();
}

1;
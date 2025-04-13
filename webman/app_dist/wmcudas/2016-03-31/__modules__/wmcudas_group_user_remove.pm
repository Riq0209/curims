package wmcudas_group_user_remove;

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
    
    #$cgi->add_Debug_Text($cgi->param("id_usergroup_36base_0"), __FILE__, __LINE__);
    
    ### Part for multiple item remove operation. 
    my @cgi_var_list = $cgi->var_Name;

    foreach my $param_name (@cgi_var_list) {
        if ($param_name =~ /^id_usergroup_36base_/) {
            my $id_usergroup_36base = $cgi->param_Shift($param_name);
            
            ### Delete user-group assignment from framework's default user-group table first.
            $this->delete_Default_UG_Table($id_usergroup_36base);              

            #$cgi->add_Debug_Text("$this->{table_name} : $param_name = $id_usergroup_36base", __FILE__, __LINE__);
            
            ### Delete user-group assigment from "wmcudas_usergroup" table.
            $dbu->set_Table($this->{table_name});
            $dbu->delete_Item("id_usergroup_36base", $id_usergroup_36base);
                      
        }
    }
    
    
    ### Part for single itme remove operation.
    
    ### Delete user-group assignment from framework's default user-group table.
    $this->delete_Default_UG_Table($cgi->param("id_usergroup_36base"));
    
    ### Delete user-group assigment from "wmcudas_usergroup" table.
    $this->SUPER::run_Task();
}

sub delete_Default_UG_Table {
    my $this = shift @_;
    my $id_usergroup_36base = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    $dbu->set_Table("wmcudas_usergroup");
    my @ahr = $dbu->get_Items("id_user_36base id_group_36base", "id_usergroup_36base", $id_usergroup_36base);

    $dbu->set_Table("wmcudas_user");
    my $login_name = $dbu->get_Item("login_name", "id_user_36base", $ahr[0]->{id_user_36base});
    
    $dbu->set_Table("wmcudas_group");
    my $group_name = $dbu->get_Item("group_name", "id_group_36base", $ahr[0]->{id_group_36base});

    $dbu->set_Table("webman_wmcudas_user_group");
    $dbu->delete_Item("login_name group_name", "$login_name $group_name");
}

1;
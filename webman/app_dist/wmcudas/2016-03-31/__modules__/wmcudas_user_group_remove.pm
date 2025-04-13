package wmcudas_user_group_remove;

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
    
    ### Delete user-group assignment from framework's default user-group table.
    $dbu->set_Table("wmcudas_usergroup");
    my @ahr = $dbu->get_Items("id_user_36base id_group_36base", "id_usergroup_36base", $cgi->param("id_usergroup_36base"));

    $dbu->set_Table("wmcudas_user");
    my $login_name = $dbu->get_Item("login_name", "id_user_36base", $ahr[0]->{id_user_36base});
    
    $dbu->set_Table("wmcudas_group");
    my $group_name = $dbu->get_Item("group_name", "id_group_36base", $ahr[0]->{id_group_36base});

    $dbu->set_Table("webman_wmcudas_user_group");
    $dbu->delete_Item("login_name group_name", "$login_name $group_name");    
    
    ### Delete user-group assigment from "wmcudas_usergroup" table.
    $this->SUPER::run_Task();
}

1;
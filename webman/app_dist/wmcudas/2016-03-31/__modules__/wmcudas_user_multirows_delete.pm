package wmcudas_user_multirows_delete;

use webman_db_item_delete_multirows;

@ISA=("webman_db_item_delete_multirows");

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
    
    my $status = $this->SUPER::run_Task();
    
    #$cgi->add_Debug_Text("\$status = $status ", __FILE__, __LINE__);
    
    if ($status) {
        #$cgi->add_Debug_Text($this->get_SQL, __FILE__, __LINE__, "DATABASE");

        my $id_user_in = undef;
        
        my $idx = 0;
        
        while ($cgi->param_Exist("\$db_id_user_36base_$idx")) {
            my $id_user = $cgi->param("\$db_id_user_36base_$idx");
            
            ### Collecting user ID to delete it from framework's default 
            ### user table.
            $id_user_in .= "'" . $id_user . "',";
            
            ### Delete user-group from "wmcudas_userapps", "wmcudas_usergroup" 
            ### and framework's default user-group tables.
            $dbu->set_Table("wmcudas_userapps");
            $dbu->delete_Item("id_user_36base", "$id_user");
            
            $dbu->set_Table("wmcudas_usergroup");
            $dbu->delete_Item("id_user_36base", "$id_user");
            
            #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
            
            $dbu->set_Table("webman_wmcudas_user");
            my $login_name = $dbu->get_Item("login_name", "id_user", "$id_user");
            
            $dbu->set_Table("webman_wmcudas_user_group");
            $dbu->delete_Item("login_name", "$login_name");
            
            #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
            
            $idx++;
        }
        
        $id_user_in =~ s/,$//;
        
        ### Delete user from framework's default user table.
        my $sth = $db_conn->prepare("delete from webman_wmcudas_user where id_user in ($id_user_in)");
        
        #$cgi->add_Debug_Text("delete from webman_wmcudas_user where id_user in ($id_user_in) : " . $DBI::errstr, __FILE__, __LINE__, "DATABASE");
        
        $sth->execute;
        $sth->finish;        
    }
}

sub end_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    ### Really need to call this for multi phases modules
    ### to reset some of the no longer required CGI data.
    $this->SUPER::end_Task();
}

### Provide more flexibility inside the child module so developers can 
### further refine the final constructed confirm-field-row string using 
### Perl's regular expression and string substitutions.
sub refine_Confirm_DB_Field_Row_Str {
    my $this = shift @_;
    my $str = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    #for (my $row_idx = 0;  $row_idx < @{$this->{delete_key_field_list}}; $row_idx++) {
        #$str =~ ....;
    #}
    
    return $str;
}

1;
package wmcudas_apps_multirows_delete;

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
    
    if ($status) {
        ### Also delete from "wmcudas_groupapps" and "wmcudas_userapps" table.
        #$cgi->add_Debug_Text($this->get_SQL, __FILE__, __LINE__, "DATABASE");
        
        my $sqlcmds1 = $this->get_SQL;
        my $sqlcmds2 = $this->get_SQL;
        
        $sqlcmds1 =~ s/ wmcudas_apps / wmcudas_groupapps /g;
        $sqlcmds2 =~ s/ wmcudas_apps / wmcudas_userapps /g;
        
        my @sqlcmds = split(/;/, $sqlcmds1 . $sqlcmds2);
        
        foreach my $sqlcmd (@sqlcmds) {
            #$cgi->add_Debug_Text($sqlcmd, __FILE__, __LINE__, "DATABASE");
            
            my $sth = $db_conn->prepare($sqlcmd);

            #$cgi->add_Debug_Text($DBI::errstr, __FILE__, __LINE__, "DATABASE");

            $sth->execute;
            $sth->finish;
        }
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
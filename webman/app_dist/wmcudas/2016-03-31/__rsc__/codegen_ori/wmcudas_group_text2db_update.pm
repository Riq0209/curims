package wmcudas_group_text2db_update;

use webman_text2db_map;

@ISA=("webman_text2db_map");

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
    
    #if ($this->init_Phase) {
    #    $cgi->add_Debug_Text("init_Phase", __FILE__, __LINE__, "TRACING");
        
    #} elsif($this->last_Phase) {
    #    $cgi->add_Debug_Text("last_Phase", __FILE__, __LINE__, "TRACING");
        
    #} else { ### confirm phase
    #    $cgi->add_Debug_Text("confirm_Phase", __FILE__, __LINE__, "TRACING");
    #}    
    
    $this->SUPER::run_Task();
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;

    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
     
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    $this->add_Content($te_content);
}

### Customize TLD content that affect column  
### items involved in database operation.
sub customize_TLD_DB_Operation {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $tld = $this->{tld};
    
    if (defined($tld)) {
        ### Example of TLD instance customization for database operations.
        
        #$tld->add_Column("new_column_name_");
        
        ### Example on how to skip specific row from being involved
        ### in the current selected database operation.
        #$tld->add_Column("_skip_");        
        
        #for (my $i = 0; $i < $tld->get_Row_Num; $i++) { 
            #my $existing_col_data = $tld->get_Data($i, "existing_col_name_");
            #...
            #...
            #...
            #$tld->set_Data($i, "new_col_name_", $new_col_data);
            
            

            ### Continue example on how to skip specific row from being 
            ### involved in the current selected database operation.
            #if (condition...?) {
            #    $tld->set_Data($i, "_skip_", 1);
            #}
        #}
        
        
        ### Next is to do the real implementation based on the above example.
        
        
        for (my $i = 0; $i < $tld->get_Row_Num; $i++) {
        }        
    }
    
    return $tld;
}

### Customize TLD content for view purpose only and not
### affect column items involved in database operation.
sub customize_TLD_View {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $tld = $this->{tld};
    
    if (defined($tld)) {
        ### Example of TLD instance customization for for view only.
        
        #$tld->add_Column("new_column_name_");
        
        #for (my $i = 0; $i < $tld->get_Row_Num; $i++) { 
            #my $tld_data = $tld->get_Data($i, "col_name_");
            
            #$tld->set_Data($i, "new_col_name_", $new_col_data);
            
            ### Might need to change the row status based on "_skip_" column 
            ### info. set via the above customize_TLD_DB_Operation function.
            #if ($tld->get_Data($i, "_skip_")) {
            #    $tld->set_Data($i, "_row_status_", "new status...")
            #}            
        #}
        
        
        ### Next is to do the real customization based on the above example.
        ### ???        
    }
    
    return $tld;
}

sub applied_Text_Content {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    ### The possible way to deal with key fields that are dynamically added  
    ### via customize_TLD_DB_Operation function implementations. Only required   
    ### on update and delete operations.
    
    #$this->{kf_str_struct} = "field_name_1 and field_name_2 and ...";
    
    #push(@{$this->{key_field_name_array_ref}}, "field_name_1");
    #push(@{$this->{key_field_name_array_ref}}, "field_name_2");
    #push(@{$this->{key_field_name_array_ref}}, "...");
    
    ### Next is to do the real implementation based on the above example.
    ### ???
    
    return $this->SUPER::applied_Text_Content();
}

1;
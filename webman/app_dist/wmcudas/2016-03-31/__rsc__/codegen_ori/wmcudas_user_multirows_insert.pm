package wmcudas_user_multirows_insert;

use webman_db_item_insert_multirows;

@ISA=("webman_db_item_insert_multirows");

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
    
    
   
    if ($this->{row_num} eq "") {
        $this->{row_num} = 3;
    }
    
    if ($cgi->param("irn_wmcudas_user") > 0) {
        $this->{row_num} = $cgi->param("irn_wmcudas_user");
        
    } else {
        $cgi->push_Param("irn_wmcudas_user", $this->{row_num})
    }    
    
    ### Example on how to control row input data prior 
    ### the real database operation.
    #my @CGI_var_list = $cgi->var_Name;
    
    #foreach my $var (@CGI_var_list) {
    #    if ($var =~ /^\$db_notice_$row_idx/) {
    #        #$cgi->add_Debug_Text("$var = " . $cgi->param("$var"), __FILE__, __LINE__, "TRACING");
            
    #        if ($cgi->param("$var") eq "") {
    #            $cgi->push_Param($var, "-");
    #        }
    #    }
    #}
    
    $this->SUPER::run_Task();
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

### This function will be called just before the insert 
### operation is implemented inside the run_Task function.
sub customize_CGI_Data { ### 11/10/2011
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    for (my $row_idx = 0; $row_idx < $this->{row_num}; $row_idx++) {
        ### Below is an example on how to add/insert other linked table primary  
        ### keys (linked_table_PK) that act as a foreign keys inside current table 
        ### by refering to one of current table field that act as a unique keys 
        ### inside the linked table (linked_table_UK)    
  
        #$dbu->set_Table("linked_table_name");
        #my $linked_table_PK = $dbu->get_Item("linked_table_PK", "linked_table_UK", $cgi->param("\$db_linked_table_UK_" . $row_idx));            
        #$cgi->push_Param("\$db_linked_table_PK_" . $row_idx, $linked_table_PK);
        
        ### Next is to do the real implementation based on the above example.
        
    }
}

### Provide more flexibility inside the child module so developers can 
### further refine the final constructed form-field-row string using Perl's  
### regular expression and string substitutions.
sub refine_Form_DB_Field_Row_Str {
    my $this = shift @_;
    my $str = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    #for (my $row_idx = 0;  $row_idx < $this->{row_num}; $row_idx++) {
        #$str =~ ....;
    #}
    
    return $str;
}

1;
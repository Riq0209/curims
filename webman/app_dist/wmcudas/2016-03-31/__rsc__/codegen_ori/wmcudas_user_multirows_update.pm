package wmcudas_user_multirows_update;

use webman_db_item_update_multirows;

@ISA=("webman_db_item_update_multirows");

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

### this function will be called just before the update 
### operation is implemented inside the run_Task function
sub customize_CGI_Data { ### 11/10/2011
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ### Below is an example on how to add/insert other linked table primary  
    ### keys (linked_table_PK) that act as a foreign keys inside current table 
    ### by refering to one of current table field that act as a unique keys 
    ### inside the linked table (linked_table_UK)    

    #$dbu->set_Table("linked_table_name");
    #my $linked_table_PK = $dbu->get_Item("linked_table_PK", "linked_table_UK", $cgi->param("\$db_linked_table_UK_"));            
    #$cgi->push_Param("\$db_linked_table_PK_", $linked_table_PK);

    ### next is to do the real implementation based on the above example
    
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
    
    #for (my $row_idx = 0;  $row_idx < @{$this->{update_key_field_list}}; $row_idx++) {
        #$str =~ ....;
    #}
    
    return $str;
}

1;
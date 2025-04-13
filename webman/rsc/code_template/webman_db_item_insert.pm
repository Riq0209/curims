package __component_name__;

use webman_db_item_insert;

@ISA=("webman_db_item_insert");

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
    
    __cgi_push_param__
    
    __push_param_parent_FK_start__
    $dbu->set_Table("__linked_table_name__");
    my $__linked_table_FK__ = $dbu->get_Item("__linked_table_FK__", "__linked_table_PK__", $cgi->param("__linked_table_PK__"));
    $cgi->push_Param("__linked_table_FK__", $__linked_table_FK__);    
    __push_param_parent_FK_end__    
    
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

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    ### Below is an example on how to add/insert other linked table primary  
    ### keys (linked_table_PK) that act as a foreign keys inside current table 
    ### by refering to one of current table field that act as a unique keys 
    ### inside the linked table (linked_table_UK)    

    #$dbu->set_Table("linked_table_name");
    #my $linked_table_PK = $dbu->get_Item("linked_table_PK", "linked_table_UK", $cgi->param("\$db_linked_table_UK_"));            
    #$cgi->push_Param("\$db_linked_table_PK_", $linked_table_PK);

    ### Next is to do the real implementation based on the above example.
    
    __push_param_FK_start__
    $dbu->set_Table("__linked_table_name__");
    my $__linked_table_PK__ = $dbu->get_Item("__linked_table_PK__", "__linked_table_UK__", $cgi->param("\$db___linked_table_UK__"));            
    $cgi->push_Param("\$db___linked_table_PK__", $__linked_table_PK__);        
    __push_param_FK_end__ 
}

1;
package __component_name__;

use webman_db_item_search;

@ISA=("webman_db_item_search");

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
    
    my $status = $this->SUPER::run_Task;
    
    if ($this->{found}) {
        ### extra tasks when search item was found
        ### ???
    }
    
    return $status;
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;    
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    ### process the standard dynamic content of search template which
    ### are "link_path", "form_hidden_field", and "search_result"
    
    if ($te_type_name eq "search_result") {
        if ($this->{total_item_found} == 0 || $this->{total_item_found} > 1) {
            $this->SUPER::process_DYNAMIC($te);
        }
        
    } else {
        ### process other standard dynamic content of search template which
        ### are "link_path" and "form_hidden_field"
        $this->SUPER::process_DYNAMIC($te);
    }
    
    ### process other additional dynamic content
    if ($te_type_name eq "???") {
        ### ???
    }
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
    
    #my $te_type_name = $te->get_Name;
    
    $this->add_Content($te_content);
}

sub redirect_Page {
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    if ($cgi->param("button_submit") eq "Search" && $this->{total_item_found} == 1) {
        ### directly run other module via page redirect
        $this->SUPER::redirect_Page;
        
    } else {
        ### Search item was not found.
        
        ### Also Useful for search->update/search->delete operations that 
        ### return multi row result so this module will not directly 
        ### redirect the page to update/delete module. It can first 
        ### list the returned multi row result before the users choose 
        ### the exact single item they want to update/delete.    
    }
}

sub customize_SQL {
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $sql = $this->{sql};
    
    ### Next to customize the $sql string
    ### ???
    
    return $sql;
}

sub end_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    $this->SUPER::end_Task;
    
}

1;
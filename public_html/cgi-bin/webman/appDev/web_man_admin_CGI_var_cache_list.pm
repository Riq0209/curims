package web_man_admin_CGI_var_cache_list;

require webman_db_item_view_dynamic;

@ISA=("webman_db_item_view_dynamic");

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

sub run_Task {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($cgi->param("trace_module")) {
        print "<b>" . $this->get_Name_Full . "</b><br />\n";
    }
    
    $this->SUPER::run_Task;
}

sub get_Name_Full {
    my $this = shift @_;
    
    return $this->SUPER::get_Name_Full . "::" . __PACKAGE__;
}

sub customize_SQL {
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $sql = $this->{sql};
    
    ### Next to customize the $sql string
    ### ???
    my $sql_filter = undef;
    
    
    if (!$cgi->param_Exist("filter_session_id") || $cgi->param("filter_session_id") eq "") {
        $cgi->push_Param("filter_session_id", "\%");
    }
    my $filter_session_id = $cgi->param("filter_session_id");
    $sql_filter .= "session_id like '$filter_session_id' and ";
    
    
    if (!$cgi->param_Exist("filter_link_id") || $cgi->param("filter_link_id") eq "") {
        $cgi->push_Param("filter_link_id", "\%");
    }
    my $filter_link_id = $cgi->param("filter_link_id");
    $sql_filter .= "link_id like '$filter_link_id' and ";
    
    
    $sql_filter =~ s/ and $//;
    
    my @sql_part = split(/ order by /, $sql);
    
    $cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");
    
    if ($sql_part[0] =~ / where /) {
        $sql = "$sql_part[0] and $sql_filter order by $sql_part[1]";
        
    } else {
        $sql = "$sql_part[0] where $sql_filter order by $sql_part[1]";
    }
    
    $cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");
    
    return $sql;
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $i = 0;
    my $tld_data = undef;
    
    my $caller_get_data = $cgi->generate_GET_Data("link_name link_id dmisn app_name");
    my $get_data = undef;
    
    $tld->add_Column("row_class");
    
    my $row_class = "row_odd"; ### HTML CSS class
    
    for ($i = 0; $i < $tld->get_Row_Num; $i++) { 
        #$tld_data = $tld->get_Data($i, "col_name_");
        
        #$tld_data = "<font color=\"#0099FF\">$tld_data</font>";
            
        #$tld->set_Data($i, "col_name_", $tld_data);
        #$tld->set_Data_Get_Link($i, "col_name_", "index.cgi?$get_data", "link_properties_");
        
        $tld->set_Data($i, "row_class", "$row_class");
        
        if ($row_class eq "row_odd") {
            $row_class = "row_even";
            
        } else {
            $row_class = "row_odd";
        }        
        
    }
    
    return $tld;
}

1;
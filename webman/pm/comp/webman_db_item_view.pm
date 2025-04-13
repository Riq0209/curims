package webman_db_item_view;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{sql_debug} = undef;
    
    $this->{sql} = undef;
 
    $this->{link_path_level_start} = undef; ### 06/02/2008
    $this->{link_path_level_deep} = undef; ### 14/12/2010
    $this->{link_path_separator_tag} = undef; ### 14/12/2010
    $this->{link_path_unselected_color} = undef; ### 14/12/2010    
    $this->{link_path_additional_get_data} = undef; ### 01/01/2009
    
    $this->{carried_previous_get_data} = undef; ### 16/12/2010
    
    $this->{exclude_db_cache_cgi_var} = undef; ### 05/01/2009
    $this->{remove_db_cache_cgi_var} = undef; ### 01/01/2009
    
    $this->{escape_HTML_tag} = undef; ### 15/08/2024
    
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

sub set_Template_Default {
    my $this = shift @_;
    
    $this->{template_default} = shift @_;
}

sub set_SQL_Debug {
    my $this = shift @_;
    
    $this->{sql_debug} = shift @_;
}

sub set_SQL {
    my $this = shift @_;
    
    $this->{sql} = shift @_;
}

sub set_Link_Path_Level_Start {
    my $this = shift @_;
    
    $this->{link_path_level_start} = undef;
}

sub set_Link_Path_Level_Deep {
    my $this = shift @_;
    
    $this->{link_path_level_deep} = undef;
}

sub set_Link_Path_Separator_Tag {
    my $this = shift @_;
    
    $this->{link_path_separator_tag} = undef;
}


sub set_Link_Path_Unselected_Color {
    my $this = shift @_;

    $this->{link_path_unselected_color} = undef;
}

sub set_Link_Path_Additional_Get_Data { ### 11/02/2006
    my $this = shift @_;
    
    $this->{link_path_additional_get_data} = shift @_;
}

sub set_Carried_Caller_Get_Data { ### 27/05/2008
    my $this = shift @_;
    
    $this->{carried_caller_get_data} = shift @_;
}

sub get_SQL {
    my $this = shift @_;
        
    return $this->{sql};
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->SUPER::run_Task();
    #print "run_Task from webman_db_item_view<br>\n";
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
    #print "\$this->{template_default} = " . $this->{template_default} . "<br>";
    #print "\$this->{dbi_app_conn} = " . $this->{dbi_app_conn} . "<br>";
    
    $this->SUPER::process_Content;
}

sub process_VIEW { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    ###########################################################################
    
    ### 30/11/2011
    ### The LOC below is no more relevant since the template engine already 
    ### support nested <!-- start_cgihtml_ //-->...<!-- end_cgihtml_ //--> 
    ### coupled tag
    
    #if ($this->{carried_previous_get_data} ne "") {
    #    my $cgd = $cgi->generate_GET_Data($this->{carried_previous_get_data});
        
    #    $te_content =~ s/\$carried_previous_get_data_/$cgd/g;
    #}
    
    ###########################################################################
    
    $this->add_Content($te_content);
}

sub process_DBHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    ###########################################################################
    
    ### 30/11/2011
    ### The LOC below is no more relevant since the template engine already 
    ### support nested <!-- start_cgihtml_ //-->...<!-- end_cgihtml_ //--> 
    ### coupled tag    
    
    #if ($this->{carried_previous_get_data} ne "") {
    #    my $cgd = $cgi->generate_GET_Data($this->{carried_previous_get_data});
        
    #    $te_content =~ s/\$carried_previous_get_data_/$cgd/g;
    #}
    
    ###########################################################################
    
    my $sql = $this->{sql};
    my @cgi_var = $cgi->var_Name;
    
    my $pattern = undef;
    my $replacement = undef;
    
    for (my $i = 0; $i < @cgi_var; $i++) {
        $pattern = "cgi_" . $cgi_var[$i] . "_";
        
        $replacement = $cgi->param($cgi_var[$i]); 
        
        #print "$pattern : $replacement <br>";
        
        $sql =~ s/\$\b$pattern\b/$replacement/;
    }
    
    $this->{sql} = $sql;
    
    my $db_conn_app = $this->get_DB_Conn_App;
        
    my $dbihtml = new DBI_HTML_Map;

    if ($db_conn_app ne undef) {
        $dbihtml->set_DBI_Conn($db_conn_app); 
    } else {
        $dbihtml->set_DBI_Conn($db_conn);
    }
    
    if ($this->{escape_HTML_tag} ne undef) { ### 15/08/2024
        $dbihtml->set_Escape_HTML_Tag($this->{escape_HTML_tag});
    }
    
    $this->{sql} = $this->customize_SQL;
    
    $dbihtml->set_SQL($this->{sql});
    $dbihtml->set_HTML_Code($te_content);
    
    $te_content = $dbihtml->get_HTML_Code;
    
    if ($dbihtml->get_DB_Error_Message ne "") {
        $cgi->add_Debug_Text("Database Error: " . $dbihtml->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
    }    
    
    if ($this->{sql_debug}) {
        $cgi->add_Debug_Text("SQL = " . $dbihtml->get_SQL, __FILE__, __LINE__, "DATABASE");
    }
    
    if ($dbihtml->get_Items_Num > 0) {
        $this->add_Content($te_content);
        
        ### 20/11/2011
        #return $te_content;
    }
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    #print "\$te_type_name = $te_type_name";
    
    
    if ($te_type_name eq "link_path") {
        my $wmlpg = new webman_link_path_generator;
        
        $wmlpg->set_Template_Default("template_link_path.html");
        $wmlpg->set_Carried_GET_Data("session_id");
        $wmlpg->set_Additional_GET_Data($this->{link_path_additional_get_data}); ### 01/01/2009
        $wmlpg->set_Level_Start($this->{link_path_level_start});
        
        if ($this->{link_path_level_deep} < 0) { ### 14/12/2010
            $this->{link_path_level_deep} = $this->get_My_Link_Level;
        }
        
        $wmlpg->set_Level_Deep($this->{link_path_level_deep});
        
        if ($this->{link_path_separator_tag} ne "") { ### 14/12/2010
            $wmlpg->set_Separator_Tag($this->{link_path_separator_tag});
        }
        
        if ($this->{link_path_unselected_color} ne "") { ### 14/12/2010
            $wmlpg->set_Non_Selected_Link_Color($this->{link_path_unselected_color});
        } 
        
        $wmlpg->set_CGI($cgi);
        $wmlpg->set_DBI_Conn($db_conn);
        
        $wmlpg->set_Link_Path($this->get_Link_Path); ### 04/02/2009
        
        $wmlpg->set_Current_Dynamic_Content_Name($te_type_name); ### 26/05/2011
        $wmlpg->set_Module_DB_Param; ### 26/05/2011        
        
        $wmlpg->run_Task;
        $wmlpg->process_Content;
        
        $te_content = $wmlpg->get_Content;
    }
    
    $this->add_Content($te_content);
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($te_content);
}

sub get_DB_Conn_App {
    my $this = shift @_;
    
    if ($this->{dbi_app_conn} ne "") {
        
        my @spliters = split(/ /, $this->{dbi_app_conn});
        
        my $db_conn = DBI->connect("DBI:$spliters[0]:dbname=$spliters[1]", "$spliters[2]", "$spliters[3]");
        
        return $db_conn;
    }
    
    return undef;
}

sub customize_SQL { 
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $sql = $this->{sql};
    
    ### Next to customize the $sql string
    ### ???
    
    return $sql;
}

1;

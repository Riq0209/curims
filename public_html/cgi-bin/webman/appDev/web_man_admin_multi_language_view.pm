package web_man_admin_multi_language_view;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");


sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{activate_last_path} = undef;
    
    bless $this, $type;
    
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
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($cgi->param("trace_module")) {
        print "<b>" . $this->get_Name_Full . "</b><br />\n";
    }    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_multi_language_view.html");
    
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
    
    my $caller_get_data = $this->generate_GET_Data("link_name_multi_lang dmisn_multi_lang link_name dmisn app_name");
    
    $te_content =~ s/\$caller_get_data_/$caller_get_data/;
    
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
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL("select * from $pre_table_name" . "dictionary_language order by language");
    $dbihtml->set_HTML_Code($te_content);

    $te_content = $dbihtml->get_HTML_Code;
    
    if ($dbihtml->get_Items_Num > 0) {
    
        my $caller_get_data = $this->generate_GET_Data("link_name_multi_lang dmisn_multi_lang link_name dmisn app_name");
    
        $te_content =~ s/\$caller_get_data_/$caller_get_data/g;

        $this->add_Content($te_content);
    }
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

1;
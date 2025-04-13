package web_man_admin_multi_language_link_view;

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
    
    my $task = $cgi->param("task");
    my $submit = $cgi->param("submit");
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $htmldb = new HTML_DB_Map;

    $htmldb->set_CGI($cgi);
    $htmldb->set_DBI_Conn($db_conn);
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn);   ### option 1
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_multi_language_link_view.html");
    
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
    
    $this->add_Content($te_content);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $lang_id = $cgi->param("lang_id");
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL("select * from $pre_table_name" . "link_structure order by name");

    my $tld = $dbihtml->get_Table_List_Data;
    
    my $db_items_num = $dbihtml->get_Items_Num;

    if ($db_items_num > 0) {
        my $dbu = new DB_Utilities;
        
        $dbu->set_DBI_Conn($db_conn);   ### option 1
        $dbu->set_Table($pre_table_name . "dictionary_link");
        
        $tld->add_Column("link_name_translate");
        
        my $tld_row_num = $tld->get_Row_Num;
        
        my $i = 0;
        my $link_id = undef;
        my $link_name_translate = undef;
        
        for ($i = 0; $i < $tld_row_num; $i++) {
            $link_id = $tld->get_Data($i, "link_id");
            
            $link_name_translate = $dbu->get_Item("link_name_translate", "link_id lang_id", "$link_id $lang_id");
            
            if ($link_name_translate ne "") {
                $tld->set_Data($i, "link_name_translate", $link_name_translate);
            } else {
                $tld->set_Data($i, "link_name_translate", "-");
            }
        }
        
        my $tldhtml = new TLD_HTML_Map;
                    
        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content);
                    
        my $html_result = $tldhtml->get_HTML_Code;
        
        my $caller_get_data = $this->generate_GET_Data("lang_id link_name_selected_lang dmisn_selected_lang link_name_multi_lang dmisn_multi_lang link_name dmisn app_name");
            
        $html_result =~ s/\$caller_get_data_/$caller_get_data/g;
            
        $this->add_Content($html_result);
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
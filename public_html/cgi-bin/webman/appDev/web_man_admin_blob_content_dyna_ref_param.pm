package web_man_admin_blob_content_dyna_ref_param;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);

    $this->{current_blob_id} = undef;
    
    $this->{pre_table_name} = undef;
    
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
    
    $this->{pre_table_name} = "webman_" . $cgi->param("app_name") . "_";
    
    my $task = $cgi->param("task");
    my $scdmr_id = $cgi->param("scdmr_id");
    my $param_name = $cgi->param("\$db_param_name");
    
    $cgi->set_Param_Val("\$db_scdmr_id", $scdmr_id);
    
    $cgi->push_Param("\$db_link_ref_id", -1);
    $cgi->push_Param("\$db_dyna_mod_selector_id", -1);
    
    my $dbu = new DB_Utilities;
            
    $dbu->set_DBI_Conn($db_conn);
    
    if ($task eq "dyna_ref_param_set" && $cgi->param("\$db_param_value") ne "") {
        #print "Try to set dynamic ref. parameter - $scdmr_id - $param_name <br>";
        
        $dbu->set_Table($this->{pre_table_name} . "dyna_mod_param");
        $dbu->delete_Item("scdmr_id param_name", "$scdmr_id $param_name"); 
        
        my $htmldb = new HTML_DB_Map;
                    
        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        $htmldb->set_Table($this->{pre_table_name} . "dyna_mod_param");
        
        $htmldb->insert_Table; ### method 1
        
        if ($htmldb->get_DB_Error_Message ne "") {
            $cgi->add_Debug_Text($htmldb->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
        }        
        
    } elsif ($task eq "dyna_ref_param_unset") {
        #print "Try to unset dynamic ref. parameter - $scdmr_id - $param_name <br>";
        
        $dbu->set_Table($this->{pre_table_name} . "dyna_mod_param");
        $dbu->delete_Item("scdmr_id param_name", "$scdmr_id $param_name");
    }
    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_blob_content_dyna_ref_param.html");
    
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
    
    my $caller_get_data = $cgi->generate_GET_Data("link_name dmisn app_name mode current_blob_id");
    
    $te_content =~ s/\$caller_get_data_/$caller_get_data/g;
    
    $this->add_Content($te_content);
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $hpd = $cgi->generate_Hidden_POST_Data("link_name dmisn app_name cdbr_set_num_dmisn cdbr_set_num current_blob_id mode scdmr_id dyna_mod_name dynamic_content_num");
    
    $this->add_Content($hpd);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $blob_id = $this->{current_blob_id};
    
    my $sql = "select * from " . $this->{pre_table_name} . 
              "dyna_mod_param where scdmr_id='" . $cgi->param("scdmr_id") . "'";



    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL($sql);
    $dbihtml->set_HTML_Code($te_content);

    my $tld = $dbihtml->get_Table_List_Data;

    if ($dbihtml->get_Items_Num > 0) {
        my $tldhtml = new TLD_HTML_Map;
                    
        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content);
                    
        my $html_result = $tldhtml->get_HTML_Code;
        
        my $caller_get_data = $cgi->generate_GET_Data("link_name dmisn app_name cdbr_set_num_dmisn cdbr_set_num current_blob_id mode scdmr_id dyna_mod_name dynamic_content_num");
            
        $html_result =~ s/\$caller_get_data_/$caller_get_data/g;
        
        $this->add_Content($html_result);
    }

    #print "sql = $sql <br>";
}

sub process_SELECT { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $dyna_mod_name = $cgi->param("dyna_mod_name");
    
    my $script_filename = $ENV{SCRIPT_FILENAME};
    my @array = split(/\//, $script_filename);

    my $app_dir = undef;

    for ($i = 0; $i < @array - 5; $i++) {
        $app_dir .= "$array[$i]/";
    }

    $app_dir .=  "webman/pm/apps/" . $cgi->param("app_name") . "/";
    
    #print "\$dyna_mod_name = $dyna_mod_name <br>";
    
    my $web_man_admu = new web_man_admin_dyna_mod_utils;
    
    $web_man_admu->set_Dynamic_Module_Folder($app_dir);
    
    my $s_opt = new Select_Option;
    
    $s_opt->set_Values($web_man_admu->get_Dyna_Mod_Param($dyna_mod_name));
    
    $this->add_Content($s_opt->get_Selection);
}


1;
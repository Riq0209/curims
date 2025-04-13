package web_man_admin_blob_content_dyna_ref;

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
    $this->{current_blob_id} = $cgi->param("current_blob_id");
    
    my $task = $cgi->param("task");
    
    my $dbu = new DB_Utilities;
        
    $dbu->set_DBI_Conn($db_conn);
    
    if ($task eq "dyna_ref_add") {
        my $blob_id = $this->{current_blob_id};
        my $dynamic_content_num = $cgi->param("\$db_dynamic_content_num");
        
        $dbu->set_Table($this->{pre_table_name} . "static_content_dyna_mod_ref");
        
        if (!$dbu->find_Item("dynamic_content_num blob_id", "$dynamic_content_num $blob_id")) {
            #print "Try to add dynamic ref. <br>";
            
            $cgi->set_Param_Val("\$db_blob_id", $blob_id);
            
            my $htmldb = new HTML_DB_Map;
            
            $htmldb->set_CGI($cgi);
            $htmldb->set_DBI_Conn($db_conn);
            $htmldb->set_Table($this->{pre_table_name} . "static_content_dyna_mod_ref");
            
            $htmldb->insert_Table; ### method 1
        }
        
    } elsif ($task eq "dyna_ref_delete") {
        my $scdmr_id = $cgi->param("scdmr_id");
        
        $dbu->set_Table($this->{pre_table_name} . "static_content_dyna_mod_ref");
        $dbu->delete_Item("scdmr_id", "$scdmr_id");
        
        $dbu->set_Table($this->{pre_table_name} . "dyna_mod_param");
        $dbu->delete_Item("scdmr_id", "$scdmr_id");
        
    } elsif ($task eq "dyna_ref_param_copy") { ### task is set by web_man_admin_blob_content_dyna_ref_param_copy.pm
        my $item = undef;
        my @ahr = undef;
        
        my $scdmr_id = $cgi->param("scdmr_id");
        my $scdmr_id_copy = $cgi->param("scdmr_id_copy");
        
        my $param_name = undef;
        my $param_value = undef;
        
        #print "Try to copy from $scdmr_id_copy to $scdmr_id";
        
        $dbu->set_Table($this->{pre_table_name} . "dyna_mod_param");
        
        my @ahr = $dbu->get_Items("param_name param_value", 
                                  "scdmr_id", "$scdmr_id_copy", 
                                  undef, undef);
        
        $dbu->delete_Item("scdmr_id", "$scdmr_id");
        
        foreach $item (@ahr) {
            $param_name = $item->{param_name};
            $param_value = $item->{param_value};
            
            $param_value =~ s/ /\\ /g;
            
            $dbu->insert_Row("scdmr_id param_name param_value", "$scdmr_id $param_name $param_value");
        }
    }
    
    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_blob_content_dyna_ref.html");
    
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
    
    my $hpd = $cgi->generate_Hidden_POST_Data("link_name dmisn app_name mode cdbr_set_num_dmisn cdbr_set_num current_blob_id");
    
    $this->add_Content($hpd);
}



sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $blob_id = $this->{current_blob_id};
    
    my $sql = "select * from " . $this->{pre_table_name} . 
              "static_content_dyna_mod_ref where blob_id='$blob_id'";

    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL($sql);
    $dbihtml->set_HTML_Code($te_content);

    my $tld = $dbihtml->get_Table_List_Data;
    
    my %dcname_applied = (); ### dcname stand for dynamic_content_name

    if ($tld != 0) {
        $tld->add_Column("param_num");
    
        $dbu->set_Table($this->{pre_table_name} . "dyna_mod_param");

        for (my $i = 0; $i < $tld->get_Row_Num; $i++) {
            my $param_num = $dbu->count_Item("scdmr_id", $tld->get_Data($i, "scdmr_id"));

            if ($param_num < 10) {
                $param_num = "0" . $param_num;
            }

            $tld->set_Data($i, "param_num", $param_num);
            
            $dcname_applied{$tld->get_Data($i, "dynamic_content_name")} = 1;
        }
    }
    
    $this->{dcname_applied} = \%dcname_applied;

    if ($dbihtml->get_Items_Num > 0) {
        my $tldhtml = new TLD_HTML_Map;
                    
        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content);
                    
        my $html_result = $tldhtml->get_HTML_Code;
        
        my $caller_get_data = $cgi->generate_GET_Data("link_name dmisn app_name cdbr_set_num_dmisn cdbr_set_num current_blob_id sort_link_name sort_field");
            
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
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $blob_id = $this->{current_blob_id};
    
    my $s_opt = new Select_Option;
    
    if ($te_type_num == 0) {
        my $dbu = new DB_Utilities;
                    
        $dbu->set_DBI_Conn($db_conn);
        $dbu->set_Table($this->{pre_table_name} . "blob_content");
        
        my $counter = 0;
        my @values = ();
        my $html_content = $dbu->get_Item("content", "blob_id", "$blob_id");
        
        my $tex = new Template_Element_Extractor;
        $tex->set_Doc_Content($html_content);
        
        my @te = $tex->get_Template_Element;
        
        foreach my $item (@te) {
            #print "###### " . $item->get_Type . " - " . $item->get_Name . "<br>\n";
            
            if ($item->get_Type eq "DYNAMIC" && !$this->{dcname_applied}->{$item->get_Name}) {
                push(@values, $item->get_Name);
            }
        }
        
        $s_opt->set_Values(@values);

        $te_content = $s_opt->get_Selection;
    
    } else {
        my $sql = "select dyna_mod_name from " . $this->{pre_table_name} . "dyna_mod order by dyna_mod_name";
        
        #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "TRACING");
        
        $s_opt->set_DBI_Conn($db_conn);
        $s_opt->set_Values_From_DBI_SQL($sql);
        $s_opt->set_Options_From_DBI_SQL($sql);
        
        $te_content = $s_opt->get_Selection;
    }
    
    $this->add_Content($te_content);
}

1;


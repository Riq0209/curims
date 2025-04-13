package web_man_admin_link_structure_dyna_mod_param_copy;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_link_structure;

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
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
    
    $this->SUPER::run_Task;
    
    $this->{pre_table_name} = "webman_" . $cgi->param("app_name") . "_";
    $this->{dyna_mod_name} = $cgi->param("\$ref_name");
    
    my $task = $cgi->param("task");
    my $submit = $cgi->param("submit");
    my $link_ref_id = $cgi->param("link_ref_id");
    
    my $dbu = new DB_Utilities;
            
    $dbu->set_DBI_Conn($db_conn);
    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_link_structure_dyna_mod_param_copy.html");
    
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
    
    my $root_caller_get_data = $this->generate_GET_Data("link_name dmisn app_name");
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name link_struct_id child_link_id");
    my $caller_get_data2 = $this->generate_GET_Data("app_name");
    
    my $link_struct_id = $cgi->param("link_struct_id");
    my $child_link_id = $cgi->param("child_link_id");
    
    my @link_path = undef;
    my $link_path_info = undef;
    
    $te_content =~ s/Root/<a href="index.cgi?$root_caller_get_data"><font color="#0099FF">Root<\/font><\/a>/;
    
    $te_content =~ s/child_link_id_/$child_link_id/;
    $te_content =~ s/\$caller_get_data_/index.cgi?$caller_get_data&task=update_ref_phase1/;
    
    my $web_man_als = new web_man_admin_link_structure;

    $web_man_als->set_CGI($cgi);
    $web_man_als->set_DBI_Conn($db_conn);
    $web_man_als->set_Activate_Last_Path(1);

    @link_path = $web_man_als->get_Link_Path($child_link_id);
    $link_path_info = $web_man_als->generate_Link_Path_Info("index.cgi", "$caller_get_data2", @link_path);

    $te_content =~ s/LINK_PATH_/$link_path_info/;
    
    my $data_HTML = new Data_HTML_Map;
    
    $data_HTML->set_CGI($cgi);
    $data_HTML->set_HTML_Code($te_content);
    
    $te_content = $data_HTML->get_HTML_Code;

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
    
    my $dyna_mod_name = $this->{dyna_mod_name};
    
    my $link_ref_id_current = $cgi->param("link_ref_id");
    
    #print "\$dyna_mod_name = $dyna_mod_name<br>";
    
    my $dbu = new DB_Utilities;
    
    ### keys for dynamic module parameters from link_reference
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($this->{pre_table_name} . "link_reference");
    
    my @ahr = $dbu->get_Items("link_ref_id", 
                              "ref_name", "$dyna_mod_name", 
                              undef, undef);
                              
    my $link_ref_id_in = undef;
                              
    foreach my $item (@ahr) {
        $link_ref_id_in .= "'$item->{link_ref_id}', ";
    }
    
    $link_ref_id_in =~ s/, $//;
    
    #print "\$link_ref_id_in = $link_ref_id_in <br>";
    
    
    ### keys for dynamic module parameters from dyna_mod_selector ### 14/01/2011
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($this->{pre_table_name} . "dyna_mod_selector");    
    
    my $dyna_mod_selector_id_in = undef;
    
    my @ahr = $dbu->get_Items("dyna_mod_selector_id", 
                              "dyna_mod_name", "$dyna_mod_name", 
                              undef, undef);
                              
    print __FILE__ . ":" . __LINE__ . "<br />\nSQL = " . $dbu->get_SQL . "<br />\n";
    
    foreach my $item (@ahr) {
        $dyna_mod_selector_id_in .= "'$item->{dyna_mod_selector_id}', ";
    }
    
    $dyna_mod_selector_id_in =~ s/, $//;
    
    #print "\$dyna_mod_selector_id_in = $dyna_mod_selector_id_in <br>";                              
    
    
    ### retrieve all relevant parameters from dyna_mod_param
    
    my $sql = "select * from " . $this->{pre_table_name} . "dyna_mod_param " . 
              "where link_ref_id in ($link_ref_id_in) ";
              
    if ($dyna_mod_selector_id_in ne "") {
        $sql .= "or dyna_mod_selector_id in ($dyna_mod_selector_id_in) ";
    }
    
    $sql .= "order by link_ref_id, dyna_mod_selector_id, param_name";
              
    print __FILE__ . ":" . __LINE__ . "<br />\nSQL = $sql <br />\n";

    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL($sql);
    $dbihtml->set_HTML_Code($te_content);
    
    $dbihtml->set_Escape_HTML_Tag(1); ### 14/01/2011

    my $tld = $dbihtml->get_Table_List_Data;
    
    #print $tld->get_Table_List;

    if ($dbihtml->get_Items_Num > 0) {
        my $i = 0;
        my @keys = undef;
        my @values = undef;
        my $key = undef;
        
        my $link_ref_id = undef;
        my $dyna_mod_selector_id = undef;
        
        my $param_name = undef;
        my $param_value = undef;
        my $param_name_value = undef;
        
        my %map_linkrefid_paramnamevalue = undef;
        my %map_paramnamevalue_linkrefid = undef;
        my $linkrefid_paramnamevalue_current = undef;
        
        my %map_dynamodselectorid_paramnamevalue = undef;
        my %map_paramnamevalue_dynamodselectorid = undef;       
        
        my $tld_param_selection = new Table_List_Data;
        
        $tld_param_selection->add_Column("link_ref_id");
        $tld_param_selection->add_Column("dyna_mod_selector_id");
        $tld_param_selection->add_Column("param_name_value");
        $tld_param_selection->add_Column("operation");
        
        for ($i = 0; $i < $dbihtml->get_Items_Num; $i++) {
            $link_ref_id = $tld->get_Data($i, "link_ref_id");
            $dyna_mod_selector_id = $tld->get_Data($i, "dyna_mod_selector_id");
            
            $param_name = $tld->get_Data($i, "param_name");
            $param_value = $tld->get_Data($i, "param_value");
            
            if ($link_ref_id != -1) {
                $map_linkrefid_paramnamevalue{$link_ref_id} .= "<tr><td><font size=2>$param_name</font></td><td><font size=2>$param_value</font></td></tr>\n";

                if ($link_ref_id == $link_ref_id_current) {
                    $linkrefid_paramnamevalue_current = $map_linkrefid_paramnamevalue{$link_ref_id};
                }
                
            } elsif ($dyna_mod_selector_id != -1) {
                $map_dynamodselectorid_paramnamevalue{$dyna_mod_selector_id} .= "<tr><td><font size=2>$param_name</font></td><td><font size=2>$param_value</font></td></tr>\n";
            }
        }
        
        
        ### relevant dynamic module parameters from link_reference
        
        @keys = keys(%map_linkrefid_paramnamevalue);
        
        foreach $key (@keys) {
            $param_name_value = $map_linkrefid_paramnamevalue{$key};
            
            if ($map_paramnamevalue_linkrefid{$param_name_value} eq undef) {
                $map_paramnamevalue_linkrefid{$param_name_value} = $key;
            }
        }
        
        my $value = undef;
        my @values = values(%map_paramnamevalue_linkrefid);
        
        my $get_link_copy = undef;
        my $operation_copy = undef;
        my $caller_get_data = $cgi->generate_GET_Data("link_name dmisn app_name link_struct_id child_link_id link_ref_id");
        
        foreach $value (@values) {
            $link_ref_id = $value;
            
            $get_link_copy = "index.cgi?$caller_get_data&task=update_ref_phase2_copy_param&link_ref_id_copy=$link_ref_id&dyna_mod_selector_id_copy=-1";
            
            if ($linkrefid_paramnamevalue_current eq $map_linkrefid_paramnamevalue{$link_ref_id}) {
                $operation_copy = "Copy";
                
            } else {
                $operation_copy = "<a href=\"$get_link_copy\"><font color=\"#0099FF\">Copy</font></a>\n";
            }
            
            if ($link_ref_id ne "") {
                $param_name_value = "<table border=1 cellpadding=1 cellspacing=1>" . $map_linkrefid_paramnamevalue{$link_ref_id} . "</table>\n";
            
                $tld_param_selection->add_Row_Data($link_ref_id, $dyna_mod_selector_id, $param_name_value, $operation_copy);
            }
        }
        
        
        ### relevant dynamic module parameters from dyna_mod_param
        
        @keys = keys(%map_dynamodselectorid_paramnamevalue);
        
        foreach $key (@keys) {
            $param_name_value = $map_dynamodselectorid_paramnamevalue{$key};
            
            if ($map_paramnamevalue_dynamodselectorid{$param_name_value} eq undef) {
                $map_paramnamevalue_dynamodselectorid{$param_name_value} = $key;
            }
        }
        
        my $value = undef;
        my @values = values(%map_paramnamevalue_dynamodselectorid);
        
        my $get_link_copy = undef;
        my $operation_copy = undef;
        my $caller_get_data = $cgi->generate_GET_Data("link_name dmisn app_name link_struct_id child_link_id link_ref_id");
        
        foreach $value (@values) {
            $dyna_mod_selector_id = $value;
            
            $get_link_copy = "index.cgi?$caller_get_data&task=update_ref_phase2_copy_param&link_ref_id_copy=-1&dyna_mod_selector_id_copy=$dyna_mod_selector_id";
            
            $operation_copy = "<a href=\"$get_link_copy\"><font color=\"#0099FF\">Copy</font></a>\n";
            
            if ($dyna_mod_selector_id ne "") {
                $param_name_value = "<table border=1 cellpadding=1 cellspacing=1>" . $map_dynamodselectorid_paramnamevalue{$dyna_mod_selector_id} . "</table>\n";
            
                $tld_param_selection->add_Row_Data($link_ref_id, $dyna_mod_selector_id, $param_name_value, $operation_copy);
            }
        }
        
        
        ### the final result
        
        my $tldhtml = new TLD_HTML_Map;
                    
        $tldhtml->set_Table_List_Data($tld_param_selection);
        $tldhtml->set_HTML_Code($te_content);
                    
        my $html_result = $tldhtml->get_HTML_Code;
        
        $this->add_Content($html_result);
    }

    #print "sql = $sql <br>";
}

1;
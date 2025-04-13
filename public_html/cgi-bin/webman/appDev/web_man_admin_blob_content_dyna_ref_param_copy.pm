package web_man_admin_blob_content_dyna_ref_param_copy;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

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
    
    $this->{pre_table_name} = "webman_" . $cgi->param("app_name") . "_";
    $this->{dyna_mod_name} = $cgi->param("dyna_mod_name");
    $this->{scdmr_id} = $cgi->param("scdmr_id");
    
    my $dbu = new DB_Utilities;
            
    $dbu->set_DBI_Conn($db_conn);
    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_blob_content_dyna_ref_param_copy.html");
    
    $this->SUPER::process_Content;
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $scdmr_id_current = $this->{scdmr_id};
    my $dyna_mod_name = $this->{dyna_mod_name};
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($this->{pre_table_name} . "static_content_dyna_mod_ref");
    
    my $item = undef;
    my @ahr = $dbu->get_Items("scdmr_id", 
                              "dyna_mod_name", "$dyna_mod_name", 
                              undef, undef);
                              
    my $scdmr_id_in = undef;
                              
    foreach $item (@ahr) {
        $scdmr_id_in .= "'$item->{scdmr_id}', ";
    }
    
    $scdmr_id_in =~ s/, $//;
    
    
    my $sql = "select * from " . $this->{pre_table_name} . "dyna_mod_param " . 
              "where scdmr_id in ($scdmr_id_in) order by scdmr_id, param_name";
              
    #print "\$sql = $sql <br>\n";

    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL($sql);
    $dbihtml->set_HTML_Code($te_content);

    my $tld = $dbihtml->get_Table_List_Data;

    if ($dbihtml->get_Items_Num > 0) {
        my $i = 0;
        my @keys = undef;
        my $key = undef;
        
        my $scdmr_id = undef;
        my $param_name = undef;
        my $param_value = undef;
        my $param_name_value = undef;
        
        my %map_scdmrid_paramnamevalue = undef;
        my %map_paramnamevalue_scdmrid = undef;
         my $scdmrid_paramnamevalue_current = undef;
        
        my $tld_param_selection = new Table_List_Data;
        
        $tld_param_selection->add_Column("scdmr_id");
        $tld_param_selection->add_Column("param_name_value");
        $tld_param_selection->add_Column("operation");
        
        for ($i = 0; $i < $dbihtml->get_Items_Num; $i++) {
            $scdmr_id = $tld->get_Data($i, "scdmr_id");
            $param_name = $tld->get_Data($i, "param_name");
            $param_value = $tld->get_Data($i, "param_value");
            
            $map_scdmrid_paramnamevalue{$scdmr_id} .= "<tr><td><font size=2>$param_name</font></td><td><font size=2>$param_value</font></td></tr>\n";
            
            if ($scdmr_id == $scdmr_id_current) {
                $scdmrid_paramnamevalue_current = $map_scdmrid_paramnamevalue{$scdmr_id};
            }
        }
        
        @keys = keys(%map_scdmrid_paramnamevalue);
        
        foreach $key (@keys) {
            $param_name_value = $map_scdmrid_paramnamevalue{$key};
            
            if ($map_paramnamevalue_scdmrid{$param_name_value} eq undef) {
                $map_paramnamevalue_scdmrid{$param_name_value} = $key;
            }
        }
        
        my $value = undef;
        my @values = values(%map_paramnamevalue_scdmrid);
        
        my $get_link_copy = undef;
        my $operation_copy = undef;
        my $caller_get_data = $cgi->generate_GET_Data("cdbr_set_num cdbr_set_num_dmisn link_name dmisn app_name current_blob_id scdmr_id dyna_mod_name dynamic_content_num");
        
        foreach $value (@values) {
            $scdmr_id = $value;
            
            $get_link_copy = "index.cgi?$caller_get_data&scdmr_id_copy=$scdmr_id&mode=dyna_ref&task=dyna_ref_param_copy";
            
            if ($scdmrid_paramnamevalue_current eq $map_scdmrid_paramnamevalue{$scdmr_id}) {
                $operation_copy = "Copy";
                
            } else {
                $operation_copy = "<a href=\"$get_link_copy\"><font color=\"#0099FF\">Copy</font></a>\n";
            }
            
            if ($scdmr_id ne "") {
                $param_name_value = "<table border=1 cellpadding=1 cellspacing=1>" . $map_scdmrid_paramnamevalue{$scdmr_id} . "</table>\n";
            
                $tld_param_selection->add_Row_Data($scdmr_id, $param_name_value, $operation_copy);
            }
        }
        
        my $tldhtml = new TLD_HTML_Map;
                    
        $tldhtml->set_Table_List_Data($tld_param_selection);
        $tldhtml->set_HTML_Code($te_content);
                    
        my $html_result = $tldhtml->get_HTML_Code;
        
        $this->add_Content($html_result);
    }

    #print "sql = $sql <br>";
}

1;
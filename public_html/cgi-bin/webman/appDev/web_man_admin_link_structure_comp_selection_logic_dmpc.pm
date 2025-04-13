package web_man_admin_link_structure_comp_selection_logic_dmpc; ### dmpc stand for dynamic module parameter copy

use CGI_Component;

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
    
    my $task = $cgi->param("task");
    my $submit = $cgi->param("submit");
    
    $this->{pre_table_name} = "webman_" . $cgi->param("app_name") . "_";
    
    my $dyna_mod_selector_id = $cgi->param("dyna_mod_selector_id");
    my $dyna_mod_selector_id_copy = $cgi->param("dyna_mod_selector_id_copy");
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn); ### option 1
        
    $dbu->set_Table($this->{pre_table_name} . "dyna_mod_selector");
    
    $this->{dyna_mod_name} = $dbu->get_Item("dyna_mod_name", "dyna_mod_selector_id", "$dyna_mod_selector_id");
    
    ############################################################################
    
    my $dyna_mod_name = $this->{dyna_mod_name};
    
    my $script_filename = $ENV{SCRIPT_FILENAME};
    my @array = split(/\//, $script_filename);

    my $app_dir = undef;

    for ($i = 0; $i < @array - 5; $i++) {
        $app_dir .= "$array[$i]/";
    }

    $app_dir .=  "webman/pm/apps/" . $cgi->param("app_name") . "/";
    
    $dyna_mod_name = $app_dir . $dyna_mod_name;
    
    print __FILE__ . ":" . __LINE__ . "<br />\n\$dyna_mod_name = $dyna_mod_name <br>";    
    
    my $web_man_admu = new web_man_admin_dyna_mod_utils;
    
    my @dyna_mod_param_list = $web_man_admu->get_Dyna_Mod_Param($dyna_mod_name);
    
    $this->{dyna_mod_param_list} = \@dyna_mod_param_list;
    
    ############################################################################    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_link_structure_comp_selection_logic_dmpc.html");
    
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
    
    my $dyna_mod_selector_id_current = $cgi->param("dyna_mod_selector_id");
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($this->{pre_table_name} . "dyna_mod_selector");
    
    my $dyna_mod_name = $dbu->get_Item("dyna_mod_name", "dyna_mod_selector_id", "$dyna_mod_selector_id_current");
    
    print __FILE__ . ":" . __LINE__ . "<br />\n\$dyna_mod_name = $dyna_mod_name<br />\n";
    
    my $item = undef;
    my @ahr = undef;
    
    ### first is try to get key by dyna_mod_selector_id ####################### 
    my $dyna_mod_selector_id_in = undef;
    
    $dbu->set_Table($this->{pre_table_name} . "dyna_mod_selector");
    
    @ahr = $dbu->get_Items("dyna_mod_selector_id", "dyna_mod_name", "$dyna_mod_name", undef, undef);
                              
    foreach $item (@ahr) {
        $dyna_mod_selector_id_in .= "'$item->{dyna_mod_selector_id}', ";
    }
    
    $dyna_mod_selector_id_in =~ s/, $//;
    
    #print "\$dyna_mod_selector_id_in = $dyna_mod_selector_id_in <br>";
    
    
    ### next is try to get key by link_ref_id #################################
    my $link_ref_id_in = undef;
    
    $dbu->set_Table($this->{pre_table_name} . "link_reference");
    
    @ahr = $dbu->get_Items("link_ref_id", "ref_name", "$dyna_mod_name", undef, undef);    
    
    foreach $item (@ahr) {
        $link_ref_id_in .= "'$item->{link_ref_id}', ";
    }
    
    $link_ref_id_in =~ s/, $//;
    
    #print "\$link_ref_id_in = $link_ref_id_in <br>";
    
    
    ### the last is try to get key by scdmr_id #################################
    ### ???
    
    
    my $sql = "select * from " . $this->{pre_table_name} . "dyna_mod_param " . 
              "where dyna_mod_selector_id in ($dyna_mod_selector_id_in) ";
              
    if ($link_ref_id_in ne "") {
        $sql .= "or link_ref_id in ($link_ref_id_in) ";
    }
    
    $sql .= "order by dyna_mod_selector_id, param_name";              

    print __FILE__ . ":" . __LINE__ . "<br />\n\$sql = $sql <br />\n";

    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL($sql);
    $dbihtml->set_HTML_Code($te_content);
    $dbihtml->set_Escape_HTML_Tag(1); ### 14/01/2011

    my $tld = $dbihtml->get_Table_List_Data;
    

    if ($dbihtml->get_Items_Num > 0) {
        my $i = 0;
        my @keys = undef;
        my @values = undef;
        my $key = undef;
        
        my $dyna_mod_selector_id = undef;
        my $link_ref_id = undef;
        
        my $param_name = undef;
        my $param_value = undef;
        my $param_name_value = undef;
        
        my %map_dmsid_paramnamevalue = undef;
        my %map_paramnamevalue_dmsid = undef;
        my $dmsid_paramnamevalue_current = undef;
        
        my %map_linkrefid_paramnamevalue = undef;
        my %map_paramnamevalue_linkrefid = undef;
        
        ########################################################################
        
        $tld->add_Column("param_name_seq"); ### so we can sort parameter name by its original
                                            ### sequence in dynamic module source file 

        my @dyna_mod_param_list = @{$this->{dyna_mod_param_list}};
        my %dyna_mod_param_name_num = undef;

        for ($i = 0; $i < @dyna_mod_param_list; $i++) {
            $dyna_mod_param_name_num{$dyna_mod_param_list[$i]} = $i;
        } 
        
        $i = 0;
         
        for ($i = 0; $i < $dbihtml->get_Items_Num; $i++) {
            $tld->set_Data($i, "param_name_seq", $dyna_mod_param_name_num{$tld->get_Data($i, "param_name")});
            #print $tld->get_Data($i, "param_name") . " = " . $tld->get_Data($i, "param_name_seq") . "<br>\n";
        }

        $tld->sort_Data("param_name_seq", "asc", "num");        
        
        ########################################################################
        
        my $tld_param_selection = new Table_List_Data;
        
        $tld_param_selection->add_Column("dyna_mod_selector_id");
        $tld_param_selection->add_Column("param_name_value");
        $tld_param_selection->add_Column("operation");
        
        $i = 0;
        
        for ($i = 0; $i < $dbihtml->get_Items_Num; $i++) {
            if ($tld->get_Data($i, "dyna_mod_selector_id") > 0) {
                $dyna_mod_selector_id = $tld->get_Data($i, "dyna_mod_selector_id");
               
                $param_name = $tld->get_Data($i, "param_name");
                $param_value = $tld->get_Data($i, "param_value");

                $map_dmsid_paramnamevalue{$dyna_mod_selector_id} .= "<tr><td><font size=2>$param_name</font></td><td><font size=2>$param_value</font></td></tr>\n";

                if ($dyna_mod_selector_id == $dyna_mod_selector_id_current) {
                    $dmsid_paramnamevalue_current = $map_dmsid_paramnamevalue{$dyna_mod_selector_id};
                }
                
                #print "\$dyna_mod_selector_id = $dyna_mod_selector_id <br>\n";
            
            } elsif ($tld->get_Data($i, "link_ref_id") > 0) {
                $link_ref_id = $tld->get_Data($i, "link_ref_id");
                
                $param_name = $tld->get_Data($i, "param_name");
                $param_value = $tld->get_Data($i, "param_value");
                
                $map_linkrefid_paramnamevalue{$link_ref_id} .=  "<tr><td><font size=2>$param_name</font></td><td><font size=2>$param_value</font></td></tr>\n";
                
                #print "\$link_ref_id = $link_ref_id <br>\n";
            }
        }
        
        @keys = keys(%map_dmsid_paramnamevalue);
        
        foreach $key (@keys) {
            $param_name_value = $map_dmsid_paramnamevalue{$key};
            
            if ($map_paramnamevalue_dmsid{$param_name_value} eq undef) {
                $map_paramnamevalue_dmsid{$param_name_value} = $key;
            }
        }
        
        @keys = keys(%map_linkrefid_paramnamevalue);
        
        foreach $key (@keys) {
            $param_name_value = $map_linkrefid_paramnamevalue{$key};
            
            if ($map_paramnamevalue_linkrefid{$param_name_value} eq undef) {
                $map_paramnamevalue_linkrefid{$param_name_value} = $key;
            }
        }              
        
        my $get_link_copy = undef;
        my $operation_copy = undef;
        my $caller_get_data = $cgi->generate_GET_Data("link_name dmisn app_name link_struct_id child_link_id dyna_mod_selector_id \$ref_name \$dynamic_content_num task link_ref_id dyna_mod_selector_id");
        
        my $value = undef;
        my @values = undef;
        
        @values = values(%map_paramnamevalue_dmsid);
        
        foreach $value (@values) {
            $dyna_mod_selector_id = $value;
            
            $get_link_copy ="index.cgi?$caller_get_data&task_type=copy_param_phase2&dyna_mod_selector_id_copy=$dyna_mod_selector_id";
            
            if ($dmsid_paramnamevalue_current eq $map_dmsid_paramnamevalue{$dyna_mod_selector_id}) {
                $operation_copy = "Copy";
                
            } else {
                $operation_copy = "<a href=\"$get_link_copy\"><font color=\"#0099FF\">Copy</font></a>\n";
            }
            
            if ($dyna_mod_selector_id ne "") {
                $param_name_value = "<table border=1 cellpadding=1 cellspacing=1>" . $map_dmsid_paramnamevalue{$dyna_mod_selector_id} . "</table>\n";
                $tld_param_selection->add_Row_Data($dyna_mod_selector_id, $param_name_value, $operation_copy);
            }
        }
        
        @values = values(%map_paramnamevalue_linkrefid);
        
        foreach $value (@values) {
            $link_ref_id = $value;
            
            $get_link_copy ="index.cgi?$caller_get_data&task_type=copy_param_phase2&link_ref_id_copy=$link_ref_id";
            
            $operation_copy = "<a href=\"$get_link_copy\"><font color=\"#0099FF\">Copy</font></a>\n";
            
            if ($link_ref_id ne "") {
                $param_name_value = "<table border=1 cellpadding=1 cellspacing=1>" . $map_linkrefid_paramnamevalue{$link_ref_id} . "</table>\n";
                $tld_param_selection->add_Row_Data($link_ref_id, $param_name_value, $operation_copy);
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
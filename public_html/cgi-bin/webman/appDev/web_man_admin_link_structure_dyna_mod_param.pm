package web_man_admin_link_structure_dyna_mod_param;

use CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_link_structure;
use web_man_admin_dyna_mod_utils;

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
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
    my $link_ref_id = $cgi->param("link_ref_id");
    
    ###########################################################################
    
    my $dyna_mod_name = $cgi->param("\$ref_name");
    
    my $script_filename = $ENV{SCRIPT_FILENAME};
    my @array = split(/\//, $script_filename);
    
    #print "\$script_filename = $script_filename <br>";

    #my $app_dir = "../" . $cgi->param("app_name") . "/";

    for ($i = 0; $i < @array - 5; $i++) {
        $app_dir .= "$array[$i]/";
    }

    $app_dir .=  "webman/pm/apps/" . $cgi->param("app_name") . "/";
    
    #print "\$app_dir = $app_dir<br />\n";
    #print "\$dyna_mod_name = $dyna_mod_name <br />\n";
    
    
    $this->{dyna_mod_name} = $dyna_mod_name;
    
    my $web_man_admu = new web_man_admin_dyna_mod_utils;
    
    $web_man_admu->set_Dynamic_Module_Folder($app_dir);
    
    my @dyna_mod_param_list = $web_man_admu->get_Dyna_Mod_Param($dyna_mod_name);
    
    $this->{dyna_mod_param_list} = \@dyna_mod_param_list;    
    
    ############################################################################
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    if ($task eq "update_dyna_mod_phase2" && $submit eq "Set" && $link_ref_id ne "" && 
        $cgi->param("\$db_param_name") ne "" && $cgi->param("\$db_param_value") ne "") {
        #print "Try to set dyna_mod DB parameter<br>";
        
        my $param_name = $cgi->param("\$db_param_name");
        
        my $dbu = new DB_Utilities;
        
        $dbu->set_DBI_Conn($db_conn); ### option 1
        $dbu->set_Table($pre_table_name . "dyna_mod_param");
        
        $dbu->delete_Item("link_ref_id param_name", "$link_ref_id $param_name"); 
        
        my $htmldb = new HTML_DB_Map;
        
        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        $htmldb->set_Table($pre_table_name . "dyna_mod_param");
        
        if (!$cgi->set_Param_Val("\$db_scdmr_id", -1)) { $cgi->add_Param("\$db_scdmr_id", -1); }
        if (!$cgi->set_Param_Val("\$db_dyna_mod_selector_id", -1)) { $cgi->add_Param("\$db_dyna_mod_selector_id", -1); }
        
        $htmldb->insert_Table; ### method 1
        
        #print "SQL = " . $htmldb->get_SQL;
    }
    
    if ($task eq "update_dyna_mod_phase2" && $submit ne "Set" && $link_ref_id ne "") {
        #print "Try to unset dyna_mod DB parameter: $link_ref_id - $param_name<br>";
        
        my $param_name = $cgi->param("param_name");
        
        my $dbu = new DB_Utilities;
        
        $dbu->set_DBI_Conn($db_conn); ### option 1
        $dbu->set_Table($pre_table_name . "dyna_mod_param");
        
        $dbu->delete_Item("link_ref_id param_name", "$link_ref_id $param_name"); 
    }
    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_link_structure_dyna_mod_param.html");
    
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

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $hpd = $this->generate_Hidden_POST_Data("link_name dmisn app_name link_struct_id child_link_id link_ref_id \$ref_name \$ref_type \$dynamic_content_num");
    
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
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name link_struct_id child_link_id link_ref_id \$ref_name \$ref_type \$dynamic_content_num");
    
    my $link_ref_id = $cgi->param("link_ref_id");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL("select * from $pre_table_name" . "dyna_mod_param where link_ref_id='$link_ref_id'");
    
    my $tld = $dbihtml->get_Table_List_Data;
    
    my $db_items_num = $dbihtml->get_Items_Num;
    
    if ($db_items_num > 0) {
        my $i = 0;
        my $get_link = undef;
        my $column_data = "<font color=\"#0099FF\">Unset</font>";
        
        $tld->add_Column("operation");
        $tld->add_Column("param_name_seq"); ### so we can sort parameter name by its original
                                            ### sequence in dynamic module source file         

        my @dyna_mod_param_list = @{$this->{dyna_mod_param_list}};
        my %dyna_mod_param_name_num = undef;
        
        for ($i = 0; $i < @dyna_mod_param_list; $i++) {
            $dyna_mod_param_name_num{$dyna_mod_param_list[$i]} = $i;
        }
        
        for ($i = 0; $i < $db_items_num; $i++) {
            my $param_name = $tld->get_Data($i, "param_name");
            my $param_value = $tld->get_Data($i, "param_name");
            
            $get_link = "index.cgi?$caller_get_data&task=update_dyna_mod_phase2&param_name=$param_name";
            
            $tld->set_Data($i, "operation", $column_data);
            $tld->set_Data_Get_Link($i, "operation", $get_link, "");
            $tld->set_Data($i, "param_name_seq", $dyna_mod_param_name_num{$param_name});
            
            #$param_value =~ s/\n/__br__/; 
            
            #$tld->set_Data($i, "param_value", $param_value);
        }
        
        $tld->sort_Data("param_name_seq", "asc", "num");
        
        my $tldhtml = new TLD_HTML_Map;
                    
        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content);
        $tldhtml->set_Special_Tag_View(1, [param_value]); ### 14/12/2010
                    
        my $html_result = $tldhtml->get_HTML_Code;
                    
        $this->add_Content($html_result);
        
    } else {
        #$this->add_Content($te_content);
    }
}

sub process_SELECT { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $s_opt = new Select_Option;
        
    $s_opt->set_Values(@{$this->{dyna_mod_param_list}});
        
    $this->add_Content($s_opt->get_Selection);
}

1;
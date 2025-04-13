package web_man_admin_dynamic_module_update_global;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_link_structure;
use web_man_admin_dyna_mod_utils;

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{webman_dyna_mod_files} = undef;
    
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
    
    my $submit = $cgi->param("submit");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    if ($submit eq "Set") {
        my $dyna_mod_name = $cgi->param("dyna_mod_name");
        
        $cgi->set_Param_Val("\$db_dyna_mod_name", $dyna_mod_name);
        
        my $dynamic_content_num = $cgi->param("\$db_dynamic_content_num");
        my $dynamic_content_name = $cgi->param("\$db_dynamic_content_name"); ### 15/01/2009
        my $param_name = $cgi->param("\$db_param_name");
        
        if ($dynamic_content_name ne "") { ### 15/01/2009
            $dynamic_content_num = -2;
            $cgi->set_Param_Val("\$db_dynamic_content_num", "-2");
        }
        
        if ($cgi->param("\$db_param_value") ne "") {
            #print "Try to set module global DB parameter <br>";
            
            my $dbu = new DB_Utilities;
                                
            $dbu->set_DBI_Conn($db_conn); ### option 1
            $dbu->set_Table($pre_table_name . "dyna_mod_param_global");
            
            if ($dynamic_content_name ne "") { ### 16/01/2009
                $dbu->delete_Item("dyna_mod_name dynamic_content_name param_name", 
                                  "$dyna_mod_name $dynamic_content_name $param_name");
                                  
            } else {
                $dbu->delete_Item("dyna_mod_name dynamic_content_num param_name", 
                                  "$dyna_mod_name $dynamic_content_num $param_name");
            }
            
            my $htmldb = new HTML_DB_Map;
            
            $htmldb->set_CGI($cgi);
            $htmldb->set_DBI_Conn($db_conn);
            $htmldb->set_Table($pre_table_name . "dyna_mod_param_global");
            
            $htmldb->insert_Table;
            
            print "SQL = " . $htmldb->get_SQL;
        }
        
    } elsif ($submit eq "Unset") {
        #print "Try to unset module global DB parameter <br>";
        
        my $dbu = new DB_Utilities;
                    
        $dbu->set_DBI_Conn($db_conn); ### option 1
        $dbu->set_Table($pre_table_name . "dyna_mod_param_global");
        
        $dbu->delete_Item("dmpg_id", $cgi->param("dmpg_id"));
    }
    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $dyna_mod_name = $cgi->param("dyna_mod_name");
    
    if ($dyna_mod_name eq "") {
        $this->set_Template_File("./template_admin_dynamic_module_update_global.html");
        
    } else {
        $this->set_Template_File("./template_admin_dynamic_module_update_global2.html");
    }
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
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name link_name_dyna_mod dmisn_dyna_mod");
    
    my $dyna_mod_name = $cgi->param("dyna_mod_name");
    
    
    $te_content =~ s/\$dyna_mod_name_/$dyna_mod_name/;
    $te_content =~ s/\$caller_get_data_/$caller_get_data/;
    
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
    
    my $hpd = $this->generate_Hidden_POST_Data("link_name dmisn app_name link_name_dyna_mod dmisn_dyna_mod dyna_mod_name");
    
    $this->add_Content($hpd);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name link_name_dyna_mod dmisn_dyna_mod");
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $dyna_mod_name = $cgi->param("dyna_mod_name");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $dbihtml = new DBI_HTML_Map;
    
    $dbihtml->set_DBI_Conn($db_conn);
    
    if ($dyna_mod_name eq "") {
        $dbihtml->set_SQL("select * from $pre_table_name" . "dyna_mod order by dyna_mod_name");
        
        $cgi->add_Debug_Text($dbihtml->get_SQL, __FILE__, __LINE__);
    
    } else {
        $dbihtml->set_SQL("select * from $pre_table_name" . "dyna_mod_param_global 
                           where dyna_mod_name='$dyna_mod_name' 
                           order by dynamic_content_num, dynamic_content_name, param_name");
    }
    
    $dbihtml->set_HTML_Code($te_content);
    
    my $tld = $dbihtml->get_Table_List_Data;
        
    my $db_items_num = $dbihtml->get_Items_Num;
    
    if ($db_items_num ne "" && $dyna_mod_name eq "") {
        my $dbu = new DB_Utilities;
            
        $dbu->set_DBI_Conn($db_conn); ### option 1
        $dbu->set_Table($pre_table_name . "dyna_mod_param_global");
        
        $tld->add_Column("param_num");
        
        my $i = 0;
        
        for ($i = 0; $i < $db_items_num; $i++) {
            $dyna_mod_name = $tld->get_Data($i, "dyna_mod_name");
            
            $tld->set_Data($i, "param_num", $dbu->count_Item("dyna_mod_name", $dyna_mod_name));
            
            $tld->set_Data($i, "dyna_mod_name", "<font color=\"#0099FF\">" . $dyna_mod_name . "</font>");
            $tld->set_Data_Get_Link($i, "dyna_mod_name", "index.cgi?$caller_get_data&dyna_mod_name=$dyna_mod_name");
        }
        
        $dyna_mod_name = "";
        
        my $tldhtml = new TLD_HTML_Map;

        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content);

        my $html_result = $tldhtml->get_HTML_Code;

        $this->add_Content($html_result);
    }
    
    if ($db_items_num > 0 && $dyna_mod_name ne "") {
        $tld->add_Column("operation");
                
        my $i = 0;
                
        for ($i = 0; $i < $db_items_num; $i++) {
            $tld->set_Data($i, "operation", "<font color=\"#0099FF\">Unset</font>");
            $tld->set_Data_Get_Link($i, "operation", 
                                    "index.cgi?$caller_get_data&dyna_mod_name=$dyna_mod_name&submit=Unset&dmpg_id=" . 
                                    $tld->get_Data($i, "dmpg_id"));
        }
        
        my $tldhtml = new TLD_HTML_Map;

        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content);

        my $html_result = $tldhtml->get_HTML_Code;

        $this->add_Content($html_result);
    }
    
    
}

sub process_SELECT { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_type_num = $te->get_Type_Num;
    
    my $dyna_mod_name = $cgi->param("dyna_mod_name");
    
    my $script_filename = $ENV{SCRIPT_FILENAME};
    my @array = split(/\//, $script_filename);

    my $app_dir = undef;

    for ($i = 0; $i < @array - 5; $i++) {
        $app_dir .= "$array[$i]/";
    }

    $app_dir .=  "webman/pm/apps/" . $cgi->param("app_name");
    
    my $s_opt = new Select_Option;
    
    if ($te_type_num == 0) {
        if ($dyna_mod_name eq "webman_main") {
            $s_opt->set_Values("-1");
            
        } else {
            $s_opt->set_Values("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10");
        }
        
    } else {
        my $web_man_admu = new web_man_admin_dyna_mod_utils;
        
        $web_man_admu->set_Dynamic_Module_Folder($app_dir . "/");
        
        $s_opt->set_Values($web_man_admu->get_Dyna_Mod_Param($dyna_mod_name));
    }
    
    $this->add_Content($s_opt->get_Selection);

}

1;
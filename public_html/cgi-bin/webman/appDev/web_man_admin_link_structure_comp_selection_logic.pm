package web_man_admin_link_structure_comp_selection_logic;

use CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_link_structure;
use web_man_admin_dyna_mod_utils;
use web_man_admin_link_structure_comp_selection_logic_dmps;
use web_man_admin_link_structure_comp_selection_logic_dmpc;

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
    
    my $task_type = $cgi->param("task_type");
    my $task_mode = $cgi->param("task_mode");
    
    my $link_ref_id = $cgi->param("link_ref_id");
    my $dyna_mod_selector_id = $cgi->param("dyna_mod_selector_id");
    my $parent_id = $cgi->param("parent_id");
    
    print "\$task_type = $task_type and \$link_ref_id = $link_ref_id <br>\n";
    
    my $cgi_param = $cgi->param("cgi_param");
    my $cgi_value = $cgi->param("cgi_value");
    my $dyna_mod_name = $cgi->param("dyna_mod_name");
    
    while ($cgi_param =~ / /) {
        $cgi_param =~ s/ //;
    }
    
    $cgi_value =~ s/ /\\\\ /;
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    
    if ($task_type eq "add_logic") {
        
        if ($task_mode eq "") {
            $dbu->set_Table($pre_table_name . "dyna_mod_selector");

            if ($cgi_param ne "" && 
                !$dbu->find_Item("link_ref_id cgi_param cgi_value", "$link_ref_id $cgi_param $cgi_value")) {

                print "Try to add logic - \$link_ref_id = $link_ref_id<br>\n";

                $dbu->insert_Row("link_ref_id cgi_param cgi_value dyna_mod_name", 
                                 "$link_ref_id $cgi_param $cgi_value $dyna_mod_name");
                                 
                print "SQL = " . $dbu->get_SQL;
            }
            
        } elsif ($task_mode eq "recursive_csl") { ### add logic for recursive_csl.
                                                  ### csl stand for component selection logic 
            
            print "Add logic for recursive_csl <br>\n";
            
            $dbu->set_Table($pre_table_name . "dyna_mod_selector");
            
                $dbu->insert_Row("link_ref_id cgi_param cgi_value dyna_mod_name parent_id", 
                                 "$link_ref_id $cgi_param $cgi_value $dyna_mod_name $parent_id");           
        }
        
    } elsif ($task_type eq "set_param") {
        print "Try to set param (done by web_man_admin_link_structure_comp_selection_logic_dmps module) <br>\n";
        
    
    } elsif ($task_type eq "copy_param_phase2") {
        my $dyna_mod_selector_id = $cgi->param("dyna_mod_selector_id");
        
        my $dyna_mod_selector_id_copy = $cgi->param("dyna_mod_selector_id_copy");
        my $link_ref_id_copy = $cgi->param("link_ref_id_copy");
        
        my @ahr = undef;
        
        if ($dyna_mod_selector_id_copy ne "") {
            print "Try to copy param from dyna_mod_selector_id: $dyna_mod_selector_id_copy to $dyna_mod_selector_id<br>\n";
        
            $dbu->set_Table($pre_table_name . "dyna_mod_param");
                
            @ahr = $dbu->get_Items("param_name param_value", 
                                   "dyna_mod_selector_id", "$dyna_mod_selector_id_copy", undef, undef);
                                   
        } elsif ($link_ref_id_copy ne "") {
            print "Try to copy param from link_ref_id: $link_ref_id_copy to $dyna_mod_selector_id<br>\n";
            
            $dbu->set_Table($pre_table_name . "dyna_mod_param");
            
            @ahr = $dbu->get_Items("param_name param_value", 
                                   "link_ref_id", "$link_ref_id_copy", undef, undef);            
        }
                                  
        #print $dbu->get_SQL, "<br>\n";
        
        $dbu->delete_Item("dyna_mod_selector_id", "$dyna_mod_selector_id");
        
        foreach $item (@ahr) {
            $param_name = $item->{param_name};
            $param_value = $item->{param_value};
            
            $param_value =~ s/ /\\ /g;
            
            #print "$dyna_mod_selector_id $param_name $param_value <br>\n";
            
            $dbu->insert_Row("link_ref_id scdmr_id dyna_mod_selector_id param_name param_value", "-1 -1 $dyna_mod_selector_id $param_name $param_value");
            
            #print $dbu->get_SQL . "<br>\n";
        }                                  
        
    } elsif ($task_type eq "delete") {
        my $dyna_mod_selector_id = $cgi->param("dyna_mod_selector_id");
        
        if ($dyna_mod_selector_id ne "") {
            print "Try to delete logic - \$dyna_mod_selector_id = $dyna_mod_selector_id<br>\n";
            
            $dbu->set_Table($pre_table_name . "dyna_mod_selector");
            $dbu->delete_Item("dyna_mod_selector_id", "$dyna_mod_selector_id");
            
            $dbu->set_Table($pre_table_name . "dyna_mod_param");
            $dbu->delete_Item("dyna_mod_selector_id", "$dyna_mod_selector_id");
        }
    }
    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_link_structure_comp_selection_logic.html");
    
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
    
    my $task_type = $cgi->param("task_type");
    my $task_mode = $cgi->param("task_mode");
    my $link_ref_id = $cgi->param("link_ref_id");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn);    
    
    if ($te_type_num == 0) {
        my $ref_name = $cgi->param("\$ref_name");
        
        if ($task_mode eq "recursive_csl") { ### csl stand for component selection logic
            my $parent_id = $cgi->param("parent_id");
            my @wmcs_path_id = ();
            
            push(@wmcs_path_id, $parent_id);
            
            $dbu->set_Table($pre_table_name . "dyna_mod_selector");
            $parent_id = $dbu->get_Item("parent_id", "dyna_mod_selector_id", $parent_id);
            
            while ($parent_id) {
                push(@wmcs_path_id, $parent_id);
                $parent_id = $dbu->get_Item("parent_id", "dyna_mod_selector_id", $parent_id);
            }
            
            push(@wmcs_path_id, -1);
            
            my $caller_get_data = $cgi->generate_GET_Data("link_name dmisn app_name link_struct_id child_link_id task link_ref_id \$ref_name \$dynamic_content_num");
            
            for (my $i = @wmcs_path_id - 1; $i > 0; $i--) {
                if ($wmcs_path_id[$i] != -1) {                
                    $this->add_Content("<a href=\"index.cgi?$caller_get_data&&task_mode=recursive_csl&parent_id=$wmcs_path_id[$i]\" style=\"text-decoration: none; color: #0099FF;\">???</a>  &gt; ");
                    
                } else {
                    $this->add_Content("<a href=\"index.cgi?$caller_get_data\" style=\"text-decoration: none; color: #0099FF;\">???</a>  &gt; ");
                }
            }
            
            $this->add_Content("$ref_name &gt; Selection Logic");
            
        } else {
            $this->add_Content("$ref_name &gt; Selection Logic");
        }
        
    } elsif ($te_type_num == 1) {
        my $hpd = $this->generate_Hidden_POST_Data("link_name dmisn app_name link_struct_id child_link_id  link_ref_id \$ref_name \$dynamic_content_num task_mode parent_id");
        
        $this->add_Content($hpd);
        
    } elsif ($te_type_num == 2) {
        if ($task_type eq "set_param") {
            my $component = new web_man_admin_link_structure_comp_selection_logic_dmps; ### dmps stand for dynamic module parameter set
            
            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn); ### option 2
        
            $component->run_Task;
            $component->process_Content;
        
            my $content = $component->get_Content;
            
            $this->add_Content($content);
            
        } elsif ($task_type eq "copy_param") {
            my $component = new web_man_admin_link_structure_comp_selection_logic_dmpc; ### dmpc stand for dynamic module parameter copy
            
            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn); ### option 2
        
            $component->run_Task;
            $component->process_Content;
        
            my $content = $component->get_Content;
            
            $this->add_Content($content);        
        }
    }
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name link_struct_id child_link_id link_ref_id \$ref_name \$dynamic_content_num");
    
    my $task_type = $cgi->param("task_type");
    my $task_mode = $cgi->param("task_mode");    
    
    my $link_ref_id = $cgi->param("link_ref_id");
    my $dyna_mod_selector_id = $cgi->param("dyna_mod_selector_id");
    my $parent_id = $cgi->param("parent_id");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $script_ref = "index.cgi?$caller_get_data";
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    
    if ($task_mode eq "recursive_csl") {
        $dbihtml->set_SQL("select * from $pre_table_name" . "dyna_mod_selector where link_ref_id='$link_ref_id' and parent_id='$parent_id'");
        
    } else {
        $dbihtml->set_SQL("select * from $pre_table_name" . "dyna_mod_selector where link_ref_id='$link_ref_id' and parent_id is null");
    }
    
    my $tld = $dbihtml->get_Table_List_Data;
    
    my $db_items_num = $dbihtml->get_Items_Num;
    
    if ($db_items_num > 0) {
        my $dbu = new DB_Utilities;
                
        $dbu->set_DBI_Conn($db_conn); 
        
        my $i = 0;
        my $get_link = undef;
        my $column_data = "<font color=\"#0099FF\">Unset</font>";
        
        $tld->add_Column("operation");
        
        my $i = 0;
        my $operations = undef;
        
        my $get_link_set_param = undef;
        my $operation_set_param = "Set Param";
        my $current_set_param_num = 0;
        
        my $get_link_copy_param = undef;
        my $operation_copy_param = "Copy Param";
        
        my $get_link_delete = undef;
        my $operation_delete = "<font color=\"#0099FF\">Delete</font>";
        
        my $param_name = undef; 
        
        for ($i = 0; $i < $db_items_num; $i++) {
            $cgi_param = $tld->get_Data($i, "cgi_param");
            $cgi_value = $tld->get_Data($i, "cgi_value");
            
            if ($cgi_value eq "") {
                $tld->set_Data($i, "cgi_value", "&nbsp");
            }
            
            my $dyna_mod_name = $tld->get_Data($i, "dyna_mod_name");
            
            if ($dyna_mod_name eq "webman_component_selector") {
                ### update_ref_phase2_csl: csl stand for component selection logic

                my $get_link = "$script_ref&task=update_ref_phase2_csl&task_mode=recursive_csl&parent_id=" . $tld->get_Data($i, "dyna_mod_selector_id");

                $tld->set_Data_Get_Link($i, "dyna_mod_name", $get_link, "");

                $dyna_mod_name = "<font color=\"#0099FF\">" . $dyna_mod_name . "</font>";
                $tld->set_Data($i, "dyna_mod_name", $dyna_mod_name); 
            }
            
            $operations = "";
            $get_link_set_param  = "$script_ref&task=update_ref_phase2_csl&task_type=set_param&dyna_mod_selector_id=" . $tld->get_Data($i, "dyna_mod_selector_id");                   
            $get_link_copy_param = "$script_ref&task=update_ref_phase2_csl&task_type=copy_param&dyna_mod_selector_id=" . $tld->get_Data($i, "dyna_mod_selector_id");
            
            if ($task_mode eq "recursive_csl") {
                $get_link_set_param  .= "&task_mode=$task_mode&parent_id=$parent_id";
                $get_link_copy_param .= "&task_mode=$task_mode&parent_id=$parent_id";
            }
            
            $dbu->set_Table($pre_table_name . "dyna_mod_param");
            $current_set_param_num = $dbu->count_Item("dyna_mod_selector_id", $tld->get_Data($i, "dyna_mod_selector_id"), undef);
            
            if ($current_set_param_num < 10) {
                $current_set_param_num = "0" . $current_set_param_num;
            }
            
            ########################################################################
            
            #print "$task_type -- $dyna_mod_selector_id == " . $tld->get_Data($i, "dyna_mod_selector_id") . "<br>\n";
            
            if ($task_type eq "set_param" && $dyna_mod_selector_id == $tld->get_Data($i, "dyna_mod_selector_id")) {
                $operations .= "$operation_set_param [$current_set_param_num] | ";
                
            } else {
                $operations .= "<a href=\"$get_link_set_param\"><font color=\"#0099FF\">$operation_set_param</font></a> <font color=\"#0099FF\">[$current_set_param_num]</font> | ";
            }
            
            ########################################################################
            
            if ($task_type eq "copy_param" && $dyna_mod_selector_id == $tld->get_Data($i, "dyna_mod_selector_id")) {
                $operations .= "$operation_copy_param | ";
                
            } else {
                $operations .= "<a href=\"$get_link_copy_param\"><font color=\"#0099FF\">$operation_copy_param</a></font> | ";
            }
            
            ########################################################################
            
            $get_link_delete = "$script_ref&task=update_ref_phase2_csl&task_type=delete&dyna_mod_selector_id=" . $tld->get_Data($i, "dyna_mod_selector_id");
            
            if ($task_mode eq "recursive_csl") {
                $get_link_delete  .= "&task_mode=$task_mode&parent_id=$parent_id";
            }            
            
            $operations .= "<a href=\"$get_link_delete\">$operation_delete</a>";
            
            ########################################################################
            
            $tld->set_Data($i, "operation", $operations);  
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
    
    my $s_opt = new Select_Option;
    
    my $i = 0;
    
    my $script_filename = $ENV{SCRIPT_FILENAME};
    my @array = split(/\//, $script_filename);

    my $app_dir = undef;

    for ($i = 0; $i < @array - 5; $i++) {
        $app_dir .= "$array[$i]/";
    }

    $app_dir .=  "webman/pm/apps/" . $cgi->param("app_name");
    
    #print "\$app_dir = $app_dir<br />\n";

    my $web_man_admu = new web_man_admin_dyna_mod_utils;

    $web_man_admu->set_DBI_Conn($db_conn);

    my @webman_dyna_mod_app = $web_man_admu->get_Valid_Webman_CGI_Component($app_dir);
    my @webman_dyna_mod_std = $web_man_admu->get_Valid_Webman_CGI_Component("../../../../webman/pm/comp");

    my @webman_dyna_mod_app_filtered = undef;
    my $counter = 0;

    for ($i = 0; $i < @webman_dyna_mod_app; $i++) {
        if ($webman_dyna_mod_app[$i] ne $cgi->param("app_name")) {
            $webman_dyna_mod_filtered[$counter] = $webman_dyna_mod_app[$i];
            $counter++;
        }
    }
    
    for (my $i = 0; $i < @webman_dyna_mod_std; $i++) {
        if ($webman_dyna_mod_std[$i] ne "webman_main" && 
            $webman_dyna_mod_std[$i] ne "webman_init" &&
            $webman_dyna_mod_std[$i] ne "webman_component_init") {

            $webman_dyna_mod_filtered[$counter] = $webman_dyna_mod_std[$i];
            $counter++;
        }
    }    

    $s_opt->set_Values(@webman_dyna_mod_filtered);
    
    $this->add_Content($s_opt->get_Selection);
}

1;
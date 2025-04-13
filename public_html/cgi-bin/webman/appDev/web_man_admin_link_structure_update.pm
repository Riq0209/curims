package web_man_admin_link_structure_update;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_link_structure;

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
    my $child_link_id = $cgi->param("child_link_id");
    my $submit = $cgi->param("submit");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    if ($task eq "update_phase2" && $submit ne "Cancel") {
        my $htmldb = new HTML_DB_Map;
        
        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        $htmldb->set_Table($pre_table_name . "link_structure");
        
        $htmldb->update_Table("link_id", "$child_link_id");
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $task = $cgi->param("task");
    
    if ($task eq "update_phase1") {
    
        $this->set_Template_File("./template_admin_link_structure_update.html");
    
        $this->SUPER::process_Content;
    
    } else {
        my $component = new web_man_admin_link_structure;
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2
                
        $component->run_Task;
        $component->process_Content;
                
        my $content = $component->get_Content;
        
        $this->add_Content($content);
    }
}

sub process_VIEW { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name");
    my $caller_get_data2 = $this->generate_GET_Data("app_name");
    
    my $link_struct_id = $cgi->param("link_struct_id");
    my $child_link_id = $cgi->param("child_link_id");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my @link_path = undef;
    my $link_path_info = undef;
    
    $te_content =~ s/Root/<a href="index.cgi?$caller_get_data"><font color="#0099FF">Root<\/font><\/a>/;
    
    if ($link_struct_id == 0) {
        $te_content =~ s/LINK_PATH_//;
        
    } else {
        my $web_man_als = new web_man_admin_link_structure;

        $web_man_als->set_CGI($cgi);
        $web_man_als->set_DBI_Conn($db_conn);
        
        @link_path = $web_man_als->get_Link_Path($child_link_id);
        $link_path_info = $web_man_als->generate_Link_Path_Info("index.cgi", "$caller_get_data2", @link_path);
        
        $te_content =~ s/LINK_PATH_/$link_path_info/;
    }
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($pre_table_name . "link_structure");

    my $link_struct_name = $dbu->get_Item("name", "link_id", "$child_link_id");
    
    $te_content =~ s/db_name_/$link_struct_name/;
    
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
    
    my $hpd = $this->generate_Hidden_POST_Data("link_name dmisn app_name link_struct_id child_link_id");
    
    $this->add_Content($hpd);
}

sub process_SELECT { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $child_link_id = $cgi->param("child_link_id");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($pre_table_name . "link_structure");

    my $auto_selected = undef;
    
    my $s_opt = new Select_Option;
    
    if ($te_type_num == 0) {
        $auto_selected = $dbu->get_Item("auto_selected", "link_id", "$child_link_id");
        $s_opt->set_Values("NO", "YES");
    } else {
        $auto_selected = $dbu->get_Item("target_window", "link_id", "$child_link_id");
        $s_opt->set_Values("", "_blank", "_parent", "_self", "_top");
    }
    
    $s_opt->set_Selected($auto_selected);

    my $content = $s_opt->get_Selection;
    
    $this->add_Content($content);
}


1;
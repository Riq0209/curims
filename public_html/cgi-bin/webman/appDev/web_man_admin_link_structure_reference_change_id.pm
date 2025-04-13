package web_man_admin_link_structure_reference_change_id;

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
    
    $this->set_Template_File("./template_admin_link_structure_reference_change_id.html");
    
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
    
    if ($te_type_num == 0) {
        my $hpd = $this->generate_Hidden_POST_Data("link_name dmisn app_name link_struct_id child_link_id link_ref_id");
    
        $this->add_Content($hpd);
        
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
    
    $s_opt->set_Values("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10");
    $s_opt->set_Selected($cgi->param("\$dynamic_content_num"));
    
    $this->add_Content($s_opt->get_Selection);
}

1;
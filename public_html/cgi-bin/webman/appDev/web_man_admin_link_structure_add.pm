package web_man_admin_link_structure_add;

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
    my $submit = $cgi->param("submit");
    
    my $table_name = "webman_" . $cgi->param("app_name") . "_link_structure";
    
    if ($task eq "add_phase2" && $submit ne "Cancel") {
        #print "\$table_name = $table_name <br>";
        
        my $htmldb = new HTML_DB_Map;
        
        $htmldb->set_CGI($cgi);
        $htmldb->set_DBI_Conn($db_conn);
        $htmldb->set_Table($table_name);
        
        $htmldb->insert_Table; ### method 1
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $task = $cgi->param("task");
    
    if ($task eq "add_phase1") {
    
        $this->set_Template_File("./template_admin_link_structure_add.html");
    
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
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name app_dir");
    
    my $link_struct_id = $cgi->param("link_struct_id");
    
    my @link_path = undef;
    my $link_path_info = undef;
    
    $te_content =~ s/Root/<a href="index.cgi?$caller_get_data"><font color="#0099FF">Root<\/font><\/a>/;
    
    if ($link_struct_id == 0) {
        $te_content =~ s/LINK_PATH_//;
        
    } else {
        my $web_man_als = new web_man_admin_link_structure;

        $web_man_als->set_CGI($cgi);
        $web_man_als->set_DBI_Conn($db_conn);
        
        @link_path = $web_man_als->get_Link_Path;
        $link_path_info = $web_man_als->generate_Link_Path_Info("index.cgi", "", @link_path);
        
        $te_content =~ s/LINK_PATH_/$link_path_info/;
    }
    
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
    
    my $hpd = $this->generate_Hidden_POST_Data("link_name dmisn app_name app_dir link_struct_id \$db_parent_id \$db_sequence");
    
    $this->add_Content($hpd);
}

1;
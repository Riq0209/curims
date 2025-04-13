package web_man_admin_multi_language_link;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_multi_language_link_view;
use web_man_admin_multi_language_link_set;

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{activate_last_path} = undef;
    
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
    
    my $task = $cgi->param("task");
    my $submit = $cgi->param("submit");
    my $link_name_translate = $cgi->param("\$db_link_name_translate");
    my $link_id = $cgi->param("link_id");
    my $lang_id = $cgi->param("lang_id");
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $htmldb = new HTML_DB_Map;

    $htmldb->set_CGI($cgi);
    $htmldb->set_DBI_Conn($db_conn);
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn);   ### option 1
    
    if ($submit eq "Set" && $task eq "set_phase2" && $link_name_translate ne "") {
        #print "Try to set link translation: link_id=$link_id - lang_id=$lang_id<br>";
        
        $cgi->set_Param_Val("\$db_link_lang_id", $link_id . $lang_id);
        $cgi->set_Param_Val("\$db_link_id", $link_id);
        $cgi->set_Param_Val("\$db_lang_id", $lang_id);
        
        $dbu->set_Table($pre_table_name . "dictionary_link");
        $dbu->delete_Item("link_id lang_id", "$link_id $lang_id");
        
        $htmldb->set_Table($pre_table_name . "dictionary_link");
        
        $htmldb->insert_Table; ### method 1
        
    } elsif ($submit eq "Unset") {
        $dbu->set_Table($pre_table_name . "dictionary_link");
        $dbu->delete_Item("link_id lang_id", "$link_id $lang_id");  
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_multi_language_link.html");
    
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
    
    $this->add_Content($te_content);
}

sub process_MENU { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn link_name_multi_lang dmisn_multi_lang app_name app_dir task link_id");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    my $link_name_selected_lang = $cgi->param("link_name_selected_lang");
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);   ### option 1
    $dbu->set_Table($pre_table_name . "dictionary_language");
    
    my @array_hash_ref = $dbu->get_Items("lang_id language");

    my @menu_items = undef;
    my @menu_links = undef;
    
    my $i = 0;
    
    for ($i = 0; $i < @array_hash_ref; $i++) {
        $menu_items[$i] = $array_hash_ref[$i]->{"language"};
        $menu_links[$i] = "lang_id=" . $array_hash_ref[$i]->{"lang_id"};
    }
                  
    my $html_menu = new HTML_Link_Menu_Paginate;

    $html_menu->set_Menu_Template_Content($te_content);
    $html_menu->set_Menu_Items(@menu_items);
    $html_menu->set_Menu_Links(@menu_links);
    $html_menu->set_Auto_Menu_Links("index.cgi", "link_name_selected_lang", "dmisn_selected_lang");
    $html_menu->add_GET_Data_Links_Source($caller_get_data);
    $html_menu->set_Active_Menu_Item($link_name_selected_lang);
    
    $html_menu->set_Separator_Tag("|");
    $html_menu->set_Next_Tag(">");
    $html_menu->set_Previous_Tag("<");

    $te_content = $html_menu->get_Menu;
    
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
    
    my $task = $cgi->param("task");
    my $link_name_selected_lang = $cgi->param("link_name_selected_lang");
    
    my $component_name = undef;
    
    if ($link_name_selected_lang ne "") {
        if ($task eq "" || $task eq "set_phase2") {
            $component = new web_man_admin_multi_language_link_view;
        
            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn); ### option 2

            $component->run_Task;
            $component->process_Content;
        
            $te_content = $component->get_Content;
            
        } elsif($task eq "set_phase1") {
            $component = new web_man_admin_multi_language_link_set;
        
            $component->set_CGI($cgi);
            $component->set_DBI_Conn($db_conn); ### option 2

            $component->run_Task;
            $component->process_Content;
        
            $te_content = $component->get_Content;
        }
    }
    
    $this->add_Content($te_content);
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($te_content);
}

1;
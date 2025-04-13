package web_man_admin_multi_language;

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_multi_language_view;
use web_man_admin_multi_language_add;
use web_man_admin_multi_language_delete;
use web_man_admin_multi_language_update;

use web_man_admin_multi_language_link;

use web_man_admin_multi_language_dynamic_module;


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
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $htmldb = new HTML_DB_Map;

    $htmldb->set_CGI($cgi);
    $htmldb->set_DBI_Conn($db_conn);
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn);   ### option 1

    
    if ($submit eq "Submit" && $task eq "add_phase2") {
        #print "Try to add";
        
        $htmldb->set_Table($pre_table_name . "dictionary_language");
        
        $htmldb->insert_Table; ### method 1
    }
    
    if ($submit eq "Submit" && $task eq "delete_phase2") {
        #print "Try to delete";
        
        $dbu->set_Table($pre_table_name . "dictionary_language");
        
        $dbu->delete_Item("lang_id", $cgi->param("lang_id"));
    }
    
    if ($submit eq "Submit" && $task eq "update_phase2") {
        #print "Try to update";
        
        $htmldb->set_Table($pre_table_name . "dictionary_language");
        
        $htmldb->update_Table("lang_id", $cgi->param("lang_id")); ### method 1
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_multi_language.html");
    
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
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn");
    
    my $link_name_multi_lang = $cgi->param("link_name_multi_lang");

    my @menu_items = ("Language", "Link", "Template", "Blob Content", "Dynamic Module Content");
    my @menu_links = ("", "", "", "", "");
                  
    my $html_menu = new HTML_Link_Menu_Paginate;

    $html_menu->set_Menu_Template_Content($te_content);
    $html_menu->set_Items_View_Num(10);
    $html_menu->set_Menu_Items(@menu_items);
    $html_menu->set_Menu_Links(@menu_links);
    $html_menu->set_Auto_Menu_Links("index.cgi", "link_name_multi_lang", "dmisn_multi_lang");
    $html_menu->add_GET_Data_Links_Source($caller_get_data);
    $html_menu->set_Active_Menu_Item($link_name_multi_lang);
    
    my $caller_get_data = $cgi->generate_GET_Data("app_name app_dir");
    
    $html_menu->add_GET_Data_Links_Source($caller_get_data);

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
    my $link_name_multi_lang = $cgi->param("link_name_multi_lang");
    
    my $component = undef;
    
    if ($link_name_multi_lang eq "Language") {
        if ($task eq "" || $task eq "add_phase2" || $task eq "delete_phase2" || $task eq "update_phase2") {
            $component = new web_man_admin_multi_language_view;
            
        } elsif ($task eq "add_phase1") {
            $component = new web_man_admin_multi_language_add;
        
        } elsif ($task eq "delete_phase1") {
            $component = new web_man_admin_multi_language_delete;
                
            $te_content = $component->get_Content;
            
        } elsif ($task eq "update_phase1") {
            $component = new web_man_admin_multi_language_update;
        }
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2

        $component->run_Task;
        $component->process_Content;
        
        $te_content = $component->get_Content;
        
    } elsif ($link_name_multi_lang eq "Link") {
        $component = new web_man_admin_multi_language_link;
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2

        $component->run_Task;
        $component->process_Content;
        
        $te_content = $component->get_Content;
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
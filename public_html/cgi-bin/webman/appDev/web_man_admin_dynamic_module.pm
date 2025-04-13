package web_man_admin_dynamic_module;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_link_structure;
use web_man_admin_dynamic_module_scan;
use web_man_admin_dynamic_module_update_global;

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
    
    my $task = $cgi->param("task");
    my $submit = $cgi->param("submit");
    my $link_name_dyna_mod = $cgi->param("link_name_dyna_mod");
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_dynamic_module.html");
    
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
    
    my $link_name_dyna_mod = $cgi->param("link_name_dyna_mod");

    my @menu_items = ("Scan/Refresh Modules", "Update Global DB Parameter", "Update Local DB Parameter");
    my @menu_links = ("", "", "");
                  
    my $html_menu = new HTML_Link_Menu_Paginate;

    $html_menu->set_Menu_Template_Content($te_content);
    $html_menu->set_Items_View_Num(10);
    $html_menu->set_Items_Set_Num(1);
    
    $html_menu->set_Menu_Items(@menu_items);
    $html_menu->set_Menu_Links(@menu_links);
    $html_menu->set_Auto_Menu_Links("index.cgi", "link_name_dyna_mod", "dmisn_dyna_mod");
    $html_menu->add_GET_Data_Links_Source($caller_get_data);
    $html_menu->set_Active_Menu_Item($link_name_dyna_mod);
    
    $html_menu->set_Separator_Tag("");
    $html_menu->set_Next_Tag("");
    $html_menu->set_Previous_Tag("");
    
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
    
    my $link_name_dyna_mod = $cgi->param("link_name_dyna_mod");
    
    if ($link_name_dyna_mod eq "Scan/Refresh Modules") {
        $component = new web_man_admin_dynamic_module_scan;
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2

        $component->run_Task;
        $component->process_Content;
                
        $te_content = $component->get_Content;
    }
    
    if ($link_name_dyna_mod eq "Update Global DB Parameter") {
        $component = new web_man_admin_dynamic_module_update_global;
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2

        $component->run_Task;
        $component->process_Content;
                
        $te_content = $component->get_Content;
    }
    
    $this->add_Content($te_content);
}

1;
package web_man_admin_main;

use CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_link_tree;
use web_man_admin_link_structure;
use web_man_admin_link_structure_add;
use web_man_admin_link_structure_update;
use web_man_admin_link_structure_update_reference;
use web_man_admin_link_structure_delete;
use web_man_admin_link_structure_change_sequence;
use web_man_admin_link_structure_dyna_mod_param;
use web_man_admin_link_structure_dyna_mod_param_copy;
use web_man_admin_link_structure_comp_selection_logic;
use web_man_admin_link_structure_reference_change_id;

use web_man_admin_CGI_var_cache;

use web_man_admin_dynamic_module;

use web_man_admin_blob_content;

use web_man_admin_multi_language;


sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    bless $this, $class;
    
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
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_main.html");
    
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
    
    my $app_name = $cgi->param("app_name");
    
    $te_content =~ s/\$app_name_/$app_name/;
    
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
    
    my $link_name = $cgi->param("link_name");
    if ($link_name eq "") { $link_name = "Link Structure/Reference";}
    
    my @menu_items = ("Link Tree", "Link Structure/Reference", "CGI Var. Cache", "Dynamic Module Management", "BLOB Content Management", "Multi Language Support");
    
    my $html_menu = new HTML_Link_Menu_Paginate;
    
    $html_menu->set_Menu_Template_Content($te_content);
    $html_menu->set_Items_View_Num(10);
    $html_menu->set_Items_Set_Num(1);
    
    $html_menu->set_Menu_Items(@menu_items);
    $html_menu->set_Menu_Links(@menu_links);
    
    $html_menu->set_Auto_Menu_Links("index.cgi", "link_name", "dmisn");
    $html_menu->set_Active_Menu_Item($link_name);
    
    $html_menu->set_Separator_Tag("");
    $html_menu->set_Next_Tag("");
    $html_menu->set_Previous_Tag("");
    $html_menu->set_Non_Selected_Link_Color("#0099FF");
    
    my $caller_get_data = $cgi->generate_GET_Data("app_name");
    
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
    
    my $login = $cgi->param("login");
    
    my $link_name = $cgi->param("link_name");
    if ($link_name eq "") { $link_name = "Link Structure/Reference";}
    
    my $task = $cgi->param("task");
    
    my $component = undef;
    
    if ($link_name eq "Link Tree") {
        $component = new web_man_admin_link_tree;
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2
        
        $component->run_Task;
        $component->process_Content;
        
        $te_content = $component->get_Content;        
        
    } elsif ($link_name eq "Link Structure/Reference") {
        if ($task eq "") {
            $component = new web_man_admin_link_structure;
            
        } elsif ($task eq "add_phase1" || $task eq "add_phase2") {
            $component = new web_man_admin_link_structure_add;
            
        } elsif ($task eq "update_phase1" || $task eq "update_phase2") {
            $component = new web_man_admin_link_structure_update;
            
        } elsif ($task eq "update_ref_phase1" || $task eq "update_ref_phase2_add" || 
                 $task eq "update_ref_phase3_add" || $task eq "update_ref_phase2_delete" ||
                 $task eq "update_ref_phase2_copy_param" || $task eq "update_ref_phase2_change_id") {
                 
             $component = new web_man_admin_link_structure_update_reference;
             
        } elsif ($task eq "delete_phase1") {
            $component = new web_man_admin_link_structure_delete;
            
        } elsif ($task eq "sequence_up" || $task eq "sequence_down") {
            $component = new web_man_admin_link_structure_change_sequence;
            
        } elsif ($task eq "update_dyna_mod_phase1" || $task eq "update_dyna_mod_phase2") {
            $component = new web_man_admin_link_structure_dyna_mod_param;
            
        } elsif ($task eq "update_ref_phase1_copy_param") {
            $component = new web_man_admin_link_structure_dyna_mod_param_copy;
            
        } elsif ($task eq "update_ref_phase1_csl" || $task eq "update_ref_phase2_csl") { ### csl stand for component selection logic
            $component = new web_man_admin_link_structure_comp_selection_logic;
            
        } elsif ($task eq "update_ref_phase1_change_id") {
            $component = new web_man_admin_link_structure_reference_change_id;
        }
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2
        
        $component->run_Task;
        $component->process_Content;
        
        $te_content = $component->get_Content;
        
    } elsif( $link_name eq "CGI Var. Cache") {
        $component = new web_man_admin_CGI_var_cache;
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2

        $component->run_Task;
        $component->process_Content;
                
        $te_content = $component->get_Content;    
        
    } elsif( $link_name eq "BLOB Content Management") {
        $component = new web_man_admin_blob_content;
        
        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2

        $component->run_Task;
        $component->process_Content;
                
        $te_content = $component->get_Content;
        
    } elsif( $link_name eq "Dynamic Module Management") { 
        $component = new web_man_admin_dynamic_module;

        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2

        $component->run_Task;
        $component->process_Content;
                        
        $te_content = $component->get_Content;
        
    } elsif( $link_name eq "Multi Language Support") { 
        $component = new web_man_admin_multi_language;

        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn); ### option 2

        $component->run_Task;
        $component->process_Content;
                        
        $te_content = $component->get_Content;
        
    } else {
        $te_content = $link_name;
    }
        
    $this->add_Content($te_content);

}

1;

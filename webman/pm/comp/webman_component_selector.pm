package webman_component_selector;

use webman_CGI_component;

@ISA=("webman_CGI_component");

### standard webman modules

use webman_component_selector;

use webman_calendar;
use webman_calendar_interactive;
use webman_calendar_week_list;
use webman_calendar_weekly;
use webman_calendar_weekly_timerow;

use webman_db_item_insert;
use webman_db_item_insert_multirows;

use webman_db_item_update;
use webman_db_item_update_multirows;

use webman_db_item_delete;
use webman_db_item_delete_multirows;

use webman_text2db_map;

use webman_db_item_search;

use webman_db_item_view;
use webman_db_item_view_dynamic;

use webman_dynamic_links;

use webman_HTML_printer;
use webman_HTML_static_file;

use webman_image_map_links;
use webman_link_path_generator;
use webman_static_links;
use webman_TLD_item_view;
use webman_TLD_item_view_dynamic;

use webman_FTP_upload;
use webman_FTP_list;

sub new {
    my $class = shift @_;

    print STDERR "Trying to load component: $comp_name\n";
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{cgi_data_refresh_exception} = undef;
    
    $this->{exclude_db_cache_cgi_var} = undef; ### 19/12/2008
    $this->{remove_db_cache_cgi_var} = undef; ### 01/01/2009
    
    $this->{debug_component} = undef;
    
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

sub set_Template_Default {
    my $this = shift @_;
    
    my $template_file = shift @_;
    
    $this->{template_default} = $template_file;
}

sub set_Component_Selector_ID {
    my $this = shift @_;
        
    $this->{component_selector_id} = shift @_;
}

sub set_Recursive_Call_Num {
    my $this = shift @_;
        
    $this->{recursive_call_num} = shift @_;
}

sub run_Task {
    my $this = shift @_;
    
    $this->SUPER::run_Task();
    
    #print "<font color=\"#0000FF\"> run_Task from webman_component_selector</font> <br>\n";    
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->{active_link_id} = $this->get_Current_Link_ID;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    $this->{dyna_mod_name_selected} = undef;
    $this->{dyna_mod_base_module} = undef;
    
    #my $dbu = new DB_Utilities;

    #$dbu->set_DBI_Conn($db_conn); ### option 1
    
    my $app_name = $this->get_Application_Name;
    my $my_link_id = $this->get_My_Link_ID;
    my $current_dyna_cont_num = $this->get_Current_Dynamic_Content_Num;
    my $current_dyna_cont_name = $this->get_Current_Dynamic_Content_Name;
    
    my $link_reference_table_name = "webman_" . $app_name . "_link_reference";
    my $dyna_mod_selector_table_name = "webman_" . $app_name . "_dyna_mod_selector";
    
    my $link_ref_id = undef;
    
    $dbu->set_Table($link_reference_table_name);
    
    ### link_ref_id that match by dynamic content name will have a  
    ### privilege over link_ref_id that match by dynamic content number
    
    if ($current_dyna_cont_name ne "") { ### 22/01/2009
        $link_ref_id = $dbu->get_Item("link_ref_id", "link_id dynamic_content_name", "$my_link_id $current_dyna_cont_name");
    }
    
    if ($link_ref_id eq "") { ### 22/01/2009
        $link_ref_id = $dbu->get_Item("link_ref_id", "link_id dynamic_content_num", "$my_link_id $current_dyna_cont_num");
    }
    ### end of comments relevance
    
    #print "SQL (\$link_ref_id): " . $dbu->get_SQL . "<br>\n";
    
    #print "$app_name - $my_link_id - $current_dyna_cont_num - $link_reference_table_name - $link_ref_id - $dyna_mod_selector_table_name <br>\n";
    
    $dbu->set_Table($dyna_mod_selector_table_name);
    
    my $item = undef;
    my $cgi_param_name_db = undef;
    my $cgi_param_value_db = undef;
    
    my @ahr = undef;
    
    if ($this->{component_selector_id} ne "" && $dbu->find_Item("parent_id", $this->{component_selector_id})) {
        #print "Warning: run task for nested webman_component_selector - $this->{component_selector_id}<br>\n";
        
        @ahr = $dbu->get_Items("dyna_mod_selector_id cgi_param cgi_value dyna_mod_name parent_id", "link_ref_id parent_id",  "$link_ref_id $this->{component_selector_id}");
        
        #$cgi->add_Debug_Text("SQL : " . $dbu->get_SQL, __FILE__, __LINE__);
        
    } else {
        @ahr = $dbu->get_Items("dyna_mod_selector_id cgi_param cgi_value dyna_mod_name parent_id", "link_ref_id",  "$link_ref_id");
        
        #$cgi->add_Debug_Text("SQL : " . $dbu->get_SQL, __FILE__, __LINE__);
    }
    
    
    
    ### determine webman dynamic module name to be choosed by comparing
    ### CGI parameter name & value from DB and current state  
    
    CGI_PARAM_VALUE:foreach $item (@ahr) {
        #$cgi->add_Debug_Text($item->{cgi_param} . " : " . $item->{cgi_value} . " : " . $item->{dyna_mod_name} . " : " . $item->{parent_id}, __FILE__, __LINE__);
        
        $cgi_param_name_db = $item->{cgi_param};
        $cgi_param_value_db = $item->{cgi_value};
        
        #$cgi->add_Debug_Text("'" . $cgi_param_value_db . "'" . " eq " . "'" . $cgi->param($cgi_param_name_db) . "'", __FILE__, __LINE__);
        
        if ($cgi_param_value_db eq $cgi->param($cgi_param_name_db)) {
            $this->{dyna_mod_selector_id_selected} = $item->{dyna_mod_selector_id}; 
            $this->{dyna_mod_name_selected} = $item->{dyna_mod_name};
            
            #$cgi->add_Debug_Text("Ok found" , __FILE__, __LINE__);
            
            last CGI_PARAM_VALUE;
        }
    }
    
    #$cgi->add_Debug_Text("\$this->{dyna_mod_name_selected} = $this->{dyna_mod_name_selected}" , __FILE__, __LINE__);
    
    $this->{dyna_mod_base_module} = $this->get_dyna_mod_base_module($this->{dyna_mod_name_selected});
    
    #$this->set_Error("???");
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
    #print "\$this->{template_default} = " . $this->{template_default} . "<br>";
    
    $this->SUPER::process_Content;  
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    #my $te_type_name = $te->get_Name;
    
    my $content = undef;
    
    my $component_id = $this->{dyna_mod_selector_id_selected};
    my $component_name = $this->{dyna_mod_name_selected};
    my $base_module = $this->{dyna_mod_base_module};
    
    #$cgi->add_Debug_Text("Component ID selected: $component_id", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("Component name selected: $component_name", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("Component base module: $base_module", __FILE__, __LINE__);
    
    if ($this->{debug_component}) {
        $cgi->add_Debug_Text("Component ID: $component_id, Component name: $component_name, Base module: $base_module", __FILE__, __LINE__, "DEBUG_COMP");
    }
    
    if ($base_module eq "webman_CGI_component") {
        $content = $this->run_webman_CGI_component_base_module($component_name);
               
    } elsif ($base_module eq "webman_db_item_insert") {
        $content = $this->run_webman_db_item_insert_base_module($component_name);
        
    } elsif ($base_module eq "webman_db_item_insert_multirows") {
        ### item insert v2 & v3 exactly have the same 
        ### methods/functions to be called
        $content = $this->run_webman_db_item_insert_base_module($component_name);
        
    } elsif ($base_module eq "webman_db_item_update") {
        $content = $this->run_webman_db_item_update_base_module($component_name);
        
    } elsif ($base_module eq "webman_db_item_update_multirows") {
        ### item update v2 & v3 exactly have the same 
        ### methods/functions to be called
        $content = $this->run_webman_db_item_update_base_module($component_name);
        
    } elsif ($base_module eq "webman_db_item_delete") {
        $content = $this->run_webman_db_item_delete_base_module($component_name);
        
    } elsif ($base_module eq "webman_db_item_delete_multirows") {
        ### item delete v2 & v3 exactly have the same 
        ### methods/functions to be called
        $content = $this->run_webman_db_item_delete_base_module($component_name);
        
    } elsif ($base_module eq "webman_text2db_map") {
        $content = $this->run_webman_text2db_map_base_module($component_name);
        
    } elsif ($base_module eq "webman_db_item_search") {
        $content = $this->run_webman_db_item_search_base_module($component_name);
                
    } elsif ($base_module eq "webman_db_item_view") {
        $content = $this->run_webman_db_item_view_base_module($component_name);
        
    } elsif ($base_module eq "webman_db_item_view_dynamic") {
        $content = $this->run_webman_db_item_view_dynamic_base_module($component_name);
        
    } elsif ($base_module eq "webman_TLD_item_view_dynamic") {
        $content = $this->run_webman_TLD_item_view_dynamic_base_module($component_name);
        
    } elsif ($base_module eq "webman_component_selector") {
        #$cgi->add_Debug_Text("Warning webman_component_selector call other webman_component_selector ", __FILE__, __LINE__);
        
        $content = $this->run_webman_component_selector_Base_Module($component_id);
        
    } elsif ($base_module eq "webman_FTP_upload") {
        #$cgi->add_Debug_Text("Run standard multi-phases webman_CGI_Component based module", __FILE__, __LINE__);
        
        ### run as a standard multi-phases webman_CGI_Component based module
        $content = $this->run_webman_CGI_component_base_module_multiphases($component_name); 
        
    } else {
        #$cgi->add_Debug_Text("Run standard single-phase webman_CGI_Component based module", __FILE__, __LINE__);
        
        ### just try to run as a standard webman_CGI_Component based module
        $content = $this->run_webman_CGI_component_base_module($component_name); 
    }
    
    $this->add_Content($content);
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    #my $te_type_name = $te->get_Name;
    
    $this->add_Content($te_content);
    
    #if ($this->get_Error eq "") {
    #   $this->add_Content($te_content);
        
    #} else {
    #   $this->add_Content($this->get_Error);
    #}
}

####################################################################################

sub run_webman_component_selector_Base_Module {
    my $this = shift @_;
    
    my $component_selector_id = shift @_;
    my $recursive_call_num = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    ### next is to call webman_component_selector 
    ### as we call it inside webman_main.pm
    
    my $content = undef;
    my $component = undef;
    
    $component = new webman_component_selector;
    
    $component->set_Caller_Module_Name($this->get_Name);
    
    if ($component_selector_id ne "") {
        $component->set_Component_Selector_ID($component_selector_id);
    }
    
    if ($recursive_call_num eq undef) {
        $recursive_call_num = 1;
    }
    
    $component->set_Recursive_Call_Num($recursive_call_num);
    
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    
    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009

    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param("webman_component_selector");

    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) &&
        $component->authenticate) {
        $component->run_Task;
        $component->process_Content;
    }

    $content = $component->get_Content;
    
    return $content;
}

####################################################################################

sub run_webman_CGI_component_base_module {
    my $this = shift @_;
    
    my $comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $component = new $comp_name;
    
    $component->set_Caller_Module_Name($this->get_Name);
    
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    
    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009
    
    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param($comp_name);
    
    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) && 
        $component->authenticate) {
        $component->run_Task;
        $component->process_Content;
        $component->end_Task; ### 05/11/2013
    }

    my $content = $component->get_Content;

    return $content;    
}  

#################################################

sub run_webman_CGI_component_base_module_multiphases {
    my $this = shift @_;
    
    my $comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $component = new $comp_name;
    
    $component->set_Caller_Module_Name($this->get_Name);
    
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    
    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009
    
    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param($comp_name);
    
    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) && 
        $component->authenticate) {
        $component->run_Task;
        $component->process_Content;
    }

    my $content = undef;

    if ($component->last_Phase) {    
        ### this is useful to avoid infinite recursive module calling below
        #$component->last_Phase_CGI_Data_Reset; ### 14/04/2008
        $component->end_Task; ### 17/01/2011
        
        if ($this->{recursive_call_num} < 10) {
            $this->{recursive_call_num}++;
            
            ### warning! below is a recursive module calling
            $content = $this->run_webman_component_selector_Base_Module(undef, $this->{recursive_call_num});
            
        } else {
            $content  = "<b>Logical Error:</b> <br>\n";
            $content .= "Possibility of webman component [webman_component_selector] infinite recursive call. ";
            $content .= "Don't forget to set last_phase_cgi_data_reset for multi phase webman component call [" . $component->get_Name . "].";
        }

    } else {
        $content = $component->get_Content;
    }
    
    return $content; 
}  

#################################################

sub run_webman_db_item_insert_base_module {
    my $this = shift @_;
    
    my $comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $component = new $comp_name;
    
    $component->set_Caller_Module_Name($this->get_Name);

    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);

    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009
    
    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param($comp_name);
    
    my $status = 0;

    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) && 
        $component->authenticate) {
        $status = $component->run_Task; ### $status == 1 if insert operation is proceeded & done
        $component->process_Content;
    }

    my $content = undef;

    if ($component->last_Phase) {    
        ### this is useful to avoid infinite recursive module calling below
        #$component->last_Phase_CGI_Data_Reset; ### 14/04/2008
        $component->end_Task; ### 17/01/2011
        
        if ($this->{recursive_call_num} < 10) {
            $this->{recursive_call_num}++;
            
            ### warning! below is a recursive module calling
            $content = $this->run_webman_component_selector_Base_Module(undef, $this->{recursive_call_num});
            
        } else {
            $content  = "<b>Logical Error:</b> <br>\n";
            $content .= "Possibility of webman component [webman_component_selector] infinite recursive call. ";
            $content .= "Don't forget to set last_phase_cgi_data_reset for multi phase webman component call [" . $component->get_Name . "].";
        }

    } else {
        $content = $component->get_Content;
    }
    
    return $content;
    
    #if ($this->get_Error eq "") {
    #   $this->add_Content($te_content);
        
    #} else {
    #   $this->add_Content($this->get_Error);
    #}
}

#################################################

sub run_webman_db_item_update_base_module {
    my $this = shift @_;
    
    my $comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    $component = new $comp_name;
    
    $component->set_Caller_Module_Name($this->get_Name);
    
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    
    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009
    
    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param($comp_name);

    my $status = 0;

    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) && 
        $component->authenticate) {
        $status = $component->run_Task; ### $status == 1 if update operation is proceeded & done
        $component->process_Content;
    }

    #print "SQL = " . $component->get_SQL_View; ### for debug purpose

    my $content = undef;

    if ($component->last_Phase) {
    
        ### this is useful to avoid infinite recursive module calling below
        #$component->last_Phase_CGI_Data_Reset; ### 14/04/2008
        $component->end_Task; ### 17/01/2011
        
        if ($this->{recursive_call_num} < 10) {
            $this->{recursive_call_num}++;
            
            ### warning! below is a recursive module calling
            $content = $this->run_webman_component_selector_Base_Module(undef, $this->{recursive_call_num});
            
        } else {
            $content  = "<b>Logical Error:</b> <br>\n";
            $content .= "Possibility of webman component [webman_component_selector] infinite recursive call.<br>\n";
            $content .= "Don't forget to provide a mechanism to set last_phase_cgi_data_reset for multi phase webman component call [" . $component->get_Name . "].";
        }

    } else {
        $content = $component->get_Content;
    }
    
    return $content;
    
    #if ($this->get_Error eq "") {
    #   $this->add_Content($te_content);
        
    #} else {
    #   $this->add_Content($this->get_Error);
    #}
}

#################################################

sub run_webman_db_item_delete_base_module {
    my $this = shift @_;
    
    my $comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    $component = new $comp_name;
    
    $component->set_Caller_Module_Name($this->get_Name);
    
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    
    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009
    
    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param($comp_name);
    
    my $status = 0;
    
    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) && 
        $component->authenticate) {
        $status = $component->run_Task; ### $status == 1 if delete operation is proceeded & done
        $component->process_Content;
    }
    
    #print "SQL = " . $component->get_SQL_View; ### for debug purpose
    
    my $content = undef;

    if ($component->last_Phase) { 
        ### this is useful to avoid infinite recursive module calling below
        #$component->last_Phase_CGI_Data_Reset; ### 14/04/2008
        $component->end_Task; ### 17/01/2011
        
        if ($this->{recursive_call_num} < 10) {
            $this->{recursive_call_num}++;
            
            ### warning! below is a recursive module calling
            $content = $this->run_webman_component_selector_Base_Module(undef, $this->{recursive_call_num});
            
        } else {
            $content  = "<b>Logical Error:</b> <br>\n";
            $content .= "Possibility of webman component [webman_component_selector] infinite recursive call. ";
            $content .= "Don't forget to set last_phase_cgi_data_reset for multi phase webman component call [" . $component->get_Name . "].";
        }

    } else {
        $content = $component->get_Content;
    }
    
    return $content;
    
    #if ($this->get_Error eq "") {
    #   $this->add_Content($te_content);
        
    #} else {
    #   $this->add_Content($this->get_Error);
    #}
}

####################################################################################

sub run_webman_text2db_map_base_module {
    my $this = shift @_;
    
    my $comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $component = new $comp_name;
    
    $component->set_Caller_Module_Name($this->get_Name);

    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);

    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009
    
    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param($comp_name);
    
    my $status = 0;

    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) && 
        $component->authenticate) {
        $status = $component->run_Task; ### $status == 1 if insert operation is proceeded & done
        $component->process_Content;
    }

    my $content = undef;

    if ($component->last_Phase) {    
        ### this is useful to avoid infinite recursive module calling below
        #$component->last_Phase_CGI_Data_Reset; ### 14/04/2008
        $component->end_Task; ### 17/01/2011
        
        if ($this->{recursive_call_num} < 10) {
            $this->{recursive_call_num}++;
            
            ### warning! below is a recursive module calling
            $content = $this->run_webman_component_selector_Base_Module(undef, $this->{recursive_call_num});
            
        } else {
            $content  = "<b>Logical Error:</b> <br>\n";
            $content .= "Possibility of webman component [webman_component_selector] infinite recursive call. ";
            $content .= "Don't forget to set last_phase_cgi_data_reset for multi phase webman component call [" . $component->get_Name . "].";
        }

    } else {
        $content = $component->get_Content;
    }
    
    return $content;
    
    #if ($this->get_Error eq "") {
    #   $this->add_Content($te_content);
        
    #} else {
    #   $this->add_Content($this->get_Error);
    #}
}

####################################################################################

sub run_webman_db_item_search_base_module {
    my $this = shift @_;
    
    my $comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $component = new $comp_name;
    
    $component->set_Caller_Module_Name($this->get_Name);
    
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    
    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009
    
    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param($comp_name);
    
    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) && 
        $component->authenticate) {
        $component->run_Task;
        $component->process_Content;
    }

    my $content = $component->get_Content;

    return $content;
}

####################################################################################

sub run_webman_db_item_view_base_module {
    my $this = shift @_;
    
    my $comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $component = new $comp_name;
    
    $component->set_Caller_Module_Name($this->get_Name);
    
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    
    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009
    
    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param($comp_name);
    
    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) && 
        $component->authenticate) {
        $component->run_Task;
        $component->process_Content;
    }

    my $content = $component->get_Content;

    return $content;
}

#################################################

sub run_webman_db_item_view_dynamic_base_module {
    my $this = shift @_;
    
    my $comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $component = new $comp_name;

    $component->set_Caller_Module_Name($this->get_Name);
    
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    
    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009
    
    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param($comp_name);
    
    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) && 
        $component->authenticate) {
        $component->run_Task;
        $component->process_Content;
    }

    my $content = $component->get_Content;
    
    #$cgi->add_Debug_Text("\$content = $content", __FILE__, __LINE__);
    
    return $content;
}

####################################################################################

sub run_webman_TLD_item_view_dynamic_base_module {
    my $this = shift @_;
    
    my $comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $component = new $comp_name;
    
    $component->set_Caller_Module_Name($this->get_Name);
    
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);
    #$component->set_DBI_App_Conn("db_driver_ db_name_ db_username_ db_password_");
    
    $component->set_Current_Dynamic_Content_Num($this->get_Current_Dynamic_Content_Num);
    $component->set_Current_Dynamic_Content_Name($this->get_Current_Dynamic_Content_Name); ### 16/01/2009
    
    $component->set_Link_Path($this->get_Link_Path); ### 04/02/2009
    $component->set_My_Link_Level($this->get_My_Link_Level);
    $component->set_Module_DB_Param($comp_name);
    
    if ($component->auth_Link_ID($this->{active_link_id}, undef, 0) && 
        $component->authenticate) {
        $component->run_Task;
        $component->process_Content;
    }

    my $content = $component->get_Content;

    return $content;
}

####################################################################################

sub get_dyna_mod_base_module {
    my $this = shift @_;
        
    my $dyna_mod_name = shift @_;
    
    my $cgi = $this->get_CGI;
    
    my %valid_base_component = ("webman_CGI_component" => 1,
                                "webman_calendar" => 1,
                                "webman_calendar_interactive" => 1,
                                "webman_calendar_week_list" => 1,
                                "webman_calendar_weekly" => 1,
                                "webman_calendar_weekly_timerow" => 1,
                                "webman_component_selector" => 1,
                                "webman_db_item_delete" => 1,
                                "webman_db_item_delete_multirows" => 1,
                                "webman_db_item_insert" => 1,
                                "webman_db_item_insert_multirows" => 1,
                                "webman_db_item_update" => 1,
                                "webman_db_item_update_multirows" => 1,
                                "webman_text2db_map" => 1,
                                "webman_db_item_view" => 1,
                                "webman_db_item_view_dynamic" => 1,
                                "webman_db_item_search" => 1,
                                "webman_dynamic_links" => 1,
                                "webman_image_map_links" => 1,
                                "webman_link_path_generator" => 1,
                                "webman_static_links" => 1, 
                                "webman_TLD_item_view" => 1,
                                "webman_TLD_item_view_dynamic" => 1,
                                "webman_FTP_upload" => 1,
                                "webman_FTP_list" => 1);
                                
    if ($valid_base_component{$dyna_mod_name} == 1) {
        return $dyna_mod_name;
    }
    
    my $app_name = $cgi->param("app_name");
    
    #$cgi->add_Debug_Text("\$app_name = $app_name, \$dyna_mod_name = $dyna_mod_name", __FILE__, __LINE__);
    
    my $dyna_mod_file_name = $dyna_mod_name . ".pm";
    
    if (open(MYFILE, "<../../../../webman/pm/apps/$app_name/$dyna_mod_file_name")) {
        my $line = undef;
        my @file_content = <MYFILE>;
        
        foreach $line (@file_content) {
            if ($line =~ /\@ISA/) {
                my @spliters = split(/;/, $line);
                
                my $super_class_name = $spliters[0];
                
                while ($super_class_name =~ / /) {
                    $super_class_name =~ s/ //;
                }
                
                $super_class_name =~ s/^\@ISA=\("//;
                $super_class_name =~ s/"\)$//;
            
                return $this->get_dyna_mod_base_module($super_class_name);
            }
        }
        
        close(MYFILE);
    }
    
    return undef;
}

sub is_additional_refresh_exception {
    my $this = shift @_;
    
    my $cgi_var_name = shift @_;
    
    my $list = undef;
    my @exception_list = split(/ /, $this->{cgi_data_refresh_exception});
    
    foreach $list (@exception_list) {
        if ($cgi_var_name eq $list) {
            return 1;
        }
    }
    
    return 0;
}

1;